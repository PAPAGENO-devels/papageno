
--
-- api.lua  - Copyright (c) 2006, the WoWBench developer community. All rights reserved. See LICENSE.TXT.
--
-- WoW API emulation
--
-- Most of it is quick-and-dirty. Flesh out as needed.
--

-----------------------------------------------------------------------
-----------------------------------------------------------------------
-----------------------------------------------------------------------
--
-- Constants
--


-- Observed CVar Defaults from http://www.wowwiki.com/Config.wtf_defaults
local WOWB_CVarDefaults={
	accountName = "",
	alphaLevel = "1",
	AmbienceVolume = "0.6",
	anisotropic = "1",
	assistAttack = "0",
	autoClearAFK = "1",
	autointeract = "0",
	automoveturnspeednarrow = "800",
	automoveturnspeedwide = "1200",
	
	baseMip = "0",
	BlockTrades = "0",
	bspcache = "1",
	
	cameraBobbing = "0",
	cameraBobbingFrequency = "0.8",
	cameraBobbingLRAmplitude = "2.0",
	cameraBobbingSmoothSpeed = "0.8",
	cameraBobbingUDAmplitude = "2.0",
	cameraCustomViewSmoothing = "0",
	cameraDistance = "0.0",
	cameraDistanceMax = "15.0",
	cameraDistanceMaxFactor = "1.0",
	cameraDistanceMoveSpeed = "8.33",
	cameraDistanceSmoothSpeed = "8.33",
	cameraDive = "1",
	cameraFoVSmoothSpeed = "0.5",
	cameraGroundSmoothSpeed = "7.5",
	cameraHeightIgnoreStandState = "0",
	cameraHeightSmoothSpeed = "1.2",
	cameraPitch = "0.0",
	cameraPitchMoveSpeed = "90.0",
	cameraPitchSmoothMax = "30.0",
	cameraPitchSmoothMin = "0.0",
	cameraPitchSmoothSpeed = "45.0",
	cameraPivot = "1",
	cameraPivotDXMax = "0.05",
	cameraPivotDYMin = "0.00",
	camerasmooth = "1",
	cameraSmoothPitch = "0",
	cameraSmoothStyle = "1",
	cameraSmoothTimeMax = "2.0",
	cameraSmoothTimeMin = "0.1",
	cameraSmoothTrackingStyle = "1",
	cameraSmoothYaw = "1",
	cameraSubmergeFinalPitch = "5.0",
	cameraSubmergePitch = "18.0",
	cameraSurfaceFinalPitch = "5.0",
	cameraSurfacePitch = "0.0",
	cameraTargetSmoothSpeed = "90.0",
	cameraTerrainTilt = "0",
	cameraTerrainTiltTimeMax = "10.0",
	cameraTerrainTiltTimeMin = "3.0",
	cameraView = "1",
	cameraViewBlendStyle = "1",
	cameraWaterCollision = "1",
	cameraYawMoveSpeed = "180.0",
	cameraYawSmoothMax = "0.0",
	cameraYawSmoothMin = "0.0",
	cameraYawSmoothSpeed = "180.0",
	ChatBubbles = "1",
	ChatBubblesParty = "0",
	checkAddonVersion = "1",
	CombatDamage = "1",
	CombatDeathLogRange = "60",
	combatLogOn = "1",
	CombatLogPeriodicSpells = "1",
	CombatLogRangeCreature = "30",
	CombatLogRangeFriendlyPlayers = "50",
	CombatLogRangeFriendlyPlayersPets = "50",
	CombatLogRangeHostilePlayers = "50",
	CombatLogRangeHostilePlayersPets = "50",
	CombatLogRangeParty = "50",
	CombatLogRangePartyPet = "50",
	CombatModeMaxDistance = "30.0f",
	
	debugTaint = "0",
	deselectOnClick = "1",
	desktopGamma = "0",
	DistCull = "500",
	doodadAnim = "1",
	
	EmoteSounds = "1",
	EnableAmbience = "1",
	EnableErrorSpeech = "1",
	EnableGroupSpeech = "1",
	EnableMusic = "1",
	ErrorFilter = "all",
	ErrorLevelMax = "3",
	ErrorLevelMin = "1",
	errors = "0",
	
	farclip = "350",
	ffxDeath = "1",
	ffxGlow = "1",
	footstepBias = "0.125",
	FootstepSounds = "1",
	frillDensity = "16",
	fullAlpha = "0",
	
	gameTip = "0",
	gamma = "1.0",
	guildMemberNotify = "0",
	gxApi = "direct3d",
	gxAspect = "1",
	gxColorBits = "16",
	gxCursor = "1",
	gxDepthBits = "16",
	gxFixLag = "1",
	gxMaximize = "0",
	gxMultisample = "1",
	gxMultisampleQuality = "0.0",
	gxOverride = "",
	gxRefresh = "75",
	gxResolution = "640x480",
	gxTripleBuffer = "0",
	gxVSync = "1",
	gxWindow = "0",
	
	horizonfarclip = "2112",
	hwDetect = "1",
	
	Joystick = "0",
	
	lastCharacterIndex = "0",
	lodDist = "100.0",
	
	M2BatchDoodads = "1",
	M2Faster = "1",
	M2FasterDebug = "0",
	M2UseClipPlanes = "1",
	M2UsePixelShaders = "0",
	M2UseShaders = "1",
	M2UseThreads = "1",
	M2UseZFill = "1",
	mapObjLightLOD = "0",
	mapObjOverbright = "1",
	mapShadows = "1",
	MapWaterSounds = "1",
	MasterSoundEffects = "1",
	MasterVolume = "1.0",
	MaxLights = "4",
	minimapInsideZoom = "3",
	minimapZoom = "3",
	mouseInvertPitch = "0",
	mouseInvertYaw = "0",
	mousespeed = "1.0",
	movie = "1",
	movieSubtitle = "0",
	MusicVolume = "0.4",
	
	nearclip = "0.1",
	
	ObjectSelectionCircle = "1",
	occlusion = "1",
	
	particleDensity = "1.0",
	PetMeleeDamage = "1",
	PetNamePlates = "0",
	PetSpellDamage = "1",
	pixelShaders = "0",
	PlayerAnim = "0",
	PlayerFadeInRate = "4096",
	PlayerFadeOutAlpha = "128",
	PlayerFadeOutRate = "4096",
	profanityFilter = "1",
	
	readContest = "0",
	readEULA = "0",
	readScanning = "0",
	readTOS = "0",
	realmList = "us.logon.worldofwarcraft.com:3724",
	realmName = "",
	
	scriptMemory = "49152",
	shadowBias = "0.1",
	shadowLevel = "1",
	shadowLOD = "1",
	ShowErrors = "1",
	showfootprintparticles = "1",
	showfootprints = "1",
	showGameTips = "1",
	showLootSpam = "1",
	showsmartrects = "0",
	SkyCloudLOD = "0",
	smallCull = "0.04",
	SoundBufferSize = "50",
	SoundDriver = "-1",
	SoundInitFlags = "128",
	SoundListenerAtCharacter = "1",
	SoundMaxHardwareChannels = "12",
	SoundMemoryCache = "4",
	SoundMinHardwareChannels = "-1",
	SoundMixer = "-1",
	SoundMixRate = "44100",
	SoundOutputSystem = "-1",
	SoundReverb = "1",
	SoundRolloffFactor = "4",
	SoundSoftwareChannels = "12",
	SoundVolume = "1.0",
	SoundZoneMusicNoDelay = "0",
	specular = "0",
	spellEffectLevel = "2",
	statusBarText = "0",
	
	TargetAnim = "0",
	targetNearestDistance = "41.000000",
	targetNearestDistanceRadius = "10.000000",
	texLodBias = "0.0",
	textureLodDist = "777.0",
	triangleStrips = "1",
	trilinear = "0",
	
	UberTooltips = "1",
	uiscale = "1.0",
	unitDrawDist = "300.0",
	UnitNameNPC = "0",
	UnitNamePlayer = "1",
	UnitNamePlayerGuild = "1",
	UnitNamePlayerPVPTitle = "1",
	UnitNameRenderMode = "2",
	useUiScale = "0",
	useWeatherShaders = "1",
	
	violenceLevel = "2",
	
	waterLOD = "0",
	weatherDensity = "2",
	widescreen = "1"
};

_CLASSUSESRELICS = { ["DRUID"]=true, ["PALADIN"]=true, ["SHAMAN"]=true }

_INVENTORYSLOTS = {
	"HeadSlot","NeckSlot","ShoulderSlot","BackSlot","ChestSlot","ShirtSlot","TabardSlot","WristSlot",
	"HandsSlot","WaistSlot","LegsSlot","FeetSlot","Finger0Slot","Finger1Slot",
	"Trinket0Slot","Trinket1Slot","MainHandSlot","SecondaryHandSlot",
	"RangedSlot","AmmoSlot","Bag0Slot","Bag1Slot","Bag2Slot","Bag3Slot"
}

_WHOTOUI = 0; -- not constant



_CHATWINDOWINFO = {	-- This table is compatible with the return from GetChatWindowInfo(). Do not alter the format.
	-- 1     2            3  4  5    6    7      8       9
	-- name, fontSize,		r, g, b,   a,   shown, locked, docked
	{ "General",  12,			1, 1, 1,   0.9, 1,     1,      1 },
	{ "",   			12,			1, 1, 1,   0.9, 0,     1,      1 },
	{ "",   			12,			1, 1, 1,   0.9, 0,     1,      1 },
	{ "",   			12,			1, 1, 1,   0.9, 0,     1,      1 },
	{ "",   			12,			1, 1, 1,   0.9, 0,     1,      1 },
	{ "",   			12,			1, 1, 1,   0.9, 0,     1,      1 },
	{ "",   			12,			1, 1, 1,   0.9, 0,     1,      1 },
}

_CHATWINDOWMESSAGES = {
	{ "SYSTEM", "SAY", "YELL", "WHISPER", "PARTY", "GUILD", "CREATURE", "CHANNEL", "SKILL", "LOOT" },
	{ },	{ },	{ },
	{ },	{ },	{ },
}


-----------------------------------------------------------------------
-----------------------------------------------------------------------
-----------------------------------------------------------------------
--
-- WoWified LUA Functions
--

-- time() [FULL] --
time=os.time;
-- date() [FULL] --
date=os.date;


-- abs() [FULL] --
abs = math.abs;
-- acos() [FULL] --
function acos(v) return math.acos(v)/math.pi/2*360; end;
-- asin() [FULL] --
function asin(v) return math.asin(v)/math.pi/2*360; end;
-- atan() [FULL] --
function atan(v) return math.atan(v)/math.pi/2*360; end;
-- atan2() [FULL] --
function atan2(v1,v2) return math.atan2(v1,v2)/math.pi/2*360; end;
-- ceil() [FULL] --
ceil = math.ceil;
-- cos() [FULL] --
function cos(deg) return math.cos(deg/360*math.pi*2); end
-- deg() [FULL] --
deg = math.deg;
-- exp() [FULL] --
exp = math.exp;
-- floor() [FULL] --
floor = math.floor;
-- log() [FULL] --
log = math.log;
-- log10() [FULL] --
log10 = math.log10;
-- max() [FULL] --
max = math.max;
-- min() [FULL] --
min = math.min;
-- mod() [FULL] --
mod = math.mod;
-- pow() [FULL] --
pow = math.pow;
-- rad() [FULL] --
rad = math.rad;
-- sin() [FULL] --
function sin(deg) return math.sin(deg/360*math.pi*2); end
-- sqrt() [FULL] --
sqrt = math.sqrt;
-- tan() [FULL] --
function tan(deg) return math.tan(deg/360*math.pi*2); end
-- frexp() [FULL] --
frexp = math.frexp;
-- ldexp() [FULL] --
ldexp = math.ldexp;
-- random() [FULL] --
random = math.random;
-- randomseed() [FULL] --
randomseed = math.randomseed;


-- These are just to make http://www.wowwiki.com/WoWBench/Progress report correct stats:
-- assert() [FULL] --
-- error() [FULL] --
-- foreach() [FULL] --
-- foreachi() [FULL] --
-- format() [FULL] --
-- getfenv() [FULL] --
-- getmetatable() [FULL] --
-- getn() [FULL] --
-- gsub() [FULL] --
-- ipairs() [FULL] --
-- next() [FULL] --
-- pairs() [FULL] --
-- pcall() [FULL] --
-- __pow() [FULL] --
-- rawequal() [FULL] --
-- rawget() [FULL] --
-- rawset() [FULL] --
-- setfenv() [FULL] --
-- setmetatable() [FULL] --
-- sort() [FULL] --
-- strbyte() [FULL] --
-- strchar() [FULL] --
-- strfind() [FULL] --
-- strlen() [FULL] --
-- strlower() [FULL] --
-- strrep() [FULL] --
-- strsub() [FULL] --
-- strupper () [FULL] --
-- tinsert() [FULL] --
-- tonumber() [FULL] --
-- tostring() [FULL] --
-- tremove() [FULL] --
-- type() [FULL] --
-- unpack() [FULL] --
-- xpcall() [FULL] --


if(not string.gfind) then
	string.gfind = string.gmatch;  -- gfind is deprecated in newer Lua versions, it's called gmatch now. but wow uses an old lua version.
end

-- gfind() [FULL] --
gfind = string.gfind;



-----------------------------------------------------------------------
-----------------------------------------------------------------------
-----------------------------------------------------------------------
--
-- Internal WoWBench Functions
--


local bChatUpdatedDPCQueued = false;

local function chatupdateddpc()
	bChatUpdatedDPCQueued = false;
	WOWB_FireEvent("UPDATE_CHAT_WINDOWS");
end

local function chatupdated()
	if(not bChatUpdatedDPCQueued) then
		bChatUpdatedDPCQueued = true;
		WOWB_QueueDPC(chatupdateddpc);
	end
end


-- _getaddonindexbyname(name)
local function _getaddonindexbyname(name)
	for k,v in _ADDONS do
		if(string.lower(v)==string.lower(name)) then
			return k;
		end
	end
end


function WOWB_OriginateChatMessage(srcPlayerName,  msg,system,language,channel)
	if(not system) then system="SAY"; end
	if(not language) then language = GetDefaultLanguage("player"); end
	if(not channel) then channel = ""; end
	if(system=="WHISPER") then
		-- Whisper message, some special handling needed...
		local bFound = false;
		for v,_ in pairs(World[0].children) do
			if(v:IsObjectType("Player") and string.lower(v:GetName())==string.lower(channel) and v[0].faction==Me[0].faction) then
				if(v[0].sessionIndex) then
					local ses=WOWB_SessCtl[v[0].sessionIndex];
					-- print("Queued in session "..v[0].sessionIndex);
					ses.WOWB_QueueDPC(ses.WOWB_FireEvent, "CHAT_MSG_WHISPER", msg, srcPlayerName, language, "", "", "", "", "", "");
				end
				if(srcPlayerName == _CHARACTER) then
					WOWB_QueueDPC(WOWB_FireEvent, "CHAT_MSG_WHISPER_INFORM", msg, channel, language, "", "", "", "", "", "");
				else
					print("Emulated whisper from '" .. srcPlayerName .. "' to '" .. channel .."'");
				end
				bFound = true;
				break;
			end
		end
		if(not bFound) then
			if(srcPlayerName == _CHARACTER) then
				WOWB_QueueDPC(WOWB_FireEvent, "CHAT_MSG_SYSTEM", format(ERR_CHAT_PLAYER_NOT_FOUND_S,channel), "", "", "", "", "", 0, 0, "");
			else
				print("Couldn't send whisper from '" .. srcPlayerName .. "': could not locate player '" .. channel .."'");
			end
		end
	else
		-- Other message. Just dump it in all sessions. (Assume everyone is in /say range etc..)
		for v,_ in pairs(World[0].children) do
			if(v:IsObjectType("Player") and v[0].sessionIndex) then
				local ses=WOWB_SessCtl[v[0].sessionIndex];
				ses.WOWB_QueueDPC(ses.WOWB_FireEvent, "CHAT_MSG_"..system, msg, srcPlayerName, language, channel, "", "", "", "", channel);
			end
		end
	end
end

-----------------------------------------------------------
-- function WOWB_GetUnit(who)
--
-- Resolve e.g. "player", "mouseover", "party1" etc to a unit object
--

function WOWB_GetUnit(who)
	if(who=="player") then return Me; end
	if(who=="mouseover") then 
		if(WOWB_CurrentMouseTarget and WOWB_CurrentMouseTarget:IsObjectType("Unit")) then
			return WOWB_CurrentMouseTarget;
		end
		return nil;
	end
	if(who=="target") then return _TARGET; end
	local _,_,n = string.find(who,"^party([1-4])$");
	n=tonumber(n);
	if(n and _PARTY[n]) then return WOWB_AllObjectsByName[strlower(_PARTY[n])]; end
end





-----------------------------------------------------------
-- function WOWB_CreateObject(strType, strName, oParent, strInherits)
--
--

function WOWB_CreateObject(strType, strName, oParent, strInherits)
	local oType = getglobal("WBClass_"..strType);
	if(not oType) then error("No such object type: "..strType); end
	
	local o = {
		[0] = {
			name=strName,
			xmltag=strType,
			xmlfile="",
			xmlfilelinenum=-1,
			children = {},
			parentobj = oParent,
		}
	}
	
	if(oParent) then
		oParent[0].children[o] = true;
	end
	
	WOWB_InheritType(o, oType);

	if(strInherits) then
		WOWB_ParseXML_InheritObj(WOWB_XMLFileParserContext:None(), o, strInherits, false);

		function doOnLoads(o)
			if(o[0].Scripts and o[0].Scripts[0].OnLoad) then
				WOWB_DoScript({this=o, scriptnode=o[0].Scripts[0].OnLoad});
			end	
			if(o[0].Frames) then
				for _,oChild in ipairs(o[0].Frames[0]) do
					doOnLoads(oChild);
				end
			end
		end
		doOnLoads(o);

	end
	
	WOWB_RunObjConstructors(o, oType);
	
	return o;
end





-----------------------------------------------------------------------
-----------------------------------------------------------------------
-----------------------------------------------------------------------
--
-- WoW API Functions        
--                                
-- [FULL] - Full Implementation   
-- [HALF] - Partial Implementation
-- [DUD]  - Placeholder           
--



-- AddChatWindowMessages(n, ...) [FULL]
function AddChatWindowMessages(n, ...)
	local t = {}
	for _,chattype in ipairs(_CHATWINDOWMESSAGES[n]) do  t[chattype]=true;  end
	for _,chattype in ipairs(arg) do  t[chattype]=true;  end
	_CHATWINDOWMESSAGES[n] = {}
	for chattype,_ in pairs(t) do
		tinsert(_CHATWINDOWMESSAGES, chattype);
	end
end

-- CanEditMOTD() [DUD] --
function CanEditMOTD() 
	return nil; 
end
-- CanGuildInvite() [DUD] --
function CanGuildInvite() 
	return nil;
end
-- CanJoinBattlefieldAsGroup() [DUD] --
function CanJoinBattlefieldAsGroup()
	return false;
end
-- CanShowResetInstances() [DUD] --
function CanShowResetInstances()
	return false;
end
-- CheckReadyCheckTime() [DUD] --
function CheckReadyCheckTime() 
end -- have no idea what this does
-- CreateFrame(strType, strName, oParent, strInherits) [FULL] --
function CreateFrame(strType, strName, oParent, strInherits)
	local o = WOWB_CreateObject(strType, strName, oParent, strInherits);
	o:SetParent(oParent);
	if(strName and strName~="" and not getglobal(strName)) then
		setglobal(strName, o);
		WOWB_AllObjectsByName[string.lower(strName)] = o;
	end
	if((o[0].hidden or "false")=="false") then
		o:Show();
	end
	return o;
end
-- CreateWorldMapArrowFrame(onFrame) [DUD] --
function CreateWorldMapArrowFrame(onFrame)
end
-- CursorCanGoInSlot(slot) [DUD] --
function CursorCanGoInSlot(slot) 
	return nil; 
end
-- CursorHasMoney() [DUD] --
function CursorHasMoney()
	return false;
end
-- debuginfo() [DUD] --
function debuginfo() 
end
-- debugstack() [HALF] --
function debugstack(skip,upper,lower)
	skip = skip or 1;
	upper = upper or 10;
	lower = lower or 10;
	ret = {}
	for i=2,999 do 
		local n=WOWB_OffsetStackPos(i);
		if(not n) then break; end
		local tab = debug.getinfo(n);
		if(tab.name=="WOWB_DoScript" or tab.name=="WOWB_FireEvent" or tab.name=="WOWB_CommandLine") then
			break;
		end
		if(string.find(tab.source, "^[@=]")) then
			tab.source = string.sub(tab.source, 2);
		else
			tab.source = "[string "..string.gsub(tab.source, "\n.*", "").."]";
		end
		tinsert(ret, tab.source..":"..tab.currentline..": in "..tab.namewhat.." `"..(tab.name or "(unnamed)").."'");
	end
	ret = table.concat(ret, "\n");
	return gsub(ret, "/", "\\");
end
-- debugprofilestart() [FULL] --
local debugprofile_LastStartTime;
function debugprofilestart()
	debugprofile_LastStartTime = os.clock();
end
-- debugprofilestop() [FULL] --
function debugprofilestop()
	return os.clock() - debugprofile_LastStartTime;
end
-- DoEmote(strToken, strTarget) [DUD] --
function DoEmote(strToken, strTarget) 
	print("DoEmote: "..strToken.." @ "..strTarget);
end;
-- GetActionBarToggles() [DUD] --
function GetActionBarToggles() 
end  -- no bars shown
-- GetActionCount(actionSlot) [DUD] --
function GetActionCount(actionSlot)
	return 0;
end
-- GetActionText(nSlot) [DUD] --
function GetActionText(nSlot) 
	return ""; 
end
-- GetActionTexture(nSlot) [DUD] --
function GetActionTexture(nSlot) 
end
-- GetAddOnDependencies() [DUD] --
function GetAddOnDependencies()
	return nil; 
end
-- GetAddOnInfo(which) [HALF] --
function GetAddOnInfo(which)
	if(type(which)~="number") then
		which=_getaddonindexbyname(which);
	end
	if(not which or not _ADDONS[which]) then return; end
	return _ADDONS[which], "fake addon title", "fake addon notes", true, true, nil, "INSECURE";
end
-- GetAdjustedSkillPoints() [DUD] --
function GetAdjustedSkillPoints()
	return 0;
end
-- GetBattlefieldInfo() [DUD] --
function GetBattlefieldInfo()
	return ""; 
end
-- GetBattlefieldStatus() [DUD] --
function GetBattlefieldStatus()
	return "none"; 
end
-- GetBattlefieldWinner() [DUD] --
function GetBattlefieldWinner() 
	return nil;
end
-- GetBindingKey(strCommand) [DUD] --
function GetBindingKey(strCommand)
	return nil;
end
-- GetBonusBarOffset() [DUD] --
function GetBonusBarOffset() 
	return 0; 
end
-- GetBuildInfo() [FULL] --
function GetBuildInfo()
	return "0.12.0", "5537", "July 27 2006";
end
-- GetChatTypeIndex(str) [HALF] --
function GetChatTypeIndex(str) 
	local n=1;
	for k,v in ChatTypeInfo do 
		if(k==str) then
			return n;
		end
		n=n+1;
	end
	return 0;
end
-- GetChatWindowChannels(n) [DUD] --
function GetChatWindowChannels(n)
	if(n==1) then
		return "General - "..GetZoneText(), 1, "Wowbench", 0;
	end
end
-- GetChatWindowInfo(nIndex) [FULL] --
function GetChatWindowInfo(nIndex)
	return unpack(_CHATWINDOWINFO[nIndex]);
end
-- GetChatWindowMessages(n) [FULL] --
function GetChatWindowMessages(n)
	return unpack(_CHATWINDOWMESSAGES[n]);
end
-- GetComboPoints() [DUD] --
function GetComboPoints() 
	return 0; 
end
-- GetCurrentMapContinent() [DUD] --
function GetCurrentMapContinent() 
	return 2;
end
-- GetCurrentMultisampleFormat() [DUD] --
function GetCurrentMultisampleFormat()
	return 1;
end
-- GetCurrentResolution() [DUD] --
function GetCurrentResolution()
	return 2;
end
-- GetCursorMoney() [DUD] --
function GetCursorMoney() 
	return 0; 
end
-- GetCursorPosition() [HALF] --
function GetCursorPosition() 
	return mod(GetTime()*10,700), 100;
end
-- GetCVarDefault(varname) [FULL] --
function GetCVarDefault(varname)
	for k,v in WOWB_CVarDefaults do
		if(string.lower(k) == string.lower(varname)) then
			return v;
		end
	end
	error("Couldn't find CVar named '"..varname.."'");
end
-- GetCVar(varname) [FULL] --
function GetCVar(varname)
	if(not __CVars) then
		__CVars = {};
		for lin in io.lines(_WOWDIR.."/WTF/Config.wtf") do
			local _,_,name,val = string.find(lin, "^SET +([%a%d_]+) +\"(.*)\"");
			if(name) then
				__CVars[string.lower(name)]=val;
			else
				print("config.wtf: ???: " .. lin);
			end
		end
	end
	if(GetCVarDefault(varname)) then
		return __CVars[string.lower(varname)] or GetCVarDefault(varname);
	end
end
-- GetDefaultLanguage(who) [FULL] --
function GetDefaultLanguage(who)
	local u = WOWB_GetUnit(who or "player"); 
	if(not u) then return nil; end
	if(u[0].faction=="Alliance") then return "Common"; end
	if(u[0].faction=="Horde") then return "Orcish"; end
	return "";
end
-- GetFactionInfo(n) [DUD] --
function GetFactionInfo(n)
	if(n==1) then
		     -- name,				description,	standingId,	bottomValue,	topValue,	earnedValue,	atWarWith,	canToggleAtWar,	isHeader,	isCollapsed,	isWatched
		return "Ironforge", "",         	4,					0,						3000,			1500,					nil,				nil,						nil,			nil,					1
	elseif(n==2) then
		     -- name,				description,	standingId,	bottomValue,	topValue,	earnedValue,	atWarWith,	canToggleAtWar,	isHeader,	isCollapsed,	isWatched
		return "Stormwind", "",         	5,					3000,					6000,			4500,					nil,				nil,						nil,			nil,					nil
	end		
end
-- GetFriendInfo(nIndex) [DUD] --
function GetFriendInfo(nIndex)
	--      name, level, class, area, connected, status
	return  nil;
end
-- GetGameTime() [FULL] --
function GetGameTime()
	local t = os.date("*t");
	return t.hour, t.min;
end
-- getglobal(name) [FULL] --
function getglobal(name)
	if(not name or name=="") then
		return nil;
	end
	return _G[name];
end
-- GetGMTicket() [DUD] --
function GetGMTicket()
end
-- GetGMTicketCategories() [HALF] --
function GetGMTicketCategories()
	return "Automated replies", "Different automated replies";
end
-- GetGuildInfo(strUnitId) [DUD] --
function GetGuildInfo(strUnitId) 
	return nil; 
end
-- GetGuildRosterInfo() [DUD] --
function GetGuildRosterInfo()
	return nil;
end
-- GetGuildRosterMOTD() [DUD] --
function GetGuildRosterMOTD()
	return "";
end
-- GetGuildRosterSelection() [DUD] --
function GetGuildRosterSelection()
	return 0;
end
-- GetItemQualityColor() [HALF] --
function GetItemQualityColor()
	return 1,1,1,"ffffffff";
end;
-- GetIgnoreName(nIndex) [DUD] --
function GetIgnoreName(nIndex)
	return nil; 
end
-- GetInventoryAlertStatus(n) [DUD] --
function GetInventoryAlertStatus(n)
	return 0;
end  -- this slot isn't broken
-- GetInventoryItemBroken(who, slotid) [DUD] --
function GetInventoryItemBroken(who, slotid)
	return nil;
end
-- GetInventoryItemCooldown(who, slotid) [DUD] --
function GetInventoryItemCooldown(who, slotid)
	return 0,0,0;
end
-- GetInventoryItemCount(who, slotid) [DUD] --
function GetInventoryItemCount(who, slotid)
	return 1;
end -- should return ammo count for ammo slot if >1
-- GetInventoryItemTexture(who, slotid) [DUD] --
function GetInventoryItemTexture(who, slotid)
	return "FAKED TEXTURE FOR ".._INVENTORYSLOTS[slotid];
end
-- GetInventorySlotInfo(name) [HALF] --
function GetInventorySlotInfo(name)
	for k,v in _INVENTORYSLOTS do
		if(string.lower(name)==string.lower(v)) then
			local relic;
			if(string.lower(name)=="rangedslot") then
				relic = _CLASSUSESRELICS[Me[0].class];
			end
			return k,"",relic;
		end
	end
end
-- GetLanguageByIndex(n) [HALF] --
function GetLanguageByIndex(n) 
	if(n~=1) then return nil; end  
	if(Me[0].faction=="Alliance") then return "Common" else return "Orcish"; end 
end
-- GetLocale() [HALF] --
function GetLocale() 
	return "enUS";
end
-- GetLootMethod() [FULL] --
function GetLootMethod()
	return _PARTY.lootmethod, _PARTY.masterlooter;
end
-- GetLootThreshold() [FULL] --
function GetLootThreshold()
	return _PARTY.lootthreshold;
end
-- GetMapContinents() [FULL] --
function GetMapContinents()
	return "Kalimdor", "Eastern Kingdoms"; 
end
-- GetMapInfo() [DUD] --
function GetMapInfo() 
	return "Ironforge", 100, 100;
end
-- GetMapZones(n) [HALF] --
function GetMapZones(n) 
	if(n==1) then 
		return "Orgrimmar"; 
	elseif(n==2) 
		then return "Ironforge"; 
	else 
		error("GetMapZones "..n); 
	end 
end
-- GetMasterLootCandidate(i) [FULL] --
function GetMasterLootCandidate(i) 
	return _PARTY[i-1];
end
-- GetMinimapZoneText() [DUD] --
function GetMinimapZoneText() 
	return "Ironforge"; 
end
-- GetMoney() [FULL] --
function GetMoney() 
	return tonumber(Me[0].money) or 0;
end
-- GetMouseFocus() [FULL] --
function GetMouseFocus()
	if(not WOWB_CurrentMouseTarget) then
		return WorldFrame;
	end
	if(not WOWB_CurrentMouseTarget:IsObjectType("UIObject")) then
		return WorldFrame;
	end
end
-- GetMultisampleFormats() [DUD] --
function GetMultisampleFormats()
	return 24,8,1;
end
-- GetNetStats() [DUD] --
function GetNetStats()
	return 0,0,100;
end
-- GetNumAddOns() [FULL] --
function GetNumAddOns() 
	return table.getn(_ADDONS); 
end
-- GetNumBattlefields() [DUD] --
function GetNumBattlefields()
	return 0;
end
-- GetNumBattlefieldScores() [DUD] --
function GetNumBattlefieldScores() 
	return 0;
end
-- GetNumBattlefieldStats() [DUD] --
function GetNumBattlefieldStats() 
	return 0; 
end
-- GetNumFactions() [DUD] --
function GetNumFactions()
	return 2;
end
-- GetNumFriends() [DUD] --
function GetNumFriends()
	return 0;
end
-- GetNumGuildMembers() [DUD] --
function GetNumGuildMembers() 
	return 0;
end
-- GetNumIgnores() [DUD] --
function GetNumIgnores() 
	return 0; 
end
-- GetNumLaguages() [DUD] --
function GetNumLaguages() 
	return 1;
end
-- GetNumMapLandmarks() [DUD] --
function GetNumMapLandmarks() 
	return 0; 
end
-- GetNumMapOverlays() [DUD] --
function GetNumMapOverlays() 
	return 0; 
end
-- GetNumPartyMembers() [FULL] --
function GetNumPartyMembers() 
	return table.getn(_PARTY);
end
-- GetNumQuestLogEntries() [DUD] --
function GetNumQuestLogEntries()
	return 0,0;  -- numEntries (including headers), numQuests 
end
-- GetNumRaidMembers() [DUD] --
function GetNumRaidMembers()
	return 0;
end
-- GetNumShapeshiftForms() [DUD] --
function GetNumShapeshiftForms()
	return 0; 
end
-- GetNumSkillLines() [DUD] --
function GetNumSkillLines() 
	return 0; 
end
-- GetNumSpellTabs() [DUD] --
function GetNumSpellTabs()
	return 0;
end
-- GetNumStationeries() [DUD] --
function GetNumStationeries()
	return 1;
end
-- GetNumWhoResults() [DUD] --
function GetNumWhoResults() return 0,0; --[[ totalCount, numWhos ]] end
-- GetNumWorldStateUI() [DUD] --
function GetNumWorldStateUI() 
	return 0; 
end  -- no battlefield crap showing
-- GetPartyLeaderIndex() [FULL] --
function GetPartyLeaderIndex()
	return (_PARTY.leader>=1) and _PARTY.leader;
end
-- GetPartyMember(n) [FULL] --
function GetPartyMember(n) 
	if(n>=1 and _PARTY[n]) then 
		return "party"..n; 
	end
end
-- GetPetActionCooldown(n) [DUD] --
function GetPetActionCooldown(n)
	return 0,0,0; 
end
-- GetPetActionInfo(n) [DUD] --
function GetPetActionInfo(n)
end
-- GetPetActionsUsable() [DUD] --
function GetPetActionsUsable() 
	return false; 
end
-- GetPlayerBuff(nIndex, strFilter) [DUD] --
function GetPlayerBuff(nIndex, strFilter) 
	return -1; 
end -- we don't have that buff
-- GetPlayerTradeMoney() [DUD] --
function GetPlayerTradeMoney()
	return 0; 
end
-- GetPVPLastWeekStats() [DUD] --
function GetPVPLastWeekStats()
	return 0,0,0,""; 
end
-- GetPVPLifetimeStats() [DUD] --
function GetPVPLifetimeStats() 
	return 0,0,0; 
end
-- GetPVPRankInfo(rank) [DUD] --
function GetPVPRankInfo(rank) 
	return nil, 1; 
end
-- GetPVPRankProgress() [DUD] --
function GetPVPRankProgress() 
	return 0;
end
-- GetPVPSessionStats() [DUD] --
function GetPVPSessionStats() 
	return 0,0;
end
-- GetPVPThisWeekStats() [DUD] --
function GetPVPThisWeekStats()
	return 0,0; 
end
-- GetPVPYesterdayStats() [DUD] --
function GetPVPYesterdayStats() 
	return 0,0,0; 
end
-- GetQuestGreenRange() [HALF] --
function GetQuestGreenRange()	-- roughly correct, but not entirely. will return 12 at 60 though.
	return 5 + math.floor(Me[0].level/8);
end
-- GetQuestLogSelection() [DUD] --
function GetQuestLogSelection()
	return 0;
end
-- GetQuestTimers() [DUD] --
function GetQuestTimers() 
end
-- GetRaidTargetIndex() [DUD] --
function GetRaidTargetIndex()
	return 0;
end
-- GetRealmName() [FULL] --
function GetRealmName() 
	return _REALM; 
end
-- GetRealZoneText() [DUD] --
function GetRealZoneText()
	return GetZoneText();
end
-- GetRefreshRates() [DUD] --
function GetRefreshRates()
	return 20;
end
-- GetRepairAllCost() [DUD] --
function GetRepairAllCost()
	return 0,nil;
end -- repairAllCost, canRepair
-- GetRestState() [DUD] --
function GetRestState() 
	return 1,"Normal",1; 
end
-- GetScreenHeight() [DUD] --
function GetScreenHeight()
	return 768; 
end
-- GetScreenResolutions() [HALF] --
function GetScreenResolutions()
	return "800x600", "1024x768";
end
-- GetScreenWidth() [DUD] --
function GetScreenWidth()
	return 1024;
end
-- GetSelectedBattlefield() [DUD] --
function GetSelectedBattlefield()
	return 0;
end
-- GetSelectedFaction() [DUD] --
function GetSelectedFaction()
	return 0;
end
-- GetSelectedFriend() [DUD] --
function GetSelectedFriend() 
	return 0; 
end
-- GetSelectedIgnore() [DUD] --
function GetSelectedIgnore() 
	return 0; 
end
-- GetSelectedSkill() [DUD] --
function GetSelectedSkill()
	return 0;
end
-- GetSendMailPrice() [HALF] --
function GetSendMailPrice() 
	return 70; 
end
-- GetSkillLineInfo() [HALF] --
function GetSkillLineInfo()
	-- skillName, header, isExpanded, skillRank, numTempPoints, skillModifier, skillMaxRank, isAbandonable, stepCost, rankCost, minLevel, skillCostType, skillDescription 
	return "",    false,  false,      1,         0,             0,             0,            false,         1,        1,        1,        1,             ""
end
-- GetSpellName(id, strBook) [DUD] --
function GetSpellName(id, strBook)
	return nil;
end
-- GetSpellTabInfo(tabnum) [DUD] --
function GetSpellTabInfo(tabnum)
	-- name, texture, offset, numSpells 	
	return "",nil,0,0;
end
-- GetStationeryInfo(n) [HALF] --
function GetStationeryInfo(n)
	if n==1 then return "Default Stationery"; 
	end
end
-- GetSubZoneText() [DUD] --
function GetSubZoneText()
	return "Ironforge";
end
-- GetTabardCreationCost() [FULL] --
function GetTabardCreationCost() 
	return 100000;
end
-- GetTargetTradeMoney() [DUD] --
function GetTargetTradeMoney() 
	return 0; 
end
-- GetTime() [FULL] --
function GetTime()
	return os.clock();
end
-- GetVideoCaps() [DUD] --
function GetVideoCaps()
	return nil; 
end -- no shaders, filtering, ... no nothing
-- GetWeaponEnchantInfo() [DUD] --
function GetWeaponEnchantInfo() 
end;  -- hasMainHandEnchant, mainHandExpiration, mainHandCharges, hasOffHandEnchant, offHandExpiration, offHandCharges
-- GetWhoInfo(nIndex) [DUD] --
function GetWhoInfo(nIndex)
	--     name, guild, level, race, class, zone
	return nil;
end
-- GetXPExhaustion() [DUD] --
function GetXPExhaustion()
	return 0; 
end  -- no rested xp
-- GetZonePVPInfo() [DUD] --
function GetZonePVPInfo()
	return "friendly", "Ironforge", false;
end
-- GetZoneText() [DUD] --
function GetZoneText()
	return "Ironforge";
end
-- GuildControlGetNumRanks() [DUD] --
function GuildControlGetNumRanks()
	return 0; 
end
-- GuildControlGetRankFlags() [DUD] --
function GuildControlGetRankFlags() 
	return nil; 
end
-- HasAction(nSlot) [DUD] --
function HasAction(nSlot)
	return nil; 
end
-- HasKey() [DUD] --
function HasKey()
	return false;
end
-- HasPetSpells() [DUD] --
function HasPetSpells()	
	return nil;
end
-- HasPetUI() [DUD] --
function HasPetUI()
	return nil; 
end
-- HideFriendNameplates() [DUD] --
function HideFriendNameplates()
end
-- HideNameplates() [DUD] --
function HideNameplates()
end
-- InCinematic() [HALF] --
function InCinematic()
	return nil;
end
-- IsAddOnLoaded(which) [FULL] --
function IsAddOnLoaded(which)
	if(type(which)~="number") then
		which=_getaddonindexbyname(which);
	end
	if(not which or not _ADDONS[which]) then return false; end
	return true;
end
-- IsAltKeyDown() [DUD] --
function IsAltKeyDown()
	return nil;
end
-- IsAttackAction(actionSlot) [DUD] --
function IsAttackAction(actionSlot)
	return nil;
end
-- IsAutoRepeatAction(actionSlot) [DUD] --
function IsAutoRepeatAction(actionSlot)
	return nil;
end
-- IsConsumableAction(nSlot) [DUD] --
function IsConsumableAction(nSlot) 
	return nil; 
end
-- IsCurrentAction(actionSlot) [DUD] --
function IsCurrentAction(actionSlot)
	return nil;
end
-- IsEquippedAction(nSlot) [DUD] --
function IsEquippedAction(nSlot)
	return nil; 
end
-- IsGuildLeader() [DUD] --
function IsGuildLeader() 
	return nil; 
end
-- IsInGuild() [DUD] --
function IsInGuild() 
	return false; 
end
-- IsInInstance() [DUD] --
function IsInInstance() 
	return false; 
end
-- IsInventoryItemLocked(slotid) [DUD] --
function IsInventoryItemLocked(slotid) 
	return nil; 
end
-- IsPartyLeader() [FULL] --
function IsPartyLeader()
	return _PARTY.leader == 0;
end
-- IsRaidOfficer() [DUD] --
function IsRaidOfficer()
	return false;
end
-- IsResting() [DUD] --
function IsResting()
	return true;
end
-- MouseIsOver(frame, offsTop, offsBottom, offsLeft, offsRight) [FULL] --
function MouseIsOver(frame, offsTop, offsBottom, offsLeft, offsRight)
	if(not frame) then return nil; end
	return frame==WOWB_CurrentMouseTarget;
end
-- NoPlayTime() [DUD] --
function NoPlayTime()
	return false;
end
-- OffhandHasWeapon() [DUD] --
function OffhandHasWeapon() 
end -- nope
-- PartialPlayTime() [DUD] --
function PartialPlayTime()
	return false;
end
-- PetHasActionBar() [DUD] --
function PetHasActionBar() 
	return false; 
end
-- PlaySound(str) [DUD] --
function PlaySound(str)
end
-- RegisterCVar(cvar {, default}) [FULL] --
function RegisterCVar(cvar, default)
	if(default == nil) then
		default="0";
	end
	WOWB_CVarDefaults[cvar]=default;
end
-- RegisterForSave(varname) [FULL] --
function RegisterForSave(varname)
	assert(type(varname)=="string");
	table.insert(WOWB_SavedVariablesGlobal, varname);
end
-- RequestBattlefieldPositions() [DUD] --
function RequestBattlefieldPositions() 
end
-- RequestRaidInfo() [DUD] --
function RequestRaidInfo() 
end
-- RequestTimePlayed() [HALF] --
function RequestTimePlayed() 
	WOWB_QueueDPC(WOWB_FireEvent, "TIME_PLAYED_MSG", 2,1); 
end

-- SendAddonMessage() [HALF] -- Will always send to all logged-in-players regardless of system
function SendAddonMessage(prefix,message,system)
	if(not (prefix and message and (system=="PARTY" or system=="RAID" or system=="GUILD" or system=="BATTLEGROUND") ) ) then
		error('Usage: SendAddonMessage("prefix", "text", "PARTY|RAID|GUILD|BATTLEGROUND")', 2);
	end
	-- Just dump it in all sessions. (Assume everyone is in /say range etc..)
	for v,_ in pairs(World[0].children) do
		if(v:IsObjectType("Player") and v[0].sessionIndex and v:GetName()~=_CHARACTER) then
			local ses=WOWB_SessCtl[v[0].sessionIndex];
			ses.WOWB_QueueDPC(ses.WOWB_FireEvent, "CHAT_MSG_ADDON", prefix, message, system, Me:GetName(),  "", "", "", "", "");
		end
	end
	
end

-- SendChatMessage() [HALF] --
function SendChatMessage(msg,system,language,channel)
	WOWB_OriginateChatMessage(_CHARACTER,  msg,system,language,channel);
end

-- SetChatWindowAlpha(nIndex, a) [FULL] --
function SetChatWindowAlpha(nIndex, a)
	_CHATWINDOWINFO[nIndex][6] = a;
	chatupdated();
end
-- SetChatWindowDocked(nIndex, flag) [FULL] --
function SetChatWindowDocked(nIndex, flag)
	_CHATWINDOWINFO[nIndex][9] = flag;
	chatupdated();
end
-- SetChatWindowLocked(nIndex, flag) [FULL] --
function SetChatWindowLocked(nIndex, flag)
	_CHATWINDOWINFO[nIndex][8] = flag;
	chatupdated();
end
-- SetChatWindowName(nIndex, name) [FULL] --
function SetChatWindowName(nIndex, name)
	_CHATWINDOWINFO[nIndex][1] = name or "";
	chatupdated();
end
-- SetChatWindowSize(nIndex, size) [HALF] --
function SetChatWindowSize(nIndex, size)
	chatupdated();
end
-- SetChatWindowShown(nIndex. flag) [FULL] --
function SetChatWindowShown(nIndex, flag) 
	_CHATWINDOWINFO[nIndex][7] = flag;
	chatupdated();
end;
-- seterrorhandler() [DUD] --
function seterrorhandler()
	return nil;
end
-- SetCVar(cvar,value{,"scriptCVar"}) [HALF] --
function SetCVar(cvar,value,scriptCVar)
	-- force loading config.wtf and check if CVar is registered by calling GetCVar
	if(GetCVar(cvar)) then
		__CVars[string.lower(cvar)]=value;
	end
	-- if scriptCVar is not nil, should fire CVAR_UPDATE at this point, appropriately setting arg1 etc. based on scriptCVar
end
-- setglobal(name,value) [FULL] --
function setglobal(name,value)
	if(not string.find(name,"^[%a_][.%[%]\"'%a%d_]*$")) then
		error("setglobal(): invalid variable name \"" .. name .. "\"");
	end
	_G[name] = value;
end
-- SetGuildRosterSelection() [DUD] --
function SetGuildRosterSelection() 
end
-- SetMapToCurrentZone() [DUD] --
function SetMapToCurrentZone() 
end
-- SetPortraitTexture() [DUD] --
function SetPortraitTexture()
end;
-- SetSelectedSkill(n) [DUD] --
function SetSelectedSkill(n) 
end;
-- SetWhoToUI(n) [FULL] --
function SetWhoToUI(n) 
	_WHOTOUI=n;
end;
-- ShowFriendNameplates() [DUD] --
function ShowFriendNameplates()
end
-- ShowNameplates() [DUD] --
function ShowNameplates()
end
-- TargetByName() [FULL] --
function TargetByName(name,exact)
	u = WOWB_World_FindUnitByname(name);
	if(u and exact and strlower(u:GetName())~=strlower(name)) then
		u = nil;
	end
	if(u) then
		WOWB_TargetUnit(u);
	else
		WOWB_QueueDPC(WOWB_FireEvent, "UI_ERROR_MESSAGE", ERR_UNIT_NOT_FOUND);
	end
end
-- TEXT(str) [FULL] --
function TEXT(str)
	return str; 
end
-- UnitBuff(who) [DUD] --
function UnitBuff(who)
	return nil;		-- noone has any buffs
end  
-- UnitCanAttack(attacker, attacked) [FULL] --
function UnitCanAttack(attacker, attacked)
	local u1 = WOWB_GetUnit(attacker);
	local u2 = WOWB_GetUnit(attacked);
	if(not u1 or not u2) then return nil; end
	return (u1[0].faction or "") ~= (u2[0].faction or "");  -- Alliance vs Horde and vice versas. Either vs nonfaction NPCs. And those can't attack eachother. Simplistic.
end
-- UnitCanCooperate(who1,who2) [HALF] --
function UnitCanCooperate(who1,who2)
	return not UnitCanAttack(who1,who2);	-- bit simplistic
end
-- UnitCharacterPoints(who) [HALF] --
function UnitCharacterPoints(who)
	if(who=="player") then
		return 0;
	end
	return nil;
end  -- no talent points unused
-- UnitClass(who) [FULL] --
function UnitClass(who)
	local u = WOWB_GetUnit(who);
	return u and u[0].class;
end
-- UnitClassification(who) [DUD] --
function UnitClassification(who)
	return "normal";
end
-- UnitDebuff(who) [DUD] --
function UnitDebuff(who)
	return nil;	-- noone has any nasty debuffs
end  
-- UnitExists(who) [FULL] --
function UnitExists(who)
	return WOWB_GetUnit(who)~=nil;
end
-- UnitFactionGroup(who) [FULL] --
function UnitFactionGroup(who)
	local u = WOWB_GetUnit(who);
	if(u) then
		return u[0].faction,u[0].faction;  -- not sure about this one
	end
end
-- UnitHealth(who) [FULL] --
function UnitHealth(who)		
	local u = WOWB_GetUnit(who); 
	if(u) then 
		if(u:IsObjectType("NPC")) then
			return ceil((u.health or u.maxhealth or 100)/(u.maxhealth or 100)* 100);
		else
			return u[0].health;
		end
	end
end
-- UnitHealthMax(who) [FULL] --
function UnitHealthMax(who)
	local u = WOWB_GetUnit(who); 
	if(u) then 
		if(u:IsObjectType("NPC")) then
			return 100;
		else
			return u[0].healthmax;
		end
	end
end
-- UnitInRaid(who) [DUD] --
function UnitInRaid(who)
	return nil;
end
-- UnitIsCharmed(who) [DUD] --
function UnitIsCharmed(who)
	return nil;
end
-- UnitIsCivilian(who) [DUD] --
function UnitIsCivilian(who)
	return nil;
end
-- UnitIsConnected(who) [FULL] --
function UnitIsConnected(who)
	local u = WOWB_GetUnit(who);
	return u and u.connected; -- not a typo; there's a bool directly under u
end
-- UnitIsCorpse(who) [DUD] --
function UnitIsCorpse(who)
	return nil;
end
-- UnitIsDead(who) [DUD] --
function UnitIsDead(who)
	return nil;
end
-- UnitIsDeadOrGhost(who) [DUD] --
function UnitIsDeadOrGhost(who)
	return nil;
end
-- UnitIsEnemy(who) [HALF] --
function UnitIsEnemy(who)
	return UnitCanAttack("player", who);	-- bit simplistic
end
-- UnitIsFriend(who) [HALF] --
function UnitIsFriend(who)
	return not UnitIsEnemy(who);	-- bit simplistic
end
-- UnitIsGhost(who) [DUD] --
function UnitIsGhost(who)
	return nil;
end
-- UnitIsPartyLeader(who)  [FULL] --
function UnitIsPartyLeader(who)
	local u = WOWB_GetUnit(who);
	return u and u:IsObjectType("Player") and u:GetName()==_PARTY[_PARTY.leader];
end
-- UnitIsPlayer(who) [FULL] --
function UnitIsPlayer(who)
	local u = WOWB_GetUnit(who);
	return u and u:IsObjectType("Player");
end
-- UnitIsPVP(who) [HALF] --
function UnitIsPVP(who)
	return UnitIsPlayer(who);
end
-- UnitIsPVPFreeForAll(who) [DUD] --
function UnitIsPVPFreeForAll(who)
	return false;
end
-- UnitIsUnit(who1,who2) [FULL] --
function UnitIsUnit(who1,who2)
	local u = WOWB_GetUnit(who1);
	return u and u == WOWB_GetUnit(who2);
end
function UnitIsTapped(who)
	return nil;	-- nothing is tapped
end
-- UnitIsVisible(who) [HALF] --
function UnitIsVisible(who)
	return WOWB_GetUnit(who)~=nil;
end
-- UnitLevel(who) [FULL] --
function UnitLevel(who)
	local u = WOWB_GetUnit(who);
	return u and u[0].level;
end
-- UnitMana(who) [FULL] --
function UnitMana(who)
	local u = WOWB_GetUnit(who);
	return u and u[0].mana;
end
-- UnitManaMax(who) [FULL] --
function UnitManaMax(who)
	local u = WOWB_GetUnit(who);
	return u and u[0].manamax;
end
-- UnitName(who) [FULL] --
function UnitName(who)
	local u = WOWB_GetUnit(who);
	return u and u[0].name;
end
-- UnitPlayerControlled(who) [HALF] --
function UnitPlayerControlled(who)
	local u = WOWB_GetUnit(who);
	return u and u:IsObjectType("Player");
end  -- should likely include mind controlled units and pets too but we don't have those
-- UnitPowerType(who) [FULL] --
function UnitPowerType(who)
	local u = WOWB_GetUnit(who);
	return u and u[0].powertype;
end
-- UnitPVPRank(who) [DUD] --
function UnitPVPRank(who)
	return 0;
end
-- UnitRace(who) [FULL] --
function UnitRace(who)
	local u = WOWB_GetUnit(who);
	return u and u[0].race;
end
-- UnitReaction(attacker,attacked) [HALF] --
function UnitReaction(attacker,attacked)
	if(UnitCanAttack(attacker,attacked)) then return 2; end		-- bit simplistic yes =)
	return 5;
end
-- UnitSex(who) [FULL] --
function UnitSex(who)
	local u = WOWB_GetUnit(who);
	return u and (u[0].sex or 1);
end
-- UnitXP(who) [FULL] --
function UnitXP(who)
	if(who=="player") then
		return Me[0].xp;
	end
	return nil;
end
-- UnitXPMax(who) [FULL] --
function UnitXPMax(who)
	if(who=="player") then
		return Me[0].xpmax;
	end
	return nil;
end