
--
-- world.lua  - Copyright (c) 2006, the WoWBench developer community. All rights reserved. See LICENSE.TXT.
--
-- Defines "the world", interaction with it and itsobject classes. 
-- The actual objects are parsed from world.xml
--
--
--


WOWB_World = {}





---------------------------------------------------------------------
---------------------------------------------------------------------
---------------------------------------------------------------------
--
-- Define players, npcs, objects, items ...
--

--------------------------------------------------------------
-- "worldthing" - base class units and objects

WBClass_WorldThing = {}
WOWB_InheritType(WBClass_WorldThing, WBClass_Base);

function WBClass_WorldThing:GetObjectType() return "WorldThing"; end

function WBClass_WorldThing:__constructor()
	if(not self[0]) then self[0]={} end
	self[0].clickTypes={LeftButtonUp=true, RightButtonUp=true};
end

function WBClass_WorldThing:IsVisible() return false; end
function WBClass_WorldThing:IsShown() return false; end

WOWB_Debug_AddClassInfo(WBClass_WorldThing, WBClass_WorldThing:GetObjectType());

--------------------------------------------------------------
-- "unit" - base class for players and npcs

WBClass_Unit = {}
WOWB_InheritType(WBClass_Unit, WBClass_WorldThing);

function WBClass_Unit:GetObjectType() return "Unit"; end

function WBClass_Unit:__constructor()
	if((self[0].virtual or "false")=="true") then
		return;
	end
	self[0].class = string.upper(self[0].class or "WARRIOR");
	if(self[0].class == "WARRIOR") then
		self[0].powertype = 1;
		self[0].manamax=100;
		self[0].mana=0;
	elseif(self[0].class == "ROGUE") then
		self[0].powertype = 3;
		self[0].manamax=100;
		self[0].mana=100;
	else
		self[0].powertype = 0;
		self[0].mana = self[0].mana or self[0].manamax;
	end
	self[0].health = self[0].health or self[0].healthmax;
end

function WBClass_Unit:IsVisible() return (self[0].virtual or "false")=="false"; end
function WBClass_Unit:IsShown() return self:IsVisible(); end

WOWB_Debug_AddClassInfo(WBClass_Unit, WBClass_Unit:GetObjectType());


--------------------------------------------------------------
-- "player" class

WBClass_Player = {}
WOWB_InheritType(WBClass_Player, WBClass_Unit);

function WBClass_Player:GetObjectType() return "Player"; end

function WBClass_Player:__constructor()
	self.connected = (self[0].connected or "true")=="true";
	if(self[0].name=="Me") then
		self[0].name=_CHARACTER;
	end
end

WOWB_Debug_AddClassInfo(WBClass_Player, WBClass_Player:GetObjectType());


--------------------------------------------------------------
-- "npc" class

WBClass_NPC = {}
WOWB_InheritType(WBClass_NPC, WBClass_Unit);

function WBClass_NPC:GetObjectType() return "NPC"; end

WOWB_Debug_AddClassInfo(WBClass_NPC, WBClass_NPC:GetObjectType());


--------------------------------------------------------------
-- "object" class  - mailboxes, corpses, chests ...

WBClass_Object = {}
WOWB_InheritType(WBClass_Object, WBClass_WorldThing);

function WBClass_Object:GetObjectType() return "Object"; end

function WBClass_Object:IsVisible() return true; end
function WBClass_Object:IsShown() return true; end

WOWB_Debug_AddClassInfo(WBClass_Object, WBClass_Object:GetObjectType());


--------------------------------------------------------------
-- "item" class  - stuff you can wear and carry


WBClass_Item = {}
WOWB_InheritType(WBClass_Item, WBClass_WorldThing);

function WBClass_Item:GetObjectType() return "Item"; end

WOWB_Debug_AddClassInfo(WBClass_Item, WBClass_Item:GetObjectType());







function WOWB_World_OnLoad()
	Me = WOWB_CreateObject("Player", "Me", World, "MeTemplate");
	Me[0].name = _CHARACTER;
	print("Your name is "..Me[0].name..".");
end


---------------------------------------------------------------------
---------------------------------------------------------------------
---------------------------------------------------------------------
--
-- Misc utility functions called from elsewhere mainly
--
--

function WOWB_TargetUnit(unit)
	assert(not unit or unit:IsObjectType("Unit"));
	if(unit ~= _TARGET) then
		_TARGET = unit;
		print("WOWB_TargetUnit(): Target changed to '" .. ((unit and unit:GetName()) or "(nil)") .. "'");
		WOWB_QueueDPC(WOWB_FireEvent, "PLAYER_TARGET_CHANGED");
	end
end


function WOWB_World_FindUnitByname(str)
	local a = {}
	str = string.lower(str);
	
	for v,_ in pairs(World[0].children) do
		if(v:IsObjectType("Unit") and v:IsVisible()) then
			a[string.lower(v:GetName())] = v;
		end
	end
	
	if(a[str]) then
		return a[str];
	end
	
	-- Blizzard's algorithm seems even wonkier than this but this is the best I could do =)
	
	for l=strlen(str),2,-1 do
		local strs = string.sub(str,1,l);
		for k,v in a do
			if(string.sub(k,1,l) == strs) then
				return v;
			end
		end
	end
  
	for l=strlen(str),1,-1 do
		local strs = string.sub(str,1,l);
		for k,v in a do
			if(string.find(k,strs,1,true)) then
				return v;
			end
		end
	end

end


function WOWB_World_FindMouseTarget(str)
	local o = WOWB_AllObjectsByName[string.lower(str)];
	if(o) then
		if(not o:IsVisible()) then
			print("Cannot target "..o:GetName().."; it is not visible.");
			return nil;
		end
		return o;
	else
		return WOWB_World_FindUnitByname(str);
	end
end


WOWB_CurrentMouseTarget = nil;

function WOWB_World_MouseToTarget(name_or_frame)
	if(WOWB_CurrentMouseTarget) then
		WOWB_DoScript({this=WOWB_CurrentMouseTarget, script="OnLeave"});
	end
	if(type(name_or_frame)=="table") then
		assert(name_or_frame[0]);
		WOWB_CurrentMouseTarget = name_or_frame;
	elseif((name_or_frame or "")=="") then
		WOWB_CurrentMouseTarget = nil;
	else
		WOWB_CurrentMouseTarget = WOWB_World_FindMouseTarget(name_or_frame);
	end
	
	if(WOWB_CurrentMouseTarget) then
		WOWB_DoScript({this=WOWB_CurrentMouseTarget, script="OnEnter"});
		if(WOWB_CurrentMouseTarget:IsObjectType("Unit")) then
			WOWB_FireEvent("UPDATE_MOUSEOVER_UNIT");  -- don't DPC this.
		end
	end
	return WOWB_CurrentMouseTarget;
end

