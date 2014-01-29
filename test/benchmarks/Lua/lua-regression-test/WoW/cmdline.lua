
--
-- cmdline.lua  - Copyright (c) 2006, the WoWBench developer community. All rights reserved. See LICENSE.TXT.
--
-- WOWB_CommandLine -- skeleton for a command line driver.
-- Accepts command lists with command names, (regexes), functions, help ...
--
-- Always contains a few base commands: quit, exit, defaulting to Lua parsing
--


WOWB_CommandLine_Vars = {}  -- Currently only deals with $1, $2 ...  Used by WOWB_WorldCmds.look

function WOWB_CommandLine(arg)
	local bSeenCommands = false;	
	
	assert(table.getn(arg)>=1);
	
	if(not arg.infiles) then
		arg.infiles = {cur=1, io.input()};
	end
	
	local regexes = {}
	local cmds = {}
	local sortedcmds = {}
	
	for _,cmdlist in ipairs(arg) do
		for cmd,cmddef in pairs(cmdlist) do
			if(type(cmddef.syntax)=="string") then
				cmddef.syntax = { cmddef.syntax };
			end
			cmddef.cmd = cmd;
			if(cmddef.regex) then
				regexes[cmddef.regex] = cmddef;
			else
				cmds[cmd] = cmddef;
				tinsert(sortedcmds, cmd);
			end
		end
	end
	table.sort(sortedcmds);
	
	
	local function getsyntaxes(cmddef, cmd)
		local ret = "  " .. table.concat(cmddef.syntax, "\n  ");
		return ""..string.gsub(ret, "%$cmd", cmd or cmddef.cmd);
	end
	

	io.write(arg.prompt);
	
	local bEof = false;

	while true do
		local cmdline;
		while(not cmdline and arg.infiles.cur <= getn(arg.infiles)) do
			cmdline = arg.infiles[arg.infiles.cur]:read("*l");
			if(not cmdline) then
				arg.infiles.cur = arg.infiles.cur + 1;
			end
		end
		
		if(arg.infiles.cur > getn(arg.infiles)) then
			break;
		end
		
		if(arg.infiles.cur < getn(arg.infiles)) then
			print(cmdline);
		end
		
		local origcmdline = cmdline;
		bSeenCommands = true;
		local args = WOWB_GetWords(cmdline);
		local cmd = string.lower(args[1] or "");
		table.remove(args, 1);
		
		local bDone = false;
		local msg;
		
		cmdline = string.gsub(cmdline, "%$[0-9]+", function(str) return WOWB_CommandLine_Vars[tonumber(strsub(str,2))].text; end);
		if(cmdline~=origcmdline) then
			print("> "..cmdline);
		end
		
		if(cmds[cmd]) then
			
			args = WOWB_GetWords(cmdline);
			table.remove(args,1);
			bDone, msg = true, cmds[cmd].func(cmd,args);
			if(msg) then 
				print(cmd..": "..msg);
			end
		else
			for r,v in regexes do
				local a = { string.find(cmdline, r) };
				if(a[1]) then
					bDone, msg = true, v.func(cmdline, a);
					if(msg) then
						print(v.cmd..": "..msg);
					end
					break;
				end
			end
		end
		
		
		if(bDone) then
			-- gifv "continue" in lua
		
		-- COMMAND: exit, quit
		elseif(cmd=="exit" or cmd=="quit") then
			break;

		-- COMMAND: "help"			
		elseif(cmd=="help") then
			if(not args[1]) then
				print "Available commands:";
				local lastletter="";
				for _,cmd in ipairs(sortedcmds) do
					if(string.sub(cmd,1,1) ~= lastletter) then
						print "";
						lastletter = string.sub(cmd,1,1);
					end
					print(getsyntaxes(cmds[cmd], cmd));
				end
				for _,cmddef in pairs(regexes) do
					print "";
					print(getsyntaxes(cmddef));
					print("    - "..cmddef.help);
				end
				print "";
				print "Or any valid Lua command.";
				print "";
				print "Use help <command> for more information.";
			else
				if(cmds[args[1]]) then
					print("Help for \""..args[1].."\":");
					print "";
					print "Syntax: "
					print(getsyntaxes(cmds[args[1]], args[1]));
					print "";
					print(cmds[args[1]].help);
				else
					print("No help available for \""..args[1].."\"");
				end
			end


		-- COMMAND: ""  (note that if the command list defines "", this never gets run)
		elseif(cmd=="") then
			-- nothing
		
		-- COMMAND: anything else -> Lua	
		else
			cmdline = string.gsub(origcmdline, "%$[0-9]+", function(str) return "WOWB_CommandLine_Vars["..tonumber(strsub(str,2)).."].luavar"; end);
			local chunk,msg = loadstring(cmdline);
			if(not chunk) then
				print(msg);
			else
				WOWB_Pcall(chunk);
			end
		end			
		
		if(not arg.nodpcs) then
			WOWB_PumpDPCs();	-- Pump any DPCs that might have gotten queued
		end
		
		if(WOWB_SessCtl.NextSes and not arg.ignorenextses) then
			break; -- A command above requested that we switch sessions. Bail out and let WOWB_Main switch for us.
		end
		
		io.write(arg.prompt);
	end

	if(not arg.nodpcs) then
		WOWB_PumpDPCs();	-- Pump any DPCs that might have gotten queued
	end
		
	if(not bSeenCommands) then
		-- would have used "io.input():read(0) == nil" test except it blocks under win32. duh.
		print "\nCommandline interpreter: This is not a console.";
		return false;
	end		
		
	return true;
end


-----------------------------------------------------
-- The "default" command list in the main prompt
-- Probably not the right place to put it but ...


WOWB_Cmds = {}

WOWB_Cmds.dump = WOWB_DebugCmds.dump;
WOWB_Cmds.editdump = WOWB_DebugCmds.editdump;


