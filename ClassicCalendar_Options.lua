local AddonName, AddonTable = ...
local L = CLASSIC_CALENDAR_L
local AddonTitle = C_AddOns.GetAddOnMetadata(AddonName, "Title")

local localeString = tostring(GetLocale())
local localeStringOptions
local CCOptions = CreateFrame("Frame")
CCOptions:RegisterEvent("ADDON_LOADED")
CCOptions:RegisterEvent("VARIABLES_LOADED")

function GoToCCSettings(msg, editbox)
	if msg == "" or msg == nil then
		InterfaceOptionsFrame_OpenToCategory(AddonTitle)
		InterfaceOptionsFrame_OpenToCategory(AddonTitle) -- Second call works around the issue detailed at Stanzilla/WoWUIBugs/issues/89
	end
end

local function CCOptionsHandler(self, event, arg1)
	-- If SavedVariable is not set, default settings
	if event == "ADDON_LOADED" then
		if CCConfig == nil or CCConfig == "" then
			CCConfig = {
				["BattlegroundsArt"] = false,
				["ChildrensWeekArt"] = false,
				["FireworksSpectacularArt"] = true,
				--["Dropdown"] = "Value1",
			}
		end
	end

	if event == "VARIABLES_LOADED" then
		SlashCmdList["CCCONFIG"] = GoToCCSettings;
		SLASH_CCCONFIG1, SLASH_CCCONFIG2 = "/caloptions", "/calendaroptions"
	end
end

CCOptions:SetScript("OnEvent", CCOptionsHandler)

-- Checks localizations for Options and returns "enUS" if none exist

local function checkLocale()
	for _, v in next, L.Options[localeString] do
		if v == "" then
			localeStringOptions = "enUS"
			break
		end
		localeStringOptions = localeString
	end
end

-- Runs function above

checkLocale()

-- INTERFACE OPTIONS (starts building the frame now)

local CCIOFrame = CreateFrame("Frame")
CCIOFrame.name = AddonTitle

local InterfaceOptionsFramePanelContainerWidth = InterfaceOptionsFramePanelContainer:GetWidth()

-- Header

local lblTitle = CCIOFrame:CreateFontString(nil, nil, "GameFontHighlight")
lblTitle:SetFont("Fonts\\FRIZQT__.TTF", 16)
lblTitle:SetPoint("TOPLEFT", CCIOFrame, "TOPLEFT", 12, -12)
lblTitle:SetText("|cFFEFC502" .. AddonTitle .. " (v" .. C_AddOns.GetAddOnMetadata(AddonName, "Version") .. ")|r")

-- HR line for Art options
local hrLine1_p1 = CCIOFrame:CreateLine()
hrLine1_p1:SetColorTexture(0.5, 0.5, 0.5)
hrLine1_p1:SetThickness(1)
hrLine1_p1:SetStartPoint("TOPLEFT", lblTitle, 0, -32)
hrLine1_p1:SetEndPoint("TOPLEFT", lblTitle, (InterfaceOptionsFramePanelContainerWidth/2)-20, -32)

local hrLineText = CCIOFrame:CreateFontString(nil, nil, "GameFontHighlight")
hrLineText:SetFont("Fonts\\FRIZQT__.TTF", 14)
hrLineText:SetPoint("CENTER", hrLine1_p1, "LEFT", (InterfaceOptionsFramePanelContainerWidth/2), 0)
hrLineText:SetText("|cFFEFC502Art|r")

local hrLine1_p2 = CCIOFrame:CreateLine()
hrLine1_p2:SetColorTexture(0.5, 0.5, 0.5)
hrLine1_p2:SetThickness(1)
hrLine1_p2:SetStartPoint("TOPLEFT", hrLine1_p1, (InterfaceOptionsFramePanelContainerWidth/2)+20, 0)
hrLine1_p2:SetEndPoint("TOPLEFT", hrLine1_p1, InterfaceOptionsFramePanelContainerWidth, 0)

-- PVP weekends

local chkIOUsePVPArts = CreateFrame("CheckButton", nil, CCIOFrame, "OptionsBaseCheckButtonTemplate")
chkIOUsePVPArts:SetPoint("TOPLEFT", hrLine1_p1, "BOTTOMLEFT", 0, -16)

chkIOUsePVPArts:SetScript("OnUpdate", function(frame)
	chkIOUsePVPArts:SetChecked(CCConfig.BattlegroundsArt)
end)

chkIOUsePVPArts:SetScript("OnClick", function(frame)
	CCConfig.BattlegroundsArt = frame:GetChecked()
end)

local chkIOUsePVPArtsText = CCIOFrame:CreateFontString(nil, nil, "GameFontHighlight")
chkIOUsePVPArtsText:SetPoint("LEFT", chkIOUsePVPArts, "RIGHT", 0, 1)
chkIOUsePVPArtsText:SetText(L.Options[localeStringOptions]["PVPArtText"])

-- Childrens Week

local chkIOShowChildrensWeek = CreateFrame("CheckButton", nil, CCIOFrame, "OptionsBaseCheckButtonTemplate")
chkIOShowChildrensWeek:SetPoint("TOPLEFT", chkIOUsePVPArts, "BOTTOMLEFT", 0, -8) -- Second arguement is the previous local variable name

chkIOShowChildrensWeek:SetScript("OnUpdate", function(frame)
	chkIOShowChildrensWeek:SetChecked(CCConfig.ChildrensWeekArt)
end)

chkIOShowChildrensWeek:SetScript("OnClick", function(frame)
	CCConfig.ChildrensWeekArt = frame:GetChecked()
end)

local chkIOShowChildrensWeekText = CCIOFrame:CreateFontString(nil, nil, "GameFontHighlight")
chkIOShowChildrensWeekText:SetPoint("LEFT", chkIOShowChildrensWeek, "RIGHT", 0, 1)
chkIOShowChildrensWeekText:SetText(L.Options[localeStringOptions]["ChildrensWeekText"])

-- Fireworks Spectacular

local chkIOShowFireworksSpectacular = CreateFrame("CheckButton", nil, CCIOFrame, "OptionsBaseCheckButtonTemplate")
chkIOShowFireworksSpectacular:SetPoint("TOPLEFT", chkIOShowChildrensWeek, "BOTTOMLEFT", 0, -8) -- Second arguement is the previous local variable name

chkIOShowFireworksSpectacular:SetScript("OnUpdate", function(frame)
	chkIOShowFireworksSpectacular:SetChecked(CCConfig.FireworksSpectacularArt)
end)

chkIOShowFireworksSpectacular:SetScript("OnClick", function(frame)
	CCConfig.FireworksSpectacularArt = frame:GetChecked()
end)

local chkIOShowFireworksSpectacularText = CCIOFrame:CreateFontString(nil, nil, "GameFontHighlight")
chkIOShowFireworksSpectacularText:SetPoint("LEFT", chkIOShowFireworksSpectacular, "RIGHT", 0, 1)
chkIOShowFireworksSpectacularText:SetText(L.Options[localeStringOptions]["FireworksSpectacularText"])

-- HR line for Footer

local hrLine2 = CCIOFrame:CreateLine()
hrLine2:SetColorTexture(0.5, 0.5, 0.5)
hrLine2:SetThickness(1)
hrLine2:SetStartPoint("TOPLEFT", chkIOShowFireworksSpectacular, 0, -41)
hrLine2:SetEndPoint("TOPLEFT", chkIOShowFireworksSpectacular, InterfaceOptionsFramePanelContainerWidth, -41)

-- Discord Info

local DiscordLogo = CCIOFrame:CreateTexture(nil, "OVERLAY")
DiscordLogo:SetPoint("TOPLEFT", hrLine2, "BOTTOMLEFT", 0, -16) -- Second arguement is the previous local variable name
DiscordLogo:SetSize(16, 16)
DiscordLogo:SetTexture("Interface\\AddOns\\ClassicCalendar\\Textures\\DiscordLogo.tga")

local lblDiscord = CCIOFrame:CreateFontString(nil, nil, "GameFontHighlight")
lblDiscord:SetPoint("LEFT", DiscordLogo, "RIGHT", 4, 0)
lblDiscord:SetText("|cFFEFC502https://discord.gg/CMxKsBQFKp|r")

InterfaceOptions_AddCategory(CCIOFrame);
