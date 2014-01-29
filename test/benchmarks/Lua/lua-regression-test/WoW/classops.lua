
--
-- classops.lua  - Copyright (c) 2006, the WoWBench developer community. All rights reserved. See LICENSE.TXT.
-- 
-- Basic object class operations: constructing, inheriting...
-- Also defines WBClass_Base
--

-----------------------------------------------------------
-- function WOWB_RunObjConstructors(o, objtype)
--
-- Run __constructor in all base classes and the object 
-- itself. This is a misnomer really. It's not so much a
-- "constructor" as a "deal with parameters from xml".
--
-- We should have both, really. An opportunity to set
-- nice default values wouldn't hurt.
-- (Though mind that InheritType refuses to copy over values
--  that are already filled out ... hrm...)
--
-----------------------------------------------------------

function WOWB_RunObjConstructors(o, objtype)
	for _,inheritedtype in objtype.__inheritstypes do
		WOWB_RunObjConstructors(o, inheritedtype);
	end
	objtype.__constructor(o);
end


---------------------------------------------------------------------
-- function WOWB_InheritType(dest,...)
--
-- Used when creating new types, e.g.
--   WBClass_Something = {}
--   WBClass_InheritType(WBClass_Something, WBClass_Base)
-- Also does multiple inheritance.
---------------------------------------------------------------------

function WOWB_InheritType(dest,...)
	
	local function WOWB_InheritType_Fly(dest,classes)
		for _,src in ipairs(classes) do
			for k,v in src do
				if(not dest[k]) then
					dest[k] = v;
				end
			end
			WOWB_InheritType_Fly(dest,src.__inheritstypes);
		end
	end
	
	assert(not dest.__inheritstypes);
	dest.__inheritstypes = {}
	if(table.getn(arg)<2) then
		-- single inheritance: yay, we can just point __index to our base class
		src = arg[1];
		table.insert(dest.__inheritstypes, src);
		setmetatable(dest, {__index=src});
	
	else
		-- multiple inheritance, copy in all methods from all classes (and their children... sigh)
		for _,src in ipairs(arg) do
			table.insert(dest.__inheritstypes, src);
		end
		WOWB_InheritType_Fly(dest,dest.__inheritstypes);
	end
end



---------------------------------------------------------------------
-- function WOWB_DescribeObject(o)
--
-- Return e.g. "Frame MyFrame" or "Button myxmlfile:123"
---------------------------------------------------------------------

function WOWB_DescribeObject(o)
	if(not o) then
		return "(nil)";
	end
	if(o[0].name) then
		return o[0].xmltag..' '..o[0].name;
	end
	if(o[0].xmlfile) then
		return o[0].xmltag..' '..WOWB_SimpleFilename(o[0].xmlfile)..':'..o[0].xmlfilelinenum;
	end
	return o[0].xmltag..' (unnamed)';
end



-------------------------------------------------
-- Base class; inherit everything from this

WBClass_Base = { __inheritstypes={} }

local function __Base_IsObjectType_Fly(oType, str)
	for k,v in oType.__inheritstypes do
		if(string.lower(v:GetObjectType())==str) then return true; end
		if(__Base_IsObjectType_Fly(v,str)) then
			return true;
		end
	end
	return false;
end
function WBClass_Base:IsObjectType(str)
	return __Base_IsObjectType_Fly(self, string.lower(str));
end
function WBClass_Base:GetObjectType(str) return "WBClass_Base"; end
function WBClass_Base:__constructor() end
function WBClass_Base:GetName() return self[0].name or ""; end

WOWB_Debug_AddClassInfo(WBClass_Base, WBClass_Base:GetObjectType());

