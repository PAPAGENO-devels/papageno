
--
-- debugger.lua   - Copyright (c) 2006, the WoWBench developer community. All rights reserved. See LICENSE.TXT.
--
--
--



errlog = io.open("tmp/errorlog.txt","w");

WOWB_NumSuppressedErrors = 0;
WOWB_SuppressingErrors = false;

WOWB_Debug_GlobalFunctionNamesByRef = {}  -- gets filled out with names of WoWBench's global function names by WOWB_Debug_RegisterGlobalFunctionNames
                                     -- (just for debugging purposes since they get hidden by WOWB_Pcall())

WOWB_SkipStackFuncs = { ["pcall"]=true, ["xpcall"]=true, ["error"]=true }   -- gets filled in with more down this file

WOWB_PointerDescriptions = {}   -- Can get filled in from anywhere. Like WOWB_ParseXML_FixObjectName(). Will just show extra info in DumpVar()

WOWB_Debug_ClassNamesByRef = {}   -- DumpVar() will never recurse into tables encountered here
WOWB_Debug_ClassMethodNamesByRef = {}	 -- Methods in above tables. Displayed instead of function: 00c0ffee

function WOWB_Debug_AddClassInfo(tablevar, tablename)
	WOWB_Debug_ClassNamesByRef[tablevar] = tablename;
	for k,v in tablevar do
		if(type(v)=="function" and not WOWB_Debug_ClassMethodNamesByRef[v]) then
			WOWB_Debug_ClassMethodNamesByRef[v]=tablename..":"..k;
		end
	end
end	



---------------------------------------------------------------------
-- function WOWB_DumpVar(var,maxdepth,ind)
--
-- Return contents of a variable  as an ascii dump. Will recurse into tables.
-- Will attempt to avoid recursion to back references
-- Will never follow names in config.lua:_DUMPDONTFOLLOW[]
-- Uses plenty of magic set up elsewhere in the code to make more sense of 
-- table and function references.
--
-- var: the variable to be dumped
-- maxdepth: maximum recursion depth
-- ind: initial indent string, can be nil or e.g. "    "
--


-- _Fly for WOWB_DumpVar:
local function WOWB_DumpVar_Fly(var,ind,parents,maxdepth,aRet)
	
	if(type(var)=="table") then
		if(table.getn(parents)>=1 and WOWB_Debug_ClassNamesByRef and WOWB_Debug_ClassNamesByRef[var]) then
			tinsert(aRet,tostring(var) .. " (global \""..tostring(WOWB_Debug_ClassNamesByRef[var]).."\")\n");
		else
			tinsert(aRet, tostring(var));
			local k,v,backref;
			for k,v in parents do
				if(var==v) then
					backref=true; 
					break;
				end
			end
			if(backref) then
				tinsert(aRet," (recursive backreference!)\n");
			elseif(maxdepth<0) then
				tinsert(aRet," (will not inspect table with this name)\n");
			elseif(table.getn(parents)>=maxdepth) then
				tinsert(aRet," (depth > " .. maxdepth ..")\n");
			else
				local aSkippedGlobalMethods = {};
				table.insert(parents, var);
				tinsert(aRet," {\n");
				local maxout = math.min((100 + 5^maxdepth)*3, 1000000); -- ~250k lines max
				for k,v in var do
					if(getn(aRet)>maxout) then
						tinsert(aRet, ind.."} aborted dump - output limit exceeded for maxdepth="..maxdepth.."\n");
						return;
					end

					--[[ Nah. We use metatables for inheritance now so this isn't as annoying anymore. And it hides useful information in the base classes themselves.						
					if(type(v)=="function" and WOWB_Debug_ClassMethodNamesByRef and WOWB_Debug_ClassMethodNamesByRef[v] and
								 string.find(WOWB_Debug_ClassMethodNamesByRef[v], ":"..k.."$")) then
						local _,_,tablename = string.find(WOWB_Debug_ClassMethodNamesByRef[v], "^(.-):");
						aSkippedGlobalMethods[tablename] = (aSkippedGlobalMethods[tablename] or 0) + 1;
					else
					]]
						tinsert(aRet, ind.."  ");
						if(type(k)=="string" and string.find(k,"^[%a_][%a%d_]*$")) then
							tinsert(aRet, k);
						elseif(type(k)=="string") then
							tinsert(aRet, "[\"" .. k .. "\"]");
						elseif(type(k)=="table" and WOWB_PointerDescriptions[k]) then
							tinsert(aRet, "[" .. WOWB_PointerDescriptions[k] .. "]");
						else
							tinsert(aRet, "[" .. tostring(k) .. "]");
						end
						tinsert(aRet, " = ");
						if(_DUMPDONTFOLLOW and _DUMPDONTFOLLOW[tostring(k)]) then
							WOWB_DumpVar_Fly(v, ind.."  ", parents, -1, aRet);
						else
							WOWB_DumpVar_Fly(v, ind.."  ", parents, maxdepth, aRet);
						end
					--[[ end ]]
				end -- for k,v in var do
				table.remove(parents);
				--[[ for tablename,n in aSkippedGlobalMethods do
					tinsert(aRet, ind .. "  + " .. n .. " methods from \"" .. tablename .. "\"\n");
				end ]]
				tinsert(aRet, ind .. "}\n");
			end
		end
	elseif(type(var)=="function" and WOWB_Debug_ClassMethodNamesByRef and WOWB_Debug_ClassMethodNamesByRef[var]) then
		tinsert(aRet, tostring(var) .. "  (class method " .. WOWB_Debug_ClassMethodNamesByRef[var] .. ")\n");
	elseif(type(var)=="function" and WOWB_Debug_GlobalFunctionNamesByRef and WOWB_Debug_GlobalFunctionNamesByRef[var]) then
		tinsert(aRet, tostring(var) .. "  (global function " .. WOWB_Debug_GlobalFunctionNamesByRef[var] .. ")\n");
	elseif(type(var)=="string") then
		tinsert(aRet, "\"" .. (string.gsub(var, "\n", "\\n")) .. "\"\n");
	else
		tinsert(aRet, tostring(var) .. "\n");
	end
end


function WOWB_DumpVar(var,maxdepth,ind)
	if(not ind) then ind=""; end
	if(not maxdepth) then maxdepth=5; end
	local aRet = {};
	WOWB_DumpVar_Fly(var,ind,{},maxdepth,aRet)
	local tab = debug.getinfo(2);
	return table.concat(aRet);
end


----------------------------------------------------------------------
-- function WOWB_OffsetStackPos(n)
--
-- skip over everything in @debugger.lua and functions named in WOWB_SkipStackFuncs[] 
-- (Does NOT follow aliases and please keep it that way!)
--

function WOWB_OffsetStackPos(n)
	-- if(1) then return n; end;
	for i=1,999 do
		local tab = debug.getinfo(i);
		if not tab then return nil; end
		if(WOWB_SkipStackFuncs[tab.name] or tab.source=="@debugger.lua" or tab.source=="@./debugger.lua") then
			-- nope, this depth doesn't exist =)
		else
			n=n-1;
			if(n<1) then
				return i-1;  -- getinfo will be called by my parent so -1
			end
		end
	end
	return nil;
end


---------------------------------------------------------------------
-- function getcurrentstackdepth()
--
-- Retreive current stack depth by probing debug.getinfo() with different depths
-- Note: very expensive operation time wise.
--

local _previousstackdepth = 8;
WOWB_SkipStackFuncs["getcurrentstackdepth"]=true;
function getcurrentstackdepth()
	local l=1;
	local h=_previousstackdepth;		-- work from previously known depth
	
	-- Test if we're still at the same depth as last time (often the case)
	if(debug.getinfo(h) and not debug.getinfo(h+1)) then
		return h-1; -- don't include myself
	end
	
	-- Expand upwards by multiplying depth by 2 until we pass the top
	while(debug.getinfo(h)) do
		l=h;
		h=h*2;
	end
	
	-- Now do divide and conquer search
	while l<h do
		local p = math.ceil((l+h)/2);
		if(debug.getinfo(p)) then
			l=p;
		else
			h=p-1;
		end
	end
	assert(l==h);
	
	-- Remember this depth
	_previousstackdepth = h;
	
	return h-1;  -- don't include myself
end



-----------------------------------------------------------
-- local function describestackpos(n)
-- 
-- Describe the function at the given stack depth as well
-- as humanly (LUAbly?) possible. There's a number of places
-- where information can come from:
--
-- - WOWB_StackInfo[]  (from WOWB_AddStackInfo or from the WOWB_XMLFileParserContext helper)
-- - The debug ".source" field being set to "WOWB_STACKINFO##filename##linenum##extrainfo"; done for all <On..> handlers and more
-- - Looking in WOWB_Debug_GlobalFunctionNamesByRef to accurately name functions that have been called via aliases
--

local function describestackpos(n)
	n=WOWB_OffsetStackPos(n);
	if(not n) then
		return nil;
	end
	
	local nStackInfoPos = getcurrentstackdepth() - n + 1;
	local info;
	if(nStackInfoPos>WOWB_StackInfo.n) then
		info = nil;
	else
		info = WOWB_StackInfo[nStackInfoPos];
	end
		
	local tab = debug.getinfo(n);
	if(not tab) then
		return nil;
	end	
	local src = tab.source;
	if(src=="=[C]") then 
		src="(C)";
	elseif(string.sub(src,1,1)=="@") then
		src=string.sub(src,2);
		if(WOWB_Debug_GlobalFunctionNamesByRef[tab.func] and WOWB_Debug_GlobalFunctionNamesByRef[tab.func]~=tab.name) then
			tab.name = WOWB_Debug_GlobalFunctionNamesByRef[tab.func] .. " (via "..tab.namewhat.." "..(tab.name or "(nil)")..")";
			tab.namewhat = "global";
		end
	else
		src = string.gsub(src, "\r", "");
		src = string.gsub(src, "[ \t]*\n[ \t]*", "\n");
		src = string.gsub(src, "^[ \t]+", "");
		src = string.gsub(src, "[ \t]+$", "");

		if(string.find(src, "^WOWB_STACKINFO##")) then
			local _,_,filename,linenum,info=string.find(src, "^WOWB_STACKINFO##([^#\n]+)##(%d+)##([^#]+)");
			ret = filename..":"..(tonumber(linenum)+tab.currentline-1)..":"..info;
		elseif(info) then
			src=string.gsub(src, "\n", "\\n");
			if(strlen(src)>40) then
				src = string.sub(src,1,37) .. '..."';
			end
			ret = info.filename..":"..(info.linenum+tab.currentline-1)..":"..info.info.." "..src;
		elseif(tab.currentline>0) then
			ret = "[string]:"..tab.currentline..": ";
			local ind = string.rep(" ", strlen(ret));
			local b,e=1,0;
			local n=1;
			local bFirst = true;
			src = src .. "\n";
			while n<=tab.currentline+2 do
				_,e = string.find(src, "\n", b);
				if(not e) then break; end
				local str = string.sub(src,b,e-1);
				b=e+1;
				
				if(n<tab.currentline-2) then
					-- nope
				elseif(string.find(str,"^[%s%c]*$")) then
					-- nada
				else
					if(bFirst) then
						bFirst = false;
					elseif(n==tab.currentline) then 
						ret = ret .. "\n" .. string.sub(ind,5) .. " -> ";
					else
						ret = ret .. "\n" .. ind;
					end
					if(strlen(str)>100) then
						ret = ret .. "\"" .. string.sub(str,1,97) .. "...\"";
					else
						ret = ret .. "\"" .. str .. "\"";
					end
				end
				n=n+1;
			end
				
			if(bFirst) then
				ret = ret .. " (couldn't find line "..tab.currentline.."?!)";
			end
		end
		
		if(info and info.appendlines) then
			ret = ret .. "\n" .. info.appendlines;
		end
		return ret;
	end
	
	if(info and info.filename) then
		ret = string.format("%s:%d:%s (%s:%d:%s %s)",
			info.filename, info.linenum or -1, info.info or "",
			src, tab.currentline, tab.namewhat, 
			tab.name or ""
		);
	else
		ret =  string.format("%s:%d:%s %s", 
			src, tab.currentline, tab.namewhat, 
			tab.name or ""
		);
		if(info and info.info) then
			ret = ret .. " ("..info.info..")";
		end
	end
	
	if(info and info.appendlines) then
		ret = ret .. "\n" .. info.appendlines;
	end
	
	return ret;
end	


---------------------------------------------------------------------
-- local function gettablememberviastring(tab,strIndices)
--
-- Access a table member via table reference + index string, 
-- e.g. myTable, "[0].foo['bar']"
--

local function gettablememberviastring(tab,strIndices)
	local idx;
	local ext = assert(strIndices);
	while(ext~="") do
		if(type(tab)~="table") then
			
		end
		if(string.find(ext,"^%[\"(.-)\"%](.*)")) then
			_,_,idx,ext = string.find(ext,"^%[\"(.-)\"%](.*)");
			tab=tab[idx];
		elseif(string.find(ext,"^%['(.-)'%](.*)")) then
			_,_,idx,ext = string.find(ext,"^%['(.-)'%](.*)");
			tab=tab[idx];
		elseif(string.find(ext,"^%[(-?%d+)%](.*)")) then
			_,_,idx,ext = string.find(ext,"^%[(.-)%](.*)");
			idx = tonumber(idx);
			tab=tab[idx];
		elseif(string.find(ext,"^%.([%a_][%a%d_]+)(.*)")) then
			_,_,idx,ext = string.find(ext,"^%.([%a_][%a%d_]+)(.*)");
			tab=tab[idx];
		else
			return nil,"syntax error at '"..ext.."'";
		end
		if(not tab) then
			if(tonumber(idx)) then
				return nil,"no such table index ["..idx.."]";
			else
				return nil,"no such table index [\""..idx.."\"]";
			end
		end
		assert(ext);
	end
	return tab;
end

---------------------------------------------------------------------
-- local function getlocalvarext(stackdepth, varname)
--
-- Get a local variable at the given stack depth. Understands
-- table indices (e.g. "sometable[123].blah") through calling
-- gettablememberviastring()
--

local function getlocalvarext(stackdepth, varname)
  local n=WOWB_OffsetStackPos(stackdepth);
  if(not n) then 
  	return nil, "Stack depth "..stackdepth.." does not exist";
 	end
  
  local _,_,base,ext = string.find(varname, "^([%a_][%a%d_]*)(.*)");
  local name,val,msg;
	for i=1,999999 do
		name,val = debug.getlocal(n,i);
		if(not name) then
			return nil, "No \""..base.."\" at stack depth "..stackdepth;
		end
		if(name==base) then
			break;
		end
	end
	val,msg = gettablememberviastring(val, ext);
	if(msg) then
		msg = "'"..varname.."': "..msg;
	end
	return val,msg;
end



---------------------------------------------------------------------
-- local function getglobalvarext(stackdepth, varname)
--
-- Get a global variable. Understands table indices 
-- (e.g. "sometable[123].blah") through calling gettablememberviastring()
--

local function getglobalvarext(varname)
  local _,_,base,ext = string.find(varname, "^([%a_][%a%d_]*)(.*)");
  val = getglobal(base);
  if(not val) then return nil; end
	val,msg = gettablememberviastring(val, ext);
	if(msg) then
		msg = "'"..varname.."': "..msg;
	end
	return val,msg;
end


---------------------------------------------------------------------
-- local function locals(stackdepth, maxtabledepth)
--
-- Dump all local variables at diven stack depth
--

local function locals(stackdepth, maxtabledepth)
	local str = describestackpos(stackdepth);
	if(not str) then
		print("locals: nothing at stack depth "..stackdepth);
		return;
	end
	
	print("\nLocals of " .. str);
	print(string.rep("-",60).."\n");

	local n=WOWB_OffsetStackPos(stackdepth);
	
	for i=1,1000 do
		local name,val = debug.getlocal(n,i);
		if(not name) then
			return;
		end
		io.write("  " .. name .. " = " .. WOWB_DumpVar(val, maxtabledepth, "  "));
	end
	print "Aborting output at 1000 local variables. l2code.\n";
end


---------------------------------------------------------------------
-- local function stack(maxdepth)
-- 
-- Display call stack

local function stack(maxdepth)
	maxdepth = tonumber(maxdepth) or 20;
	local n=1;
	for i=1,maxdepth do
		str = describestackpos(n);
		if(not str) then
			break;
		end
		print(string.format("  %2d %s", i, string.gsub(str,"\n","\n     ")));
		n=n+1;
	end
	local i=0;
	while(describestackpos(n+i)) do
		i=i+1;
	end
	if(i>0 and maxdepth>1) then   -- if someone asks for "1" they know they're missing out on stuff  (used by "exit"/"quit" debugger commands), so don't display warning about missing stuff
		print("  ... "..i.." deeper points not shown");
	end
end




	
local function WOWB_ErrHandler_FormatMessage(msg,bEditDump)
	--[[  this seemed like a good idea but errors from lua file load really want their file:line info kept intact
	local _,_,pos,str = string.find(msg, "^(.-:%-?%d+: *)(.*)$");
	if(not str) then   
		str = msg;
	end
	]]
	local str=msg;
	
	local errdump;
	if(bEditDump) then
		print("Dumping stack state to tmp/errdump.txt...");
		errdump = io.open("tmp/errdump.txt", "w");
		if(errdump) then errdump:write("ERROR: " .. str); end
	end
	
	for n=1,30 do
		local locstr = describestackpos(n);
		if(not locstr) then
			break;
		end
		str = str.."\n  ".. string.gsub(locstr,"\n","\n  ");
		
		if(errdump) then
			errdump:write("\n\n" ..
				"Depth " .. n .. ": " .. locstr .. "\n" .. 
				string.rep("-", 70) .. "\n\n");
			
			local nActual=WOWB_OffsetStackPos(n);
			for i=1,100 do
				local name,val = debug.getlocal(nActual,i);
				if(not name) then
					break;
				end
				errdump:write("  " .. name .. " = " .. WOWB_DumpVar(val, _ERRORDUMPDEPTH, "  "));
				if(i==100) then
					errdump:write("Aborting output at 100 local variables. l2code.\n");
				end
			end
		end
		
	end

	if(errdump) then
		io.close(errdump);
	end

	
	return str;
end



WOWB_SkipStackFuncs["WOWB_ErrHandler"]=true;
function WOWB_ErrHandler(msg)
	msg = msg or "";
	if(string.find(msg, "JUSTBAILPLEASE")) then
		return msg;
	end
	if(string.find(msg, "[NODBG]",1,true)) then
		return string.gsub(msg, "%[NODBG%]", "", 1);
	end
	local b;
	b,msg=pcall(WOWB_ErrHandler_FormatMessage, msg, _EDITDUMPONERROR);  -- grmbl when error handlers become so big you need to be able to debug them ... hmmm... =)
	if(not b) then
		print("ERROR IN ERROR HANDLER: "..msg); -- sigh
	else
		if(errlog) then
			errlog:write(os.date("%Y-%m-%d %H:%H:%S")..": "..msg);
			errlog:write("\n\n");
			errlog:flush();
		end
		
		if(_EDITDUMPONERROR) then
			os.execute("\"".._EDITOR .. "\" tmp/errdump.txt");
		end
		
		if(_DEBUGONERROR) then
			print "";
			print("ERROR: "..string.gsub(msg, "\n.*", ""));
			WOWB_Debugger();
		end
	end		
	return msg;
end



function WOWB_ErrHandler_JustLog(msg)
	local b;
	b,msg=pcall(WOWB_ErrHandler_FormatMessage, msg, false);
	errlog:write(os.date("%Y-%m-%d %H:%H:%S")..": "..msg);
	errlog:write("\n\n");
	errlog:flush();
	return msg;
end


----------------------------------------------------------------------
-- function WOWB_AddStackInfo(filename,linenum,info,appendlines, nOffset)
--
-- Adds information pertaining to current stack depth (or 
-- deeper in advance). Helps debugging.
--
-- Note that this function is relatively slow because of getcurrentstackdepth() 
-- having to use the debug library.
-- You don't want to use it in recurring recursion (i.e. the XML parser). 
-- Using something specialized (like the WOWB_XMLFileParserContext) is necessary.
--
----------------------------------------------------------------------

WOWB_StackInfo = {n=0}

function WOWB_AddStackInfo(filename,linenum,info,appendlines, nOffset)
	local n = getcurrentstackdepth() -1;   -- -1: remove WOWB_AddStackInfo
	for i=WOWB_StackInfo.n,n,-1 do
		WOWB_StackInfo[i] = nil;
	end
	if(nOffset) then
		n=n+nOffset;
	end
	WOWB_StackInfo[n] = {
		filename=filename,
		linenum=linenum,
		info=info,
		appendlines=appendlines
	};
	WOWB_StackInfo.n = n;
end

function WOWB_RemoveStackInfo()
	local n = getcurrentstackdepth() -1;   -- remove WOWB_RemoveStackInfo
	for i=WOWB_StackInfo.n,n,-1 do
		WOWB_StackInfo[i] = nil;
	end
	WOWB_StackInfo.n=n-1;
end







-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--
-- Debugger commands
--

WOWB_DebugCmds = {}

WOWB_DebugCmds.stack = {
	syntax = "$cmd [<maxstackdepth>]",
	help   = "Shows the current call stack",
	func   = function(cmd,args) stack(tonumber(args[1])); end
}

WOWB_DebugCmds.locals = {
	syntax = "$cmd <stackdepth> [<maxstackdepth>]",
	help   = "Show all local variables on the given stack depth",
	func = function(cmd, args)
		if(not tonumber(args[1])) then
			return "missing stack depth";
		end
		locals(tonumber(args[1]), tonumber(args[2]) or 1);
	end
}


WOWB_DebugCmds.dump = {
	syntax = {
		"$cmd <globalvarname> [<maxtabledepth>]",
		"$cmd [-i] <pattern>",
		"$cmd <stackdepth>:<localvarname> [<maxtabledepth>]",
	},
	help = "Output contents of a variable (recursing into tables)\n"..
	       "Or dump all global variables matching the given pattern (-i = case insensitive).",
	func = function(cmd,args)

		if(args[1] and (args[1]=="-i" or string.find(args[1], "[%-%%*%?%+%^%$]"))) then
			local bCaseMatch = true;
			local name=args[1];
			if(args[1]=="-i") then
				bCaseMatch = false;
				name = string.lower(args[2]);
			end
			local a = {}
			for k,v in pairs(_G) do
				if(type(k)=="string" and string.find(bCaseMatch and k or string.lower(k), name)) then
					tinsert(a, k.." = "..WOWB_DumpVar(v, 0));
				end
			end
			local fil = io.output();
			if(cmd=="editdump") then
				fil = assert(io.open("tmp/dump.txt", "w"));
			end
			fil:write("All global variables matching \""..name.."\""..
				(bCaseMatch and "" or " (case insensitive)")..
				":\n  ");
			fil:write(table.concat(a, "  "));
			if(cmd=="editdump") then
				io.close(fil);
				os.execute("\"".._EDITOR .. "\" tmp/dump.txt");
			end
			return;
		end
	
		local var,msg,maxdepth,dispname;
		if(not args[1]) then
			return "missing variable name";
		elseif(string.find(args[1], "^%d+:")) then
			local _,_,depth,varname=string.find(args[1], "^(%d+):(.*)");
			if(not varname or varname=="") then
				return "missing variable name to dump at stack depth "..depth;
			end
			var,msg = getlocalvarext(depth, varname);
			if(msg) then
				return msg;
			end
		else
			var = getglobalvarext(args[1]);
		end
		
		maxdepth = tonumber(args[2]);
		
		
		if(cmd=="dump") then
			maxdepth = maxdepth or _DUMPDEPTH;
			io.write("Contents of "..args[1].." = ");
			print(WOWB_DumpVar(var, maxdepth));
		elseif(cmd=="editdump") then
			maxdepth = maxdepth or _EDITDUMPDEPTH;
			local fil = assert(io.open("tmp/dump.txt", "w"));
			fil:write("Contents of "..args[1].." = " .. WOWB_DumpVar(var, maxdepth));
			io.close(fil);
			os.execute("\"".._EDITOR .. "\" tmp/dump.txt");
		end
	end
}

WOWB_DebugCmds.editdump = {
	syntax = WOWB_DebugCmds.dump.syntax,
	help = WOWB_DebugCmds.dump.help .. " to _EDITOR",
	func = WOWB_DebugCmds.dump.func,
}
	
WOWB_DebugCmds["varname = <depth>:..."] = {
	regex = "^ *([%a_][%a%d_]*) *= *(%d+):(.*)",
	syntax = "varname = <stackdepth>:<localvarname>";
	help = "Extract a local variable into the given global variable for further processing";
	func = function(cmdline, a)
		local tovar,depth,locvar = a[3],a[4],a[5];
		var,msg = getlocalvarext(depth, locvar);
		if(not var) then
			return "No local variable named \""..locvar.."\" at stack depth "..depth;
		elseif(msg) then
			return msg;
		else
			setglobal(tovar, var);
		end
	end
}



WOWB_Debugger_Recurse=0;

local function debugger()
	
	if(WOWB_Debugger_Recurse>1) then
		return false;
	end

	print("Entering debugger. Use \"help\" for help.");
	
	WOWB_SkipStackFuncs["WOWB_Debug_CommandLine"] = true;
	WOWB_Debug_CommandLine = WOWB_CommandLine;  -- hehe, ugly trick =)	
			
	if(not WOWB_Debug_CommandLine{prompt="\ndebug> ", ignorenextses=true, nodpcs=true, WOWB_DebugCmds}) then
		-- command line parser thinks stdin is not a console
		-- willingly NOT restoring WOWB_Debugger_Recurse; it'll cause immediate return next 
		-- time this is called without on-screen spam
		WOWB_Debugger_Recurse = 999;
		return false;
	end

	print("Exiting debugger back to "..describestackpos(1));
	print ""
	
	return true;
end


WOWB_SkipStackFuncs["WOWB_Debugger"] = true;
function WOWB_Debugger()
	WOWB_Debugger_Recurse = WOWB_Debugger_Recurse + 1;
	while(true) do
		local success,retval = xpcall(debugger, function(a) return a; end);
		if(not success) then
			if(string.find(retval, ": interrupted!")) then
				break;
			end
			print("BUG IN DEBUGGER: "..retval);
		else
			break;
		end
	end
	WOWB_Debugger_Recurse = WOWB_Debugger_Recurse - 1;
end




---------------------------------------------------------------------
-- function DP(cat, lvl, msg)
--
-- Debug Print, filtered according to category and level settings 
-- in config.lua:WOWB_DEBUGCAT[]
--


WOWB_SkipStackFuncs["DP"] = true;
function DP(cat, lvl, msg)
	if((WOWB_DEBUGCAT[cat] or 0)>=lvl) then
		local ind = string.rep(" ", (lvl-1)*2);
		local tab = debug.getinfo(WOWB_OffsetStackPos(1));
		if(tab.name and tab.name~="") then
			if(WOWB_Debug_GlobalFunctionNamesByRef[tab.func]) then tab.name=WOWB_Debug_GlobalFunctionNamesByRef[tab.func]; end
			if(WOWB_Debug_ClassMethodNamesByRef[tab.func]) then tab.name=WOWB_Debug_ClassMethodNamesByRef[tab.func]; end
			print(ind..tab.name..": "..msg);
		else
			local _,_,src = string.find(tab.source, "([^\\/]*)$");
			print(ind..src..":"..(tab.currentline or -1)..": "..msg);
		end
	end
end



-----------------------------------------------------------
--
-- function WOWB_Pcall(func, errhandler, ...)
--
-- Smart replacement for xpcall() that allows parameters to
-- be passed into the called function, as well as retaining
-- active errorhandler (via errhandler==nil)
--
-- Params:  func  - function to call
--          errhandler - error handler to use or 
--										 - nil for whatever is already active
--          ... - arguments to func
--
-- Returns: - bool - success or error (true or false)
--          - (bool=true): table - return values from func
--            (bool=false): string - error message
--    
-----------------------------------------------------------

WOWB_Pcall_Params = {}
WOWB_CURRENT_ERRHANDLER = nil;

WOWB_SkipStackFuncs["WOWB_Pcall"] = true;
function WOWB_Pcall(func, errhandler, ...)
	
	if(not WOWB_CURRENT_ERRHANDLER) then
		WOWB_CURRENT_ERRHANDLER = WOWB_ErrHandler;  -- don't want to do this at load time since it screws up the global function name scanner
	end
	
	local function WOWB_Pcall_Inner()
		return true, { WOWB_Pcall_Params.function_called_by_WOWB_Pcall( unpack(WOWB_Pcall_Params.arg) ) };
	end
	
	local prevhandler = WOWB_CURRENT_ERRHANDLER;
	if(errhandler) then 
		WOWB_CURRENT_ERRHANDLER = errhandler; 
	end
	
	WOWB_Pcall_Params = { function_called_by_WOWB_Pcall = func, arg = arg };  -- must be stored globally since xpcall() doesnt pass params on
	-- Yeah, cumbersome name, but it's what gets shown in the stack...
	
	local b, ret = xpcall(WOWB_Pcall_Inner, WOWB_CURRENT_ERRHANDLER);
	
	WOWB_CURRENT_ERRHANDLER = prevhandler;
	return b, ret;
end



-----------------------------------------------------------
-- function WOWB_Debug_RegisterGlobalFunctionNames()
--
-- Run through all functions encountered in the global
-- environment (_G) and register their names in
-- WOWB_Debug_GlobalFunctionNamesByRef. If a name is already
-- known, it will not be replaced (it'll be a hook).
--
-- This function is called multiple times from several
-- places in the code, e.g. when WoWBench has finished
-- loading, after each module is loaded (but before
-- <OnLoad> handlers are run), to see the global definitions
-- before they're hooked by anything else.
--
-----------------------------------------------------------

function WOWB_Debug_RegisterGlobalFunctionNames()
	for k,v in pairs(_G) do
		if(type(v)=="function") and not WOWB_Debug_GlobalFunctionNamesByRef[v] then
			WOWB_Debug_GlobalFunctionNamesByRef[v]=k;
		end
	end
end





function WOWB_Bail()
	-- I used to have os.exit(1) sprinkled all over the code, but, guess what? IT EXITS LUAEDIT TOO. Duh.
	-- Now I trigger an error with JUSTBAILPLEASE which suppresses all error reporting when it's caught
	-- by the bottom xpcall()
	error("JUSTBAILPLEASE", 0);
end

