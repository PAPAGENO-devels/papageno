
--
-- uixml.lua  - Copyright (c) 2006, the WoWBench developer community. All rights reserved. See LICENSE.TXT.
--
-- Set up the XML parser to understand Blizzard UI XML format
--
--

WOWB_ROOTXMLTAG = "Ui";

WOWB_XMLTagInfo_BlizzardUI = {
	-- Objects. Indexed by 1,2,3..
	-- If name="..." is set, a global object with that name is created
	Font = { objecttype="WBClass_Font", },
	Frame = { objecttype="WBClass_Frame", },
	Button = { objecttype="WBClass_Button", },
	ColorSelect = { objecttype="WBClass_ColorSelect", },
	EditBox = { objecttype="WBClass_EditBox", },
	GameTooltip = { objecttype="WBClass_GameTooltip", },
	MessageFrame = { objecttype="WBClass_MessageFrame", },
	Minimap = { objecttype="WBClass_Minimap", },
	Model = { objecttype="WBClass_Model", },
	MovieFrame = { objecttype="WBClass_MovieFrame", },
	ScrollFrame = { objecttype="WBClass_ScrollFrame", },
	ScrollingMessageFrame = { objecttype="WBClass_ScrollingMessageFrame", },
	SimpleHTML = { objecttype="WBClass_SimpleHTML", },
	Slider = { objecttype="WBClass_Slider", },
	StatusBar = { objecttype="WBClass_StatusBar", },
	TaxiRouteFrame = { objecttype="WBClass_TaxiRouteFrame", },
	WorldFrame = { objecttype="WBClass_WorldFrame", },
	CheckButton = { objecttype="WBClass_CheckButton", },
	LootButton = { objecttype="WBClass_LootButton", },
	PlayerModel = { objecttype="WBClass_PlayerModel", },
	DressUpModel = { objecttype="WBClass_DressUpModel", },
	TabardModel = { objecttype="WBClass_TabardModel", },
	FontString = { objecttype="WBClass_FontString", },
	Texture = { objecttype="WBClass_Texture", },
	
	-- Attributish tags that create objects. Indexed by tag name.
	-- If name="..." is set, a global object with that name is created
	BarTexture = { objecttype="WBClass_Texture", attribute=1, },
	ButtonText = { objecttype="WBClass_FontString", attribute=1, }, -- new in 1.11
	CheckedTexture = { objecttype="WBClass_Texture", attribute=1, },
	ColorValueTexture = { objecttype="WBClass_Texture", attribute=1, },
	ColorValueThumbTexture = { objecttype="WBClass_Texture", attribute=1, },
	ColorWheelTexture = { objecttype="WBClass_Texture", attribute=1, },
	ColorWheelThumbTexture = { objecttype="WBClass_Texture", attribute=1, },
	DisabledCheckedTexture = { objecttype="WBClass_Texture", attribute=1, },
	DisabledFont = { objecttype="WBClass_FontString", attribute=1, }, -- new in 1.11
	DisabledText = { objecttype="WBClass_FontString", attribute=1, }, -- deprecated in 1.11
	DisabledTexture = { objecttype="WBClass_Texture", attribute=1, },
	HighlightFont = { objecttype="WBClass_FontString", attribute=1, }, -- new in 1.11
	HighlightText = { objecttype="WBClass_FontString", attribute=1, }, -- deprecated in 1.11
	HighlightTexture = { objecttype="WBClass_Texture", attribute=1, },
	NormalFont = { objecttype="WBClass_FontString", attribute=1, }, -- new in 1.11
	NormalText = { objecttype="WBClass_FontString", attribute=1, }, -- deprecated in 1.11
	NormalTexture = { objecttype="WBClass_Texture", attribute=1, },
	PushedTexture = { objecttype="WBClass_Texture", attribute=1, },
	ThumbTexture = { objecttype="WBClass_Texture", attribute=1, },
	TitleRegion = { objecttype="WBClass_Region", attribute=1, },

	-- Attributish tags that we can have many of. Indexed by 1,2,3,...
	Layer = { multiple=1, },
	Anchor = { multiple=1, },
	
	-- Scripts 
	Offset = { script=1 },
	OnAnimFinished = { script=1 },
	OnChar = { script=1 }, OnClick = { script=1 }, OnColorSelect = { script=1 }, OnCursorChanged = { script=1 },
	OnDoubleClick = { script=1 }, OnDragStart = { script=1 }, OnDragStop = { script=1 },
	OnEditFocusGained = { script=1 }, OnEditFocusLost = { script=1 }, OnEnter = { script=1 }, OnEnterPressed = { script=1 }, OnEscapePressed = { script=1 }, OnEvent = { script=1 },
	OnHide = { script=1 }, OnHorizontalScroll = { script=1 }, OnHyperlinkClick = { script=1 }, OnHyperlinkEnter = { script=1 }, OnHyperlinkLeave = { script=1 },
	OnInputLanguageChanged = { script=1 },
	OnKeyDown = { script=1 }, OnKeyUp = { script=1 },
	OnLeave = { script=1 }, OnLoad = { script=1 },
	OnMessageScrollChanged = { script=1 }, OnMouseDown = { script=1 }, OnMouseUp = { script=1 }, OnMouseWheel = { script=1 }, OnMovieFinished = { script=1 }, OnMovieHideSubtitle = { sciprt=1 }, OnMovieShowSubtitle = { script=1}, 
	OnReceiveDrag = { script=1 },
	OnScrollRangeChanged = { script=1 }, OnShow = { script=1 }, OnSizeChanged = { script=1 }, OnSpacePressed = { script=1 },
	OnTabPressed = { script=1 }, OnTextChanged = { script=1 }, OnTextSet = { script=1 }, OnTooltipAddMoney = { script=1 }, OnTooltipCleared = { script=1 }, OnTooltipSetDefaultAnchor = { script=1 },
	OnUpdate = { script=1 }, OnUpdateModel = { script=1 },
	OnValueChanged = { script=1 }, OnVerticalScroll = { script=1 },
	Script = { script=1 },
	
	-- Other stuff...
	Include = { special=1 },

	-- Containers: inherited objects will be appended inside these containers rather than copy the container verbatim
	Frames = { container=1, },   
	Anchors = { container=1, },
	Layers = { container=1, },
	Scripts = { container=1, },
	
}

-- Ok, old code that i cba to rewrite. Whatever of this is not in
-- WOWB_XMLTagInfo will be added as "attribute=1"
for k,_ in {
	AbsDimension=1, AbsInset=1, AbsValue=1, Anchor=1, Anchors=1,
	Backdrop=1, BackgroundInsets=1, BarColor=1, BarTexture=1, Button=1,
	CheckButton=1, CheckedTexture=1, Color=1, ColorSelect=1, ColorValueTexture=1, ColorValueThumbTexture=1, ColorWheelTexture=1, ColorWheelThumbTexture=1, 
	DisabledCheckedTexture=1, DisabledText=1, DisabledTexture=1, DressUpModel=1,
	EdgeSize=1, EditBox=1,
	Font=1, FontHeight=1, FontString=1, Frame=1, Frames=1,
	GameTooltip=1,
	HighlightText=1, HighlightTexture=1, HitRectInsets=1,
	Include=1, 
	Layer=1, Layers=1, LootButton=1,
	MessageFrame=1, Minimap=1, Model=1, 
	minResize=1, maxResize=1,
	NormalText=1, NormalTexture=1,
	Offset=1,
	OnAnimFinished=1,
	OnChar=1, OnClick=1, OnColorSelect=1, OnCursorChanged=1,
	OnDragStart=1, OnDragStop=1,
	OnEditFocusGained=1, OnEditFocusLost=1, OnEnter=1, OnEnterPressed=1, OnEscapePressed=1, OnEvent=1,
	OnHide=1, OnHyperlinkClick=1,
	OnInputLanguageChanged=1,
	OnKeyDown=1, OnKeyUp=1,
	OnLeave=1,OnLoad=1,
	OnMouseDown=1, OnMouseUp=1, OnMouseWheel=1,
	OnReceiveDrag=1,
	OnScrollRangeChanged=1, OnShow=1, OnSizeChanged=1, OnSpacePressed=1,
	OnTabPressed=1, OnTextChanged=1, OnTextSet=1, OnTooltipAddMoney=1, OnTooltipCleared=1, OnTooltipSetDefaultAnchor=1,
	OnUpdate=1, OnUpdateModel=1,
	OnValueChanged=1, OnVerticalScroll=1,
	PlayerModel=1,
	PushedTextOffset=1,PushedTexture=1,
	ResizeBounds=1,
	Script=1, Scripts=1, ScrollChild=1, ScrollFrame=1, ScrollingMessageFrame=1, Shadow=1, SimpleHTML=1, Size=1, StatusBar=1, Slider=1,
	TabardModel=1, TaxiRouteFrame=1, TexCoords=1, Texture=1, ThumbTexture=1, TileSize=1, TitleRegion=1,
	Ui=1,
	WorldFrame=1,
} do
	if not WOWB_XMLTagInfo_BlizzardUI[k] then
		WOWB_XMLTagInfo_BlizzardUI[k] = { attribute=1 }
	end
end



WOWB_XMLTagInfo = WOWB_XMLTagInfo_BlizzardUI;		-- The XML parser uses "WOWB_XMLTagInfo"

