
--
-- xmlparse.lua  - Copyright (c) 2006, the WoWBench developer community. All rights reserved. See LICENSE.TXT.
--
-- An unorthodox implementation of an XML parser. First out, it cheats
-- liberally of course (it's very specific to WoW-style XML), but second,
-- it operates by translating the XML to Lua, and then executing _that_.
-- It nicely works around a lot of work that is otherwise required, and
-- also speeds the sum total of the process up, since most XML files don't
-- change (think FrameXML!)
--


WOWB_AllObjectsByName = {
	-- Ex: ["myobject"] = MyObject
	-- Entries get set up by WOWB_ParseXML_FixObjectName, and are stored as 
	--   LOWERCASE; xml names are case insensitive in wow.
}


---------------------------------------------------------------------
---------------------------------------------------------------------
---------------------------------------------------------------------
--
-- XML File parsing and object instantiation
--



---------------------------------------------------------------------
-- Parser context to keep track of where we are and what we're 
-- parsing / manipulating for error reporting.
--
-- You will see "xfpc" getting passed around alot, both in the 
-- XML parser below, as well as in the generated Lua code. 
--


WOWB_XMLFileParserContext = {}

function WOWB_XMLFileParserContext:New(filename)
	local xfpc = { 
		filename=filename, 
		linenum=0, 
		info="",
		stackdepth=getcurrentstackdepth()-1; 	-- -1 = WOWB_XMLFileParserContext:New()
	};
	setmetatable(xfpc, {__index = WOWB_XMLFileParserContext });
	WOWB_StackInfo[xfpc.stackdepth] = xfpc;
	WOWB_StackInfo.n = xfpc.stackdepth;
	return xfpc;
end	

function WOWB_XMLFileParserContext:None()
	local xfpc = {
		filename="",
		linenum=-1,
		info="",
		stackdepth=getcurrentstackdepth()-1; 	-- -1 = WOWB_XMLFileParserContext:None()
	};
	setmetatable(xfpc, {__index = WOWB_XMLFileParserContext });
	return xfpc;
end

function WOWB_XMLFileParserContext:Recurse(obj)
	assert(obj and obj[0]);
	local xfpc = {
		filename=obj[0].xmlfile,
		linenum=obj[0].xmlfilelinenum,
		info = obj[0].name or obj[0].xmltag or "",
		stackdepth=self.stackdepth+1,
	};
	setmetatable(xfpc, {__index = WOWB_XMLFileParserContext });
	WOWB_StackInfo[xfpc.stackdepth] = xfpc;
	for i=xfpc.stackdepth+1,WOWB_StackInfo.n do		-- clean up above in case we've messed up and left something there
		WOWB_StackInfo[i]=nil;
	end
	WOWB_StackInfo.n = xfpc.stackdepth;
	return xfpc;
end

function WOWB_XMLFileParserContext:Return()
	if(self.stackdepth<WOWB_StackInfo.n) then
		for i=self.stackdepth,WOWB_StackInfo.n do
			WOWB_StackInfo[i]=nil;
		end
	else
		WOWB_StackInfo[self.stackdepth] = nil;
	end
	WOWB_StackInfo.n = self.stackdepth-1;
end

function WOWB_XMLFileParserContext:error(msg)
	error(self.filename..":"..self.linenum..": XML: "..msg, 0);  -- toc parser checks for " XML: " in error to determine whether to just skip xml file or abort wowbench
end	






---------------------------------------------------------------------
-- function WOWB_ParseXML_InheritObj(xfpc, o, strInheritName, bVirtual)
--
-- Inherit an object
--
--   xfpc: WOWB_XMLFileParserContext
--   o: destination object (the one being parsed)
--   strInheritName: inherit="..." parameter
--   bVirtual: Is "o" virtual also?


-- _Fly function for InheritObj:
local function WOWB_ParseXML_InheritObj_Fly(xfpc, to, from, strLastObjName, bVirtual, aStack, parentobj)
	assert(to[0]);
	assert(from[0]);
	DP("XML", 4, string.rep(".", getn(aStack))..(from[0].name or from[0].xmltag or "").." > "..(to[0].name or to[0].xmltag or "(new)"));
	
	-- Inherit type
	if(not to.__inheritstypes and from.__inheritstypes) then
		for k,v in from.__inheritstypes do
			WOWB_InheritType(to, v);
		end
	end
	
	-- Copy over nontables in [0] (some variables are treated specially)
	for k,v in from[0] do
		if(type(v)=="table") then
			-- don't touch tables this pass
		elseif(to[0][k]) then
			-- already exists, won't be inherited
		elseif(k=="name") then
			-- this'll be dealt with right after this loop
		elseif(k=="virtual") then	
			-- doesn't get copied over
		elseif((tonumber(k) or 0)>=1) then
			tinsert(to[0], v);
		else
			to[0][k] = v;
		end
	end

	-- Now deal with the name
	if(from[0].name) then
		if(getn(aStack)==0) then
			-- at depth 0: don't copy over the name from the inherited object, it's set the way we like it already
		elseif(bVirtual) then
			to[0].name = from[0].name; -- virtual object inheriting something; just copy over the name to preserve "$parent..."
		elseif(not string.find(from[0].name, "%$parent")) then
			xfpc:error("[NODBG]\""..from[0].name.."\": named inherited children must have '$parent' in their names or we get lots of objects with the same name");
		else
			to[0].name = from[0].name;
			if(not WOWB_ParseXML_FixObjectName(xfpc:Recurse(to), to, strLastObjName)) then
				return;
			end
			strLastObjName = to[0].name;
		end
	end
	
	-- Fix parent
	assert(WOWB_XMLTagInfo[to[0].xmltag], "WOWB_XMLTagInfo[\""..to[0].xmltag.."\"] = nil!");
	if(not bVirtual and WOWB_XMLTagInfo[to[0].xmltag].objecttype and not WOWB_XMLTagInfo[to[0].xmltag].attribute) then
		if(not to[0].parentobj) then
			to[0].parentobj = parentobj;
			parentobj[0].children[to] = true;
		end
		parentobj = to;
	end
		
	-- TODO: Should we run __constructor on objects created here? Or not? Pretty much everything gets copied after all....
	--       Can we say "C++ copy constructors"? =)

	-- Now deal with tables in [0] (they get duplicated rather than referenced since this is a unique object with unique names etc)
	for k,v in from[0] do
		if(k=="parentobj") then
			-- don't touch, it'll be wildly recursive
		
		elseif(k=="children") then
			-- not inherited
		
		elseif(type(v)=="table" and not v[0]) then
			if(not to[0][k]) then
				to[0][k] = {};
				table.copy(to[0][k], v);
			end
		
		elseif(type(v)=="table") then
			assert(v[0]); -- we only expect objects here, not random tables
			local newtable;
			if((tonumber(k) or 0)>=1) then
				-- Indexed member. Append with new index.
				tinsert(to[0], {[0]={ children={} }} );
				newtable=to[0][getn(to[0])];
				tinsert(aStack, to);
				WOWB_ParseXML_InheritObj_Fly(xfpc:Recurse(v), newtable, v, strLastObjName, bVirtual, aStack, parentobj);
				tremove(aStack);
			
			elseif(to[0][k] and type(to[0][k])~="table") then
				error("to[0][\""..k.."\"] is not a table, but from[0][\""..k.."\"] _is_?!", 0);
			
			elseif(WOWB_XMLTagInfo[v[0].xmltag].container) then
				-- Container member: Merge with existing or create new
				if(to[0][k]) then
					assert(WOWB_XMLTagInfo[to[0][k][0].xmltag].container);
					DP("XML", 4, string.rep(".", getn(aStack)).. ".(container; appending to existing:)");
				else
					to[0][k] = {[0]={ children={} }};
					DP("XML", 4, string.rep(".", getn(aStack)).. ".(container; creating new:)");
				end
				newtable=to[0][k];
				tinsert(aStack, to);
				WOWB_ParseXML_InheritObj_Fly(xfpc:Recurse(v), newtable, v, strLastObjName, bVirtual, aStack, parentobj);
				tremove(aStack);
			
			elseif(not to[0][k]) then
				-- Something else that didn't exist already: inherit it!
				to[0][k] = {[0]={ children={} }};
				newtable=to[0][k];
				tinsert(aStack, to);
				WOWB_ParseXML_InheritObj_Fly(xfpc:Recurse(v), newtable, v, strLastObjName, bVirtual, aStack, parentobj);
				tremove(aStack);
				
			-- else: this member already existed, don't overwrite!
			end
		end
	
	end -- for k,v in from[0] do
	
	
	-- Now copy in regular values in the root (tables just get referenced)
	for k,v in from do
		if(k==0) then
			-- dealt with above; very special
		elseif((tonumber(k) or 0)>=1) then
			tinsert(to, v);
		elseif(not to[k]) then
			to[k] = v;
		end
	end
end


function WOWB_ParseXML_InheritObj(xfpc, o, strInheritName, bVirtual)
	DP("XML",3 , "Begin: ("..(o[0].name or "(unnamed)") .. ', ' .. strInheritName .. ', ' .. (bVirtual and "Virtual!" or "") .. ')');
	if(not string.find(strInheritName, "^[%a_][%a%d_]*$")) then
		error(o[0].xmlfile..":"..o[0].xmlfilelinenum..": [NODBG]XML: Invalid name in inherits=\""..strInheritName.."\"", 0);
	end
	
	if(not _SYNTAXONLY) then
		local oInherit = WOWB_AllObjectsByName[string.lower(strInheritName)];
		if(not oInherit) then
			error(o[0].xmlfile..":"..o[0].xmlfilelinenum..": [NODBG]XML: inherits=\""..strInheritName.."\": no such object", 0);
		end
		
		WOWB_ParseXML_InheritObj_Fly(xfpc:Recurse(oInherit), o, oInherit, o[0].name, bVirtual, {}, o[0].parentobj or WOWB_RootFrame);
	end
	DP("XML",3 , "End");
	
	xfpc:Return();
end




-----------------------------------------------------------
-- function WOWB_ParseXML_FixObjectName(xfpc, o, strLastObjName)
--
-- Replace "$parent" in names with the name of the last named parent
-- Set a global variable with the new name
--
-----------------------------------------------------------

function WOWB_ParseXML_FixObjectName(xfpc, o, strLastObjName)
	local ret = true;
	
	DP("XML",3 , "Begin: o[0].name=\""..tostring(o[0].name).."\"  strLastObjName=\""..tostring(strLastObjName).."\"");
	
	if(string.find(o[0].name, "%$parent")) then
		if((strLastObjName or "")=="") then
			xfpc:error('[NODBG]Cannot use "$parent" when there is no named parent');
		elseif(string.find(strLastObjName, "%$parent")) then
			error('Why did I get a parent with "$parent" in its name here?!');  -- shouldn't be calling this for virtual objects, which is the only time when this could happen
		else
			o[0].name = gsub(o[0].name, "%$parent", strLastObjName);
		end
	end
	
	assert(not string.find(o[0].name, "%$parent"));
	
	if((o[0].noglobal or "false")=="false") then
		if(not string.find(o[0].name, "^[%a_][%a%d_]*$")) then
			xfpc:error('[NODBG]Invalid object name "' .. o[0].name .. '"');
		end
	end
	
	if(WOWB_AllObjectsByName[string.lower(o[0].name)]) then
		o2 = WOWB_AllObjectsByName[string.lower(o[0].name)];
		print(o[0].xmlfile..":"..o[0].xmlfilelinenum..': Warning: "'..o[0].name..'" is already defined');
		print('  at '..o2[0].xmlfile..":"..o2[0].xmlfilelinenum);
		print("  Will ignore the new object (Yes, this is how Blizzard's parser works!)");
		-- At least, that's how it works with children of the same parent. For other cases, it seems
		-- to create the new object and replace the global name. But I cba to take that into account;
		-- just fix the addon, really ...
		ret=false;
		
	else
		if((o[0].noglobal or "false")=="false") then
			setglobal(o[0].name, o);
		end
		WOWB_AllObjectsByName[string.lower(o[0].name)] = o;
		WOWB_PointerDescriptions[o]=o[0].xmltag..":"..o[0].name;  -- used in debugging dumps
	end
	
	DP("XML",3 , "End o[0].name=\""..tostring(o[0].name).."\"");
	
	xfpc:Return();
	return ret;
end






---------------------------------------------------------------------
--
-- Function: WOWB_ParseXML_QueueScripts
--
-- Scan a collection of objects for scripts that need to be run
-- Will recursively call itself with child nodes on:
-- <Frame> -> <Frames> 
-- <World> -> <Units>, <Objects>
--
---------------------------------------------------------------------

function WOWB_ParseXML_QueueScripts(oCollection)
	local nScript=0;
	local nOnLoad=0;

	-- Scan numbered nodes only, not container nodes (which are named)
	for i=1,getn(oCollection[0]) do
		local o = oCollection[0][i];
		if((o[0].virtual or "false")=="false") then
			
			-- Frame->Frames: depth first; we want children to execute before parents
			if(o[0].Frames) then
				WOWB_ParseXML_QueueScripts(o[0].Frames);
			end
			
			-- Now queue up whatever's contained in this node (script content or onload event)
			if(o[0].xmltag=="Script") then
				nScript=nScript+1;
				tinsert(WOWB_ScriptsToRunForTOC, o);
			end
			if(o[0].Scripts and o[0].Scripts[0].OnLoad) then
				nOnLoad = nOnLoad + 1;
				tinsert(WOWB_ScriptsToRunForTOC, o);
			end
		end
	end
	
	-- World node: scan "Units" and "Objects"
	if(oCollection[0].xmltag=="World") then
		tinsert(WOWB_ScriptsToRunForTOC, oCollection);
		if(oCollection[0].Units) then
			WOWB_ParseXML_QueueScripts(oCollection[0].Units);
		end
		if(oCollection[0].Objects) then
			WOWB_ParseXML_QueueScripts(oCollection[0].Objects);
		end
	end
	
	DP("XML",3, "Children of "..(oCollection[0].name or oCollection[0].xmltag)..": " ..
		"<Script>:"..nScript.." <OnLoad>:"..nOnLoad);
end




-----------------------------------------------------------
-- function WOWB_ParseXML_CompileScriptNode(xfpc, o)
--
-- Compile the given script node content into 
-- an executable chunk that gets stored in [0].chunk
--
-- The chunk name gets set to "WOWB_STACKINFO##filename##line##<tag>"
-- for error reporting purposes
--
-----------------------------------------------------------

function WOWB_ParseXML_CompileScriptNode(xfpc, o)
	local chunk, msg = loadstring(o[0].content, 
		"WOWB_STACKINFO##"..o[0].xmlfile.."##"..o[0].xmlfilelinenum.."##<"..o[0].xmltag..">");
	if(not chunk) then
		error(msg, 0);
	end
	o[0].chunk = chunk;
end



-----------------------------------------------------------
-- function WOWB_ParseXML_dofile(xfpc, filename)
--
--
-----------------------------------------------------------

function WOWB_ParseXML_dofile(xfpc, orgfilename)
	local filename = WOWB_ProcessFilename(orgfilename, false);
	if(not filename) then
		print(xfpc.filename..":"..xfpc.linenum..": Warning: Cannot locate \""..orgfilename.."\". Skipping.");
		return;
	end
	dofile(filename);
	-- Assume that this file should be parsed BEFORE current file in compiled .toc.luac -- current file must not already be added to WOWB_AllFilesForTOC
	tinsert(WOWB_AllFilesForTOC, filename);
end



-----------------------------------------------------------
-- function WOWB_ParseXML(filename)
--
-- Parse an XML file into Lua and run the resulting Lua
-- (Will avoid parsing if existing Lua is newer than XML)
--
-- Not a true XML parser at all; there's plenty of app-specific
-- stuff in here. It will however index objects by load order.
--
-----------------------------------------------------------

function WOWB_ParseXML(orgfilename)
	
	local filename = WOWB_ProcessFilename(orgfilename);
	if(not filename) then
		error("[NODBG]Cannot locate \""..orgfilename.."\"", 0);
	end
	local xfpc = WOWB_XMLFileParserContext:New(filename);
	DP("XML",1, "Begin: "..xfpc.filename);
	local bSeenTags = false;

	if(not _SYNTAXONLY and not _FORCEREPARSE and WOWB_IsFileNewerThan(_CWD, orgfilename..".lua", orgfilename)) then
		-- whee, we don't have to parse the xml file!
		if(_VERBOSE) then print("XML: "..WOWB_SimpleFilename(xfpc.filename)..".lua"); end;
	else
		-- need to do .xml -> .xml.lua conversion
		DP("XML",2, "Parsing .xml file into .xml.lua");
		local strFileContents, fil;
		if(_VERBOSE) then print("XML: "..WOWB_SimpleFilename(xfpc.filename)); end;
		fil = io.open(xfpc.filename);
		strFileContents = fil:read("*a");
		io.close(fil);
		
		-- Make a table of what positions lines begin on (so we can do proper error reporting)
		local n=-1;
		local aNewlinePositions = {}
		local nFileLen = string.len(strFileContents);
		xfpc.linenum = 1;
		while(n) do
			n = string.find(strFileContents,"\n",n+1);
			table.insert(aNewlinePositions, n);
		end
			
		local aParentTags = {};
		
		local fil = assert(io.open(xfpc.filename..".lua", "w"));
		WOWB_ParseXML_CurrentOutputFile = fil; -- global copy so it can be closed by caller on error
		
		fil:write(
			"-- Auto generated by WoWBench "..WOWB_VER.." from \"" .. xfpc.filename .. "\" on " .. os.date("%Y-%m-%d %H:%M:%S") .. "\n" ..
			"local WOWB_XMLFILE=\"" .. WOWB_EscapeString(xfpc.filename) .. "\";\n" ..
			"local WOWB_XMLFILENOPATH=\"" .. WOWB_EscapeString(orgfilename) .. "\";\n" ..
			"local WOWB_TAG = { [0]={content=\"\"} }\n" ..  -- bogus "root xml tag"
			"local WOWB_PARENTOBJECT = WOWB_RootFrame;\n" ..   -- used only for objects, not random tags
			"local xfpc = WOWB_XMLFileParserContext:New(WOWB_XMLFILE);\n" ..
			"\n");
		
		--------------------------------------------------------
		-- Parse the xml and generate lua from it
		
		local pos = 0;
	  while true do
	  	
	  	-- Get content up to the next "<"
			local b,content,slash,strTag,imslash;
			b,pos,content=string.find(strFileContents, "(.-)<", pos+1);
			if(not b) then
				break; -- will check if all tags were properly closed after then loop
			end
			
			if(content and not string.find(content,"^[%s%c]*$")) then
				fil:write(
					"WOWB_TAG[0].content = WOWB_TAG[0].content .. \"" .. WOWB_EscapeString(WOWB_HTMLEntityDecode(content)) .. "\";\n");
			end
			
			-- Figure out which line number we're parsing (for error reporting)
			while(aNewlinePositions[xfpc.linenum] and pos>aNewlinePositions[xfpc.linenum]) do
				xfpc.linenum=xfpc.linenum+1;
			end
			
			-- Comment?
			if(string.sub(strFileContents,pos+1,pos+1+2)=="!--") then		-- TODO: better algo that understands nested comments
				b,pos=string.find(strFileContents, "%-%->", pos+4);
				if(not b) then
					xfpc:error('[NODBG]"<!--" is missing "-->"');
				end
				
			-- Not a comment
			else
				bSeenTags = true;
				-- Get tag name (remember if it started with a "/")
				b,pos,slash,strTag=string.find(strFileContents, "^<(/?)(%a+)",pos);
				if(not b) then
					xfpc:error('[NODBG]Broken tag "'..(string.sub(strFileContents,pos,pos+10))..'.."');
				end
	
				-- Get attributes and ">" (remember if there was a "/" at the end)
				local strAttributes;
				b,pos,strAttributes,imslash = string.find(strFileContents, "([^>]-)(/?)>", pos+1);
				
				-- Was this a </Tag>?
				if(slash=="/") then
					-- Just verify nesting. Real termination happens later (since it can be done via <Tag.../> too)
					if(table.getn(aParentTags)==0) then
						xfpc:error("[NODBG]Got </"..strTag.."> at root level");
					end
					if(strTag~=aParentTags[table.getn(aParentTags)]) then
						xfpc:error("[NODBG]Got </"..strTag..">. Expected </"..aParentTags[table.getn(aParentTags)]..">");
					end
				
				-- It was a <Tag...>  (or <Tag.../>)
				else
					if(not WOWB_XMLTagInfo[strTag]) then
						xfpc:error("[NODBG]Unknown tag <"..strTag..">");
					end
					tinsert(aParentTags, strTag);
					
					-- Start lua context for this tag
					fil:write(
						'do -- <'..strTag..' ...>\n'..
						'local WOWB_PARENT = WOWB_TAG;\n' ..
						'local bIgnored = false;\n'..
						'xfpc.linenum='..xfpc.linenum..'\n'..
						'local WOWB_TAG = { [0]={'..
						'  xmltag="'..strTag..'", '..
						'  xmlfile=WOWB_XMLFILE,'..
						'  xmlfilelinenum='..xfpc.linenum..','..
						'  children={},'..
						'  virtual=WOWB_ISVIRTUAL and "true",'..
						'  content="",\n'
					);
					
					-- Parse attributes (note: lua continues from "{ [0]={ ..."
					strAttributes=string.gsub(strAttributes, "[\r\n]", "");
					local attrs = {};
					while true do
						local attrname,val;
						b,e,attrname,val = string.find(strAttributes, "^%s*([%a:]+)%s*=%s*\"([^<>\"]*)\"%s*");
						if(not attrname) then
							b,e,attrname,val = string.find(strAttributes, "^%s*([%a:]+)=([^<> \t]+)%s*");
						end
						if(not attrname) then
							if(not string.find(strAttributes,"^%s*$")) then
								xfpc:error("[NODBG]Garbage in <"..strTag.."> tag: \""..strAttributes.."\"");
							end
							break;
						end
						strAttributes = string.sub(strAttributes, e+1);
						fil:write('["' .. WOWB_EscapeString(attrname) .. '"] =');
						val = WOWB_HTMLEntityDecode(val);
						if(tonumber(val)) then
							attrs[attrname] = tonumber(val);
							fil:write(tonumber(val).. ",\n");
						else
							fil:write('"' .. WOWB_EscapeString(val) .. '",\n');
							attrs[attrname] = val;
						end
					end
					fil:write("}};\n");
					
					-- Done parsing!
			
					
					-- Store according to type (object, attribute, ...)
					
					-- Attribute Object:
					if(WOWB_XMLTagInfo[strTag].attribute and WOWB_XMLTagInfo[strTag].objecttype) then
						if(attrs["name"]) then    -- yep, <NormalTexture name="$parentFoo" ...> is in use and allowed, even though it's silly
							fil:write(
								"if(not WOWB_ISVIRTUAL) then\n"..
								"  if(not WOWB_ParseXML_FixObjectName(xfpc:Recurse(WOWB_TAG), WOWB_TAG, WOWB_LASTOBJNAME)) then\n"..
								"    bIgnored = true;\n"..
								"  end\n"..
								"end\n" ..
								"local WOWB_LASTOBJNAME = WOWB_TAG[0].name;\n");
						end
						fil:write("if(not bIgnored) then WOWB_PARENT[0][\"" .. strTag .. "\"] = WOWB_TAG; end\n");

					-- Attribute:
					elseif(WOWB_XMLTagInfo[strTag].attribute) then
						fil:write("WOWB_PARENT[0][\"" .. strTag .. "\"] = WOWB_TAG;\n");
						
					-- Container:  (will already exist if inherited from somewhere)
					elseif(WOWB_XMLTagInfo[strTag].container) then
						fil:write(
							"if(not WOWB_PARENT[0][\"" .. strTag .. "\"]) then\n" ..
							"  WOWB_PARENT[0][\"" .. strTag .. "\"] = WOWB_TAG;\n" ..
							"else\n"..
							"  WOWB_TAG = WOWB_PARENT[0][\"" .. strTag .. "\"];\n" ..
							"end\n");
					
					-- Object:
					elseif(WOWB_XMLTagInfo[strTag].objecttype) then
						if(attrs["name"]) then
							fil:write(
								"if(not WOWB_ISVIRTUAL) then\n"..
								"  if(not WOWB_ParseXML_FixObjectName(xfpc:Recurse(WOWB_TAG), WOWB_TAG, WOWB_LASTOBJNAME)) then\n"..
								"    bIgnored = true;\n"..
								"  end\n"..
								"end\n" ..
								"local WOWB_LASTOBJNAME = WOWB_TAG[0].name;\n");
						end
						fil:write("if(not bIgnored) then tinsert(WOWB_PARENT[0], WOWB_TAG); end\n");
						
					-- Multiple:
					elseif(WOWB_XMLTagInfo[strTag].multiple) then
						fil:write("tinsert(WOWB_PARENT[0], WOWB_TAG);\n");

					-- Script: (<Script> and <On...> tags)
					elseif(WOWB_XMLTagInfo[strTag].script) then
						if(strTag == "Script") then	-- check for file="...." in <Script> nodes
							if(aParentTags[getn(aParentTags)-1]~="Ui") then
								xfpc:error("[NODBG]<Script> needs to be a child of <Ui>");  -- technically no but i'd like to know if it ever isn't the case
							end
							if(attrs["file"]) then
								fil:write(
								  -- Pull in the included file unless we're executing a compiled .toc.luac file (in which case it will have been run already)
									'if not WOWB_EXECCOMPILED then\n' ..
									'  WOWB_ParseXML_dofile(xfpc, WOWB_TAG[0].file);\n' ..
									'end\n');
							end	
							fil:write("tinsert(WOWB_PARENT[0], WOWB_TAG);\n");
						else
							fil:write("WOWB_PARENT[0][\"" .. strTag .. "\"] = WOWB_TAG;\n");
						end								
						-- the content will get compiled at </tag>  (we don't have it yet so can't do it now)
					
					-- Special:
					elseif(WOWB_XMLTagInfo[strTag].special) then
						if(strTag=="Include") then
							if(aParentTags[getn(aParentTags)-1]~="Ui") then
								xfpc:error("[NODBG]<Include> needs to be a child of <Ui>");  -- technically no but i'd like to know if it ever isn't the case
							end
							fil:write(
							  -- Pull in the included file unless we're executing a compiled .toc.luac file (in which case it will have been run already)
								'if not WOWB_EXECCOMPILED then\n' ..
								'  local prevCWD = _CWD;\n' ..
								'  local filename;\n'..
								'  filename,_CWD = WOWB_ProcessFilename(WOWB_TAG[0].file, true);\n' ..
								'  WOWB_ParseXML(filename);\n' ..
								'  _CWD = prevCWD;\n' ..
								-- Assume that this file should be parsed BEFORE current file in compiled .toc.luac -- current file must not already be added to WOWB_AllFilesForTOC
								'  tinsert(WOWB_AllFilesForTOC, filename);\n' ..
								'end\n');
						else
							error("Why is <"..strTag.."> 'special' tagged in WOWB_XMLTagInfo?!");
						end
					
					-- Whiskey, Tango, Foxtrot?
					else
						error("What the h*ll kind of object is <"..strTag.."> and how did it end up in our list of recognized tags?!");
					end
	
					-- Remember if this is virtual
					if(attrs["virtual"]=="true") then
						fil:write(
							"local WOWB_PARENTOBJECT = nil;\n"..		-- virtual objects don't have runtime parent/children
							"local WOWB_ISVIRTUAL = true;\n");
					end

					
					-- Object? Inherit type, assign parent, run constructors, do object inheritance
					if(WOWB_XMLTagInfo[strTag].objecttype) then
						fil:write(
							'WOWB_InheritType(WOWB_TAG, ' .. WOWB_XMLTagInfo[strTag].objecttype .. ');\n');
						if(not WOWB_XMLTagInfo[strTag].attribute) then fil:write(
							'WOWB_TAG[0].parentobj = WOWB_PARENTOBJECT;\n'..
							'if(WOWB_PARENTOBJECT) then\n'..
							'  WOWB_PARENTOBJECT[0].children[WOWB_TAG] = true;\n'..
							'end\n');
						end
						fil:write(
							'local WOWB_PARENTOBJECT = (not WOWB_ISVIRTUAL) and WOWB_TAG or nil;\n' ..
							'if WOWB_TAG[0].inherits then\n'..
							'  WOWB_ParseXML_InheritObj(xfpc:Recurse(WOWB_TAG), WOWB_TAG, WOWB_TAG[0].inherits, WOWB_ISVIRTUAL);\n'..
							'end\n'..
							'WOWB_RunObjConstructors(WOWB_TAG, ' .. WOWB_XMLTagInfo[strTag].objecttype .. ');\n' ..
							'\n');
					end
					
				end
				
				-- Was this a "<Tag ... />" or "</Tag>"?
				if(imslash=="/" or slash=="/") then 
					-- Script? Compile now that we have all the content
					if(WOWB_XMLTagInfo[strTag].script) then
						fil:write("WOWB_ParseXML_CompileScriptNode(xfpc:Recurse(WOWB_TAG), WOWB_TAG);");
					end
					-- End lua context
					fil:write(
						"end\n");
					tremove(aParentTags);
				end
			
			end -- if(tag is comment) ... else
		
		end -- while(true)
		
		
		-- We're at the end of the file!
		
		if(getn(aParentTags)>0) then
			str = "The following XML tags were left unclosed:\n";
			for n=getn(aParentTags),1,-1 do
				str = str .. "  <"..aParentTags[n]..">\n";
			end
			error("[NODBG]"..str);
		end

		if(bSeenTags) then
			fil:write(
				'if(not WOWB_TAG[0][WOWB_ROOTXMLTAG]) then xfpc:error("No <"..WOWB_ROOTXMLTAG.."> tag?"); end\n' ..
				'WOWB_ParseXML_QueueScripts(WOWB_TAG[0][WOWB_ROOTXMLTAG]);\n' ..
				'\n'
			);
		end
		
		fil:write(
			"xfpc:Return();\n"
		);
		
		-- Close the lua file
		io.close(fil);
		WOWB_ParseXML_CurrentOutputFile = nil;
	end
	
	xfpc:Return();

	-- Execute the resulting lua file!
	DP("XML", 2, "Executing "..xfpc.filename..".lua");
	dofile(xfpc.filename..".lua");
	DP("XML", 2, "Done executing "..xfpc.filename..".lua");
	
	DP("XML",1, "End: "..xfpc.filename);
end


