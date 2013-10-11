
--
-- wowbench.lua  - Copyright (c) 2006, the WoWBench developer community. All rights reserved. See LICENSE.TXT.
--
-- 

WOWB_VER = "1.12.0.a2";
WOWB_PHASE = "";  -- "LOAD" -> "STARTEVENTS" -> "LIVE"


libs="";

luaopen_bit = loadlib("bitlib.dll", "luaopen_bit");
if(luaopen_bit) then
  libs=libs.." +bitlib";
  luaopen_bit();
else
  libs=libs.." -bitlib";
end


print("[WoWBench v"..WOWB_VER..libs.."]");
print("");



-- Necessary dofile() and loadstring() hacks for multisession
if(not WOWB_ORIG_loadfile) then WOWB_ORIG_loadfile = loadfile; end
function loadfile(filename) local chunk,msg=WOWB_ORIG_loadfile(filename); if chunk then setfenv(chunk, getfenv()); end; return chunk,msg; end
function dofile(filename) local chunk,msg = loadfile(filename); if(not chunk) then error(msg, 0); end chunk(); end
if(not WOWB_ORIG_loadstring) then WOWB_ORIG_loadstring = loadstring; end
function loadstring(str) local chunk,msg = WOWB_ORIG_loadstring(str); if chunk then setfenv(chunk, getfenv()); end; return chunk,msg; end


-- Make a copy of the base environment to use in additional sessions. Shallow copy should be ok at this point.
-- (If this _IS_ an additional session, WOWB_BaseEnv will already be set)
if(not WOWB_SessCtl) then
	local baseenv = {};
	for k,v in _G do
		baseenv[k]=v;
	end
	WOWB_SessCtl = { BaseEnv = baseenv; }
	table.insert(WOWB_SessCtl, _G); -- we're the first environment
end


function help()
print("Usage: " .. tostring(arg[-1]) .." " .. tostring(arg[0]) .. " [<parameters>] addon1 [addon2 ...]");
print([[

Parameters:
  -q  Quick mode (Use framexml-lite.toc)
  -x  Syntax checker mode (load LUAs, verify XML syntax, run nothing)
  -d  Enable debug output according to WOWB_DEBUGCAT in config.lua
  -v  Verbose
  -f  Forced reparse of all files, don't use compiled files
  
]]);
	return;
end

if(not arg[1]) then
	help();
	return;
end

_VERBOSE = false;
_ADDONS = {};
_QUICK = false;
_SYNTAXONLY = false;
_DEBUG = false;
_FORCEREPARSE = false;
_CWD = "./";

-- Pull in configuration (and fill out defaults)

dofile("config.lua");

if(_FORCECHARACTER) then        -- gets set in additional sessions'
	_PARTY[0] = _FORCECHARACTER;
	_CHARACTER = _FORCECHARACTER;
end

_WOWDIR = _WOWDIR or "C:/Program Files/World of Warcraft";
_EDITOR = _EDITOR or "start notepad.exe"
_LUAC = _LUAC or "luac.exe"
_MINDELAY = _MINDELAY or 0.2;
_EDITDUMPDEPTH = _EDITDUMPDEPTH or 20;
_DUMPDEPTH = _DUMPDEPTH or 2;
_ERRORDUMPDEPTH = _ERRORDUMPDEPTH or 3;
_DUMPDONTFOLLOW = _DUMPDONTFOLLOW or { 
	["previous"]=1, ["parent"]=1, ["prev"]=1, ["parentobj"]=1 
};
_DEBUGONERROR = _DEBUGONERROR or true;




-- .toc files that always get parsed
_TOCFILES = {
	"world.toc",
	"blizzardui.toc",
	"BlizzardInterface/FrameXML/FrameXML.toc",
}

-- things to get executed on the prompt
if(not _FORCECHARACTER) then -- only in first session
	_INFILES = {
		cur=1
	}
end

for i=1,table.getn(arg) do
	local a = arg[i];
	if(a=="-h") then
		help();
		return;
	elseif(a=="-v") then 
		_VERBOSE = true; 
	elseif(a=="-d") then
		_DEBUG = true;
	elseif(a=="-q") then
		_QUICK = true;
		_TOCFILES = {
			"world.toc",
			"blizzardui.toc",
			"BlizzardInterface/FrameXML/FrameXML-lite.toc",
		}
	elseif(a=="-x") then
		_SYNTAXONLY = true;
		_TOCFILES = {
			"blizzardui.toc",
		}
	elseif(a=="-f") then
		if(not _FORCECHARACTER) then _FORCEREPARSE = true; end   -- only in first session
	elseif(string.find(a, "%.[tT][xX][tT]$")) then
		if(not _FORCECHARACTER) then -- only in first session
			local fil,msg = io.open(a, "rt");
			if(not fil) then error(msg); end
			table.insert(_INFILES, fil);
		end
	else
		table.insert(_ADDONS, a);
	end
end


if(not _FORCECHARACTER) then -- only in first session
	table.insert(_INFILES, io.input());
end

if(not _DEBUG) then
	for k,v in WOWB_DEBUGCAT do
		WOWB_DEBUGCAT[k]=0;
	end
end




fil,msg = io.open("wowbench.lua");
if(not fil) then
	print "Run WoWBench with current directory set to where WoWBench lives.";
	print "i.e. > cd c:\wowbench";
	print "     > lua50 wowbench.lua";
	print("("..msg..")");
	return;
end
io.close(fil);



local fil,msg = io.open(_WOWDIR.."/wow.exe");
if not fil then
	fil,msg = io.open(_WOWDIR.."/WoW.exe");
end
if(not fil) then
	print "ERROR: Make certain that _WOWDIR is set correctly in config.lua!";
	print("("..msg..")");
	return;
end
io.close(fil);


fil,msg = io.open("tmp/exists","w");
if(not fil) then
	os.execute("mkdir tmp");    -- should work evvvvverrrywhere
else
	io.close(fil);
end


dofile("utils.lua");
dofile("debugger.lua");
dofile("api.lua");
dofile("xmlparse.lua");
dofile("cmdline.lua");
dofile("classops.lua");



if(not _ACCOUNT or _ACCOUNT=="") then
	_ACCOUNT = GetCVar("accountName");
end
if(_ACCOUNT and _ACCOUNT~="") then
	_ACCOUNT = strupper(_ACCOUNT);
end

if(not _REALM or _REALM=="") then
	_REALM = GetCVar("realmName");
end

if(not _ACCOUNT or _ACCOUNT=="") then	print("Please specify _ACCOUNT in your config.lua"); return; end
if(not _REALM or _REALM=="") then	print("Please specify _REALM in your config.lua"); return; end
if(not _CHARACTER or _CHARACTER=="") then	print("Please specify _CHARACTER in your config.lua"); return; end


fil,msg = io.open(_WOWDIR.."/WTF/Account/".._ACCOUNT.."/".._REALM.."/".._CHARACTER.."/AddOns.txt");
if(not fil) then
	print "ERROR: Make certain that _ACCOUNT, _REALM and _CHARACTER is set correctly in config.lua!";
	print("("..msg..")");
	return;
end
io.close(fil);





-----------------------------------------------------------
-- function WOWB_FireEvent(name, ...)
--
-- Fire the given event with the given parameters.
--
-- Note that you probably do not want to call this from inside
-- API calls; that'll result in recursive calls into the addon,
-- something which it might not be prepared to handle.
-- (WoW doesn't recurse back into addons I don't think.. haven't tested though)
--
-- Rather use WOWB_QueueDPC(WOWB_FireEvent, name, ...)
--


WOWB_RegisteredEventsByEvent = { -- Used when firing events
	-- ["EVENT_NAME"][frameptr]=1
}

WOWB_RegisteredEventsByFrame = { -- Used in UnregisterAllEvents
	-- [frameptr]["EVENT_NAME"]=1
}

function WOWB_FireEvent(name, ...)
	
	DP("EVENT", 2, "Firing '"..name.."'");
	
	if(not WOWB_RegisteredEventsByEvent[name]) then
		return 0;
	end
	
	WOWB_AddStackInfo(nil,nil,name);
	
	local prevevent=event;
	
	local nFired=0;
	for frame,_ in WOWB_RegisteredEventsByEvent[name] do
		if(frame[0].Scripts and frame[0].Scripts[0].OnEvent) then
			event = name;
			DP("EVENT", 3, "  ... to " .. (frame:GetName() or "(unnamed)"..tostring(frame)));
			WOWB_DoScript({this=frame, script="OnEvent", args=arg});
			nFired=nFired+1;
		end
	end
	
	event=prevevent;
	
	WOWB_RemoveStackInfo();

	return nFired;
end





---------------------------------------------------------------------
-- function WOWB_DoScript({scriptnode=|script="", [this=,] args={}, [suppresserrors=true])
--
-- Execute [0].chunk stored in a script node
-- Also assign this=(this or scriptnode), arg1=args[1], arg2=args[2]....
-- (Remember what they were for previous recursion levels and restore when done)
--
--

WOWB_PrevScripts = {};  -- kept global for debugging purposes; could easily have been kept locally in WOWB_DoScript recursively

function WOWB_DoScript(params)
	assert((params.scriptnode and params.scriptnode[0]) or 
	       (params.this and params.this[0] and params.script)
	);

	local o = (params.this or params.scriptnode);
	local oScript = params.scriptnode;
	if(not oScript) then
		assert(type(params.script)=="string");
		if(not o[0].Scripts) then return; end
		oScript = o[0].Scripts[0][params.script];
	end

	if(oScript and oScript[0].chunk) then	
		DP("SCRIPT", 2, "Firing "..(o[0].name or (o[0].xmlfile..":"..o[0].xmlfilelinenum)).." <"..oScript[0].xmltag..">");
	
		tinsert(WOWB_PrevScripts, {
			this = this,
			arg1=arg1, arg2=arg2, arg3=arg3, arg4=arg4, arg5=arg5, arg6=arg6, arg7=arg7, arg8=arg8, arg9=arg9
		});
		
		this = o;
		
		local args = (params.args or {});
		arg1=args[1]; arg2=args[2]; arg3=args[3]; arg4=args[4]; arg5=args[5]; arg6=args[6]; arg7=args[7]; arg8=args[8]; arg9=args[9];
	
		if(o ~= oScript) then
			extraline=o[0].xmlfile..":"..o[0].xmlfilelinenum..":"..o[0].xmltag.." "..(o[0].name or "");
		end
	
		local bPrevSuppressErrors = WOWB_SuppressingErrors;
		if(params.suppresserrors) then
			WOWB_SuppressingErrors = true;
		end
		
		if(WOWB_SuppressingErrors) then
			if(not WOWB_Pcall(oScript[0].chunk, WOWB_ErrHandler_JustLog)) then
				WOWB_NumSuppressedErrors = WOWB_NumSuppressedErrors + 1;
			end
		else
			local b,msg = WOWB_Pcall(oScript[0].chunk);
			if(not b) then
				print("SCRIPT ERROR: "..msg);
			end
		end
		
		WOWB_SuppressingErrors = bPrevSuppressErrors;
			
		local p = WOWB_PrevScripts[getn(WOWB_PrevScripts)];
		this=p.this;
		arg1=p.arg1; arg2=p.arg2; arg3=p.arg3; arg4=p.arg4; arg5=p.arg5; arg6=p.arg6; arg7=p.arg7; arg8=p.arg8; arg9=p.arg9;
		
		tremove(WOWB_PrevScripts);
	end
		
end




-----------------------------------------------------------
-- function WOWB_RunOnLoadsAndScripts(aObjects)
--
-- Execute contents of <Script> and <OnLoad> tags
-- Called on a per-mod basis.
--
--

function WOWB_RunOnLoadsAndScripts(aObjects, bSuppressErrors)
	DP("SCRIPT", 1, "Begin");
	
	local nObjects=0;
	local nObjScripts=0;
	local nObjOnLoads=0;
	local nScripts=0;
	
	for i=1,getn(aObjects) do
		local o=aObjects[i];
		if(o[0].xmltag == "Script") then
			nScripts = nScripts+1;
			if(not string.find(o[0].content, "^[\\r\\n%s%c]*$")) then
				WOWB_DoScript({scriptnode=o, suppresserrors=bSuppressErrors});
			end
			-- file="..." has already been registered with the .toc loader (and will have been run already)
		else
			nObjects=nObjects+1;
			if(o[0].Scripts) then 
				nObjScripts=nObjScripts+1;
				if(o[0].Scripts[0].OnLoad) then
					nObjOnLoads=nObjOnLoads+1
					WOWB_DoScript({this=o, scriptnode=o[0].Scripts[0].OnLoad, suppresserrors=bSuppressErrors});
				end
			end
		end
	end
	
	DP("SCRIPT", 1, "End. <Script>:"..nScripts.."   Objects:"..nObjects.." <Scripts>:"..nObjScripts.." <OnLoad>:"..nObjOnLoads);
end




---------------------------------------------------------------------
---------------------------------------------------------------------
---------------------------------------------------------------------
--
-- TOC file handling
-- 
--

WOWB_SavedVariablesGlobal = {};
WOWB_SavedVariables = {};
WOWB_SavedVariablesPerCharacter = {};

-- These three get reset per TOC file parsed:
WOWB_AllFilesForTOC = {}    -- All files referenced by the TOC + included files (gets filled in by parsers)
WOWB_ScriptsToRunForTOC = {}  -- All <OnLoad>s and <Script>s encountered during parsing go in here



---------------------------------------------------------------------
-- function WOWB_ParseTOC(orgfilename)
--
-- - Call WOWB_ParseXML()
-- - Execute plain .LUA files
-- - Compile all of the above into TocFile.toc.luac
--
--

function WOWB_ParseTOC(orgfilename)
	filename = _CWD..orgfilename;
	tocfilename = filename;
	luacfile = filename..".luac";
	luacdepfile = filename..".luac.dep";
	aFiles = {}
	
	DP("TOC",1, "Begin "..filename);
	
	WOWB_AllFilesForTOC = {}
	WOWB_ScriptsToRunForTOC = {}
	
	if(_FORCEREPARSE) then
		WOWB_RemoveFile(luacfile);
		WOWB_RemoveFile(luacdepfile);
	end
	
	
	----------------------------------------------
	-- Parse the .toc file contents
	
	local fil,msg = io.open(filename);
	if(not fil) then
		print(msg);
		WOWB_Bail();
	end
	local lin = fil:read("*l");
	local nLine=0;
	while lin do
		nLine = nLine +1;
		if(nLine==1) then lin=string.gsub(lin, "^\239\187\191", ""); end
		
		_,_,lin = string.find(lin, "^ *([^%s]+)");
		if(not lin) then
			lin = lin;
		elseif(string.find(lin ,"^#")) then
			local str;
			_,_,str=string.find(lin,"## *SavedVariables: *(.-) *$");
			for v in string.gfind(str or "","[%a_][%a%d_]*") do
				table.insert(WOWB_SavedVariables, v);
			end
			_,_,str=string.find(lin,"## *SavedVariablesPerCharacter: *(.-) *$");
			for v in string.gfind(str or "","[%a_][%a%d_]*") do
				table.insert(WOWB_SavedVariablesPerCharacter, v);
			end
		elseif(string.find(lin,"%.lua$")) then
			tinsert(aFiles, (string.gsub(lin, "[\\/]+", "/")));
		elseif(string.find(lin,".xml$")) then
			tinsert(aFiles, (string.gsub(lin, "[\\/]+", "/")));
		else
			WOWB_AddStackInfo(filename,nLine);
			error("Unknown .toc argument: " .. lin);
		end
		lin = fil:read("*l");
	end
	

	
	-----------------------------------------------
	-- Use our .toc.luac file if it is up to date!
	
	if(not _FORCEREPARSE and not _SYNTAXONLY) then
		b = true;
		fil,msg = io.open(luacdepfile);
		if(not fil) then
			b=false;
			DP("TOC",2, "Forcing recompile -- "..msg);
		elseif(not WOWB_IsFileNewerThan(_CWD, orgfilename..".luac", orgfilename)) then
			b=false;
			DP("TOC",2, "Modified: "..orgfilename);
		else
			for lin in fil:lines() do
				if(WOWB_IsFileNewerThan(_CWD, orgfilename..".luac", lin)) then
					-- all good so far
				else
					b=false;
					DP("TOC",2, "Modified: "..lin);
					break; --bleh
				end
			end
		end
		if(fil) then
			io.close(fil);
		end
		
		if(b) then
			if(_VERBOSE) then print("LUA: "..WOWB_SimpleFilename(luacfile)); end
			DP("TOC",2, "Directly executing compiled "..luacfile);
			WOWB_EXECCOMPILED = true; -- setting this flag makes the compiled lua code skip dofile() and WOWB_ParseXML() calls; those files will have been run already
			dofile(luacfile);
			WOWB_EXECCOMPILED = nil;
			DP("TOC",1, "End "..filename);
			return;
		end		
	end
	
	
	-----------------------------------------------
	-- Parse XML, Execute LUA
	
	DP("TOC",2, "Parsing contents");

	local prevCWD = _CWD;
	for i=1,getn(aFiles) do
		local filename = WOWB_ProcessFilename(aFiles[i], false);
		if(not filename) then
			print("Warning: "..tocfilename..": Cannot locate \""..aFiles[i].."\". Skipping file.");
		elseif(string.find(filename,"%.lua$")) then
			if(_VERBOSE) then print("LUA: "..WOWB_SimpleFilename(filename)); end
			dofile(filename);
			tinsert(WOWB_AllFilesForTOC, filename);
		else
			local prevCWD = _CWD;
			local b,msg = WOWB_Pcall(WOWB_ParseXML, nil, filename);
			_CWD = prevCWD;
			if(not b) then
				if(WOWB_ParseXML_CurrentOutputFile) then
					io.close(WOWB_ParseXML_CurrentOutputFile);
					WOWB_ParseXML_CurrentOutputFile = nil;
				end
				WOWB_RemoveFile(filename..".lua");
				if(msg=="JUSTBAILPLEASE") then
					WOWB_Bail();
				end
				print("ERROR: " .. msg);
				if(string.find(msg, " XML: ")) then
					print("  Skipping this XML file.");
				else
					WOWB_Bail();
				end
			else
				tinsert(WOWB_AllFilesForTOC, filename);
			end
		end
	end
	_CWD = prevCWD;

	
	---------------------------------------------------------
	-- Compile all the files above, including files that have 
	-- gotten inserted in WOWB_AllFilesForTOC during parsing
	-- into finished path/to/addon.toc.luac

	if(not _SYNTAXONLY) then
		if(_VERBOSE) then print("Compiling "..WOWB_SimpleFilename(luacfile)); end;
		DP("TOC",2, "Compiling "..luacfile);
		
		local str = "";
		local nCompilerTmp=0;
			
		for i=1,getn(WOWB_AllFilesForTOC) do
			lin = WOWB_AllFilesForTOC[i];
			if(string.find(lin,"%.lua$")) then
				str = str .. " \"" ..lin.."\"";
			else
				str = str .. " \"" ..lin..".lua".."\"";
			end
			if(strlen(str)>900) then
				nCompilerTmp = nCompilerTmp + 1;
				os.execute(_LUAC.." -o tmp/luac"..nCompilerTmp..str);
				str="";
			end
		end
	
		if(nCompilerTmp>0) then
			if(str~="") then
				nCompilerTmp = nCompilerTmp + 1;
				os.execute(_LUAC.." -o tmp/luac"..nCompilerTmp..str);
				str="";
			end
			for i=1,nCompilerTmp do
				str = str .. " tmp/luac"..i;
			end
		end
		
		fil = assert(io.open(luacdepfile, "w"));
		fil:write(table.concat(WOWB_AllFilesForTOC, "\n"));
		io.close(fil);
	
		os.execute(_LUAC.." -o \""..luacfile.."\" "..str);
	end
	
	DP("TOC",1, "End "..filename);

end



-----------------------------------------------------------
-- function WOWB_FireOnUpdate()
--
-- Execute <OnUpdate> in all visible frames
-- (return number of frames that received it)
--
--

local LastOnUpdate = GetTime();
local function FireOnUpdate_Fly(o)
	if(not o:IsVisible()) then return 0; end
	local n=0;
	if(o[0].Scripts and o[0].Scripts[0].OnUpdate) then
		n=1;
		WOWB_DoScript({this=o, scriptnode=o[0].Scripts[0].OnUpdate, args={GetTime()-LastOnUpdate}});
	end
	for c,_ in o[0].children do
		n = n + FireOnUpdate_Fly(c);
	end
	return n;
end

function WOWB_FireOnUpdate()
	local n = FireOnUpdate_Fly(WOWB_RootFrame);
	LastOnUpdate = GetTime();
	return n;
end



-----------------------------------------------------------
-- function WOWB_ShowFirstFrames()
--
-- Loop through all base frames that should be shown and 
-- call their :Show() member.  They will recursively call
-- their own children.
--

function WOWB_ShowFirstFrames()
	WOWB_RootFrame[0].shown = true;
	for k,v in WOWB_RootFrame[0].children do
		if(k:IsShown()) then
			k:Show();
		end
	end
end




-----------------------------------------------------------
-- function WOWB_QueueDPC(func, ...)
--
-- Register a "Deferred Procedure Call", i.e. something that you
-- want called very soon, but not immediately. 
--
-- The DPC queue gets processed before WoWBench returns to the
-- command prompt.
--

WOWB_DPCQueue = {}

function WOWB_QueueDPC(func, ...)
	tinsert(WOWB_DPCQueue, {
		func = func,
		args = arg
	});
end



-----------------------------------------------------------
-- function WOWB_PumpDPCs()
--
-- Run queued DPCs. Gets called from WOWB_Main.
--

function WOWB_PumpDPCs()
	local i=getn(WOWB_DPCQueue)*5;		-- Allow up to 5 times the number of registered DPCs to run (for DPCs resulting in more DPCs)
	i = max(20, i);
	local j=0;
	while getn(WOWB_DPCQueue)>0 do
		j=j+1;
		if(j>=i) then
			error("WOWB_PumpDPCs ran more than "..i.." DPCs. Something may be re-registering DPCs infinitely. Examine WOWB_PumpDPCs");
		end
		local dpc = WOWB_DPCQueue[1];
		tremove(WOWB_DPCQueue, 1);
		dpc.func(unpack(dpc.args));
	end
end



---------------------------------------------------------------------
---------------------------------------------------------------------
---------------------------------------------------------------------
--
-- Let's make stuff happen!
--
	
	

local function _message(msg)
	print("message(): " ..msg);
end

local function header(str)
	str = "-------- ["..str.."] ";
	str = str .. string.rep("-", 79-string.len(str));
	print("\n"..str);
end

	
---------------------------------------------------------------------
-- function WOWB_Main()	
--
-- Gets executed at the end of this script inside a custom error handler
--
--
	
function WOWB_Main()	
	
	WOWB_PHASE="LOAD";

	---------------------------------------------------------------------
	-- Append .toc files of our AddOns to _TOCFILES list
	
	for _,a in _ADDONS do
		table.insert(_TOCFILES, _WOWDIR.."/Interface/AddOns/"..a.."/"..a..".toc");
	end
	
	---------------------------------------------------------------------
	-- Run through .toc file names, extract their paths, and get
	-- relative file ages of files in their directories (we want to
	-- know this to determine if we need to reparse .xml into .xml.lua)

	for _,tocfile in _TOCFILES do
		WOWB_CacheFileAges(WOWB_GetFileDir(tocfile));
	end	

	---------------------------------------------------------------------
	-- Parse all registered .toc files in _TOCFILES
	
	header("Parsing .TOC files");
	
	for k,tocfile in _TOCFILES do
		local filename;
		print("\n---["..WOWB_SimpleFilename(tocfile).."]");
		-- make _CWD contain the base path of the .toc; it gets used all over the place after this point
		_,_,_CWD,filename = string.find(tocfile, "^(.*[\\/])([-%a%d_]+%.toc)");
		if(not _CWD) then
			filename = tocfile;
			_CWD = "";
		end
		WOWB_ParseTOC(filename);
		message = _message; -- have to set this after framexml is parsed since it defines its own that we don't like
		
		if(not _SYNTAXONLY) then
			print("Running <OnLoad>s and <Scripts>s...");
			
			WOWB_Debug_RegisterGlobalFunctionNames();   -- we'll have loaded lots of new functions now so scan again
			
			local n = WOWB_NumSuppressedErrors;
			WOWB_RunOnLoadsAndScripts(WOWB_ScriptsToRunForTOC, false--[[don't suppress errors]]);
			
			if(WOWB_NumSuppressedErrors>n) then
				print("(tmp/errorlog.txt: added details of "..(WOWB_NumSuppressedErrors-n).." suppressed errors.)");
			end
		end
		
	end
	


	
	---------------------------------------------------------------------
	-- Pull in saved variables and fire ADDON_LOADED

	if(not _SYNTAXONLY) then	
		header("Loading saved variables and firing ADDON_LOADED for each addon");
		
		for _,a in _ADDONS do
			local files = {
				_WOWDIR .. "/WTF/Account/" .. _ACCOUNT .. "/SavedVariables/" .. a .. ".lua",
				_WOWDIR .. "/WTF/Account/" .. _ACCOUNT .. "/" .. _REALM .. "/" .. _CHARACTER .. "/SavedVariables/" .. a .. ".lua"
			}
			
			for _,filename in files do
				local fil = io.open(filename);
				if fil then
					io.close(fil);
					local chunk,msg;
					if(_VERBOSE) then print("LUA Vars: "..WOWB_SimpleFilename(filename)); end
					dofile(filename);
				else
					if(_VERBOSE) then print("Did not exist: "..WOWB_SimpleFilename(filename)); end
				end
			end
			WOWB_FireEvent("ADDON_LOADED", a);
		end
		
		dofile(_WOWDIR .. "/WTF/Account/" .. _ACCOUNT .. "/SavedVariables.lua");
	end
	
	---------------------------------------------------------------------
	-- Fire startup events
	
	if(not _SYNTAXONLY) then
		
		WOWB_PHASE = "STARTEVENTS";
		
		header("Firing VARIABLES_LOADED");
		WOWB_FireEvent("VARIABLES_LOADED");
		
		header("Startup events, showing frames, first OnUpdates, etc");
		
		print("Firing SPELLS_CHANGED...");
		WOWB_FireEvent("SPELLS_CHANGED");
		
		print("Showing frames initially shown...");
		WOWB_ShowFirstFrames();
		
		print("Firing PLAYER_LOGIN...");
		WOWB_FireEvent("PLAYER_LOGIN");
		
		WOWB_FireEvent("UPDATE_CHAT_WINDOWS");  -- Tell chat windows to "read their configuration"
		
		print("Firing PLAYER_ENTERING_WORLD...");
		WOWB_FireEvent("PLAYER_ENTERING_WORLD");
		print("");
		
		WOWB_FireOnUpdate();		-- Give all frames their first <OnUpdate>
		WOWB_PumpDPCs();
		WOWB_FireOnUpdate();		-- .. and again
		WOWB_PumpDPCs();
		WOWB_FireOnUpdate();		-- .. and again
		WOWB_PumpDPCs();
		
	end	
	
	---------------------------------------------------------------------
	-- We're live!
	
	header("I am alive!");
	
	WOWB_PHASE = "LIVE";
	
	if(WOWB_SessCtl.NextSes) then
		return; -- This a newly started session. The parent session is already running a command handler. Just bail.
	end
	
	print("Use \"help\" for help");
	
	while true do
		local prompt = "\ncmd> ";
		local nSes = WOWB_SessCtl.NextSes or 1;
		WOWB_SessCtl.NextSes = nil;
		local ses = WOWB_SessCtl[nSes];
		if(table.getn(WOWB_SessCtl)>1) then
			prompt = "\n["..nSes.."] "..ses._CHARACTER.."> ";
		end
		ses.WOWB_CommandLine{prompt=prompt, infiles=_INFILES, ses.WOWB_Cmds, ses.WOWB_WorldCmds};
		if(not WOWB_SessCtl.NextSes) then
			break;
		end
	end
	
	print("\n[Exiting WoWBench v"..WOWB_VER.."]");

end





-----------------------------------------------------------
-- Finally: Run WOWB_Main encapsulated in our cool error handler

WOWB_Debug_RegisterGlobalFunctionNames();

local b,err = WOWB_Pcall(WOWB_Main);
if(not b) then
	if(not string.find(err, "JUSTBAILPLEASE")) then
		print("ERROR: " .. err);
	end
	return 1;
end

return 0;
