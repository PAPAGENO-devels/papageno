
--
-- widgets.lua  - Copyright (c) 2006, the WoWBench developer community. All rights reserved. See LICENSE.TXT.
--
-- All basic WoW widget types
--
--
--

function _notimplemented(funcname)
	error(funcname .. " not implemented!", 3);
end

function _ignore_notimplemented(funcname)
end






---------------------------------------------------------------------
---------------------------------------------------------------------
---------------------------------------------------------------------
--
-- The WOWB_RootFrame. All frames with parent=nil end up being 
-- children of this "frame".
--


WOWB_RootFrame = { [0]={ shown=false, children={} } } -- all frames with parent=nil end up being children of this node
function WOWB_RootFrame:IsVisible() return self[0].shown; end
function WOWB_RootFrame:GetEffectiveScale() return 1.0; end

WOWB_Debug_AddClassInfo(WOWB_RootFrame, "WOWB_RootFrame (==nil)")







---------------------------------------------------------------------
---------------------------------------------------------------------
---------------------------------------------------------------------
--
-- UIObject
--

WBClass_UIObject = {}
WOWB_InheritType(WBClass_UIObject, WBClass_Base);

function WBClass_UIObject:__constructor() end
function WBClass_UIObject:GetObjectType() return "UIObject"; end

function WBClass_UIObject:GetAlpha() -- Get the alpha level of this frame - Moved in 1.11. 
	return (self[0].alpha or 1);
end
function WBClass_UIObject:SetAlpha(alpha) -- Set the alpha level of this object (affects children also). 
	self[0].alpha = assert(tonumber(alpha));
end

WOWB_Debug_AddClassInfo(WBClass_UIObject, WBClass_UIObject:GetObjectType());






---------------------------------------------------------------------
---------------------------------------------------------------------
---------------------------------------------------------------------
--
-- FontInstance
--


WBClass_FontInstance = {}
WOWB_InheritType(WBClass_FontInstance, WBClass_UIObject);
function WBClass_FontInstance:GetFrameType() return "FontInstance"; end
function WBClass_FontInstance:GetObjectType() return "FontInstance"; end

function WBClass_FontInstance:__constructor()
	self[0].fontName = tostring(font);
	self[0].fontHeight = (self[0].FontHeight and self[0].FontHeight[0].AbsValue and tonumber(self[0].FontHeight[0].AbsValue.val)) or 0;
	self[0].fontFlags="";
end

function WBClass_FontInstance:GetFont() -- Return the font file, height, and flags for this FontInstance. 
	local obj = self[0].fontObject or self;
	return obj[0].fontName, obj[0].fontHeight, obj[0].fontFlags
end
function WBClass_FontInstance:GetFontObject() 	-- Return the 'parent' FontInstance object, or nil if none. 
	return self[0].fontObject or self;
end 
function WBClass_FontInstance:GetJustifyH()  -- Return FontInstance's horizontal justification. 
	return "CENTER";
end
function WBClass_FontInstance:GetJustifyV() -- Return FontInstance's vertical justification. 
	return "MIDDLE";
end
function WBClass_FontInstance:GetShadowColor() -- Returns the color of this FontInstance's shadow (r,g,b,a). 
	return 0,0,0,0;
end
function WBClass_FontInstance:GetShadowOffset() -- Returns the FontInstance's shadow offset (x,y). 
	return 0,0;
end
function WBClass_FontInstance:GetSpacing() -- Returns the FontInstance's spacing(). 
	return 0;
end
function WBClass_FontInstance:GetTextColor() -- Returns the FontInstance's color (r,g,b,a) 
	return 1,1,1,1;
end
function WBClass_FontInstance:SetFont(strPath,height,   flags) -- Sets the font to use, returns 1 if the path was valid, nil otherwise (no change occurs). 
	self[0].fontObject = nil;
	self[0].fontName = tostring(strPath);
	self[0].fontHeight = tonumber(height);
	self[0].fontFlags = tostring(flags);
	return 1;
end
function WBClass_FontInstance:SetFontObject(fontObject) -- Sets the 'parent' FontInstance object. 
	self[0].fontObject = fontObject;
end
function WBClass_FontInstance:SetJustifyH(str) _ignore_notimplemented("FontInstance.SetJustifyH"); end -- Sets horizontal justification ("LEFT","RIGHT", or "CENTER") 
function WBClass_FontInstance:SetJustifyV(str) _ignore_notimplemented("FontInstance.SetJustifyV"); end -- Sets vertical justification ("TOP","BOTTOM", or "MIDDLE") 
function WBClass_FontInstance:SetShadowColor(r,g,b,a) end -- Sets the shadow color. 
function WBClass_FontInstance:SetShadowOffset(x,y) end -- Sets the shadow offset. 
function WBClass_FontInstance:SetSpacing(spacing) end -- Sets the font spacing. 
function WBClass_FontInstance:SetTextColor(r,g,b,a) end -- Sets the font's color.

WOWB_Debug_AddClassInfo(WBClass_FontInstance, WBClass_FontInstance:GetObjectType());





---------------------------------------------------------------------
---------------------------------------------------------------------
---------------------------------------------------------------------
--
-- Region
--


WBClass_Region = {}
WOWB_InheritType(WBClass_Region, WBClass_UIObject)
function WBClass_Region:GetFrameType() return "Region"; end
function WBClass_Region:GetObjectType() return "Region"; end


local function WOWB_Region_ComputeFrameLevel(o)
	o[0].frameLevel = 0;
	local op = o[0].parentobj;
	assert(op);
	while(op and op~=WOWB_RootFrame) do
		o[0].frameLevel = o[0].frameLevel + 1;
		op = op[0].parentobj;
	end
end

local function WOWB_Region_SetParent(self, frame_or_name)
	local f = frame_or_name;
	if(type(frame_or_name)=="string") then
		f = WOWB_AllObjectsByName[string.lower(frame_or_name)];
		if(not f) then
			error("SetParent(\"" .. frame_or_name .. "\"): No such object", 2);
		end
	end
	if(self[0].parentobj) then
		self[0].parentobj[0].children[self] = nil;
	end
	if(not f) then
		f = WOWB_RootFrame;	 -- parent=nil -> end up getting inserted in WOWB_RootFrame's list of children
	else
		assert(f.SetParent); -- we want the destination object to be something that knows what parents are! =)		
	end
	self[0].parentobj=f;
	f[0].children[self] = true;
	WOWB_Region_ComputeFrameLevel(self); -- TODO: should this be done here or in the constructor?  (does it matter much when we can't draw on screen anyway? =))
end	

local function WOWB_Region_Show_Fly(self)
	assert(self:IsShown());
	if(not self[0].shown and self[0].parentobj[0].shown) then
		DP("FRAMES",3+(string.find(self[0].xmlfile or "","FrameXML") and 1 or 0), "Show: "..WOWB_DescribeObject(self));
		self[0].shown = true;
		if(self[0].Scripts and self[0].Scripts[0].OnShow) then
			WOWB_DoScript{this=self, scriptnode=self[0].Scripts[0].OnShow};
		end
		for k,v in self[0].children do
			if(k:IsShown()) then  -- required test; showing a parent doesn't mean all of its children show (they can still have hidden="true")
				WOWB_Region_Show_Fly(k);
			end
		end
	end
end

function WOWB_Region_Show(self)
	if(not self[0].shown and self[0].parentobj[0].shown) then
		DP("FRAMES",1+(string.find(self[0].xmlfile or "","FrameXML") and 1 or 0), WOWB_DescribeObject(self));
		if(WOWB_PHASE=="LIVE") then
			print("Show: "..WOWB_DescribeObject(self));
		end
	end
	self[0].hidden="false";
	WOWB_Region_Show_Fly(self);
end


local function WOWB_Region_Hide_Fly(self)
	if(self[0].shown) then
		DP("FRAMES",3+(string.find(self[0].xmlfile or "","FrameXML") and 1 or 0), "Hide: "..WOWB_DescribeObject(self));
		self[0].shown=false;
		if(self[0].Scripts and self[0].Scripts[0].OnHide) then
			WOWB_DoScript{this=self, scriptnode=self[0].Scripts[0].OnHide};
		end
		for k,v in self[0].children do
			if(k[0].shown) then -- just an optimization to avoid unnecessary recursion
				WOWB_Region_Hide_Fly(k);
			end
		end
	end
end

function WOWB_Region_Hide(self)
	if(self[0].shown) then
		DP("FRAMES",1+(string.find(self[0].xmlfile or "","FrameXML") and 1 or 0), WOWB_DescribeObject(self));
		if(WOWB_PHASE=="LIVE") then
			print("Hide: "..WOWB_DescribeObject(self));
		end
	end
	self[0].hidden="true";
	WOWB_Region_Hide_Fly(self);
end



function WBClass_Region:__constructor()
	local n;
	
	if(self[0].Size) then
		self[0].width  = tonumber(self[0].Size[0].x or self[0].Size[0].AbsDimension[0].x) or 0;
		self[0].height = tonumber(self[0].Size[0].y or self[0].Size[0].AbsDimension[0].y) or 0;
	else
		self[0].width =0;
		self[0].height=0;
	end

	if(_SYNTAXONLY) then
		return;
	end

	if((self[0].virtual or "false")=="false" and not WOWB_XMLTagInfo[self[0].xmltag].attribute) then
		if(self[0].parent) then
			assert(type(self[0].parent)=="string");
			WOWB_Region_SetParent(self, self[0].parent);
		elseif(self[0].parentobj) then
			WOWB_Region_ComputeFrameLevel(self); -- [0].parentobj will already by set by xml parser
		end
	end
	
	-- TODO
end


function WBClass_Region:ClearAllPoints() end -- Clear all attachment points for this object. 
function WBClass_Region:GetBottom() -- Get the y location of the bottom edge of this frame - Moved in 1.10. 
	return self:GetTop() - self:GetHeight();
end
function WBClass_Region:GetCenter() _notimplemented("Region.GetCenter"); end -- Get the coordinates of the center of this frame - Moved in 1.10. 
function WBClass_Region:GetHeight() -- Get the height of this object. 
	return assert(tonumber(self[0].height));
end
function WBClass_Region:GetLeft() -- Get the x location of the left edge of this frame - Moved in 1.10. 
	return 0;
end
function WBClass_Region:GetNumPoints() _notimplemented("Region.GetNumPoints"); end -- Get the number of anchor points for this frame - New in 1.10. 
function WBClass_Region:GetParent() -- Get the parent of this frame (The object, not just the name) -- Moved in 1.10. 
	if(self[0].parentobj == WOWB_RootFrame) then
		return nil;
	end
	return self[0].parentobj;
end
function WBClass_Region:GetPoint(point) _notimplemented("Region.GetPoint"); end -- Get details for an anchor points for this frame (point,relativeTo,relativePoint,xofs,yofs) -- New in 1.10. 
function WBClass_Region:GetRight() -- Get the x location of the right edge of this frame - Moved in 1.10. 
	return self:GetLeft() + self:GetWidth();
end
function WBClass_Region:GetTop() -- Get the y location of the top edge of this frame - Moved in 1.10. 
	return 600;
end
function WBClass_Region:GetWidth() -- Get the width of this object. 
	return assert(tonumber(self[0].width));
end
function WBClass_Region:Hide() -- Set this object to hidden (it and all of its children will disappear).
	WOWB_Region_Hide(self);
end
function WBClass_Region:IsShown() -- Determine if this object is shown (would be visible if its parent was visible). 
	return ( (self[0].hidden or "false") == "false" )
end
function WBClass_Region:IsVisible() -- Get whether the object is visible on screen (logically (IsShown() and GetParent():IsVisible())); 
	return self[0].shown;
end
function WBClass_Region:SetAllPoints(frame_or_name) end -- Set all anchors to match edges of specified frame - Moved in 1.10. 
function WBClass_Region:SetHeight(height) -- Set the height of the object. 
	self[0].height = assert(tonumber(height));
end
function WBClass_Region:SetParent(frame_or_name) -- Set the parent for this frame - Moevd in 1.10. 
	WOWB_Region_SetParent(self, frame_or_name);
	if(self[0].shown and not self[0].parentobj[0].shown) then
		WOWB_Region_Hide(self);
	end
	if(not self[0].shown and self[0].parentobj[0].shown) then
		WOWB_Region_Show(self);
	end
end
function WBClass_Region:SetPoint(strPoint,relativeFrame,strRelativePoint,   xOfs,yOfs) end -- Set an attachment point of this object - Updated in 1.10. 
function WBClass_Region:SetWidth(width) -- Set the width of the object. 
	self[0].width = assert(tonumber(width));
end
function WBClass_Region:Show() -- Set this object to shown (it will appear if its parent is visible).
	WOWB_Region_Show(self);
end

WOWB_Debug_AddClassInfo(WBClass_Region, WBClass_Region:GetObjectType());








---------------------------------------------------------------------
---------------------------------------------------------------------
---------------------------------------------------------------------
--
-- Font
--

WBClass_Font = {}
WOWB_InheritType(WBClass_Font, WBClass_FontInstance)
WBClass_Font.GetFrameType = nil
function WBClass_Font:GetObjectType() return "Font"; end
function WBClass_Font:__constructor()
	-- TODO
end

function WBClass_Font:CopyFontObject(otherFont) _notimplemented("Font.CopyFontObject"); end -- Set this Font's attributes to be a copy of the otherFont font object's. 

WOWB_Debug_AddClassInfo(WBClass_Font, WBClass_Font:GetObjectType());


---------------------------------------------------------------------
---------------------------------------------------------------------
---------------------------------------------------------------------
--
-- FontStringBase (not an actual type, but used in inheritance for 
-- other classes just because i cba to retype these all the time)
-- (TODO: the list got a lot smaller in 1.11. maybe yank this cheat.)
--

local WBClass_FontStringBase = {}
WOWB_InheritType(WBClass_FontStringBase, WBClass_Font)
WBClass_FontStringBase.GetFrameType = nil
function WBClass_FontStringBase:GetObjectType() return "FontStringBase"; end
function WBClass_FontStringBase:__constructor()
	-- TODO
end

function WBClass_FontStringBase:GetText() -- Get the displayed text. 
	return self[0].text or "";
end
function WBClass_FontStringBase:SetText(strText) -- Set the displayed text. 
	self[0].text = tostring(strText);
end

WOWB_Debug_AddClassInfo(WBClass_FontStringBase, WBClass_FontStringBase:GetObjectType());











---------------------------------------------------------------------
---------------------------------------------------------------------
---------------------------------------------------------------------
--
-- Frame
--

WBClass_Frame = {}
WOWB_InheritType(WBClass_Frame, WBClass_Region)
function WBClass_Frame:GetFrameType() return "Frame"; end
function WBClass_Frame:GetObjectType() return "Frame"; end

function WBClass_Frame:__constructor()
	-- TODO
end

function WBClass_Frame:CreateFontString(strName,strLayer,strInherits) -- Create and return a new FontString as a child of this Frame. 
	return CreateFrame("FontString",strName,self,strInherits);  -- TODO: move to internal function, e.g. WOWB_CreateRegion. CreateFrame shouldn't be able to create these.
end
function WBClass_Frame:CreateTexture(strName,strLayer,strInherits) -- Create and return a new Texture as a child of this Frame. 
	return CreateFrame("Texture",strName,self,strInherits);   -- TODO: move to internal function, e.g. WOWB_CreateRegion. CreateFrame shouldn't be able to create these.
end
function WBClass_Frame:CreateTitleRegion() _notimplemented("Frame:CreateTitleRegion"); end -- Create a title region for the frame if it does not have one. - New in 1.11
function WBClass_Frame:DisableDrawLayer(strLayer) _ignore_notimplemented("Frame.DisableDrawLayer"); end -- Disable rendering of regions in the specified draw layer. 
function WBClass_Frame:EnableDrawLayer(strLayer) _ignore_notimplemented("Frame.EnableDrawLayer"); end -- Enable rendering of regions in the specified draw layer. 
function WBClass_Frame:EnableKeyboard(enableFlag) _ignore_notimplemented("Frame.EnableKeyboard"); end -- Set whether this frame will get keyboard input. 
function WBClass_Frame:EnableMouse(enableFlag) _ignore_notimplemented("Frame.EnableMouse"); end -- Set whether this frame will get mouse input. 
function WBClass_Frame:EnableMouseWheel(enableFlag) _ignore_notimplemented("Frame.EnableMouseWheel"); end -- Set whether this frame will get mouse wheel events. 
function WBClass_Frame:GetBackdrop() _notimplemented("Frame:GetBackdrop"); end -- Creates and returns a backdrop table suitable for use in SetBackdrop - New in 1.11. 
function WBClass_Frame:GetBackdropBorderColor() _notimplemented("Frame:GetBackdropBorderColor"); end -- Gets the frame's backdrop border color (r,g,b,a)- New in 1.11. 
function WBClass_Frame:GetBackdropColor() _notimplemented("Frame:GetBackdropColor"); end -- Gets the frame's backdrop color (r,g,b,a)- New in 1.11.
function WBClass_Frame:GetChildren() _notimplemented("Frame.GetChildren"); end -- Get the children of this frame. 
function WBClass_Frame:GetEffectiveScale() -- Get the scale factor of this object relative to the root window. 
	return self:GetScale() * self[0].parentobj:GetEffectiveScale();
end
function WBClass_Frame:GetFrameLevel() -- Get the level of this frame. 
	return self[0].frameLevel or 0;
end
function WBClass_Frame:GetFrameStrata() -- Get the strata of this frame. 
	return self[0].frameStrata or "MEDIUM";
end
function WBClass_Frame:GetHitRectInsets() _notimplemented("Frame:GetHitRectInset"); end -- Gets the frame's hit rectangle inset distances (l,r,t,b) - new in 1.11.
function WBClass_Frame:GetID() return self[0].id; end -- Get the ID of this frame. 
function WBClass_Frame:GetMaxResize() _notimplemented("Frame:GetMaxResize"); end -- Gets the frame's maximum allowed resize bounds (w,h) - new in 1.11. 
function WBClass_Frame:GetMinResize() _notimplemented("Frame:GetMinResize"); end -- Gets the frame's minimum allowed resize bounds (w,h) - new in 1.11.
function WBClass_Frame:GetNumChildren() _notimplemented("Frame.GetNumChildren"); end -- Get the number of children this frame has. 
function WBClass_Frame:GetNumRegions() _notimplemented("Frame.GetNumRegions"); end -- Return the number of Regions that are children of this frame. 
function WBClass_Frame:GetRegions() _notimplemented("Frame.GetRegions"); end -- Return the regions of the frame (multiple return values). 
function WBClass_Frame:GetScale() -- Get the scale factor of this object relative to its parent. 
	return self[0].scale or 1.0;
end
function WBClass_Frame:GetScript(strHandler) -- Get the function for one of this frame's handlers. 
	if(self[0].Scripts and self[0].Scripts[0][strHandler]) then
		return self[0].Scripts[0][strHandler][0].chunk;
	end
end
function WBClass_Frame:GetTitleRegion() _notimplemented("Frame:GetTitleRegion"); end -- Return the frame's title region - New in 1.11.
function WBClass_Frame:HasScript(strHandler) -- Return true if the frame can be given a handler of the specified type, NOT whether it actually HAS one, use GetScript for that -- Since 1.8. 
	return true; --lie
end
function WBClass_Frame:IsClampedToScreen() _notimplemented("Frame:IsClampedToScreen"); end -- Gets whether the frame is prohibited from being dragged off screen - New in 1.11.
function WBClass_Frame:IsFrameType(strType) _notimplemented("Frame.IsFrameType"); end -- Determine if this frame is of the specified type, or a subclass of that type. 
function WBClass_Frame:IsKeyboardEnabled() _notimplemented("Frame.IsKeyboardEnabled"); end -- Get whether this frame will get keyboard input. - New in 1.11. 
function WBClass_Frame:IsMouseEnabled() _notimplemented("Frame.IsMouseEnabled"); end -- Get whether this frame will get mouse input. - New in 1.11. 
function WBClass_Frame:IsMouseWheelEnabled() _notimplemented("Frame.IsMouseWheelEnabled"); end -- Get whether this frame will get mouse wheel notifications. New in 1.11.
function WBClass_Frame:IsMovable() _notimplemented("Frame.IsMovable"); end -- Determine if the frame can be moved. 
function WBClass_Frame:IsResizable() _notimplemented("Frame.IsResizable"); end -- Determine if the frame can be resized. 
function WBClass_Frame:IsToplevel() _notimplemented("Frame.IsToplevel"); end -- Determine if the frame is Toplevel. 
function WBClass_Frame:IsUserPlaced() return nil; end -- Determine if this frame has been relocated by the user. 
function WBClass_Frame:Lower() -- Lower this frame behind other frames. 
	self[0].frameLevel = self[0].frameLevel - 1;
end
function WBClass_Frame:Raise() -- Raise this frame above other frames. 
  self[0].frameLevel = self[0].frameLevel + 1;
end
function WBClass_Frame:RegisterAllEvents() _notimplemented("Frame:RegisterAllEvents"); end -- Register this frame to receive all events (For debugging purposes only!) - New in 1.11.
function WBClass_Frame:RegisterEvent(strEvent) -- Indicate that this frame should be notified when event occurs. 
	DP("EVENT", 1, this:GetObjectType() .. " " .. (this:GetName() or "(unnamed)") .. " registering event '"..strEvent.."'");
	if(not WOWB_RegisteredEventsByEvent[strEvent]) then
		WOWB_RegisteredEventsByEvent[strEvent] = {};
	end
	if(not WOWB_RegisteredEventsByFrame[self]) then
		WOWB_RegisteredEventsByFrame[self] = {};
	end
	WOWB_RegisteredEventsByEvent[strEvent][self]=1;
	WOWB_RegisteredEventsByFrame[self][strEvent]=1;
end
function WBClass_Frame:RegisterForDrag(strButtonType1,   ...) _ignore_notimplemented("Frame:RegisterForDrag"); end -- Inidicate that this frame should be notified of drag events for the specified buttons. 
function WBClass_Frame:SetBackdrop(backdropTable) _ignore_notimplemented("Frame:SetBackdrop"); end -- Set the backdrop of the frame according to the specification provided. 
function WBClass_Frame:SetBackdropBorderColor(r,g,b,   a) _ignore_notimplemented("Frame:SetBackdropBorderColor"); end -- Set the frame's backdrop's border's color. 
function WBClass_Frame:SetBackdropColor(r,g,b,   a) _ignore_notimplemented("Frame:SetBackdropColor"); end -- Set the frame's backdrop color. 
function WBClass_Frame:SetClampedToScreen(clamped) _ignore_notimplemented("Frame:SetClampedToScreen"); end -- Set whether the frame is prohibited from being dragged off screen - New in 1.11.
function WBClass_Frame:SetFrameLevel(level) -- Set the level of this frame (determines which of overlapping frames shows on top). 
	self[0].frameLevel = (tonumber(level) or 0);
end
function WBClass_Frame:SetFrameStrata(strStrata) -- Set the strata of this frame. 
	self[0].frameStrata = strStrata;
end
function WBClass_Frame:SetHitRectInsets(left,right,top,bottom) _notimplemented("Frame:SetHitRectInsets"); end -- Set the inset distances for the frame's hit rectangle - New in 1.11.
function WBClass_Frame:SetID(id) self[0].id=id; end -- Set the ID of this frame. 
function WBClass_Frame:SetMaxResize(maxWidth,maxHeight) _notimplemented("Frame.SetMaxResize"); end -- Set the maximum dimensions this frame can be resized to. 
function WBClass_Frame:SetMinResize(minWidth,minHeight) _notimplemented("Frame.SetMinResize"); end -- Set the minimum dimensions this frame can be resized to. 
function WBClass_Frame:SetMovable(isMovable) _ignore_notimplemented("Frame.SetMovable"); end -- Set whether the frame can be moved. 
function WBClass_Frame:SetResizable(isResizable) _notimplemented("Frame.SetResizable"); end -- Set whether the frame can be resized. 
function WBClass_Frame:SetScale(scale) -- Set the scale factor of this frame relative to its parent. 
	self[0].scale = tonumber(scale) or 1.0;
end
function WBClass_Frame:SetScript(strHandler,funcptr) -- Set the function to use for a handler on this frame.
	assert(not funcptr or type(funcptr)=="function", "param #2: Expected function or nil");
	if(not self[0].Scripts) then self[0].Scripts = { [0]={ xmltag="Scripts", xmlfile="", xmlfilelinenum=-1 } } end
	if(not self[0].Scripts[0][strHandler]) then self[0].Scripts[0][strHandler] = { [0]={ xmltag=strHandler, xmlfile="", xmlfilelinenum=-1 } } end
	self[0].Scripts[0][strHandler][0].chunk = funcptr;
end
function WBClass_Frame:SetToplevel(isToplevel) _ignore_notimplemented("Frame.SetToplevel"); end -- Set whether the frame is Toplevel. 
function WBClass_Frame:SetUserPlaced(isUserPlaced) _notimplemented("Frame.SetUserPlaced"); end -- Set whether the frame has been relocated by the user (and will thus be saved in the layout cache). 
function WBClass_Frame:StartMoving() _notimplemented("Frame.StartMoving"); end -- Start moving this frame. 
function WBClass_Frame:StartSizing(strPoint) _notimplemented("Frame.StartSizing"); end -- Start sizing this frame using the specified anchor point. 
function WBClass_Frame:StopMovingOrSizing() _notimplemented("Frame.StopMovingOrSizing"); end -- Stop moving and/or sizing this frame. 
function WBClass_Frame:UnregisterAllEvents() -- Indicate that this frame should no longer be notified when any events occur. 
	DP("EVENT", 1, this:GetObjectType() .. " " .. (this:GetName() or "(unnamed)") .. " unregistering ALL events");
	if(WOWB_RegisteredEventsByFrame[self]) then
		for strEvent,_ in WOWB_RegisteredEventsByFrame[self] do
			WOWB_RegisteredEventsByEvent[strEvent][self] = nil;
		end
		WOWB_RegisteredEventsByFrame[self] = nil
	end
end
function WBClass_Frame:UnregisterEvent(strEvent) -- Indicate that this frame should no longer be notified when event occurs.
	DP("EVENT", 1, this:GetObjectType() .. " " .. (this:GetName() or "(unnamed)") .. " UNregistering event '"..strEvent.."'");
	if(WOWB_RegisteredEventsByEvent[strEvent]) then
		WOWB_RegisteredEventsByEvent[strEvent][self] = nil;
	end
	if(WOWB_RegisteredEventsByFrame[self]) then
		WOWB_RegisteredEventsByFrame[self][strEvent] = nil;
	end
end
	
WOWB_Debug_AddClassInfo(WBClass_Frame, WBClass_Frame:GetObjectType());




---------------------------------------------------------------------
---------------------------------------------------------------------
---------------------------------------------------------------------
--
-- LayeredRegion
--


WBClass_LayeredRegion = {}
WOWB_InheritType(WBClass_LayeredRegion, WBClass_Region)
function WBClass_LayeredRegion:GetFrameType() return "LayeredRegion"; end
function WBClass_LayeredRegion:GetObjectType() return "LayeredRegion"; end

function WBClass_LayeredRegion:__constructor()
	-- TODO
end

function WBClass_LayeredRegion:GetDrawLayer() _notimplemented("LayeredRegion.GetDrawLayer"); end -- Returns the draw layer for the LayeredRegion
function WBClass_LayeredRegion:SetDrawLayer(strLayer) _ignore_notimplemented("LayeredRegion.SetDrawLayer"); end -- Sets the draw layer for the LayeredRegion
function WBClass_LayeredRegion:SetVertexColor(r,g,b,a) _ignore_notimplemented("LayeredRegion.SetVertexColor"); end

WOWB_Debug_AddClassInfo(WBClass_LayeredRegion, WBClass_LayeredRegion:GetObjectType());





---------------------------------------------------------------------
---------------------------------------------------------------------
---------------------------------------------------------------------
--
-- Button
--

WBClass_Button = {}
WOWB_InheritType(WBClass_Button, WBClass_Frame, WBClass_FontStringBase)
function WBClass_Button:GetFrameType() return "Button"; end
function WBClass_Button:GetObjectType() return "Button"; end

function WBClass_Button:__constructor()
	self[0].buttonEnabled = true;
	self[0].clickTypes = {LeftButtonUp=true};
end

function WBClass_Button:Click() _notimplemented("Button.Click"); end -- Execute the click action of the button. 
function WBClass_Button:Disable() -- Disable the Button so that it cannot be clicked. 
	self[0].buttonEnabled = false;
end
function WBClass_Button:Enable() -- Enable to the Button so that it may be clicked. 
	self[0].buttonEnabled = true;
	self[0].buttonState = "NORMAL";
end
function WBClass_Button:GetButtonState() -- Return the current state ("PUSHED","NORMAL") of the Button. 
	return self[0].buttonState;
end
function WBClass_Button:GetDisabledFontObject() _notimplemented("Button.GetDisabledFontObject"); end -- Return the font object for the Button when disabled - New in 1.10. 
function WBClass_Button:GetDisabledTextColor() _notimplemented("Button.GetDisabledTextColor"); end -- Get the color of this button's text when disabled (r,g,b,a) - New in 1.11. 
function WBClass_Button:GetDisabledTexture() _notimplemented("Button.GetDisabledTexture"); end -- Get the texture for this button when disabled - New in 1.11.
function WBClass_Button:GetFont() _notimplemented("Button.GetFont"); end -- Returns the font, size, and flags currently used for display on the Button. 
function WBClass_Button:GetFontString() _notimplemented("Button.GetFontString"); end -- Get this button's label FontString - New in 1.11.
function WBClass_Button:GetHighlightFontObject() _notimplemented("Button.GetHighlightFontObject"); end -- Return the font object for the Button when highlighted - New in 1.10. 
function WBClass_Button:GetHighlightTextColor() _notimplemented("Button.GetHighlightTextColor"); end -- Get the color of this button's text when highlighted (r,g,b,a) - New in 1.11. 
function WBClass_Button:GetHighlightTexture() _notimplemented("Button.GetHighlightTexture"); end -- Get the texture for this button when highlighted - New in 1.11. 
function WBClass_Button:GetNormalTexture() _notimplemented("Button.GetNormalTexture"); end -- Get the normal texture for this button - New in 1.11. 
function WBClass_Button:GetPushedTextOffset() _notimplemented("Button.GetPushedTextOffset"); end -- Get the text offset when this button is pushed (x,y) - New in 1.11. 
function WBClass_Button:GetPushedTexture() _notimplemented("Button.GetPushedTexture"); end -- Get the texture for this button when pushed - New in 1.11.
function WBClass_Button:GetTextColor() _notimplemented("Button.GetTextColor"); end -- Get the normal color of this button's text (r,g,b,a) - New in 1.11.
function WBClass_Button:GetTextFontObject() -- Return the font object for the Button's normal text - New in 1.10. 
	return self[0].textFontObject;	-- won't be set unless set by SetTextFontObject. Which isn't how it should work. Should happen on SetFont() and via inheritance too.
end
function WBClass_Button:GetTextHeight() _notimplemented("Button.GetTextHeight"); end -- Get the height of the Button's text. 
function WBClass_Button:GetTextWidth() -- Get the width of the Button's text. 
	return strlen(self:GetText()) * 12 * 0.6;
end
function WBClass_Button:IsEnabled() -- Determine whether the Button is enabled. 
	return self[0].buttonEnabled;
end
function WBClass_Button:LockHighlight() _ignore_notimplemented("Button.LockHighlight"); end -- Set the Button to always be drawn highlighted. 
function WBClass_Button:RegisterForClicks(...) -- Indicate which types of clicks this Button should receive. 
	self[0].clickTypes = {}
	for k,v in arg do
		self[0].clickTypes[v]=true;
	end
end
function WBClass_Button:SetButtonState(strState,   bLock) -- Set the state of the Button ("PUSHED", "NORMAL") and whether it is locked. 
	if(strState~="NORMAL" and strState~="PUSHED") then
		error("SetButtonState(\""..strState.."\"): Invalid button state");
	end
	self[0].buttonState = strState;
end
function WBClass_Button:SetDisabledFontObject(fontObject) _ignore_notimplemented("Button.SetDisabledFontObject"); end -- Set the font object for settings when disabled - New in 1.10. 
function WBClass_Button:SetDisabledTextColor(r,g,b,   a) _ignore_notimplemented("Button.SetDisabledTextColor"); end -- Set the disabled text color for the Button. 
function WBClass_Button:SetDisabledTexture(texture_or_path) _ignore_notimplemented("Button.SetDisabledTexture"); end -- Set the disabled texture for the Button - Updated in 1.10. 
function WBClass_Button:SetFont(strFont,nSize,   strFlags) _ignore_notimplemented("Button.SetFont"); end -- Set the font to use for display. 
function WBClass_Button:SetFontString(fontString) _notimplemented("Button:SetFontString"); end -- Set the button's label FontString - New in 1.11.
function WBClass_Button:SetHighlightFontObject(font) _ignore_notimplemented("Button.SetHighlightFontObject"); end -- Set the font object for settings when highlighted - New in 1.10. 
function WBClass_Button:SetHighlightTextColor(r,g,b,   a) _ignore_notimplemented("Button.SetHighlightTextColor"); end -- Set the highlight text color for the Button. 
function WBClass_Button:SetHighlightTexture(texture_or_path) _ignore_notimplemented("Button.SetHighlightTexture"); end -- Set the highlight texture for the Button - Updated in 1.10. 
function WBClass_Button:SetNormalTexture(texture_or_path) _ignore_notimplemented("Button.SetNormalTexture"); end -- Set the normal texture for the Button - Updated in 1.10. 
function WBClass_Button:SetPushedTextOffset(x,y) _ignore_notimplemented("Button.SetPushedTextOffset"); end -- Set the text offset for this button when pushed - New in 1.11.
function WBClass_Button:SetPushedTexture(texture_or_path) _ignore_notimplemented("Button.SetPushedTexture"); end -- Set the pushed texture for the Button - Updated in 1.10. 
function WBClass_Button:SetTextColor(r,g,b) _ignore_notimplemented("Button.SetTextColor"); end -- Set the text color for the Button. 
function WBClass_Button:SetTextFontObject(font) 	-- Set the font object from which to get settings for this Button's normal state - New in 1.10. 
	self[0].textFontObject = font;
end 
function WBClass_Button:UnlockHighlight() _ignore_notimplemented("Button.UnlockHighlight"); end -- Set the Button to not always be drawn highlighted.

WOWB_Debug_AddClassInfo(WBClass_Button, WBClass_Button:GetObjectType());



---------------------------------------------------------------------
---------------------------------------------------------------------
---------------------------------------------------------------------
--
-- ColorSelect
--


WBClass_ColorSelect = {}
WOWB_InheritType(WBClass_ColorSelect, WBClass_Frame)
function WBClass_ColorSelect:GetFrameType() return "ColorSelect"; end
function WBClass_ColorSelect:GetObjectType() return "ColorSelect"; end

function WBClass_ColorSelect:__constructor()
	-- TODO
end

function WBClass_ColorSelect:GetColorHSV() _notimplemented("ColorSelect.GetColorHSV"); end -- Get the HSV values of the selected color. 
function WBClass_ColorSelect:GetColorRGB() _notimplemented("ColorSelect.GetColorRGB"); end -- Get the RGB values of the selected color. 
function WBClass_ColorSelect:GetColorValueTexture() _notimplemented("ColorSelect.GetColorValueTexture"); end -- Get the texture used to show color value - new in 1.11. 
function WBClass_ColorSelect:GetColorValueThumbTexture() _notimplemented("ColorSelect.GetColorValueThumbTexture"); end -- Get the texture for the color value thumb - New in 1.11. 
function WBClass_ColorSelect:GetColorWheelTexture() _notimplemented("ColorSelect.GetColorWheelTexture"); end -- Get the texture for the color wheel - New in 1.11. 
function WBClass_ColorSelect:GetColorWheelThumbTexture() _notimplemented("ColorSelect.GetColorWheelThumbTexture"); end -- Get the texture for the color wheel thumb - New in 1.11.
function WBClass_ColorSelect:SetColorHSV(h,s,v) _notimplemented("ColorSelect.SetColorHSV"); end -- Set to a specific HSV color. 
function WBClass_ColorSelect:SetColorRGB(r,g,b) _notimplemented("ColorSelect.SetColorRGB"); end -- Set to a specific RGB color.
function WBClass_ColorSelect:SetColorValueTexture(texture) _notimplemented("ColorSelect.SetColorValueTexture"); end -- Set the texture used to show color value - New in 1.11. 
function WBClass_ColorSelect:SetColorValueThumbTexture(texture) _notimplemented("ColorSelect.SetColorValueThumbTexture"); end -- Set the texture for the color value thumb - New in 1.11. 
function WBClass_ColorSelect:SetColorWheelTexture(texture) _notimplemented("ColorSelect.SetColorWheelTexture"); end -- Set the texture for the color wheel - New in 1.11. 
function WBClass_ColorSelect:SetColorWheelThumbTexture(texture) _notimplemented("ColorSelect.SetColorWheelThumbTexture"); end -- Set the texture for the color wheel thumb - New in 1.11.

WOWB_Debug_AddClassInfo(WBClass_ColorSelect, WBClass_ColorSelect:GetObjectType());





---------------------------------------------------------------------
---------------------------------------------------------------------
---------------------------------------------------------------------
--
-- EditBox
--

WBClass_EditBox = {}
WOWB_InheritType(WBClass_EditBox, WBClass_Frame, WBClass_FontStringBase)
function WBClass_EditBox:GetFrameType() return "EditBox"; end
function WBClass_EditBox:GetObjectType() return "EditBox"; end

function WBClass_EditBox:__constructor()
	-- TODO
end

function WBClass_EditBox:AddHistoryLine(strText) _ignore_notimplemented("EditBox.AddHistoryLine"); end -- Add text to the edit history. 
function WBClass_EditBox:ClearFocus() _notimplemented("EditBox.ClearFocus"); end
function WBClass_EditBox:GetAltArrowKeyMode() _notimplemented("EditBox.GetAltArrowKeyMode"); end
function WBClass_EditBox:GetBlinkSpeed() _notimplemented("EditBox.GetBlinkSpeed"); end -- Gets the blink speed of the EditBox in seconds - New in 1.11.
function WBClass_EditBox:GetHistoryLines() _notimplemented("EditBox.GetHistoryLines"); end -- Get the number of history lines for this edit box 
function WBClass_EditBox:GetInputLanguage() _notimplemented("EditBox.GetInputLanguage"); end -- Get the input language (locale based not in-game) 
function WBClass_EditBox:GetMaxBytes() _notimplemented("EditBox.GetMaxBytes"); end -- Gets the maximum number bytes allowed in the EditBox - New in 1.11. 
function WBClass_EditBox:GetMaxLetters() _notimplemented("EditBox.GetMaxLetters"); end -- Gets the maximum number of letters allowed in the EditBox - New in 1.11.
function WBClass_EditBox:GetNumLetters() _notimplemented("EditBox.GetNumLetters"); end -- Gets the number of letters in the box. 
function WBClass_EditBox:GetNumber() return tonumber(self:GetText()) or 0; end
function WBClass_EditBox:GetTextInsets() _notimplemented("EditBox.GetTextInsets"); end -- Gets the text display insets for the EditBox - New in 1.11.
function WBClass_EditBox:HighlightText(startPos,endPos) _notimplemented("EditBox.HighlightText"); end -- Set the highlight to all or some of the edit box text. 
function WBClass_EditBox:Insert(strText) _notimplemented("EditBox.Insert"); end -- Insert text into the edit box. 
function WBClass_EditBox:IsAutoFocus() _notimplemented("EditBox.IsAutoFocus"); end -- Determine if the EditBox has autofocus enabled - New in 1.11. 
function WBClass_EditBox:IsMultiLine() _notimplemented("EditBox.IsMultiLine"); end -- Determine if the EditBox accepts multiple lines - New in 1.11. 
function WBClass_EditBox:IsNumeric() _notimplemented("EditBox.IsNumeric"); end -- Determine if the EditBox only accepts numeric input - New in 1.11. 
function WBClass_EditBox:IsPassword() _notimplemented("EditBox.IsPassword"); end -- Determine if the EditBox performs password masking - New in 1.11.
function WBClass_EditBox:SetAltArrowKeyMode() _notimplemented("EditBox.SetAltArrowKeyMode"); end
function WBClass_EditBox:SetAutoFocus(state) _notimplemented("EditBox.SetAutoFocus"); end -- Set the EditBox's autofocus state - New in 1.11.
--TODO: EditBox:SetBlinkSpeed 
function WBClass_EditBox:SetFocus() _notimplemented("EditBox.SetFocus"); end
function WBClass_EditBox:SetHistoryLines(nLines) _notimplemented("EditBox.SetHistoryLines"); end -- Set the number of history lines to remember. 
function WBClass_EditBox:SetMaxBytes(maxBytes) _notimplemented("EditBox.SetMaxBytes"); end -- Set the maximum byte size for entered text. 
function WBClass_EditBox:SetMaxLetters(maxLetters) _notimplemented("EditBox.SetMaxLetters"); end -- Set the maximum number of letters for entered text. 
function WBClass_EditBox:SetMultiLine(state) _notimplemented("EditBox.SetMultiLine"); end -- Set the EditBox's multi-line state - New in 1.11.
function WBClass_EditBox:SetNumber(number) self:SetText(tostring(number)); end
function WBClass_EditBox:SetNumeric(state) _notimplemented("EditBox.SetNumeric"); end -- Set if the EditBox only accepts numeric input - New in 1.11. 
function WBClass_EditBox:SetPassword(state) _notimplemented("EditBox.SetPassword"); end -- Set the EditBox's password masking state - New in 1.11.
function WBClass_EditBox:SetTextInsets(l,r,t,b) _ignore_notimplemented("EditBox.SetTextInsets"); end
function WBClass_EditBox:ToggleInputLanguage() _notimplemented("EditBox.ToggleInputLanguage"); end

WOWB_Debug_AddClassInfo(WBClass_EditBox, WBClass_EditBox:GetObjectType());




---------------------------------------------------------------------
---------------------------------------------------------------------
---------------------------------------------------------------------
--
-- GameTooltip  -- plenty of stuff implemented as global functions 
-- to match the fact that it really is internal APIs that can't be hooked for gameworld operations
--


function WOWB_GameTooltip_AddLine(self, strText,r,g,b,bWrap)
	self[0].numLines = self[0].numLines + 1;
	local o = WOWB_AllObjectsByName[strlower(self[0].name.."TextLeft"..self[0].numLines)];
	assert(o);	
	if(o) then
		o:SetText(strText);
		o:Show();
	end
end

function WOWB_GameTooltip_SetUnit(self, strUnitId, u)
	if(not u) then u = WOWB_GetUnit(strUnitId); end		-- Internal code can pass in u directly. Widget method can't.
	if(not u) then return; end
	if(u[0].shown) then
		WOWB_Region_Hide(self);
	end
	WOWB_GameTooltip_ClearLines(self);
	WOWB_GameTooltip_AddLine(self, u:GetName());
	if(u:IsObjectType("player")) then
		WOWB_GameTooltip_AddLine(self, "Level "..u[0].level.." "..u[0].class);
	else
		WOWB_GameTooltip_AddLine(self, "Level "..u[0].level.." "..u[0].class);
	end
	WOWB_Region_Show(self);
end

function WOWB_GameTooltip_ClearLines(self)
	for n=1,(self[0].numLines or 0) do
		local o = WOWB_AllObjectsByName[strlower(self[0].name.."TextLeft"..n)];
		assert(o);
		if(o) then
			o:SetText("");
			o:Hide();
		end
		local o = WOWB_AllObjectsByName[strlower(self[0].name.."TextRight"..n)];
		if(o) then
			o:SetText("");
			o:Hide();
		end
	end
	self[0].numLines = 0;
end

function WOWB_GameTooltip_FadeOut(self)
	WOWB_Region_Hide(self);
end


WBClass_GameTooltip = {}
WOWB_InheritType(WBClass_GameTooltip, WBClass_Frame)
function WBClass_GameTooltip:GetFrameType() return "GameTooltip"; end
function WBClass_GameTooltip:GetObjectType() return "GameTooltip"; end

function WBClass_GameTooltip:__constructor()
	-- TODO
end

function WBClass_GameTooltip:AddDoubleLine(textL,textR,rL,gL,bL,rR,gR,bR) _notimplemented("GameTooltip.AddDoubleLine"); end
function WBClass_GameTooltip:AddFontStrings(leftstring,rightstring) _notimplemented("GameTooltip.AddFontStrings"); end -- Dynamically expands the size of a tooltip - New in 1.11.
function WBClass_GameTooltip.AddLine(strText,   r,g,b,bWrap) WOWB_GameTooltip_AddLine(self, strText,r,g,b,bWrap); end
function WBClass_GameTooltip:AppendText(strText) _notimplemented("GameTooltip.AppendText"); end -- Append text to the end of the first line of the tooltip. 
function WBClass_GameTooltip:ClearLines() WOWB_GameTooltip_ClearLines(self); end
function WBClass_GameTooltip:FadeOut() WOWB_GameTooltip_FadeOut(self); end
function WBClass_GameTooltip:GetAnchorType() _notimplemented("GameTooltip.GetAnchorType"); end -- Returns the current anchoring type. 
function WBClass_GameTooltip:Hide() -- override
	WBClass_Frame.Hide(self);
	self[0].tooltipIsOwned = false;
end
function WBClass_GameTooltip:IsOwned(frame) -- Returns true if the tooltip is currently owned by the specified frame - Since 1.8. 
	return self[0].tooltipOwner ~= nil;
end
function WBClass_GameTooltip:NumLines() _notimplemented("GameTooltip.NumLines"); end -- Get the number of lines in the tooltip. 
function WBClass_GameTooltip:SetAction(slot) _notimplemented("GameTooltip.SetAction"); end -- Shows the tooltip for the specified action button. 
function WBClass_GameTooltip:SetAuctionCompareItem(strType,index,   offset) _notimplemented("GameTooltip.SetAuctionCompareItem"); end
function WBClass_GameTooltip:SetAuctionItem(strType,index) _notimplemented("GameTooltip.SetAuctionItem"); end -- Shows the tooltip for the specified auction item. 
function WBClass_GameTooltip:SetAuctionSellItem() _notimplemented("GameTooltip.SetAuctionSellItem"); end -- UNKNOWN ARGS
function WBClass_GameTooltip:SetBagItem(badId,itemId) _notimplemented("GameTooltip.SetBagItem"); end
function WBClass_GameTooltip:SetBuybackItem() _notimplemented("GameTooltip.SetBuybackItem"); end -- UNKNOWN ARGS
function WBClass_GameTooltip:SetCraftItem() _notimplemented("GameTooltip.SetCraftItem"); end -- UNKNOWN ARGS
function WBClass_GameTooltip:SetCraftSpell() _notimplemented("GameTooltip.SetCraftSpell"); end -- UNKNOWN ARGS
function WBClass_GameTooltip:SetHyperlink(link) _notimplemented("GameTooltip.SetHyperlink"); end -- Shows the tooltip for the specified hyperlink (usually item link). 
function WBClass_GameTooltip:SetInboxItem(index) _notimplemented("GameTooltip.SetInboxItem"); end -- Shows the tooltip for the specified mail inbox item. 
function WBClass_GameTooltip:SetInventoryItem(unit,slot,   nameOnly) _notimplemented("GameTooltip.SetInventoryItem"); end
function WBClass_GameTooltip:SetLootItem() _notimplemented("GameTooltip.SetLootItem"); end  -- TODO ARGS
function WBClass_GameTooltip:SetLootRollItem(id) _notimplemented("GameTooltip.SetLootRollItem"); end -- Shows the tooltip for the specified loot roll item. 
function WBClass_GameTooltip:SetMerchantCompareItem(strSlot,   offset) _notimplemented("GameTooltip.SetMerchantCompareItem"); end
function WBClass_GameTooltip:SetMerchantItem() _notimplemented("GameTooltip.SetMerchantItem"); end -- UNKNOWN ARGS
function WBClass_GameTooltip:SetMinimumWidth(width) _notimplemented("GameTooltip.SetMinimumWidth"); end -- (Formerly SetMoneyWidth) 
function WBClass_GameTooltip:SetOwner(owner,strAnchor,   x,y)
	self[0].tooltipOwner = owner;
end
function WBClass_GameTooltip:SetPadding() _ignore_notimplemented("GameTooltip.SetPadding"); end  -- UNKNOWN ARGS
function WBClass_GameTooltip:SetPetAction(slot) _notimplemented("GameTooltip.SetPetAction"); end -- Shows the tooltip for the specified pet action. 
function WBClass_GameTooltip:SetPlayerBuff(buffIndex) _notimplemented("GameTooltip.SetPlayerBuff"); end -- Direct the tooltip to show information about a player's buff. 
function WBClass_GameTooltip:SetQuestItem(strType,index) _notimplemented("GameTooltip.SetQuestItem"); end
function WBClass_GameTooltip:SetQuestLogItem() _notimplemented("GameTooltip.SetQuestLogItem"); end -- UNKNOWN ARGS
function WBClass_GameTooltip:SetQuestLogRewardSpell() _notimplemented("GameTooltip.SetQuestLogRewardSpell"); end -- UNKNOWN ARGS
function WBClass_GameTooltip:SetQuestRewardSpell() _notimplemented("GameTooltip.SetQuestRewardSpell"); end -- UNKNOWN ARGS
function WBClass_GameTooltip:SetSendMailItem() _notimplemented("GameTooltip.SetSendMailItem"); end -- UNKNOWN ARGS
function WBClass_GameTooltip:SetShapeshift(slot) _notimplemented("GameTooltip.SetShapeshift"); end -- Shows the tooltip for the specified shapeshift form. 
function WBClass_GameTooltip:SetSpell(spellId,spellbookTabNum) _notimplemented("GameTooltip.SetSpell"); end -- Shows the tooltip for the specified spell. 
function WBClass_GameTooltip:SetTalent(tabIndex,talentIndex) _notimplemented("GameTooltip.SetTalent"); end -- Shows the tooltip for the specified talent. 
function WBClass_GameTooltip:SetText(strText,r,g,b,   a,bWrap) _notimplemented("GameTooltip.SetText"); end -- Set the text of the tooltip. 
function WBClass_GameTooltip:SetTrackingSpell() _notimplemented("GameTooltip.SetTrackingSpell"); end -- UNKNOWN ARGS
function WBClass_GameTooltip:SetTradePlayerItem() _notimplemented("GameTooltip.SetTradePlayerItem"); end -- UNKNOWN ARGS
function WBClass_GameTooltip:SetTradeSkillItem(tradeItemIndex,   reagentIndex) _notimplemented("GameTooltip.SetTradeSkillItem"); end
function WBClass_GameTooltip:SetTradeTargetItem() _notimplemented("GameTooltip.SetTradeTargetItem"); end -- UNKNOWN ARGS
function WBClass_GameTooltip:SetTrainerService() _notimplemented("GameTooltip.SetTrainerService"); end -- UNKNOWN ARGS
function WBClass_GameTooltip:SetUnit(strUnitId) WOWB_GameTooltip_SetUnit(self, strUnitId); end
function WBClass_GameTooltip:SetUnitBuff(strUnitId,buffIndex,   raidFilter) _notimplemented("GameTooltip.SetUnitBuff"); end -- Shows the tooltip for a unit's buff. 
function WBClass_GameTooltip:SetUnitDebuff(strUnitId,buffIndex,   raidFilter) _notimplemented("GameTooltip.SetUnitDebuff"); end -- Shows the tooltip for a unit's debuff.

WOWB_Debug_AddClassInfo(WBClass_GameTooltip, WBClass_GameTooltip:GetObjectType());




---------------------------------------------------------------------
---------------------------------------------------------------------
---------------------------------------------------------------------
--
-- MessageFrame
--

WBClass_MessageFrame = {}
WOWB_InheritType(WBClass_MessageFrame, WBClass_Frame, WBClass_FontStringBase);
function WBClass_MessageFrame:GetFrameType() return "MessageFrame"; end
function WBClass_MessageFrame:GetObjectType() return "MessageFrame"; end

function WBClass_MessageFrame:__constructor()
	-- TODO
end

function WBClass_MessageFrame:AddMessage(strText,   r,g,b,a,holdTime) 	-- Add a message to the frame which will fade eventually. 
	strText = gsub(strText, "\n", "\n"..string.rep(" ", strlen(self:GetName()..": ")));
	print(self:GetName() .. ": ".. strText);
end 
function WBClass_MessageFrame:Clear() _notimplemented("MessageFrame:Clear"); end -- Clear the messages from the frame - New in 1.11. 
function WBClass_MessageFrame:GetFadeDuration() _notimplemented("MessageFrame:GetFadeDuration"); end -- Gets the fade duration in seconds - New in 1.11. 
function WBClass_MessageFrame:GetFading() _notimplemented("MessageFrame:GetFading"); end -- Get whether the frame is fading - New in 1.11. 
function WBClass_MessageFrame:GetInsertMode() _notimplemented("MessageFrame:GetInsertMode"); end -- Get the insert mode for the frame - New in 1.11. 
function WBClass_MessageFrame:GetTimeVisible() _notimplemented("MessageFrame:GetTimeVisible"); end -- Get the message visibility time in seconds - New in 1.11. 
function WBClass_MessageFrame:SetFadeDuration(seconds) _notimplemented("MessageFrame:SetFadeDuration"); end -- Set the fade duration - New in 1.11. 
function WBClass_MessageFrame:SetFading(status) _notimplemented("MessageFrame:SetFading"); end -- Set whether the frame fades messages - New in 1.11. 
function WBClass_MessageFrame:SetInsertMode(strTopOrBottom) _ignore_notimplemented("MessageFrame:SetInsertMode"); end -- Set where new messages are inserted ("TOP or "BOTTOM") - New in 1.11. 
function WBClass_MessageFrame:SetTimeVisible(seconds) _notimplemented("MessageFrame:SetTimeVisible"); end -- Sets the message visibility time - New in 1.11.
    
WOWB_Debug_AddClassInfo(WBClass_MessageFrame, WBClass_MessageFrame:GetObjectType());




---------------------------------------------------------------------
---------------------------------------------------------------------
---------------------------------------------------------------------
--
-- Minimap
--

WBClass_Minimap = {}
WOWB_InheritType(WBClass_Minimap, WBClass_Frame);
function WBClass_Minimap:GetFrameType() return "Minimap"; end
function WBClass_Minimap:GetObjectType() return "Minimap"; end

function WBClass_Minimap:__constructor()
	-- TODO
end

function WBClass_Minimap:GetPingPosition() _notimplemented("Minimap.GetPingPosition"); end -- Get the last ping location. 
function WBClass_Minimap:GetZoom() _notimplemented("Minimap.GetZoom"); end -- Get the current zoom level. 
function WBClass_Minimap:GetZoomLevels() _notimplemented("Minimap.GetZoomLevels"); end -- Get the maximum zoom level. 
function WBClass_Minimap:PingLocation(x,y) _notimplemented("Minimap.PingLocation"); end -- Perform a ping at the specified location. 
function WBClass_Minimap:SetArrowModel(strFile) _notimplemented("Minimap.SetArrowModel"); end -- Set the file to use for the arrow model - New in 1.11.
function WBClass_Minimap:SetBlipTexture() _notimplemented("Minimap.SetBlipTexture"); end -- UNKNOWN ARGS
function WBClass_Minimap:SetIconTexture() _notimplemented("Minimap.SetIconTexture"); end -- UNKNOWN ARGS
function WBClass_Minimap:SetMaskTexture() _notimplemented("Minimap.SetMaskTexture"); end -- UNKNOWN ARGS
function WBClass_Minimap:SetPlayerModel(strFile) _notimplemented("Minimap.SetPlayerModel"); end -- Set the file to use for the player model - New in 1.11.
function WBClass_Minimap:SetZoom(level) _notimplemented("Minimap.SetZoom"); end -- Set the current zoom level.

WOWB_Debug_AddClassInfo(WBClass_Minimap, WBClass_Minimap:GetObjectType());



---------------------------------------------------------------------
---------------------------------------------------------------------
---------------------------------------------------------------------
--
-- Model
--

WBClass_Model = {}
WOWB_InheritType(WBClass_Model, WBClass_Frame);
function WBClass_Model:GetFrameType() return "Model"; end
function WBClass_Model:GetObjectType() return "Model"; end

function WBClass_Model:__constructor()
	-- TODO
end

function WBClass_Model:AdvanceTime() _ignore_notimplemented("Model.AdvanceTime"); end
function WBClass_Model:ClearFog() _ignore_notimplemented("Model.ClearFog"); end -- Removes all fogging effects currently active in rendering. 
function WBClass_Model:ClearModel() _ignore_notimplemented("Model.ClearModel"); end -- Removes all geometry from the Model (i.e. makes it empty) 
function WBClass_Model:GetFacing() _ignore_notimplemented("Model.GetFacing"); end -- Returns the direction the model is facing. 
function WBClass_Model:GetFogColor() _ignore_notimplemented("Model.GetFogColor"); end -- Gets the fog color (r,g,b,a) - New in 1.11. 
function WBClass_Model:GetFogFar() _ignore_notimplemented("Model.GetFogFar"); end -- Gets the fog far distance - New in 1.11. 
function WBClass_Model:GetFogNear() _ignore_notimplemented("Model.GetFogNear"); end -- Gets the fog near distance - New in 1.11. 
function WBClass_Model:GetLight() _ignore_notimplemented("Model.GetLight"); end -- Gets the light specification for the model, returns a list of results compatible with the SetLight method - New in 1.11. 
function WBClass_Model:GetModel() _ignore_notimplemented("Model.GetModel"); end -- Gets the model file for this Model - New in 1.11.
function WBClass_Model:GetModelScale() _ignore_notimplemented("Model.GetModelScale"); end -- Returns the current mesh scaling factor. 
function WBClass_Model:GetPosition() _ignore_notimplemented("Model.GetPosition"); end -- Returns the current position of the mesh as x,y,z 
function WBClass_Model:ReplaceIconTexture(strTexture) _ignore_notimplemented("Model.ReplaceIconTexture"); end
function WBClass_Model:SetCamera(index) _ignore_notimplemented("Model.SetCamera"); end -- Select a predefined camera. 
function WBClass_Model:SetFacing(facing) _ignore_notimplemented("Model.SetFacing"); end -- Set the direction that the model is facing. 
function WBClass_Model:SetFogColor(r,g,b,   a) _ignore_notimplemented("Model.SetFogColor"); end -- Set the fog color and enable fogging. 
function WBClass_Model:SetFogFar(value) _ignore_notimplemented("Model.SetFogFar"); end -- Set the far-clipping plane distance for fogging. 
function WBClass_Model:SetFogNear(value) _ignore_notimplemented("Model.SetFogNear"); end -- Set the near-clipping plane distance for fogging. 
function WBClass_Model:SetLight(enabled,   omni,dirX,dirY,dirZ,ambIntensity,   ambR,ambG,ambB,   dirIntensity,   dirR,dirG,dirB) _ignore_notimplemented("Model.SetLight"); end -- Place the light source used for rendering 
function WBClass_Model:SetModel(strFile) _ignore_notimplemented("Model.SetModel"); end -- Set the mesh that is displayed in the frame. 
function WBClass_Model:SetModelScale(scale) _ignore_notimplemented("Model.SetModelScale"); end -- Sets the scale factor for the mesh before rendering. 
function WBClass_Model:SetPosition(x,y,z) _ignore_notimplemented("Model.SetPosition"); end -- Set the position of the mesh inside the frame's coordinate system. 
function WBClass_Model:SetSequence(sequence) _ignore_notimplemented("Model.SetSequence"); end -- Set the animation to be played. 
function WBClass_Model:SetSequenceTime(sequence,time) _ignore_notimplemented("Model.SetSequenceTime"); end

WOWB_Debug_AddClassInfo(WBClass_Model, WBClass_Model:GetObjectType());



---------------------------------------------------------------------
---------------------------------------------------------------------
---------------------------------------------------------------------
--
-- MovieFrame
-- TODO: This no longer appears in Iriel's listing. Yank it?
--

WBClass_MovieFrame = {}
WOWB_InheritType(WBClass_MovieFrame, WBClass_Frame);
function WBClass_MovieFrame:GetFrameType() return "Frame"; end
function WBClass_MovieFrame:GetObjectType() return "MovieFrame"; end

function WBClass_MovieFrame:__constructor()
	-- TODO
end

function WBClass_MovieFrame:EnableSubtitles() _notimplemented("MovieFrame.EnableSubtitles"); end
function WBClass_MovieFrame:StartMovie(strFile) _notimplemented("MovieFrame.StartMovie"); end
function WBClass_MovieFrame:StopMovie() _notimplemented("MovieFrame.StopMovie"); end

WOWB_Debug_AddClassInfo(WBClass_MovieFrame, WBClass_MovieFrame:GetObjectType());



---------------------------------------------------------------------
---------------------------------------------------------------------
---------------------------------------------------------------------
--
-- ScrollFrame
--

WBClass_ScrollFrame = {}
WOWB_InheritType(WBClass_ScrollFrame, WBClass_Frame);
function WBClass_ScrollFrame:GetFrameType() return "ScrollFrame"; end
function WBClass_ScrollFrame:GetObjectType() return "ScrollFrame"; end

function WBClass_ScrollFrame:__constructor()
	-- TODO
end

function WBClass_ScrollFrame:GetHorizontalScroll() _notimplemented("ScrollFrame.GetHorizontalScroll"); end
function WBClass_ScrollFrame:GetHorizontalScrollRange() _notimplemented("ScrollFrame.GetHorizontalScrollRange"); end
function WBClass_ScrollFrame:GetScrollChild() _notimplemented("ScrollFrame.GetScrollChild"); end
function WBClass_ScrollFrame:GetVerticalScroll() _notimplemented("ScrollFrame.GetVerticalScroll"); end
function WBClass_ScrollFrame:GetVerticalScrollRange() _notimplemented("ScrollFrame.GetVerticalScrollRange"); end
function WBClass_ScrollFrame:SetHorizontalScroll(nOffset) _notimplemented("ScrollFrame.SetHorizontalScroll"); end
function WBClass_ScrollFrame:SetScrollChild() _notimplemented("ScrollFrame.SetScrollChild"); end  -- TODO ARGS
function WBClass_ScrollFrame:SetVerticalScroll(offset)
	local prev = tonumber(self[0].verticalScroll or -1);
	self[0].verticalScroll = (tonumber(offset) or 0);
	if(prev~=self[0].verticalScroll and self[0].Scripts and self[0].Scripts[0].OnVerticalScroll) then
		WOWB_DoScript({this=self, scriptnode=self[0].Scripts[0].OnVerticalScroll, args={self[0].verticalScroll}})
	end
end
function WBClass_ScrollFrame:UpdateScrollChildRect() _ignore_notimplemented("ScrollFrame.UpdateScrollChildRect"); end  

WOWB_Debug_AddClassInfo(WBClass_ScrollFrame, WBClass_ScrollFrame:GetObjectType());



---------------------------------------------------------------------
---------------------------------------------------------------------
---------------------------------------------------------------------
--
-- ScrollingMessageFrame
--


WBClass_ScrollingMessageFrame = {}
WOWB_InheritType(WBClass_ScrollingMessageFrame, WBClass_Frame, WBClass_FontStringBase);
function WBClass_ScrollingMessageFrame:GetFrameType() return "ScrollingMessageFrame"; end
function WBClass_ScrollingMessageFrame:GetObjectType() return "ScrollingMessageFrame"; end

function WBClass_ScrollingMessageFrame:__constructor()
	-- TODO
end

function WBClass_ScrollingMessageFrame:AddMessage(strText,   r,g,b,   id) -- Add a message to the frame, with an optional color ID.
  strText = gsub(strText, "|c%x%x%x%x%x%x%x%x", "");
  strText = gsub(strText, "|r", "");
	strText = gsub(strText, "\n", "\n"..string.rep(" ", strlen(self:GetName()..": ")));
	print(self:GetName() .. ": ".. strText);
end
function WBClass_ScrollingMessageFrame:AtBottom() return true; end -- Return true if frame is at the bottom. 
function WBClass_ScrollingMessageFrame:AtTop() return false; end -- Test whether frame is at the top - New in 1.11.
function WBClass_ScrollingMessageFrame:Clear() _notimplemented("ScrollingMessageFrame.Clear"); end -- Clear all lines from the frame. 
function WBClass_ScrollingMessageFrame:GetCurrentLine() _notimplemented("ScrollingMessageFrame.GetCurrentLine"); end 
function WBClass_ScrollingMessageFrame:GetCurrentScroll() _notimplemented("ScrollingMessageFrame.GetCurrentScroll"); end 
function WBClass_ScrollingMessageFrame:GetFadeDuration() _notimplemented("ScrollingMessageFrame.GetFadeDuration"); end 
function WBClass_ScrollingMessageFrame:GetFading() _notimplemented("ScrollingMessageFrame.GetFading"); end 
function WBClass_ScrollingMessageFrame:GetMaxLines() _notimplemented("ScrollingMessageFrame.GetMaxLines"); end -- Get the maximum number of lines the frame can display. 
function WBClass_ScrollingMessageFrame:GetNumLinesDisplayed() _notimplemented("ScrollingMessageFrame.GetNumLinesDisplayed"); end 
function WBClass_ScrollingMessageFrame:GetNumMessages() _notimplemented("ScrollingMessageFrame.GetNumMessages"); end 
function WBClass_ScrollingMessageFrame:GetTimeVisible() _notimplemented("ScrollingMessageFrame.GetTimeVisible"); end 
function WBClass_ScrollingMessageFrame:PageDown() _notimplemented("ScrollingMessageFrame.PageDown"); end 
function WBClass_ScrollingMessageFrame:PageUp() _notimplemented("ScrollingMessageFrame.PageUp"); end 
function WBClass_ScrollingMessageFrame:ScrollDown() _notimplemented("ScrollingMessageFrame.ScrollDown"); end 
function WBClass_ScrollingMessageFrame:ScrollToBottom() _notimplemented("ScrollingMessageFrame.ScrollToBottom"); end 
function WBClass_ScrollingMessageFrame:ScrollToTop() _notimplemented("ScrollingMessageFrame.ScrollToTop"); end 
function WBClass_ScrollingMessageFrame:ScrollUp() _notimplemented("ScrollingMessageFrame.ScrollUp"); end 
function WBClass_ScrollingMessageFrame:SetFadeDuration(seconds) _notimplemented("ScrollingMessageFrame.SetFadeDuration"); end -- Set the fade duration. 
function WBClass_ScrollingMessageFrame:SetFading(isEnabled) _notimplemented("ScrollingMessageFrame.SetFading"); end
function WBClass_ScrollingMessageFrame:SetMaxLines(numLines) _notimplemented("ScrollingMessageFrame.SetMaxLines"); end -- Set the maximum number of displayed lines. 
function WBClass_ScrollingMessageFrame:SetScrollFromBottom() _notimplemented("ScrollingMessageFrame.SetScrollFromBottom"); end -- UNKNOWN ARGS
function WBClass_ScrollingMessageFrame:SetTimeVisible(seconds) _notimplemented("ScrollingMessageFrame.SetTimeVisible"); end -- Sets how long lines remain visible. 
function WBClass_ScrollingMessageFrame:UpdateColorByID(id,r,g,b) _notimplemented("ScrollingMessageFrame.UpdateColorByID"); end

WOWB_Debug_AddClassInfo(WBClass_ScrollingMessageFrame, WBClass_ScrollingMessageFrame:GetObjectType());




---------------------------------------------------------------------
---------------------------------------------------------------------
---------------------------------------------------------------------
--
-- SimpleHTML
-- Cheat definition, pretend we inherit FontStringBase
--

WBClass_SimpleHTML = {}
WOWB_InheritType(WBClass_SimpleHTML, WBClass_Frame, WBClass_FontStringBase);
function WBClass_SimpleHTML:GetFrameType() return "SimpleHTML"; end
function WBClass_SimpleHTML:GetObjectType() return "SimpleHTML"; end

function WBClass_SimpleHTML:__constructor()
	-- TODO
end

WBClass_SimpleHTML.GetText = nil;
function WBClass_SimpleHTML:GetHyperlinkFormat() _notimplemented("SimpleHTML.GetHyperlinkFormat"); end -- Get the string.format format to use to display hyperlinks. - New in 1.11.
function WBClass_SimpleHTML:SetHyperlinkFormat(strFormat) _notimplemented("SimpleHTML.SetHyperlinkFormat"); end -- Set the string.format format to use to display hyperlinks. 

WOWB_Debug_AddClassInfo(WBClass_SimpleHTML, WBClass_SimpleHTML:GetObjectType());









---------------------------------------------------------------------
---------------------------------------------------------------------
---------------------------------------------------------------------
--
-- Slider
--

WBClass_Slider = {}
WOWB_InheritType(WBClass_Slider, WBClass_Frame);
function WBClass_Slider:GetFrameType() return "Slider"; end
function WBClass_Slider:GetObjectType() return "Slider"; end

function WBClass_Slider:__constructor()
	self[0].sliderValue = (tonumber(self[0].defaultValue) or 0);
	self[0].valueStep = (tonumber(self[0].valueStep) or 1);
	-- TODO
end

function WBClass_Slider:GetMinMaxValues() -- Get the current bounds of the slider. 
	return (self[0].minValue or 0), (self[0].maxValue or 0);
end
function WBClass_Slider:GetOrientation() _notimplemented("Slider.GetOrientation"); end
function WBClass_Slider:GetThumbTexture() _notimplemented("Slider.GetThumbTexture"); end -- Get the texture for this slider's thumb - New in 1.11.
function WBClass_Slider:GetValue() -- Get the current value of the slider. 
	local ret = self[0].sliderValue or 0;
	if(self[0].minValue and ret<self[0].minValue) then ret=self[0].minValue; end
	if(self[0].maxValue and ret>self[0].maxValue) then ret=self[0].maxValue; end
	return ret;
end
function WBClass_Slider:GetValueStep() -- Get the current step size of the slider. 
	return self[0].valueStep or 1;
end
function WBClass_Slider:SetMinMaxValues(min,max)  -- Set the bounds of the slider. 
	self[0].minValue = (tonumber(min) or 0);
	self[0].maxValue = (tonumber(max) or 0);
end
function WBClass_Slider:SetOrientation(str) _ignore_notimplemented("Slider.SetOrientation"); end
function WBClass_Slider:SetThumbTexture(textureorpath) _ignore_notimplemented("Slider.SetThumbTexture"); end  -- Get the texture for this slider's thumb - New in 1.11.
function WBClass_Slider:SetValue(value) -- Set the value of the slider. 
	local prev = (tonumber(self[0].sliderValue) or 0);
	self[0].sliderValue = (tonumber(value) or 0);
	if(self[0].sliderValue~=prev and self[0].Scripts and self[0].Scripts[0].OnValueChanged) then
		WOWB_DoScript({this=self, scriptnode=self[0].Scripts[0].OnValueChanged, args={self[0].sliderValue}})
	end
end
function WBClass_Slider:SetValueStep(value) -- Set the step size of the slider.
	self[0].valueStep = (tonumber(value) or 1);
end

WOWB_Debug_AddClassInfo(WBClass_Slider, WBClass_Slider:GetObjectType());





---------------------------------------------------------------------
---------------------------------------------------------------------
---------------------------------------------------------------------
--
-- StatusBar
--

WBClass_StatusBar = {}
WOWB_InheritType(WBClass_StatusBar, WBClass_Frame);
function WBClass_StatusBar:GetFrameType() return "StatusBar"; end
function WBClass_StatusBar:GetObjectType() return "StatusBar"; end

function WBClass_StatusBar:__constructor()
	self[0].statusbarValue = (self[0].defaultValue or 0);
	-- TODO
end

function WBClass_StatusBar:GetMinMaxValues()  -- Get the current bounds of the bar. 
	return (self[0].minValue or 0), (self[0].maxValue or 0);
end
function WBClass_StatusBar:GetOrientation() _notimplemented("StatusBar.GetOrientation"); end 
function WBClass_StatusBar:GetStatusBarColor() _notimplemented("StatusBar.GetStatusBarColor"); end 
function WBClass_StatusBar:GetStatusBarTexture() _notimplemented("StatusBar.GetStatusBarTexture"); end -- Returns the texture object for the bar - Before 1.11 it returned the filename.
function WBClass_StatusBar:GetValue() -- Get the current value of the bar. 
	local ret = self[0].statusbarValue or 0;
	if(self[0].minValue and ret<self[0].minValue) then ret=self[0].minValue; end
	if(self[0].maxValue and ret>self[0].maxValue) then ret=self[0].maxValue; end
	return ret;
end
function WBClass_StatusBar:SetMinMaxValues(min,max) -- Set the bounds of the bar. 
	self[0].minValue = (tonumber(min) or 0);
	self[0].maxValue = (tonumber(max) or 0);
end
function WBClass_StatusBar:SetOrientation(str) _notimplemented("StatusBar.SetOrientation"); end 
function WBClass_StatusBar:SetStatusBarColor(r,g,b,   alpha) _ignore_notimplemented("StatusBar.SetStatusBarColor"); end -- Set the color of the bar. 
function WBClass_StatusBar:SetStatusBarTexture(texture,   strLayer) _ignore_notimplemented("StatusBar.SetStatusBarTexture"); end -- Sets the texture of the bar (filename or texture object)
function WBClass_StatusBar:SetValue(value) -- Set the value of the bar.
	self[0].statusbarValue = (tonumber(value) or 0);
end

WOWB_Debug_AddClassInfo(WBClass_StatusBar, WBClass_StatusBar:GetObjectType());




---------------------------------------------------------------------
---------------------------------------------------------------------
---------------------------------------------------------------------
--
-- TaxiRouteFrame
-- TODO: Iriel's listing no longer has this. Remove?
--

WBClass_TaxiRouteFrame = {}
WOWB_InheritType(WBClass_TaxiRouteFrame, WBClass_Frame);
function WBClass_TaxiRouteFrame:GetObjectType() return "TaxiRouteFrame"; end

function WBClass_TaxiRouteFrame:__constructor()
	-- TODO
end

WOWB_Debug_AddClassInfo(WBClass_TaxiRouteFrame, WBClass_TaxiRouteFrame:GetObjectType());




---------------------------------------------------------------------
---------------------------------------------------------------------
---------------------------------------------------------------------
--
-- WorldFrame
-- TODO: Iriel's listing no longer has this. Remove?
--

WBClass_WorldFrame = {}
WOWB_InheritType(WBClass_WorldFrame, WBClass_Frame);
function WBClass_WorldFrame:GetObjectType() return "WorldFrame"; end

function WBClass_WorldFrame:__constructor()
	-- TODO
end

WOWB_Debug_AddClassInfo(WBClass_WorldFrame, WBClass_WorldFrame:GetObjectType());




---------------------------------------------------------------------
---------------------------------------------------------------------
---------------------------------------------------------------------
--
-- CheckButton
--

WBClass_CheckButton = {}
WOWB_InheritType(WBClass_CheckButton, WBClass_Button);
function WBClass_CheckButton:GetFrameType() return "CheckButton"; end
function WBClass_CheckButton:GetObjectType() return "CheckButton"; end

function WBClass_CheckButton:__constructor()
	-- TODO
end

function WBClass_CheckButton:GetChecked() -- Get the status of the checkbox. 
	return (self[0].checked or "false") == "true";
end
function WBClass_CheckButton:GetCheckedTexture() _notimplemented("CheckButton.GetCheckedTexture"); end -- Get the texture used for a checked box - New in 1.11. 
function WBClass_CheckButton:GetDisabledCheckedTexture() _notimplemented("CheckButton.GetDisabledCheckedTexture"); end -- Get the texture used for a disabled checked box - New in 1.11.
function WBClass_CheckButton:SetChecked(...) -- Set the status of the checkbox.  Ugly (...) is the only way to be 1.11 compatible.
	local bState = true;
	if(table.getn(arg)>=1) then
		bState = arg[1];
	end
	if(not bState or bState==0) then
		self[0].checked = "false";
	else
		self[0].checked = "true";
	end
end
function WBClass_CheckButton:SetCheckedTexture(texture) _ignore_notimplemented("CheckButton.SetCheckedTexture"); end -- Set the texture to use for a checked box. 
function WBClass_CheckButton:SetDisabledCheckedTexture(texture) _ignore_notimplemented("CheckButton.SetDisabledCheckedTexture"); end -- Set the texture to use for an unchecked box.

WOWB_Debug_AddClassInfo(WBClass_CheckButton, WBClass_CheckButton:GetObjectType());




---------------------------------------------------------------------
---------------------------------------------------------------------
---------------------------------------------------------------------
--
-- LootButton
--

WBClass_LootButton = {}
WOWB_InheritType(WBClass_LootButton, WBClass_Button)
function WBClass_LootButton:GetFrameType() return "LootButton"; end
function WBClass_LootButton:GetObjectType() return "LootButton"; end

function WBClass_LootButton:__constructor()
	-- TODO
end
 
function WBClass_LootButton:SetSlot(index) _notimplemented("LootButton.SetSlot"); end -- Set which the item to loot if the button is clicked.

WOWB_Debug_AddClassInfo(WBClass_LootButton, WBClass_LootButton:GetObjectType());




---------------------------------------------------------------------
---------------------------------------------------------------------
---------------------------------------------------------------------
--
-- PlayerModel
--

WBClass_PlayerModel = {}
WOWB_InheritType(WBClass_PlayerModel, WBClass_Model)
function WBClass_PlayerModel:GetFrameType() return "PlayerModel"; end
function WBClass_PlayerModel:GetObjectType() return "PlayerModel"; end

function WBClass_PlayerModel:__constructor()
	-- TODO
end

function WBClass_PlayerModel:RefreshUnit() _ignore_notimplemented("PlayerModel.RefreshUnit"); end
function WBClass_PlayerModel:SetRotation(rotationRadians) _ignore_notimplemented("PlayerModel.SetRotation"); end
function WBClass_PlayerModel:SetUnit(strUnit) _ignore_notimplemented("PlayerModel.SetUnit"); end

WOWB_Debug_AddClassInfo(WBClass_PlayerModel, WBClass_PlayerModel:GetObjectType());





---------------------------------------------------------------------
---------------------------------------------------------------------
---------------------------------------------------------------------
--
-- DressUpModel
--

WBClass_DressUpModel = {}
WOWB_InheritType(WBClass_DressUpModel, WBClass_PlayerModel)
function WBClass_DressUpModel:GetFrameType() return "DressUpModel"; end
function WBClass_DressUpModel:GetObjectType() return "DressUpModel"; end

function WBClass_DressUpModel:__constructor()
	-- TODO
end

function WBClass_DressUpModel:Dress() _ignore_notimplemented("DressUpModel.Dress"); end -- Set the model to reflect the character's current inventory. 
function WBClass_DressUpModel:TryOn(strItem) _ignore_notimplemented("DressUpModel.TryOn"); end -- Add the specified item to the model. 
function WBClass_DressUpModel:Undress() _ignore_notimplemented("DressUpModel.Undress"); end -- Set the model to reflect the character without inventory.

WOWB_Debug_AddClassInfo(WBClass_DressUpModel, WBClass_DressUpModel:GetObjectType());




---------------------------------------------------------------------
---------------------------------------------------------------------
---------------------------------------------------------------------
--
-- TabardModel
--

WBClass_TabardModel = {}
WOWB_InheritType(WBClass_TabardModel, WBClass_PlayerModel)
function WBClass_TabardModel:GetFrameType() return "TabardModel"; end
function WBClass_TabardModel:GetObjectType() return "TabardModel"; end

function WBClass_TabardModel:__constructor()
	-- TODO
end

function WBClass_TabardModel:CanSaveTabardNow() _notimplemented("TabardModel.CanSaveTabardNow"); end -- Indicate if the tabard can be saved. 
function WBClass_TabardModel:CycleVariation(variationIndex,delta) _notimplemented("TabardModel.CycleVariation"); end
function WBClass_TabardModel:GetLowerBackgroundFileName() _notimplemented("TabardModel.GetLowerBackgroundFileName"); end  -- UNKNOWN ARGS
function WBClass_TabardModel:GetLowerEmblemFileName() _notimplemented("TabardModel.GetLowerEmblemFileName"); end  -- UNKNOWN ARGS
function WBClass_TabardModel:GetLowerEmblemTexture(strTextureName) _notimplemented("TabardModel.GetLowerEmblemTexture"); end
function WBClass_TabardModel:GetUpperBackgroundFileName() _notimplemented("TabardModel.GetUpperBackgroundFileName"); end  -- UNKNOWN ARGS
function WBClass_TabardModel:GetUpperEmblemFileName() _notimplemented("TabardModel.GetUpperEmblemFileName"); end  -- UNKNOWN ARGS
function WBClass_TabardModel:GetUpperEmblemTexture(strTextureName) _notimplemented("TabardModel.GetUpperEmblemTexture"); end
function WBClass_TabardModel:InitializeTabardColors() _notimplemented("TabardModel.InitializeTabardColors"); end
function WBClass_TabardModel:Save() _notimplemented("TabardModel.Save"); end -- Save the tabard.

WOWB_Debug_AddClassInfo(WBClass_TabardModel, WBClass_TabardModel:GetObjectType());







---------------------------------------------------------------------
---------------------------------------------------------------------
---------------------------------------------------------------------
--
-- Texture
--

WBClass_Texture = {}
WOWB_InheritType(WBClass_Texture, WBClass_LayeredRegion)
function WBClass_Texture:GetFrameType() return "Texture"; end
function WBClass_Texture:GetObjectType() return "Texture"; end

function WBClass_Texture:__constructor()
	-- TODO
end
 
function WBClass_Texture:GetBlendMode() _notimplemented("Texture.GetBlendMode"); end 
function WBClass_Texture:GetTexCoord() _notimplemented("Texture.GetTexCoord"); end -- Gets the 8 texture coordinates that map to the Texture's corners - New in 1.11. 
function WBClass_Texture:GetTexCoordModifiesRect() _notimplemented("Texture.GetTexCoordModifiesRect"); end -- New in 1.11
function WBClass_Texture:GetTexture() -- Gets this texture's current texture path. 
	return self[0].texturePath;
end
function WBClass_Texture:GetVertexColor() _notimplemented("Texture.GetVertexColor"); end 
function WBClass_Texture:IsDesaturated() _notimplemented("Texture.IsDesaturated"); end -- Gets the desaturation state of this Texture. - New in 1.11
function WBClass_Texture:SetBlendMode() _ignore_notimplemented("Texture.SetBlendMode"); end  -- UNKNOWN ARGS
function WBClass_Texture:SetDesaturated(bDesaturated) _ignore_notimplemented("Texture.SetDesaturated"); end -- Set whether this texture should be displayed with no saturation (IMPORTANT: This has a return value) 
function WBClass_Texture:SetGradient(strOrientation,minR,minG,minB,maxR,maxG,maxB) _ignore_notimplemented("Texture.SetGradient"); end
function WBClass_Texture:SetGradientAlpha(strOrientation,minR,minG,minB,minA,maxR,maxG,maxB,maxA) _ignore_notimplemented("Texture.SetGradientAlpha"); end
function WBClass_Texture:SetTexCoord(...) _ignore_notimplemented("Texture.SetTexCoord"); end -- Set the corner coordinates for texture display. (4 or 8 params)
function WBClass_Texture:SetTexCoordModifiesRect(--[[UNKNOWN]]) _notimplemented("Texture.SetTexCoordModifiesRect"); end -- New in 1.11
function WBClass_Texture:SetTexture(r,g,b,a) -- Sets the texture to be displayed ("texturePath" or r,g,b,a)
	if(not g) then
		self[0].texturePath = tostring(r);
	else
		self[0].texturePath = nil;
	end
	return 1;
end

WOWB_Debug_AddClassInfo(WBClass_Texture, WBClass_Texture:GetObjectType());



---------------------------------------------------------------------
---------------------------------------------------------------------
---------------------------------------------------------------------
--
-- FontString
--

WBClass_FontString = {}
WOWB_InheritType(WBClass_FontString, WBClass_LayeredRegion, WBClass_FontStringBase)
function WBClass_FontString:GetFrameType() return "FontString"; end
function WBClass_FontString:GetObjectType() return "FontString"; end

function WBClass_FontString:__constructor()
	-- TODO
end

function WBClass_FontString:CanNonSpaceWrap() -- Get whether long strings without spaces are wrapped or truncated - New in 1.11.
	return self[0].nonSpaceWrap;
end
function WBClass_FontString:GetStringWidth() -- Returns the width in pixels of the current string in the current font (without line wrapping). 
	return strlen(self:GetText()) * self[0].fontHeight * 0.6;
end
function WBClass_FontString:SetAlphaGradient(start,length) _ignore_notimplemented("FontString.SetAlphaGradient"); end -- Create or remove an alpha gradient over the text. 
function WBClass_FontString:SetNonSpaceWrap(wrapFlag) -- Set whether long strings without spaces are wrapped or truncated. 
	self[0].nonSpaceWrap = wrapFlag;
end
function WBClass_FontString:SetTextHeight(pixelHeight) _ignore_notimplemented("FontString.SetTextHeight"); end -- Set the height of the text by scaling graphics (Note: Can distort text).

WOWB_Debug_AddClassInfo(WBClass_FontString, WBClass_FontString:GetObjectType());

