
--
-- worldcmds.lua  - Copyright (c) 2006, the WoWBench developer community. All rights reserved. See LICENSE.TXT.
--
-- This file defines command-line commands that are available when
-- "the world" (world.toc) has been loaded. It is actually included
-- from there.
--


WOWB_WorldCmds = {}


---------------------------------------------------------------------
-- "fire" - fire an event

function fire(event,...)  -- don't make this local. useful from command prompt!
	event=string.upper(event);
	print("Firing " .. event);
	local n = WOWB_FireEvent(event, unpack(arg));  -- don't DPC this.
	print("Processed by ".. n .." frames");
end

WOWB_WorldCmds.fire = {
	syntax = "$cmd <EVENT NAME> [<arguments>]",
	help = "Fires the given system event.\n"..
	       "Use without arguments for a list of registered events.\n"..
	       "To use Lua variables as arguments, use fire(\"name\", ...)\n",
	func = function(cmd, args)
		if(not args[1]) then
			print "Registered events:";
			local sorted = {};
			for k,_ in WOWB_RegisteredEventsByEvent do
				tinsert(sorted, k);
			end
			table.sort(sorted);
			local lastletter = "";
			for _,k in sorted do
				if(string.sub(k,1,1)~=lastletter) then lastletter=string.sub(k,1,1); print ""; end
				print("  "..k.." - "..table.count(WOWB_RegisteredEventsByEvent[k]).." frames");
			end
		else
			local event = args[1];
			tremove(args,1);
			for k,v in args do
				if(tonumber(v)) then
					args[k]=tonumber(v);
				end
			end
			fire(event, unpack(args));
		end
	end
}


---------------------------------------------------------------------
-- "say"/"whisper" -- pretend like another player has said/whispered something

WOWB_WorldCmds.say = {
	syntax = "$cmd <Playername> <message text>",
	help = "Pretend like the given Playername has said something",
	regex = "^(say) +([^ ]+) (.*)",
	func = function(cmdline, captures)
		WOWB_DumpVar(captures);
		if(captures[3]=="say") then
			WOWB_OriginateChatMessage(captures[4], captures[5], "SAY", nil, nil);
		else
			WOWB_OriginateChatMessage(captures[4], captures[5], "WHISPER", nil, _CHARACTER);
		end
	end
}

WOWB_WorldCmds.whisper = {
	syntax = WOWB_WorldCmds.say.syntax,
	help = "Pretend like the given Playername has whispered something to you",
	regex = "^(whisper) +([^ ]+) (.*)",
	func = WOWB_WorldCmds.say.func,
}

---------------------------------------------------------------------
-- "look" -- look at NPCs/players/etc, and UI objects

local function WOWB_LookAtObject(o, ind)
	if(not ind) then 
		ind=""; 
		while(getn(WOWB_CommandLine_Vars)>0) do
			tremove(WOWB_CommandLine_Vars);
		end
	end
	
	if(o[0].xmltag=="Texture") then
		return;
	end

	if(o:GetName()~="") then
		tinsert(WOWB_CommandLine_Vars, { text = o:GetName(), luavar = o });
	else
		tinsert(WOWB_CommandLine_Vars, { text = "$"..getn(WOWB_CommandLine_Vars)+1, luavar = o });
	end
	
	
	if(o.GetText) then
		print(string.format("%2d: %s%-10s %-12s %s", getn(WOWB_CommandLine_Vars), ind, o[0].xmltag, "["..o:GetText().."]", o:GetName()));
	else
		print(string.format("%2d: %s%-10s %s", getn(WOWB_CommandLine_Vars), ind, o[0].xmltag, o:GetName()));
	end
	

	local nHidden=0;		
	local a = {};
	for f,_ in o[0].children do
		if(not f:IsShown()) then
			nHidden = nHidden + 1;
		else
			tinsert(a,f);
		end
	end
	table.sort(a, function(a,b) return a:GetName() < b:GetName(); end);
	for _,f in ipairs(a) do
		WOWB_LookAtObject(f, ind.."  ");
	end
	if(nHidden>0) then
		print(ind.."    (+"..nHidden.. " hidden frames not shown)");
	end
end

WOWB_WorldCmds.look = {
	syntax = {
		"$cmd",
		"$cmd <frame name>"
	},
	help =
		"Without arguments: list units and objects around you.\n"..
		"With argument: dump the contents of an on-screen object (e.g. frame)\n"..
		"\n"..
		"Also populates the command line variables $1--$n\n",
	func = function(cmd, args)
		if(not args[1]) then
			args[1] = "World";
		end
		
		local o = WOWB_AllObjectsByName[string.lower(args[1])];
		if(not o) then
			return "No such frame \""..args[1].."\"";
		end
		if(o:IsVisible() or o:IsObjectType("WorldThing")) then
			print("Looking at "..args[1]..":");
		else
			print("Looking at "..args[1].." (NOT CURRENTLY SHOWN):");
		end
		WOWB_LookAtObject(o);
		print "";
		if(getn(WOWB_CommandLine_Vars)>1) then
			print("You can now use $1--$"..getn(WOWB_CommandLine_Vars).." in command line expressions.");
		end
		print("Hint: Use 'look $1' to re-examine this object.");
	end

}





---------------------------------------------------------------------
-- "click", "clickr", "clickm", "mouse"

WOWB_WorldCmds.click = {
	syntax = {
		"$cmd <unit or UI element>",
	},
	help = "Click a unit or a thing. Or deselect whatever you've selected by not giving an argument.",
	func = function(cmd, args)
		local targ;
		local a = {};
		if(string.findt(a, args[1] or "", "^%$([0-9]+)$")) then
			if(not(WOWB_CommandLine_Vars[tonumber(a[3])].luavar)) then return args[1].." is empty."; end
			targ = WOWB_World_MouseToTarget(WOWB_CommandLine_Vars[tonumber(a[3])].luavar);
		else
			targ = WOWB_World_MouseToTarget(args[1]);
		end
		if(not args[1]) then
			WOWB_FireEvent("CURSOR_UPDATE");	-- don't DPC this.
			WOWB_TargetUnit(nil);
			return;
		end
		local buttons = {click="LeftButton", clickr="RightButton", clickm="MiddleButton"}
		local button = buttons[cmd];
		if(not button) then
			return;
		end
		if(not targ) then
			return "Can't find a \""..args[1].."\" to click on.";
		end
		
		if(targ:IsObjectType("Button") or targ:IsObjectType("WorldThing")) then
			assert(targ[0].clickTypes);
			if(not targ[0].Scripts) then return args[1].." does not have any event handlers whatsoever";	end
			WOWB_DoScript({this=targ, script="OnMouseDown", args={button}});
			if(targ[0].clickTypes[button.."Down"]) then
				WOWB_DoScript({this=targ, script="OnClick", args={button}});
			end
			WOWB_DoScript({this=targ, script="OnMouseUp", args={button}});
			if(targ[0].clickTypes[button.."Up"]) then
				WOWB_DoScript({this=targ, script="OnClick", args={button}});
			end
		
		else
			print("I don't know how to click a "..targ:GetObjectType());
		end
			
	end
}

WOWB_WorldCmds.clickr = WOWB_WorldCmds.click;
WOWB_WorldCmds.clickm = WOWB_WorldCmds.click;

WOWB_WorldCmds.mouse = {
	syntax = WOWB_WorldCmds.click.syntax,
	help = "Mouse over a unit or a thing. Or move away from whatever you've previously moused over by not giving an argument.",
	func = WOWB_WorldCmds.click.func
}



-----------------------------------------------------------------------
-- /cmd  -- any slash cmd (/say, /console, etc..)

WOWB_WorldCmds["/cmd"] = {
	syntax = "/<slashcmd> [<params>]",
	regex = "^/",
	help = "Executes any WoW slash command",
	func = function(cmdline)
		ChatFrameEditBox:SetText(cmdline);
		WOWB_DoScript({this=ChatFrameEditBox, script="OnEnterPressed"});
	end
}



-----------------------------------------------------------------------
-- Blank line -- fire <OnUpdate>

local lastBlankLine = 0;
	
WOWB_WorldCmds[""] = {
	syntax = "[Enter] - fire <OnUpdate> in all visible frames";
	help = "";
	func = function()
		while(os.clock() < lastBlankLine+_MINDELAY) do
			-- busy loop ftw
		end
		lastBlankLine = os.clock();
		local n = WOWB_FireOnUpdate(WOWB_RootFrame);
		print("<OnUpdate> triggered in "..n.." visible frames");
	end
}



-----------------------------------------------------------------------
-- login <playername> - fire up whole a new player session in
-- a separate environment. (yeah, Lua is funky =))
--
-- Note that each player gets a separate copy of "World". Might want to
-- do something about that some day. (Note slight problem with the "Me" object)
--

WOWB_WorldCmds["login"] = {
	syntax = "$cmd <Playername>";
	help = "Create a new session with Playername in it";
	func = function(cmd,args)
		local char = args[1] or "";
		
		if(char=="") then
			print("Current sessions:");
			for k,v in ipairs(WOWB_SessCtl) do
				print("  "..k..": "..v._CHARACTER);
			end
			return;
		end

		-- Check that the character exists
		fil,msg = io.open(_WOWDIR.."/WTF/Account/".._ACCOUNT.."/".._REALM.."/"..char.."/AddOns.txt");
		if(not fil) then
			print("ERROR: No such character \""..char.."\"");
			print("("..msg..")");
			return;
		end
		io.close(fil);
		
		-- Check that the character isn't already logged in
		for k,v in ipairs(WOWB_SessCtl) do
			if( strlower(v._CHARACTER) == strlower(char) ) then
				print("\""..v._CHARACTER.."\" is already logged in (in session #"..k..")");
				return;
			end
		end
				
		-- Create the new environment!
		local newses = {}
		for k,v in pairs(WOWB_SessCtl.BaseEnv) do
			newses[k]=v;
		end
		
		newses._G = newses;
		
		newses.WOWB_SessCtl = WOWB_SessCtl;
		newses._FORCECHARACTER = char;
		newses._INFILES = _INFILES;
		
		tinsert(WOWB_SessCtl, newses);

		WOWB_SessCtl.NextSes=table.getn(WOWB_SessCtl);
		
		local chunk, msg = loadfile("wowbench.lua");
		assert(chunk);
		setfenv(chunk, newses);
		
		chunk();	-- Innocently small, but this spawns a whole new copy of WoWBench with everything in it!
							-- The only thing it does not do is start the commandline parser. It returns when everything is up.
							
		
		-- Create this character in all other sessions, and put characters in those sessions in this session
		for k,v in ipairs(WOWB_SessCtl) do
			if(v._CHARACTER == char) then
				-- my new session!
			else
				v.WOWB_XMLTagInfo = v.WOWB_XMLTagInfo_World;	-- Use world.xml syntax for a while...
				newses.WOWB_XMLTagInfo = newses.WOWB_XMLTagInfo_World;	
				
				-- Have to dance around with PCalls setting the error handler to the one inside THAT session, 
				-- or the debugger will look on globals in THIS session if an error occurs. Buechg.
				WOWB_Pcall(v.WOWB_CreateObject, v.WOWB_ErrHandler, "Player", char, v.World, "MeTemplate");
				WOWB_Pcall(newses.WOWB_CreateObject, newses.WOWB_ErrHandler, "Player", v._CHARACTER, newses.World, "MeTemplate");
				
				v.WOWB_XMLTagInfo = v.WOWB_XMLTagInfo_BlizzardUI;	-- ... and back to standard UI XML again		
				newses.WOWB_XMLTagInfo = newses.WOWB_XMLTagInfo_BlizzardUI;
			end
		end
		
		
	end
}


-----------------------------------------------------------------------
-- n  -- any integer number 1--9

WOWB_WorldCmds["n"] = {
	syntax = "<number 1-9>",
	regex = "^[0-9]$",
	help = "Switches to another session started by 'login'",
	func = function(cmdline)
		local n = tonumber(cmdline);
		if(not n or not WOWB_SessCtl[n]) then
			print("No such session \""..cmdline.."\". Available sessions:");
			for k,v in ipairs(WOWB_SessCtl) do
				print("  "..k..": "..v._CHARACTER);
			end
			return;
		end
		WOWB_SessCtl.NextSes = n;
	end
}

