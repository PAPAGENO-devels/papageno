
--
-- utils.lua  - Copyright (c) 2006, the WoWBench developer community. All rights reserved. See LICENSE.TXT.
--
--
--

foreach=table.foreach;
foreachi=table.foreachi;
getn=table.getn;
sort=table.sort;
tinsert=table.insert;
tremove=table.remove;

format=string.format;
gsub=string.gsub;
strbyte=string.byte
strchar=string.char;
strfind=string.find;
strlen=string.len;
strlower=string.lower;
strrep=string.rep;
strsub=string.sub;
strupper=string.upper;



local isunix;
function WOWB_IsUnixSystem()
    if(isunix == nil) then
        if(WOWB_FileExists(".\\wowbench.lua")) then
            isunix = 0;
        else
            isunix = 1;
        end
    end
    return isunix == 1;
end
function WOWB_IsWindowsSystem()
    return not WOWB_IsUnixSystem()
end

WOWB_FileAgeInfo = {}

function WOWB_GetFileDir(path)
	path = string.gsub(path, "\\", "/");
	local _,_,path = string.find(path,"^(.*/)");
	return path or "./";
end

-- return { "newestfile"=4, "oldestfile"=1, "evennewerfile"=4, "newerfile"=2}
local function WOWB_GetFileAgeInfos(path)
	path = path or ".";
        if(WOWB_IsWindowsSystem()) then
	    path = string.gsub(path, "/", "\\");
	    os.execute("dir /B /tw /a-d-h-s /od \"" .. path .. "\\\" > tmp/dir.txt");
        else
            os.execute("ls -t -r \""..path.."\" > tmp/dir.txt");
        end
        
        local fil = io.open("tmp/dir.txt");
        local ret = {};
        if(not fil) then return ret; end
	local n=1;
	for lin in fil:lines() do
		ret[lin]=n;
		n=n+1;
	end
        
	return ret;
end

-- "DiRectorY/with\\sub/path/" -> "directory/with/sub/path"
local function WOWB_NormalizeDir(dir)
	dir = string.gsub(dir, "[\\/]+", "/");
	dir = string.gsub(dir, "/$", "");
	return dir;
end

-- "FileName" -> "filename"
local function WOWB_NormalizeFile(file, dir)
	file = string.gsub(file, "[\\/]+", "/");
	if(dir and string.sub(file,1,string.len(dir)+1)==dir.."/") then
		file = string.sub(file,string.len(dir)+2);
	end
	return file;
end

function WOWB_CacheFileAges(dir)
	local a = WOWB_GetFileAgeInfos(dir);
	dir = WOWB_NormalizeDir(dir);
	WOWB_FileAgeInfo[dir] = {};
	for f,n in a do
		WOWB_FileAgeInfo[dir][WOWB_NormalizeFile(f)]=n;
	end
end

-- Return true if newerfile is known to be newer than olderfile  (reverse not necessarily true)
-- (Fails horribly if the addon uses subdirectories -- always returns false, i.e. "please recompile")
function WOWB_IsFileNewerThan(dir, newerfile, olderfile)
	dir = WOWB_NormalizeDir(dir);
	newerfile = WOWB_NormalizeFile(newerfile, dir);
	olderfile = WOWB_NormalizeFile(olderfile, dir);
	DP("FILESYS",2, '"'..dir..'": is "'..newerfile..'" newer than "'..olderfile..'"?');
	if(not WOWB_FileAgeInfo[dir]) then
		return false;		-- will occur if addons have subfolders; can't really fix it since we can't get reliable relative time for stuff in subfolders with dir /od
	end
	if(not WOWB_FileAgeInfo[dir][newerfile]) then
		return false;
	end
	if(not WOWB_FileAgeInfo[dir][olderfile]) then
		return false;
	end
	return WOWB_FileAgeInfo[dir][newerfile] > WOWB_FileAgeInfo[dir][olderfile];
end



-- "very/long/path/to/filename.ext" -> "path/to/filename.ext"
function WOWB_SimpleFilename(filename)
	local _,_,f = string.find(filename, "([^\\/]+[\\/][^\\/]+[\\/][^\\/]+)$");
	if f then 
		if(f==filename) then
			return f;
		else
			return ".../"..f;
		end
	end
	return filename;
end











function WOWB_DoString(str, filename, linenum, info, extrainfolines, bSuppressErrors)
	local chunk,msg = loadstring(str, 
		"WOWB_STACKINFO##"..(filename or "").."##"..(linenum or -1).."##"..(info or "").."##"..(extrainfolines or "")
	);
	if(not chunk) then
		error(msg, 0);
	end
	
	local bPrevSuppressErrors = WOWB_SuppressingErrors;
	if(bSuppressErrors) then
		WOWB_SuppressingErrors = true;
	end
	
	if(WOWB_SuppressingErrors) then
		local b,msg = xpcall(chunk, WOWB_ErrHandler_JustLog);
		if(not b) then
			WOWB_NumSuppressedErrors = WOWB_NumSuppressedErrors + 1;
		end
	else
		xpcall(chunk, WOWB_ErrHandler);
	end
	
	WOWB_SuppressingErrors = bPrevSuppressErrors;
end



function WOWB_EscapeString(str)
	return string.gsub(str, "([%c\"\\])", function(ch)
		if(ch=="\n") then
			return "\\n";
		elseif(ch=="\\") then
			return "\\\\";
		elseif(ch=="\"") then
			return "\\\"";
		elseif(ch=="\r") then
			return "\\r";
		elseif(ch=="\t") then
			return "\\t";
		end
		return string.format("\\x%02x", string.byte(ch,1));
	end);
end


function WOWB_GetWords(str)
	local ret = {};
	local pos=0;
	while(true) do
		local word;
		_,pos,word=string.find(str, "^ *([^%s]+) *", pos+1);
		if(not word) then
			return ret;
		end
		table.insert(ret, word);
	end
end


function strfetch(str, regex)
	local _,_,ret = string.find(str,regex);
	return ret;
end

function strabbr(str, len)
	len = len>4 and len or 4;
	if(string.len(str)<=len) then
		return str;
	end
	return string.sub(str, 1, len-3).."...";
end


---------------------------------------------------------------------
-- function string.findt(tOut, strFind, strRegex, nStart, bPlain)
--
-- 1. Makes string.find output its findings in tOut rather than as 
--    returned values. (Makes it usable in 'if' clauses!)
--    (still returns begin & end positions)
--
-- TODO: (nested ()s would return nested tables)
-- 2. Extends the syntax to nested "()"s, e.g.:
--    '(%w+ +((%w)+ +)*'
--
-- 3. Allows the "|" operator (find this|or that), e.g.
--    '<(/?)(%w)( +%w+=( *([^ >]+)|"([^"]*)"|'([^']*)')>'  (html tag parser!)
--
---------------------------------------------------------------------

function string.findt(tOut, strFind, strRegex, nStart, bPlain)
	local a = { string.find(strFind, strRegex, nStart, bPlain) };
	while(getn(tOut)>0) do tremove(tOut,1); end
	for _,v in a do
		tinsert(tOut, v);
	end
	return a[1], a[2];
end

strfindt = string.findt;



function WOWB_RemoveFile(filename)
        if(WOWB_IsWindowsSystem()) then
	    filename = string.gsub(filename, "/", "\\");
	    os.execute('if exist "'..filename..'" del "'..filename..'"');
        else
            os.execute('rm "'..filename..'"');
        end
end


function WOWB_HTMLEntityDecode(str)
	str = string.gsub(str, "&gt;", ">");
	str = string.gsub(str, "&lt;", "<");
	str = string.gsub(str, "&qout;", "\"");
	return string.gsub(str, "&amp;", "&");
end


function WOWB_FileExists(filename)
	local fil = io.open(filename);
	if(not fil) then return false; end
	io.close(fil);
	return true;
end

-- Do CWD magic on a given filename (abort wowbench on errors if bError is true)
function WOWB_ProcessFilename(filename, bError)
	if(DP) then DP("FILESYS",2, "Searching for \""..filename.."\" (_CWD is now \""..tostring(_CWD).."\")"); end
	
        if(_CWD and WOWB_FileExists(_CWD..filename)) then
		filename = _CWD..filename;
	elseif(WOWB_FileExists(filename)) then 
		filename = filename;
	elseif(_WOWDIR and WOWB_FileExists(_WOWDIR.."/"..filename)) then
		filename = _WOWDIR.."/"..filename;
	elseif(bError) then
		error("Cannot locate \""..filename.."\" (_CWD is \""..tostring(_CWD).."\")", 2);
	else
		return nil;
	end
	local _,_,cwd,name = string.find(filename, "^(.*[\\/])([^\\/]+)$");
	return filename, cwd or _CWD;
end



WOWB_ORIG_dofile = dofile;
function dofile(filename)
	
	if(not WOWB_Pcall) then	-- we haven't finished loading wowbench yet! just use standard dofile.
		return WOWB_ORIG_dofile(filename);
	end
	
	local prevCWD = _CWD;
	local chunk,b,msg,fil;
	filename,_CWD = WOWB_ProcessFilename(filename, true);
	
	
	if(DP) then DP("FILESYS",1, "Executing \""..filename.."\""); end
	fil,msg = io.open(filename, "rb");
	if(not fil) then
		error(msg,2);
	end
	local src = fil:read(3);
	if(src==strchar(239, 187, 191)) then  -- utf-8 lead bytes
		src = fil:read("*a");
		fil:close();
		chunk,msg = loadstring(src, "@"..filename);
		if(not chunk) then
			error(msg, 0);
		end
		
		b,msg = WOWB_Pcall(chunk, nil);
	else
		fil:close();
		b,msg = WOWB_Pcall(WOWB_ORIG_dofile, nil, filename);
	end

	_CWD = prevCWD;
	
end



function table.insertbeforeval(t, valBefore, val)
	for k,v in ipairs(t) do
		if(v==valBefore) then
			table.insert(t, k, val);
			return;
		end
	end
	print("table.insertbeforeval: Could not find \""..valBefore.."\". Appending last.");
	tinsert(t, val);
end
	
tinsertbeforeval = table.insertbeforeval;


function table.removebyval(tab, val)
	for k,v in tab do
		if(v==val) then
			table.remove(tab, k);
			return;
		end
	end
end

tremovebyval = table.removebyval;


function table.count(a)
	local n=0;
	for _ in pairs(a) do
		n=n+1;
	end
	return n;
end

tcount = table.count;
	

function table.copy(to, from)		-- "to" must an empty table
	for k,v in pairs(from) do
		if(type(v)=="table") then
			to[k] = {}
			table.copy(to[k], v);
		else
			to[k] = v;
		end
	end
end

tcopy = table.copy;

