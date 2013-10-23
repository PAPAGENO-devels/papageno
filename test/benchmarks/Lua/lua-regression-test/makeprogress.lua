
--
-- makeprogress.lua  - Copyright (c) 2006, the WoWBench developer community. All rights reserved. See LICENSE.TXT.
--
-- * Read the wowwiki.com/Global_Function_List (globfunc.txt)
-- * Parse WoWBench Files
-- * Output what's been implemented and not, along with info on how much 
--   in actually implemented, based on [DUD], [HALF] and [FULL] tags,
--   in wikitext format
--

globalsFile = "/wow/wowwiki/globfunc.txt";

aFiles = { "api.lua" };

aPreFormat = {
	NO = "<font color=red>&diams;</font>",
	DUD = "<font color=yellow>&diams;</font>",
	HALF = "<font color=blue>&diams;</font>",
	FULL = "<font color=green>&diams;</font>",
	UNKNOWN = "<font color=grey>&diams;</font>"
}





dofile("utils.lua");

---------------------------------------------------------------------
-- Parse in globfunc.txt

api = {}

print("Getting global function list from "..globalsFile);
n=0;
for l in io.lines(globalsFile) do
	n=n+1;
	if(strfind(l, "^== Lua ")) then	-- abort at "== Lua defined functions"
		break;
	end;
  _,_,func = strfind(l, "%[%[API[_ ]([A-Za-z0-9_ ]+)");
  if(func) then
  	api[func] = "NO";
  end
end
print("  "..n.." in list.");



---------------------------------------------------------------------
-- See what we have!

function FindTag(l)
	local _,_,tag = strfind(l, "%[([A-Z]+)%]");
	if(tag==nil or tag=="DUD" or tag=="HALF" or tag=="FULL") then
		return tag;
	else
		print("Can't recognize the tag in: "..l);
	end
	return nil;
end


for _,filename in aFiles do
	fn = filename;
	print("Parsing "..fn);
	for l in io.lines(fn) do
		local _,_,func = strfind(l, "^[ \t]*function[ \t]+([A-Za-z0-9_]+)[ \t]*%(");
		if(not func) then
			_,_,func = strfind(l, "^[ \t]*%-%-[ \t]*([A-Za-z0-9_]+)[ \t]*%(");
		end
			
		if(func and api[func]) then
			if(api[func]=="NO" or api[func]=="UNKNOWN") then
				api[func] = FindTag(l) or "UNKNOWN";
			elseif(FindTag(l)) then
				print("* '''WARNING:''' Found two tags for \""..func.."\": "..api[func].." and "..FindTag(l));
			end
		end
	end
end
 
apisort = {}
for func,_ in api do
	tinsert(apisort, func);
end

table.sort(apisort);

aCounts = {
	NO = 0,
	DUD = 0,
	HALF = 0,
	FULL = 0,
	UNKNOWN = 0,
}

lastchr="";
for _,func in apisort do
	chr = strsub(func,1,1);
	if(chr~=lastchr) then
		print("");
		print("");
		print("== "..chr.." ==");
		lastchr=chr;
	end
	print(":" .. aPreFormat[api[func]] .. " [[API "..func.."|"..func.."]]");
	aCounts[api[func]] = (aCounts[api[func]] or 0) + 1;
end


print("");
print("");
print(":"..aPreFormat["NO"]     .." Not implemented:  " .. aCounts["NO"]);
print(":"..aPreFormat["DUD"]    .." Duds (fakes):     " .. aCounts["DUD"]);
print(":"..aPreFormat["HALF"]   .." Semi-functional:  " .. aCounts["HALF"]);
print(":"..aPreFormat["FULL"]   .." Fully functional: " .. aCounts["FULL"]);
print(":"..aPreFormat["UNKNOWN"].." Missing src tag:  " .. aCounts["UNKNOWN"]);
