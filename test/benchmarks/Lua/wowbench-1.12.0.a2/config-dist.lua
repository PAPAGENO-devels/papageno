

-- The directory where WoW lives (needed for WTF and AddOns folders)
_WOWDIR = "./wow"
-- _WOWDIR = "C:/Program Files/World of Warcraft"

-- Editor to use on e.g. editdump()
_EDITOR = "start notepad.exe"
-- _EDITOR = "C:/Program Files/IDM Computer Solutions/UltraEdit-32/uedit32.exe"
-- _EDITOR = "vi"
-- _EDITOR = "vim"

-- Account, realm, character data
-- _ACCOUNT = "MYACCOUNTNAME";   -- Can be left out if saved in login screen
-- _REALM = "My Realm";   			 -- Leave out to use your last realm name
_CHARACTER = "Playername";


-- Lua compiler command
-- _LUAC = "luac"
_LUAC = "luac.exe"

-- Minimum delay enforced when entering blank lines (mostly useful in scripts)
_MINDELAY  = 0.2  



---------------------------------------------------------------------
-- Debugging configuration

_EDITDUMPDEPTH = 20   -- debugger: default "editdump" max table recursion depth; 10-20?
_DUMPDEPTH = 2        -- debugger: default "dump" max table recursion depth; 2 is good
_ERRORDUMPDEPTH = 3   -- table recursion depth on automatic error dumps; 3 or 4 is good
_DUMPDONTFOLLOW = {   -- never recurse into table members with these names (you can still do it manually though by e.g. dump var[0].parent)
	["previous"]=1, ["parent"]=1, ["prev"]=1, ["parentobj"]=1 
}   
_EDITDUMPONERROR = false  -- do automatic error dumping
_DEBUGONERROR = true     -- jump into debugger on errors

WOWB_DEBUGCAT = {  -- if run with "-d" switch, debugging will be shown according to:
	["XML"] = 3,	   -- XML Parser: 1,2: Per file,  3: Per object,  4: Inherited objects
	["SCRIPT"] = 2,  -- <On...> event firing:  1: global sets of events 2: everything
	["FILESYS"] = 2, -- 1: Changing cwd, executing Lua files, 2: tests
	["WIDGET"] = 2,  -- 2: everything
	["TOC"] = 2,     -- 1: begin/end tocfiles,  2: everything else
	["FRAMES"] = 3,  -- 1: explicit :Show()/:Hide() calls.  2: ... including FrameXML frames
	                 -- 3: all frames showing/hiding  4: ... including FrameXML frames
	["EVENT"] = 2,   -- 1: show registering/unregistering   2: Show all events being fired   3: ... and to which frames
}



_PARTY = {
	[0]=_CHARACTER,
	"Alice", "Bob", n=2,
	leader=0,
	lootmethod="master", masterlooter=0,   -- 0=me
	lootthreshold=2,
}

_TARGET = nil;	-- will point to unit objects on clicking / TargetByName()ing, etc. can't set it here though; only here for documentation purposes :-)


