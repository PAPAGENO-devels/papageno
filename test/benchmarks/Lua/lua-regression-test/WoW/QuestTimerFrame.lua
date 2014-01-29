function QuestTimerFrame_OnLoad()
	this:RegisterEvent("QUEST_LOG_UPDATE");
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	this.numTimers = 0;
	this.updating = nil;
end

function QuestTimerFrame_OnEvent()
	if ( event == "QUEST_LOG_UPDATE" or event == "PLAYER_ENTERING_WORLD" ) then
		if ( not this.updating ) then
			QuestTimerFrame_Update(GetQuestTimers());
		end
	end
end

function QuestTimerFrame_Update(...)
	this.updating = 1;
	for i=1, arg.n, 1 do
		getglobal("QuestTimer"..i.."Text"):SetText(SecondsToTime(arg[i]));
		getglobal("QuestTimer"..i):Show();
	end
	for i=arg.n + 1, MAX_QUESTS, 1 do
		getglobal("QuestTimer"..i):Hide();
	end
	this.numTimers = arg.n;
	if ( arg.n > 0 ) then
		this:SetHeight(45 + (16 * arg.n));
		this:Show();
	else
		this:Hide();
	end
	this.updating = nil;
end

function QuestTimerFrame_OnUpdate()
	if ( this.numTimers > 0 ) then
		QuestTimerFrame_Update(GetQuestTimers());
	end
end

function QuestTimerButton_OnClick()
	ShowUIPanel(QuestLogFrame);
	QuestLog_SetSelection(GetQuestIndexForTimer(this:GetID()));
	QuestLog_Update();
end

function QuestTimerFrame_OnShow()
	UIParent_ManageFramePositions();
end

function QuestTimerFrame_OnHide()
	UIParent_ManageFramePositions();
end

--[[
function QuestTimerFrame_UpdatePosition()
	if ( MultiBarLeft:IsVisible() ) then
		QuestTimerFrame:SetPoint("TOP", "MinimapCluster", "BOTTOM", -75, 0);
	elseif ( MultiBarRight:IsVisible() ) then
		QuestTimerFrame:SetPoint("TOP", "MinimapCluster", "BOTTOM", -30, 0);
	else
		QuestTimerFrame:SetPoint("TOP", "MinimapCluster", "BOTTOM", 10, 0);
	end
end
]]