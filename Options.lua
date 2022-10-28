local addonName,addon=...
local config = addon.a

local version = GetAddOnMetadata(addonName, "Version") or 9999;
local author = GetAddOnMetadata(addonName, "Author") or "";

local server = GetRealmName()
local optionsPanel
local loaded = false

local y = 0

local function addCheckButton( name, text, tooltip, object, key, extraFunc )
	local o = optionsPanel.scrollChild
	o[ name ] = CreateFrame("CheckButton", nil, o, "UICheckButtonTemplate");
	o[ name ]:SetPoint("TOPLEFT", 30, y);
	o[ name ].text:SetText( text );
	o[ name ].text:SetFontObject("GameFontNormal")
	o[ name ]:SetScript("OnEnter", function(self) GameTooltip:SetOwner(self, "ANCHOR_RIGHT",0,-32);  GameTooltip:SetText( tooltip ); GameTooltip:Show() end)
	o[ name ]:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
	if object[ key ] then o[ name ]:SetChecked(true) end
	o[ name ]:SetScript("OnClick", function() object[ key ] = o[ name ]:GetChecked() if extraFunc then extraFunc() end end);
	y = y - 20
end

local function createSubTitle( o, name, text )
	y = y - 20
	--local o = optionsPanel.scrollChild
	o[ "subtitle_" .. name ] = o:CreateFontString(nil, o, "GameFontWhite" )
	o[ "subtitle_" .. name ]:SetText( text )
	o[ "subtitle_" .. name ]:SetPoint("TOPLEFT", 20, y )
	y = y - 20
end

local function buildOptions()
	if not loaded then
		loaded = true
		local oc = optionsPanel
		
		oc.title = oc:CreateFontString(nil, oc, "GameFontNormalLarge" )
		oc.title:SetText(addonName )
		oc.title:SetPoint("TOPLEFT",10,-10)
		
		oc.author = oc:CreateFontString(nil, oc, "GameFontDisable" )
		oc.author:SetText( string.gsub( PETITION_CREATOR, "%%s", author ) )
		oc.author:SetPoint("LEFT", oc.title, "RIGHT", 10, 0)
		
		oc.version = oc:CreateFontString(nil, oc, "GameFontDisable" )
		oc.version:SetText( GAME_VERSION_LABEL .. ": " .. version )
		oc.version:SetPoint("TOPRIGHT",-10,-10)
		
		oc.scrollFrame = CreateFrame( "ScrollFrame", "$parent_ScrollFrame", oc, "UIPanelScrollFrameTemplate" );
		oc.scrollFrame:SetHeight(200)
		oc.scrollBar = _G[oc.scrollFrame:GetName() .. "ScrollBar"];
		oc.scrollFrame:SetWidth( 200);
		oc.scrollFrame:SetPoint( "TOPLEFT", 10, -30 );
		oc.scrollFrame:SetPoint( "BOTTOMRIGHT", -30, 10 );

		oc.scrollChild = CreateFrame( "Frame", "$parent_ScrollChild", oc.scrollFrame );
		oc.scrollChild:SetWidth( oc.scrollFrame:GetWidth() );
		oc.scrollChild:SetAllPoints( oc.scrollFrame );
		oc.scrollFrame:SetScrollChild( oc.scrollChild );
		
		local o = oc.scrollChild
				
		createSubTitle( o, "general", GENERAL_LABEL .. ":" )
		addCheckButton( "mmShow", "Show Reputable's MiniMap icon", "", Reputable_Data.global, "mmShow", function() config:toggleMiniMap() end )
		addCheckButton( "ldbAuto", "Automatically watch last faction change", "For LDB and Blizzards Reputation Bar", Reputable_Data.global, "ldbAuto" )
		addCheckButton( "ldbAutoZone", "Automatically watch faction by zone", "For LDB and Blizzards Reputation Bar", Reputable_Data.global, "ldbAutoZone", function() config:switchingZones( "Option toggle" ) end )
		addCheckButton( "ldbUseBlizzRepBar", "Set Blizzards Reputation Bar to watched faction", "", Reputable_Data.global, "ldbUseBlizzRepBar", function() config:setWatchedFaction() end )
		addCheckButton( "repMultiplier", "Include multiplier in reputation gains (ie Humans 10% racial)", "", Reputable_Data.global, "repMultiplier" )
		addCheckButton( "repInQuestLog", "Show reputation reward in quest log", "", Reputable_Data.global, "repInQuestLog" )
		addCheckButton( "xpToolTip", "Show modified XP bar tooltip", "", Reputable_Data.global, "xpToolTip" )
		
		createSubTitle( o, "cframe", INTERFACE_OPTIONS  .. ":" )
		addCheckButton( "guiUseLocalTime", "Display daily reset time in Localtime", "Uncheck to display daily reset time in Servertime", Reputable_Data.global, "guiUseLocalTime", function() config:guiUpdate(true) end )
		addCheckButton( "guiShowNormalDaily", SHOW.." "..LFG_TYPE_DUNGEON.." "..DAILY, "", Reputable_Data.global, "guiShowNormalDaily", function() config:guiUpdate(true) end )
		addCheckButton( "guiShowHeroicDaily", SHOW.." "..LFG_TYPE_HEROIC_DUNGEON.." "..DAILY, "", Reputable_Data.global, "guiShowHeroicDaily", function() config:guiUpdate(true) end )
		addCheckButton( "guiShowCookingDaily", SHOW.." "..PROFESSIONS_COOKING.." "..DAILY, "", Reputable_Data.global, "guiShowCookingDaily", function() config:guiUpdate(true) end )
		addCheckButton( "guiShowWotlkCookingDaily", SHOW.." "..PROFESSIONS_COOKING.." Wotlk "..DAILY, "", Reputable_Data.global, "guiShowWotlkCookingDaily", function() config:guiUpdate(true) end )
		addCheckButton( "guiShowFishingDaily", SHOW.." "..PROFESSIONS_FISHING.." "..DAILY, "", Reputable_Data.global, "guiShowFishingDaily", function() config:guiUpdate(true) end )
		addCheckButton( "guiShowWotlkFishingDaily", SHOW.." "..PROFESSIONS_FISHING.." Wotlk "..DAILY, "", Reputable_Data.global, "guiShowWotlkFishingDaily", function() config:guiUpdate(true) end )
		addCheckButton( "guiShowPvPDaily", SHOW.." "..PVP.." "..DAILY, "", Reputable_Data.global, "guiShowPvPDaily", function() config:guiUpdate(true) end )
		
		createSubTitle( o, "cframe", CHAT_FRAME_SETTINGS .. ":" )
		addCheckButton( "cframeShowRewards", "Show an item's rewards in chat when an item is linked by itself", "", Reputable_Data.global, "cframeShowRewards" )
		addCheckButton( "cframeHideOriginal", "Hide default blizzard chatframe reputation messages", "", Reputable_Data.global, "cframeHideOriginal" )
		addCheckButton( "cframeEnabled", "Show Reputables modified reputation changes in chat", "", Reputable_Data.global, "cframeEnabled" )
		addCheckButton( "cframeColourize", "Add colour to reputation standings", "", Reputable_Data.global, "cframeColourize" )
		
		local chatframe = Reputable_Data.global.cframeOutputNum
		o.dropDown = CreateFrame("FRAME", "ReputableCFrameDD", o, "UIDropDownMenuTemplate")
		o.dropDown:SetPoint("TOPLEFT", 17, y - 10);
		o.dropDown.text = o:CreateFontString(nil, o, "GameFontNormal" )
		o.dropDown.text:SetPoint("LEFT", o.dropDown, "RIGHT", -10, 3);
		o.dropDown.text:SetText("Output chatframe");
		UIDropDownMenu_SetWidth(o.dropDown, 200)
		UIDropDownMenu_SetText(o.dropDown, "ChatFrame".. chatframe .. " (" .. getglobal("ChatFrame".. chatframe).name .. ")")

		UIDropDownMenu_Initialize(o.dropDown, function(self, level, menuList)
			local info = UIDropDownMenu_CreateInfo()
			info.func = self.SetValue
			for i = 1, NUM_CHAT_WINDOWS do
				info.text, info.arg1, info.checked = "Chatframe".. i .. " (" .. getglobal("ChatFrame"..i).name .. ")", i, i == chatframe
				UIDropDownMenu_AddButton(info)	
			end
		end)
		function o.dropDown:SetValue(newValue)
			chatframe = newValue
			UIDropDownMenu_SetText(o.dropDown, "ChatFrame".. chatframe .. " (" .. getglobal("ChatFrame".. chatframe).name .. ")")
			Reputable_Data.global.cframeOutputNum = chatframe
			getglobal("ChatFrame".. chatframe):AddMessage("Reputable will output to this ChatFrame",0.5,0.5,1)
		end
		y = y - 40
		
		createSubTitle( o, "tooltips", "Tooltips:" )
		addCheckButton( "mmTooltipShowAvailableDailies", "Show available dailies on minimap/LDB tooltip", "", Reputable_Data.global, "mmTooltipShowAvailableDailies" )
		addCheckButton( "mmTooltipShowOperations", "Show mouse operations on minimap/LDB tooltip", "", Reputable_Data.global, "mmTooltipShowOperations" )
		addCheckButton( "ttShowChatItemsOnMouseOver", "Show item tooltips on hyperlink mouseover", "", Reputable_Data.global, "ttShowChatItemsOnMouseOver" )
		addCheckButton( "ttShowRewards", "Show rewards from items & tokens in a secondary tooltip", "", Reputable_Data.global, "ttShowRewards" )
		addCheckButton( "ttShowJunk", "Add note to no longer needed quest items", "", Reputable_Data.global, "ttShowJunk" )
		addCheckButton( "ttShowFaction", "Show faction associated with item at top of tooltip", "", Reputable_Data.global, "ttShowFaction" )
		addCheckButton( "ttShowRepGain", "Show reputation gained from item at top of tooltip", "", Reputable_Data.global, "ttShowRepGain" )
		addCheckButton( "ttShowStanding", "Show current characters standing at top of tooltip", "", Reputable_Data.global, "ttShowStanding" )
		addCheckButton( "ttShowCurrentInList", "Show current character in the tooltip list", "", Reputable_Data.global, "ttShowCurrentInList" )
		addCheckButton( "ttShowList", "Show other characters in the tooltip list", "", Reputable_Data.global, "ttShowList" )
		createSubTitle( o, "questie", "Questie:" )
		addCheckButton( "ttQuestieAddAlts", "Add alts to Questie tooltips", "", Reputable_Data.global, "ttQuestieAddAlts" )
		addCheckButton( "ttQuestieShowOnMouseOver", "Show quest tooltip on Questie hyperlink mouseover", "", Reputable_Data.global, "ttQuestieShowOnMouseOver" )
		
		createSubTitle( o, "chars", "Show these " .. server .. " characters on tooltips:" )
		for key,show in pairs( Reputable_Data.global.profileKeys ) do
			local k  = Reputable_Data[key]
			if k.profile and server == k.profile.server then
				local color = "|c" .. RAID_CLASS_COLORS[k.profile.class].colorStr
				addCheckButton( "Show-".. key, color..k.profile.name .. " |r(Level ".. k.profile.level ..")", "", Reputable_Data.global.profileKeys, key )
			end
		end
		
		o:SetHeight( 30 - y );
	end
end

function config:initOptions()
	optionsPanel = CreateFrame("FRAME")
	optionsPanel.name = addonName
	optionsPanel.refresh = function( self ) buildOptions() end
	InterfaceOptions_AddCategory(optionsPanel)
end