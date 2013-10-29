
--
-- worldxml.lua  - Copyright (c) 2006, the WoWBench developer community. All rights reserved. See LICENSE.TXT.
--
-- Set up the XML parser to understand "world.xml" format
--
--


WOWB_ROOTXMLTAG = "World";

WOWB_XMLTagInfo_World = {
	
	World = { objecttype="WBClass_WorldThing", attribute=true},

		Units = { container=true },
	
			Unit = { objecttype="WBClass_Unit" }, -- really only want to see one of these, as a virtual
			Player = { objecttype="WBClass_Player" },
			NPC = { objecttype="WBClass_NPC" },
			
		Objects = { container = true },
		
			Object = { objecttype="WBClass_Object" },
			
		Scripts = { container = true },
		
			OnLoad = { attribute=true, script=true }, 
			OnClick = { attribute=true, script=true }, 
			OnMouseDown = { attribute=true, script=true }, 
			OnMouseUp = { attribute=true, script=true }, 
			OnMouseOver = { attribute=true, script=true }, 
			OnEnter = { attribute=true, script=true }, 
			OnLeave = { attribute=true, script=true },
}



WOWB_XMLTagInfo = WOWB_XMLTagInfo_World;	-- The XML parser uses "WOWB_XMLTagInfo"
