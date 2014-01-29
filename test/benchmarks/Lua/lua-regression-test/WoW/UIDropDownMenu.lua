UIDROPDOWNMENU_MAXBUTTONS = 32;
UIDROPDOWNMENU_MAXLEVELS = 3;
UIDROPDOWNMENU_BUTTON_HEIGHT = 16;
UIDROPDOWNMENU_BORDER_HEIGHT = 15;
-- The current open menu
UIDROPDOWNMENU_OPEN_MENU = nil;
-- The current menu being initialized
UIDROPDOWNMENU_INIT_MENU = nil;
-- Current level shown of the open menu
UIDROPDOWNMENU_MENU_LEVEL = 1;
-- Current value of the open menu
UIDROPDOWNMENU_MENU_VALUE = nil;
-- Time to wait to hide the menu
UIDROPDOWNMENU_SHOW_TIME = 2;
-- Default dropdown text height
UIDROPDOWNMENU_DEFAULT_TEXT_HEIGHT = nil;
-- List of open menus
OPEN_DROPDOWNMENUS = {};

function UIDropDownMenu_Initialize(frame, initFunction, displayMode, level)
	if ( not frame ) then
		frame = this;
	end

	if ( frame:GetName() ~= UIDROPDOWNMENU_OPEN_MENU ) then
		UIDROPDOWNMENU_MENU_LEVEL = 1;
	end

	-- Set the frame that's being intialized
	UIDROPDOWNMENU_INIT_MENU = frame:GetName();

	-- Hide all the buttons
	local button, dropDownList;
	for i = 1, UIDROPDOWNMENU_MAXLEVELS, 1 do
		dropDownList = getglobal("DropDownList"..i);
		if ( i >= UIDROPDOWNMENU_MENU_LEVEL or frame:GetName() ~= UIDROPDOWNMENU_OPEN_MENU ) then
			dropDownList.numButtons = 0;
			dropDownList.maxWidth = 0;
			for j=1, UIDROPDOWNMENU_MAXBUTTONS, 1 do
				button = getglobal("DropDownList"..i.."Button"..j);
				button:Hide();
			end
		end
	end
	frame:SetHeight(UIDROPDOWNMENU_BUTTON_HEIGHT * 2);
	
	-- Set the initialize function and call it.  The initFunction populates the dropdown list.
	if ( initFunction ) then
		frame.initialize = initFunction;
		initFunction(level);
	end

	-- Change appearance based on the displayMode
	if ( displayMode == "MENU" ) then
		getglobal(frame:GetName().."Left"):Hide();
		getglobal(frame:GetName().."Middle"):Hide();
		getglobal(frame:GetName().."Right"):Hide();
		getglobal(frame:GetName().."ButtonNormalTexture"):SetTexture("");
		getglobal(frame:GetName().."ButtonDisabledTexture"):SetTexture("");
		getglobal(frame:GetName().."ButtonPushedTexture"):SetTexture("");
		getglobal(frame:GetName().."ButtonHighlightTexture"):SetTexture("");
		getglobal(frame:GetName().."Button"):ClearAllPoints();
		getglobal(frame:GetName().."Button"):SetPoint("LEFT", frame:GetName().."Text", "LEFT", -9, 0);
		getglobal(frame:GetName().."Button"):SetPoint("RIGHT", frame:GetName().."Text", "RIGHT", 6, 0);
		frame.displayMode = "MENU";
	end

end

-- If dropdown is visible then see if its timer has expired, if so hide the frame
function UIDropDownMenu_OnUpdate(elapsed)
	if ( this:IsVisible() ) then
		if ( not this.showTimer or not this.isCounting ) then
			return;
		elseif ( this.showTimer < 0 ) then
			this:Hide();
			this.showTimer = nil;
			this.isCounting = nil;
		else
			this.showTimer = this.showTimer - elapsed;
		end
	end
end

-- Start the countdown on a frame
function UIDropDownMenu_StartCounting(frame)
	if ( frame.parent ) then
		UIDropDownMenu_StartCounting(frame.parent);
	else
		frame.showTimer = UIDROPDOWNMENU_SHOW_TIME;
		frame.isCounting = 1;
	end
end

-- Stop the countdown on a frame
function UIDropDownMenu_StopCounting(frame)
	if ( frame.parent ) then
		UIDropDownMenu_StopCounting(frame.parent);
	else
		frame.isCounting = nil;
	end
end

--[[
List of button attributes
======================================================
info.text = [STRING]  --  The text of the button
info.value = [ANYTHING]  --  The value that UIDROPDOWNMENU_MENU_VALUE is set to when the button is clicked
info.func = [function()]  --  The function that is called when you click the button
info.checked = [nil, 1]  --  Check the button
info.isTitle = [nil, 1]  --  If it's a title the button is disabled and the font color is set to yellow
info.disabled = [nil, 1]  --  Disable the button and show an invisible button that still traps the mouseover event so menu doesn't time out
info.hasArrow = [nil, 1]  --  Show the expand arrow for multilevel menus
info.hasColorSwatch = [nil, 1]  --  Show color swatch or not, for color selection
info.r = [1 - 255]  --  Red color value of the color swatch
info.g = [1 - 255]  --  Green color value of the color swatch
info.b = [1 - 255]  --  Blue color value of the color swatch
info.textR = [1 - 255]  --  Red color value of the button text
info.textG = [1 - 255]  --  Green color value of the button text
info.textB = [1 - 255]  --  Blue color value of the button text
info.swatchFunc = [function()]  --  Function called by the color picker on color change
info.hasOpacity = [nil, 1]  --  Show the opacity slider on the colorpicker frame
info.opacity = [0.0 - 1.0]  --  Percentatge of the opacity, 1.0 is fully shown, 0 is transparent
info.opacityFunc = [function()]  --  Function called by the opacity slider when you change its value
info.cancelFunc = [function(previousValues)] -- Function called by the colorpicker when you click the cancel button (it takes the previous values as its argument)
info.notClickable = [nil, 1]  --  Disable the button and color the font white
info.notCheckable = [nil, 1]  --  Shrink the size of the buttons and don't display a check box
info.owner = [Frame]  --  Dropdown frame that "owns" the current dropdownlist
info.keepShownOnClick = [nil, 1]  --  Don't hide the dropdownlist after a button is clicked
info.tooltipTitle = [nil, STRING] -- Title of the tooltip shown on mouseover
info.tooltipText = [nil, STRING] -- Text of the tooltip shown on mouseover
info.justifyH = [nil, "CENTER"] -- Justify button text
info.arg1 = [ANYTHING] -- This is the first argument used by info.func
info.arg2 = [ANYTHING] -- This is the second argument used by info.func
info.textHeight = [NUMBER] -- font height for button text
]]

function UIDropDownMenu_AddButton(info, level)
	--[[
	Might to uncomment this if there are performance issues 
	if ( not UIDROPDOWNMENU_OPEN_MENU ) then
		return;
	end
	]]
	if ( not level ) then
		level = 1;
	end
	
	local listFrame = getglobal("DropDownList"..level);
	local listFrameName = listFrame:GetName();
	local index = listFrame.numButtons + 1;
	local width;

	-- If too many buttons error out
	if ( index > UIDROPDOWNMENU_MAXBUTTONS ) then
		message("Too many buttons in UIDropDownMenu: "..UIDROPDOWNMENU_OPEN_MENU);
		return;
	end

	-- If too many levels error out
	if ( level > UIDROPDOWNMENU_MAXLEVELS ) then
		message("Too many levels in UIDropDownMenu: "..UIDROPDOWNMENU_OPEN_MENU);
		return;
	end
	
	-- Set the number of buttons in the listframe
	listFrame.numButtons = index;
	
	local button = getglobal(listFrameName.."Button"..index);
	local normalText = getglobal(button:GetName().."NormalText");
	local icon = getglobal(button:GetName().."Icon");
	-- This button is used to capture the mouse OnEnter/OnLeave events if the dropdown button is disabled, since a disabled button doesn't receive any events
	-- This is used specifically for drop down menu time outs
	local invisibleButton = getglobal(button:GetName().."InvisibleButton");
	
	-- Default settings
	button:SetDisabledTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	invisibleButton:Hide();
	button:Enable();
	
	-- Configure button
	if ( info.text ) then
		button:SetText(info.text);
		if ( info.textHeight ) then
			button:SetFont(STANDARD_TEXT_FONT, info.textHeight);
		else
			button:SetFont(STANDARD_TEXT_FONT, UIDROPDOWNMENU_DEFAULT_TEXT_HEIGHT);
		end
		-- Determine the width of the button
		width = normalText:GetWidth() + 60;
		-- Add padding if has and expand arrow or color swatch
		if ( info.hasArrow or info.hasColorSwatch ) then
			width = width + 10;
		end
		if ( info.notCheckable ) then
			width = width - 30;
		end
		-- Set icon
		if ( info.icon ) then
			icon:SetTexture(info.icon);
			if ( info.tCoordLeft ) then
				icon:SetTexCoord(info.tCoordLeft, info.tCoordRight, info.tCoordTop, info.tCoordBottom);
			end
			icon:Show();
			-- Add padding for the icon
			width = width + 10;
		else
			icon:Hide();
		end
		-- Set maximum button width
		if ( width > listFrame.maxWidth ) then
			listFrame.maxWidth = width;
		end
		-- If a textR is set then set the vertex color of the button text
		if ( info.textR ) then
			button:SetTextColor(info.textR, info.textG, info.textB);
			button:SetHighlightTextColor(info.textR, info.textG, info.textB);
		else
			button:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
			button:SetHighlightTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
		end
	else
		button:SetText("");
	end

	-- Pass through attributes
	button.func = info.func;
	button.owner = info.owner;
	button.hasOpacity = info.hasOpacity;
	button.opacity = info.opacity;
	button.opacityFunc = info.opacityFunc;
	button.cancelFunc = info.cancelFunc;
	button.swatchFunc = info.swatchFunc;
	button.keepShownOnClick = info.keepShownOnClick;
	button.tooltipTitle = info.tooltipTitle;
	button.tooltipText = info.tooltipText;
	button.arg1 = info.arg1;
	button.arg2 = info.arg2;
	button.hasArrow = info.hasArrow;
	button.hasColorSwatch = info.hasColorSwatch;
	button.notCheckable = info.notCheckable;

	if ( info.value ) then
		button.value = info.value;
	elseif ( info.text ) then
		button.value = info.text;
	else
		button.value = nil;
	end
	
	-- Show the expand arrow if it has one
	if ( info.hasArrow ) then
		getglobal(listFrameName.."Button"..index.."ExpandArrow"):Show();
	else
		getglobal(listFrameName.."Button"..index.."ExpandArrow"):Hide();
	end
	button.hasArrow = info.hasArrow;
	
	-- If not checkable move everything over to the left to fill in the gap where the check would be
	local xPos = 5;
	local yPos = -((button:GetID() - 1) * UIDROPDOWNMENU_BUTTON_HEIGHT) - UIDROPDOWNMENU_BORDER_HEIGHT;
	normalText:ClearAllPoints();
	if ( info.notCheckable ) then
		if ( info.justifyH and info.justifyH == "CENTER" ) then
			normalText:SetPoint("CENTER", button, "CENTER", -7, 0);
		else
			normalText:SetPoint("LEFT", button, "LEFT", 0, 0);
		end
		xPos = xPos + 10;
		
	else
		xPos = xPos + 12;
		normalText:SetPoint("LEFT", button, "LEFT", 27, 0);
	end

	-- Adjust offset if displayMode is menu
	local frame = getglobal(UIDROPDOWNMENU_OPEN_MENU);
	if ( frame and frame.displayMode == "MENU" ) then
		if ( not info.notCheckable ) then
			xPos = xPos - 6;
		end
	end
	
	-- If no open frame then set the frame to the currently initialized frame
	if ( not frame ) then
		frame = getglobal(UIDROPDOWNMENU_INIT_MENU);
	end

	button:SetPoint("TOPLEFT", button:GetParent(), "TOPLEFT", xPos, yPos);

	-- See if button is selected by id or name
	if ( frame ) then
		if ( UIDropDownMenu_GetSelectedName(frame) ) then
			if ( button:GetText() == UIDropDownMenu_GetSelectedName(frame) ) then
				info.checked = 1;
			end
		elseif ( UIDropDownMenu_GetSelectedID(frame) ) then
			if ( button:GetID() == UIDropDownMenu_GetSelectedID(frame) ) then
				info.checked = 1;
			end
		elseif ( UIDropDownMenu_GetSelectedValue(frame) ) then
			if ( button.value == UIDropDownMenu_GetSelectedValue(frame) ) then
				info.checked = 1;
			end
		end
	end

	-- Show the check if checked
	if ( info.checked ) then
		button:LockHighlight();
		getglobal(listFrameName.."Button"..index.."Check"):Show();
	else
		button:UnlockHighlight();
		getglobal(listFrameName.."Button"..index.."Check"):Hide();
	end
	button.checked = info.checked;

	-- If has a colorswatch, show it and vertex color it
	local colorSwatch = getglobal(listFrameName.."Button"..index.."ColorSwatch");
	if ( info.hasColorSwatch ) then
		getglobal("DropDownList"..level.."Button"..index.."ColorSwatch".."NormalTexture"):SetVertexColor(info.r, info.g, info.b);
		button.r = info.r;
		button.g = info.g;
		button.b = info.b;
		colorSwatch:Show();
	else
		colorSwatch:Hide();
	end

	-- If not clickable then disable the button and set it white
	if ( info.notClickable ) then
		info.disabled = 1;
		button:SetDisabledTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	end

	-- Set the text color and disable it if its a title
	if ( info.isTitle ) then
		info.disabled = 1;
		button:SetDisabledTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
	end
	
	-- Disable the button if disabled
	if ( info.disabled ) then
		button:Disable();
		invisibleButton:Show();
	end

	-- Set the height of the listframe
	listFrame:SetHeight((index * UIDROPDOWNMENU_BUTTON_HEIGHT) + (UIDROPDOWNMENU_BORDER_HEIGHT * 2));

	button:Show();
end

function UIDropDownMenu_Refresh(frame, useValue, dropdownLevel)
	local button, checked, checkImage, normalText;
	local maxWidth = 0;
	if ( not frame ) then
		frame = this;
	end
	if ( not dropdownLevel ) then
		dropdownLevel = UIDROPDOWNMENU_MENU_LEVEL;
	end
	
	-- Just redraws the existing menu
	for i=1, UIDROPDOWNMENU_MAXBUTTONS do
		button = getglobal("DropDownList"..dropdownLevel.."Button"..i);
		checked = nil;
		-- See if checked or not
		if ( UIDropDownMenu_GetSelectedName(frame) ) then
			if ( button:GetText() == UIDropDownMenu_GetSelectedName(frame) ) then
				checked = 1;
			end
		elseif ( UIDropDownMenu_GetSelectedID(frame) ) then
			if ( button:GetID() == UIDropDownMenu_GetSelectedID(frame) ) then
				checked = 1;
			end
		elseif ( UIDropDownMenu_GetSelectedValue(frame) ) then
			if ( button.value == UIDropDownMenu_GetSelectedValue(frame) ) then
				checked = 1;
			end
		end

		-- If checked show check image
		checkImage = getglobal("DropDownList"..dropdownLevel.."Button"..i.."Check");
		if ( checked ) then
			if ( useValue ) then
				UIDropDownMenu_SetText(button.value, frame);
			else
				UIDropDownMenu_SetText(button:GetText(), frame);
			end
			button:LockHighlight();
			checkImage:Show();
		else
			button:UnlockHighlight();
			checkImage:Hide();
		end

		if ( not level ) then
			level = 1;
		end
		
		if ( button:IsShown() ) then
			normalText = getglobal(button:GetName().."NormalText");
			-- Determine the maximum width of a button
			width = normalText:GetWidth() + 60;
			-- Add padding if has and expand arrow or color swatch
			if ( button.hasArrow or button.hasColorSwatch ) then
				width = width + 10;
			end
			if ( button.notCheckable ) then
				width = width - 30;
			end
			if ( width > maxWidth ) then
				maxWidth = width;
			end
		end
	end
	for i=1, UIDROPDOWNMENU_MAXBUTTONS do
		button = getglobal("DropDownList"..dropdownLevel.."Button"..i);
		button:SetWidth(maxWidth);
	end
	getglobal("DropDownList"..dropdownLevel):SetWidth(maxWidth+15);
end


function UIDropDownMenu_SetSelectedName(frame, name, useValue)
	frame.selectedName = name;
	frame.selectedID = nil;
	frame.selectedValue = nil;
	UIDropDownMenu_Refresh(frame, useValue);
end

function UIDropDownMenu_SetSelectedValue(frame, value, useValue)
	-- useValue will set the value as the text, not the name
	frame.selectedName = nil;
	frame.selectedID = nil;
	frame.selectedValue = value;
	UIDropDownMenu_Refresh(frame, useValue);
end

function UIDropDownMenu_SetSelectedID(frame, id, useValue)
	frame.selectedID = id;
	frame.selectedName = nil;
	frame.selectedValue = nil;
	UIDropDownMenu_Refresh(frame, useValue);
end

function UIDropDownMenu_GetSelectedName(frame)
	return frame.selectedName;
end

function UIDropDownMenu_GetSelectedID(frame)
	if ( frame.selectedID ) then
		return frame.selectedID;
	else
		-- If no explicit selectedID then try to send the id of a selected value or name
		local button;
		for i=1, UIDROPDOWNMENU_MAXBUTTONS do
			button = getglobal("DropDownList"..UIDROPDOWNMENU_MENU_LEVEL.."Button"..i);
			-- See if checked or not
			if ( UIDropDownMenu_GetSelectedName(frame) ) then
				if ( button:GetText() == UIDropDownMenu_GetSelectedName(frame) ) then
					return i;
				end
			elseif ( UIDropDownMenu_GetSelectedValue(frame) ) then
				if ( button.value == UIDropDownMenu_GetSelectedValue(frame) ) then
					return i;
				end
			end
		end
	end
end

function UIDropDownMenu_GetSelectedValue(frame)
	return frame.selectedValue;
end

function UIDropDownMenuButton_OnClick()
	local func = this.func;
	if ( func ) then
		func(this.arg1, this.arg2);
	else
		return;
	end
	
	if ( this.keepShownOnClick ) then
		if ( this.checked ) then
			getglobal(this:GetName().."Check"):Hide();
			this.checked = nil;
		else
			getglobal(this:GetName().."Check"):Show();
			this.checked = 1;
		end
	else
		this:GetParent():Hide();
	end
	PlaySound("UChatScrollButton");
end

function HideDropDownMenu(level)
	local listFrame = getglobal("DropDownList"..level);
	listFrame:Hide();
end

function ToggleDropDownMenu(level, value, dropDownFrame, anchorName, xOffset, yOffset)
	if ( not level ) then
		level = 1;
	end
	UIDROPDOWNMENU_MENU_LEVEL = level;
	UIDROPDOWNMENU_MENU_VALUE = value;
	local listFrame = getglobal("DropDownList"..level);
	local listFrameName = "DropDownList"..level;
	local tempFrame;
	local point, relativePoint, relativeTo;
	if ( not dropDownFrame ) then
		tempFrame = this:GetParent();
	else
		tempFrame = dropDownFrame;
	end
	if ( listFrame:IsVisible() and (UIDROPDOWNMENU_OPEN_MENU == tempFrame:GetName()) ) then
		listFrame:Hide();
	else
		-- Set the dropdownframe scale
		local uiScale = 1.0;
		if ( GetCVar("useUiScale") == "1" ) then
			if ( tempFrame ~= WorldMapContinentDropDown and tempFrame ~= WorldMapZoneDropDown ) then
				uiScale = tonumber(GetCVar("uiscale"));
			end
		end
		listFrame:SetScale(uiScale);
		
		-- Hide the listframe anyways since it is redrawn OnShow() 
		listFrame:Hide();
		
		-- Frame to anchor the dropdown menu to
		local anchorFrame;

		-- Display stuff
		-- Level specific stuff
		if ( level == 1 ) then
			if ( not dropDownFrame ) then
				dropDownFrame = this:GetParent();
			end
			UIDROPDOWNMENU_OPEN_MENU = dropDownFrame:GetName();
			listFrame:ClearAllPoints();
			-- If there's no specified anchorName then use left side of the dropdown menu
			if ( not anchorName ) then
				-- See if the anchor was set manually using setanchor
				if ( dropDownFrame.xOffset ) then
					xOffset = dropDownFrame.xOffset;
				end
				if ( dropDownFrame.yOffset ) then
					yOffset = dropDownFrame.yOffset;
				end
				if ( dropDownFrame.point ) then
					point = dropDownFrame.point;
				end
				if ( dropDownFrame.relativeTo ) then
					relativeTo = dropDownFrame.relativeTo;
				else
					relativeTo = UIDROPDOWNMENU_OPEN_MENU.."Left";
				end
				if ( dropDownFrame.relativePoint ) then
					relativePoint = dropDownFrame.relativePoint;
				end
			elseif ( anchorName == "cursor" ) then
				relativeTo = nil;
				local cursorX, cursorY = GetCursorPosition();
				cursorX = cursorX/uiScale;
				cursorY =  cursorY/uiScale;

				if ( not xOffset ) then
					xOffset = 0;
				end
				if ( not yOffset ) then
					yOffset = 0;
				end
				xOffset = cursorX + xOffset;
				yOffset = cursorY + yOffset;
			else
				relativeTo = anchorName;
			end
			if ( not xOffset or not yOffset ) then
				xOffset = 8;
				yOffset = 22;
			end
			if ( not point ) then
				point = "TOPLEFT";
			end
			if ( not relativePoint ) then
				relativePoint = "BOTTOMLEFT";
			end
			listFrame:SetPoint(point, relativeTo, relativePoint, xOffset, yOffset);
		else
			if ( not dropDownFrame ) then
				dropDownFrame = getglobal(UIDROPDOWNMENU_OPEN_MENU);
			end
			listFrame:ClearAllPoints();
			-- If this is a dropdown button, not the arrow anchor it to itself
			if ( strsub(this:GetParent():GetName(), 0,12) == "DropDownList" and strlen(this:GetParent():GetName()) == 13 ) then
				anchorFrame = this:GetName();
			else
				anchorFrame = this:GetParent():GetName();
			end
			listFrame:SetPoint("TOPLEFT", anchorFrame, "TOPRIGHT", 0, 0);
		end
		
		-- Change list box appearance depending on display mode
		if ( dropDownFrame and dropDownFrame.displayMode == "MENU" ) then
			getglobal(listFrameName.."Backdrop"):Hide();
			getglobal(listFrameName.."MenuBackdrop"):Show();
		else
			getglobal(listFrameName.."Backdrop"):Show();
			getglobal(listFrameName.."MenuBackdrop"):Hide();
		end

		UIDropDownMenu_Initialize(dropDownFrame, dropDownFrame.initialize, nil, level);
		-- If no items in the drop down don't show it
		if ( listFrame.numButtons == 0 ) then
			return;
		end

		-- Check to see if the dropdownlist is off the screen, if it is anchor it to the top of the dropdown button
		listFrame:Show();
		-- Hack since GetCenter() is returning coords relative to 1024x768
		local x, y = listFrame:GetCenter();
		-- Hack will fix this in next revision of dropdowns
		if ( not x or not y ) then
			listFrame:Hide();
			return;
		end
		-- Determine whether the menu is off the screen or not
		local offscreenY, offscreenX;
		if ( (y - listFrame:GetHeight()/2) < 0 ) then
			offscreenY = 1;
		end
		if ( listFrame:GetRight() > GetScreenWidth() ) then
			offscreenX = 1;	
		end
		
		--  If level 1 can only go off the bottom of the screen
		if ( level == 1 ) then
			if ( offscreenY and offscreenX ) then
				anchorPoint = "BOTTOMRIGHT";
				relativePoint = "BOTTOMLEFT";
			elseif ( offscreenY ) then
				anchorPoint = "BOTTOMLEFT";
				relativePoint = "TOPLEFT";
			elseif ( offscreenX ) then
				anchorPoint = "TOPRIGHT";
				relativePoint = "TOPLEFT";
			else
				anchorPoint = "TOPLEFT";
			end
			
			listFrame:ClearAllPoints();
			if ( anchorName == "cursor" ) then
				listFrame:SetPoint(anchorPoint, relativeTo, "BOTTOMLEFT", xOffset, yOffset);
			else
				listFrame:SetPoint(anchorPoint, relativeTo, relativePoint, xOffset, yOffset);
			end
		else
			local anchorPoint, relativePoint, offsetX, offsetY;
			if ( offscreenY and offscreenX ) then
				anchorPoint = "BOTTOMRIGHT";
				relativePoint = "BOTTOMLEFT";
				offsetX = -11;
				offsetY = -14;
			elseif ( offscreenY ) then
				anchorPoint = "BOTTOMLEFT";
				relativePoint = "BOTTOMRIGHT";
				offsetX = 0;
				offsetY = -14;
			elseif ( offscreenX ) then
				anchorPoint = "TOPRIGHT";
				relativePoint = "TOPLEFT";
				offsetX = -11;
				offsetY = 14;
			else
				anchorPoint = "TOPLEFT";
				relativePoint = "TOPRIGHT";
				offsetX = 0;
				offsetY = 14;
			end
			
			listFrame:ClearAllPoints();
			listFrame:SetPoint(anchorPoint, anchorFrame, relativePoint, offsetX, offsetY);
		end
	end
end

function CloseDropDownMenus(level)
	if ( not level ) then
		level = 1;
	end
	for i=level, UIDROPDOWNMENU_MAXLEVELS do
		getglobal("DropDownList"..i):Hide();
	end
end

function UIDropDownMenu_SetWidth(width, frame)
	if ( not frame ) then
		frame = this;
	end
	getglobal(frame:GetName().."Middle"):SetWidth(width);
	frame:SetWidth(width + 25 + 25);
	getglobal(frame:GetName().."Text"):SetWidth(width - 25);
	frame.noResize = 1;
end

function UIDropDownMenu_SetButtonWidth(width, frame)
	if ( not frame ) then
		frame = this;
	end
	
	if ( width == "TEXT" ) then
		width = getglobal(frame:GetName().."Text"):GetWidth();
	end
	
	getglobal(frame:GetName().."Button"):SetWidth(width);
	frame.noResize = 1;
end


function UIDropDownMenu_SetText(text, frame)
	if ( not frame ) then
		frame = this;
	end
	local filterText = getglobal(frame:GetName().."Text");
	filterText:SetText(text);
end

function UIDropDownMenu_GetText(frame)
	if ( not frame ) then
		frame = this;
	end
	local filterText = getglobal(frame:GetName().."Text");
	return filterText:GetText();
end

function UIDropDownMenu_ClearAll(frame)
	-- Previous code refreshed the menu quite often and was a performance bottleneck
	frame.selectedID = nil;
	frame.selectedName = nil;
	frame.selectedValue = nil;
	UIDropDownMenu_SetText("", frame);

	local button, checkImage;
	for i=1, UIDROPDOWNMENU_MAXBUTTONS do
		button = getglobal("DropDownList"..UIDROPDOWNMENU_MENU_LEVEL.."Button"..i);
		button:UnlockHighlight();

		checkImage = getglobal("DropDownList"..UIDROPDOWNMENU_MENU_LEVEL.."Button"..i.."Check");
		checkImage:Hide();
	end
end

function UIDropDownMenu_JustifyText(justification, frame)
	if ( not frame ) then
		frame = this;
	end
	local text = getglobal(frame:GetName().."Text");
	text:ClearAllPoints();
	if ( justification == "LEFT" ) then
		text:SetPoint("LEFT", frame:GetName().."Left", "LEFT", 27, 2);
	elseif ( justification == "RIGHT" ) then
		text:SetPoint("RIGHT", frame:GetName().."Right", "RIGHT", -43, 2);
	elseif ( justification == "CENTER" ) then
		text:SetPoint("CENTER", frame:GetName().."Middle", "CENTER", -5, 2);
	end
end

function UIDropDownMenu_SetAnchor(xOffset, yOffset, dropdown, point, relativeTo, relativePoint)
	if ( not dropdown ) then
		dropdown = this;
	end
	dropdown.xOffset = xOffset;
	dropdown.yOffset = yOffset;
	dropdown.point = point;
	dropdown.relativeTo = relativeTo;
	dropdown.relativePoint = relativePoint;
end

function UIDropDownMenu_GetCurrentDropDown()
	if ( UIDROPDOWNMENU_OPEN_MENU ) then
		return getglobal(UIDROPDOWNMENU_OPEN_MENU);
	end
	
	-- If no dropdown then use this
	return this;
end

function UIDropDownMenuButton_GetChecked()
	return getglobal(this:GetName().."Check"):IsVisible();
end

function UIDropDownMenuButton_GetName()
	return getglobal(this:GetName().."NormalText"):GetText();
end

function UIDropDownMenuButton_OpenColorPicker(button)
	CloseMenus();
	if ( not button ) then
		button = this;
	end
	UIDROPDOWNMENU_MENU_VALUE = button.value;
	ColorPickerFrame.func = button.swatchFunc;
	ColorPickerFrame.hasOpacity = button.hasOpacity;
	ColorPickerFrame.opacityFunc = button.opacityFunc;
	ColorPickerFrame.opacity = button.opacity;
	ColorPickerFrame:SetColorRGB(button.r, button.g, button.b);
	ColorPickerFrame.previousValues = {r = button.r, g = button.g, b = button.b, opacity = button.opacity};
	ColorPickerFrame.cancelFunc = button.cancelFunc;
	ShowUIPanel(ColorPickerFrame);
end

function UIDropDownMenu_DisableButton(level, id)
	getglobal("DropDownList"..level.."Button"..id):Disable();
end

function UIDropDownMenu_EnableButton(level, id)
	getglobal("DropDownList"..level.."Button"..id):Enable();
end

function UIDropDownMenu_SetButtonText(level, id, text, r, g, b)
	local button = getglobal("DropDownList"..level.."Button"..id);
	button:SetText(text);
	if ( r ) then
		button:SetTextColor(r, g, b);
		button:SetHighlightTextColor(r, g, b);
	end
end
