local addonName, addon = ...
local Reputable = addon.a

local debug = Reputable.debug

local version = GetAddOnMetadata(addonName, "Version") or 9999;
local author = GetAddOnMetadata(addonName, "Author") or "";

local LDB = LibStub("LibDataBroker-1.1")
local reputableDataBroker = nil
local reputableMM = nil
local reputableMinimapIcon = LibStub("LibDBIcon-1.0")

local playerFaction = UnitFactionGroup("player")
local playerName = UnitName("player")
local server = GetRealmName()
local level = UnitLevel("player")

Reputable.waitingForItemHTML = {}

function Reputable:loadHTML( pageName )
	Reputable:addonMessage()
	if pageName then
		if pageName == 'attune560' then pageName = 'attune269' end -- Send both CoT dungeons to the same page
		Reputable.tabOpen = pageName
	end
	
	--debug("Showing page", Reputable.tabOpen)

	local htmlObj = Reputable.guiTabs[ Reputable.tabOpen ].html
	local main = htmlObj.header
	local right = "<html><body><h1><br/></h1><br/>"
	local tab1 = "<html><body><h1><br/></h1><br/>"

	for i = 1, htmlObj.i - 1 do
		local leftLine = "<br/>"
		local rightLine = "<br/>"
		local tabLine = "<br/>"
		if htmlObj.main[i].tab then tabLine = htmlObj.main[i].text
		else leftLine = htmlObj.main[i].text end
		if htmlObj.right[i] and htmlObj.iRight >= i then rightLine = htmlObj.right[i] end
		
		main = main .. "<" .. htmlObj.main[i].tag .. ">" .. leftLine .. "</" .. htmlObj.main[i].tag .. ">"
		right = right .. "<" .. htmlObj.main[i].tag .. " align='right'>" .. rightLine .. "</" .. htmlObj.main[i].tag .. ">"
		tab1 = tab1 .. "<" .. htmlObj.main[i].tag .. ">" .. tabLine .. "</" .. htmlObj.main[i].tag .. ">"
	end
	
	Reputable.gui.html_main:SetText( main .. "</body></html>" )
	Reputable.gui.html_right:SetText( right .. "</body></html>" )
	Reputable.gui.html_tab1:SetText( tab1 .. "</body></html>" )
end

local function createSubTitle( frame, name, text )
	frame.y = frame.y - 10
	frame[ "subtitle_" .. name ] = frame:CreateFontString(nil, frame, "GameFontNormal" )
	frame[ "subtitle_" .. name ]:SetText( text )
	frame[ "subtitle_" .. name ]:SetPoint("TOPLEFT", 10, frame.y )
	frame.y = frame.y - 20
end
local function createMenuBTN( frame, name, text )
	frame[ "menuBTN_" .. name ] = CreateFrame('Button', name, frame, "OptionsListButtonTemplate")
	frame[ "menuBTN_" .. name ].name = name
	frame[ "menuBTN_" .. name ]:SetText( text )
	frame[ "menuBTN_" .. name ]:SetNormalFontObject( "GameFontWhiteSmall" )
	frame[ "menuBTN_" .. name ]:SetPoint("TOPLEFT", 20, frame.y )
	frame[ "menuBTN_" .. name ]:SetScript("OnClick", function(self) Reputable:loadHTML(self.name) end )
	frame.y = frame.y - 20
end

function Reputable:addLineToHTML( page, tag, text, tab, i )
	local index = page.i
	if i then index = i end
	if not page.main[ index ] then page.main[ index ] = {} end
	
	page.main[ index ].tag = tag
	page.main[ index ].text = text
	page.main[ index ].tab = tab
	
	if not i then page.i = index + 1 end
end

function Reputable:tryMakeItemLink( itemID, cat, page, i, icon, pre, post )
	if not pre then pre = "" end
	if not post then post = "" end
	local link = Reputable:createLink( "item" , itemID, nil, nil, nil, nil )
	local haveItem = ""
	if icon then haveItem = Reputable:icons( GetItemCount( itemID, true ), -9 ) end
	local returnLink = pre .. "|cff9d9d9d|Hitem:" .. itemID .. "::::::::::::|h[Item: " .. itemID .. "]|h|r" .. haveItem .. post
	if link ~= nil then
		returnLink = pre .. link .. haveItem .. post
	else
		if not Reputable.waitingForItemHTML[itemID] then Reputable.waitingForItemHTML[itemID] = {} end
		tinsert( Reputable.waitingForItemHTML[itemID], { cat, page, i, icon, pre, post } )
	end
	if page == "right" then
		Reputable.guiTabs[ cat ].html[ page ][ i ] = returnLink
	else
		local tab
		if page == 'tab' then tab = true end
		Reputable:addLineToHTML( Reputable.guiTabs[ cat ].html, "p", returnLink, tab, nil )
		
	end
	return returnLink
end

function Reputable:tryMakeQuestLink( questID, cat, page, i, icon, pre, post, done)
	if not pre then pre = "" end
	if not post then post = "" end
	local link = Reputable:createLink( "quest" , questID, nil, nil, nil, nil )
	local doneQuest = ""
	if icon then
		doneQuest = Reputable:icons( done, -9 )
	end
	local returnLink = pre .. link .. "|r" .. doneQuest .. post
	if page == "right" then
		Reputable.guiTabs[ cat ].html[ page ][ i ] = returnLink
	else
		local tab
		if page == 'tab' then tab = true end
		Reputable:addLineToHTML( Reputable.guiTabs[ cat ].html, "p", returnLink, tab, nil )

	end
	return returnLink
end

local tbcFactionList = {
	{ faction =  946 },
	{ faction =  947 },
	{ faction =  942 },
	{ faction = 1011 },
	{ faction =  933 },
	{ faction =  989 },
	{ faction =  935 },
	{ faction =  967 },
	{ faction =  970 },
	{ faction =  978 },
	{ faction =  941 },
	{ faction = 1012 },
	{ faction =  934 },
	{ faction =  932 },
	{ faction = 1031 },
	{ faction = 1038 },
	{ faction = 1015 },
	{ faction = 1077 },
}

local classicFactionList = {
	{ faction = 529	},	-- Arengt Dawn
--	{ faction = 87	},	-- Bloodsail Buccaneers
	{ faction = 21	},	-- Booty Bay
	{ faction = 910	},	-- Brood of Nozdormu
	{ faction = 609	},	-- Cenarion Circle
--	{ faction = 909	},	-- Darkmoon Faire
	{ faction = 530	},	-- Darkspear Trolls
	{ faction = 69	},	-- Darnassus
--	{ faction = 510	},	-- The Defilers	(pvp)
	{ faction = 577	},	-- Everlook
	{ faction = 930	},	-- Exodar
--	{ faction = 729	},	-- Frostwolf Clan	(pvp)
	{ faction = 369	},	-- Gadgetzan
	{ faction = 54	},	-- Gnomeregan Exiles
--	{ faction = 749	},	-- Hydraxian Waterlords
	{ faction = 47	},	-- Ironforge
--	{ faction = 509	},	-- The League of Arathor	(pvp)
	{ faction = 76	},	-- Orgrimmar
	{ faction = 470	},	-- Ratchet
--	{ faction = 349	},	-- Ravenholdt	(Rogue)
--	{ faction = 809	},	-- Shen'dralar	(Dire Maul)
	{ faction = 911	},	-- Silvermoon City
--	{ faction = 890	},	-- Silverwing Sentinels	(pvp)
--	{ faction = 730	},	-- Stormpike Gaurd	(pvp)
	{ faction = 72	},	-- Stormwind
	{ faction = 59	},	-- Thorium Brotherhood
	{ faction = 81	},	-- Thunder Bluff
	{ faction = 576	},	-- Timbermaw Hold
	{ faction = 68	},	-- Undercity
--	{ faction = 889	},	-- Warsong Outriders	(pvp)
--	{ faction = 589	},	-- Wintersaber Trainers
	{ faction = 270	},	-- Zandalar Tribe
}

local wotlkFactionList = {
	-- Alliance
	{ faction = 1037 }, --Allance Vanguard
	{ faction = 1050 }, --Valiance Expedition
	{ faction = 1068 }, --Explorers' League
	{ faction = 1126 }, --The Frostborn
	{ faction = 1094 }, --The Silver Covenant
	-- Horde
	{ faction = 1052 }, --Horde Expedition
	{ faction = 1085 }, --Warsong Offensive
	{ faction = 1067 }, --The Hand of Vengeance
	{ faction = 1064 }, --The Taunka
	{ faction = 1124 }, --The Sunreavers
	-- Both
	{ faction = 1090 }, --Kirin Tor
	{ faction = 1091 }, --The Wyrmrest Accord
	{ faction = 1098 }, --Knights of the Ebon Blade
	{ faction = 1106 }, --Argent Crusade
	{ faction = 1119 }, --The Sons of Hodir
	{ faction = 1073 }, --The Kalu'ak
	{ faction = 1104 }, --Frenzyheart Tribe
	{ faction = 1105 }, --The Oracles
	
	-- { faction = 1097	] = { name = "Wrath of the Lich King" },
	-- { faction = 1117	] = { name = "Sholazar Basin" },
	-- { faction = 1118	] = { name = "Classic" },	
}

local wotlkFactionPages = {}
for _,f in ipairs( wotlkFactionList ) do
	wotlkFactionPages[ f.faction ] = true
	table.insert(Reputable.guiTabs, {faction = f.faction, cat = 2} )
end

local tbcFactionPages = {}
for _,f in ipairs( tbcFactionList ) do
	tbcFactionPages[ f.faction ] = true
	table.insert(Reputable.guiTabs, {faction = f.faction, cat = 3} )
end

local classicFactionPages = {}
for _,f in ipairs( classicFactionList ) do
	--print( k,v, classicFactionList[ k ].faction )
	--print( f.faction)
	classicFactionPages[ f.faction ] = true
	table.insert(Reputable.guiTabs, {faction = f.faction, cat = 4} )
end

local classicAttunePages = {}
for instanceID in pairs( Reputable.attunements ) do
	classicAttunePages[ instanceID ] = true
	table.insert(Reputable.guiTabs, {instance = instanceID, cat = 6} )
end
	
local htmlLayers = {
	["main"]  = { margin = { 20,  0 } },
	["tab1"]  = { margin = { 40,  0 } },
	["right"] = { margin = {  0, 20 } },
}

function Reputable:addDungeonToHTML( thisPage, dungeonID, limit, pre, post )
	local showNormal = true
	local showHeroic = true
	if not pre then pre = "" end
	if not post then post = "" end
	if limit == 0 then showHeroic = false
	elseif limit == 1 then showNormal = false end
	local d = Reputable.instance[ dungeonID ]
	local icon
	if d.icon then icon = "|TInterface\\AddOns\\Reputable\\icons\\" .. d.icon .. ":12:12:0:-10:64:64:5:59:5:59|t " end
	if d.accessKey and thisPage.pagetype ~= "attunement" then	
		Reputable:tryMakeItemLink( d.accessKey, thisPage.name, "right", thisPage.i, true, nil, nil )
		thisPage.iRight = thisPage.i
	end
	local levelLock = '' local accessKeyLock = '' local heroicKeyLock = '' local accessQuestLock = '' local allLocks = ''
	local colour, levelTooLow, levelString, requiredQuestComplete, accessKeyMissing, heroicKeyMissing = Reputable:getInstanceInfo( dungeonID, false, nil )
	if accessKeyMissing then accessKeyLock = Reputable:icons( 'lock', -9 ) end
	if requiredQuestComplete == false then accessQuestLock = Reputable:icons( 'lock', -9 ) end
	allLocks = " "..levelLock .. accessKeyLock .. accessQuestLock
	if showNormal then
		Reputable:addLineToHTML( thisPage, "p", pre..Reputable:createLink( "instance" , dungeonID, false, nil, icon, nil )..allLocks..post, true, nil )
	end
	if d.heroic and showHeroic then
		local colour, levelTooLow, levelString, requiredQuestComplete, accessKeyMissing, heroicKeyMissing = Reputable:getInstanceInfo( dungeonID, true, nil )
		if heroicKeyMissing then heroicKeyLock = Reputable:icons( 'lock', -9 ) end
		allLocks = " "..levelLock .. heroicKeyLock .. accessKeyLock .. accessQuestLock
		if d.accessKey and thisPage.pagetype ~= "attunement" then
			Reputable:tryMakeItemLink( d.accessKey, thisPage.name, "right", thisPage.i, true, nil, nil )
			thisPage.iRight = thisPage.i
		end
		if d.heroicQuest and thisPage.pagetype ~= "attunement" then
			Reputable:tryMakeQuestLink( d.heroicQuest, thisPage.name, "right", thisPage.i, true, nil, nil, requiredQuestComplete)
			thisPage.iRight = thisPage.i
		end
		Reputable:addLineToHTML( thisPage, "p", pre..Reputable:createLink( "instance" , dungeonID, true, nil, icon, nil )..allLocks..post, true, nil )
	end
end

local function makeDungeonHTMLlist ()
	for _, zoneInfo in ipairs ( Reputable.instanceZones ) do
		local cat = zoneInfo.cat
			--Reputable.guiTabs[ zoneInfo.cat ].html
			--makeDungeonHTMLlist ( zoneInfo.cat, zoneInfo )
		
		local thisPage = Reputable.guiTabs[ cat ].html
		local factionID = zoneInfo.faction
		if type(factionID) == 'table' then factionID = zoneInfo.faction[ playerFaction ] end
		local factionPage = false
		if Reputable.guiTabs[ "faction"..factionID] then factionPage = Reputable.guiTabs[ "faction"..factionID].html end
		local factionLink = Reputable:createLink( "faction" , factionID, nil, nil, nil, nil )
		local heroicKey = zoneInfo.heroicKey
		if heroicKey then
			if type(heroicKey) == 'table' then heroicKey = heroicKey[ playerFaction ] end
			Reputable:tryMakeItemLink( heroicKey, cat, "right", thisPage.i, true, nil, nil )
			thisPage.iRight = thisPage.i
			if factionPage then
				Reputable:tryMakeItemLink( heroicKey, factionPage.name, "right", factionPage.i, true, nil, nil )
				factionPage.iRight = factionPage.i
			end
		end
		if factionPage then
			if Reputable.factionInfo[ factionID ] and Reputable.factionInfo[ factionID ].iz then
				Reputable:addLineToHTML( factionPage, "p", Reputable.instanceZones[ Reputable.factionInfo[ factionID ].iz ].name .. " " .. factionLink, nil, nil )
			end
		end
		Reputable:addLineToHTML( Reputable.guiTabs[cat].html, "p", zoneInfo.name .. " " .. factionLink, nil, nil )
		for _, dungeonID in ipairs ( zoneInfo.dungeons ) do
			Reputable:getInstanceStatus( dungeonID )
			Reputable:addDungeonToHTML( thisPage, dungeonID, 2, nil, nil )
			if factionPage then
				local d = Reputable.instance[ dungeonID ]
				if d.rep and d.rep.normal.rep and d.rep.normal.rep > 0 then
					Reputable:addDungeonToHTML( factionPage, dungeonID, 2, nil, nil )
				else
					Reputable:addDungeonToHTML( factionPage, dungeonID, 1, nil, nil )
				end
			end
		end
		if factionPage then Reputable:addLineToHTML( factionPage, "p", "<br/>", nil, nil ) end
		Reputable:addLineToHTML( Reputable.guiTabs[zoneInfo.cat].html, "p", "<br/>", nil, nil )
	end
end
	
function Reputable:addQuestToHTML( page, questID, repInc, factionID, showLocation )
	local q = Reputable.questInfo[ questID ]
	if q then
		if q[2] ~= Reputable.notFactionInt[ playerFaction ] then
	--	if q[2] ~= Reputable.notFactionInt[ playerFaction ] or debug() then
			local levelColor, complete, inProgress, progressIcon, levelMin, levelTooLow, levelString, minF, minR, maxF, maxR, repTooLow, repTooHigh, requiredQuestComplete = Reputable:getQuestInfo( questID, nil, factionID )
			local extraInfo = Reputable.extraQuestInfo[ questID ]
			local repStr = ""
			local repstringColour = "|cFF8080FF"
			if Reputable.ignoredQuestsForRep and Reputable.ignoredQuestsForRep[questID] then repstringColour ="|cff808080" end
			if repInc and repInc > 0 then repStr = repstringColour .." +" .. Reputable:repWithMultiplier( repInc, nil ).. "|r" end
			if extraInfo and extraInfo.item then
				Reputable:tryMakeItemLink( extraInfo.item, page.name, "right", page.i, nil, nil, nil )
				page.iRight = page.i
			end

			local progress = ''
			if inProgress then
				progress = "|cFFCCCCCC •"..QUEST_TOOLTIP_ACTIVE.."|r "
			end
			local showThisDaily = true
			if q[13] == 1 then
				if complete then progress = "|cFF00FF00 •"..format(ACHIEVEMENT_META_COMPLETED_DATE,HONOR_TODAY) .."|r " end
			end
			if q[12] == 1 then
				if not ( Reputable_Data.global.guiShowExaltedDailies or not repTooHigh ) then
					showThisDaily = false
				end
			end
			if page.name == "dailies" then
				if showThisDaily then
					if factionID and not page.dailyFactionHeader[factionID] then
						page.dailyFactionHeader[factionID] = true
						Reputable:addLineToHTML( page, "p", "<br/>", nil, nil )
						local reputationString = Reputable:getRepString( Reputable_Data[Reputable.profileKey].factions[factionID] )
						Reputable:addLineToHTML( page, "p", Reputable:createLink( "faction", factionID, nil, nil, nil, nil ) .. " " .. reputationString, nil, nil )
					end
				end
			end
			
			if showLocation  then
				local locationColour = "|cffffffff"
				if complete then locationColour = "|cff808080" end
			--	repStr = locationColour .. ( C_Map.GetAreaInfo( q[6] ) or "" ) .."|r"
				
				page.right[ page.i ] = locationColour .. ( C_Map.GetAreaInfo( q[6] ) or "" ) .."|r"
				page.iRight = page.i
				--if debug() then repStr = questID.."||"..q[2].."||".. repStr end
			end
			
			if showThisDaily and ( Reputable_Data.global.guiShowCompletedQuests or not complete ) then
			--	if debug() then repStr = repStr.." || "..q[6] end
				Reputable:addLineToHTML( page, "p", Reputable:icons( progressIcon, -9 ) .. " " .. Reputable:createLink( "quest" , questID,nil,nil,nil,factionID, -8 ) .. repStr .. progress, true, nil )
				page.lastWasHeader = false
			end
		end
	else
		debug("Quest ".. questID .. " missing from questDB")
	end
end

local function addPlayerToDailiesPage( key, show )
	if show then
		local k = Reputable_Data[key]
		if 	k.profile and server == k.profile.server then
			local color = "|c"..RAID_CLASS_COLORS[k.profile.class].colorStr
			local dailyCount, dailyList = Reputable:getDailyCount( key )
		--	if dailyList ~= "" then debug( key, dailyList ) end
			if dailyCount > 0 or key == Reputable.profileKey then
				local line = "|cffffff00("..dailyCount.." / "..GetMaxDailyQuests()..")|r ".. color..k.profile.name.."|r"
			--	if dailyList ~= "" then line = "|Hreputable:dailiesList:"..key.."|h"..line.."|h" end
				line = "|Hreputable:dailiesList:"..key.."|h"..line.."|h"
				Reputable:addLineToHTML( Reputable.guiTabs[ "dailies" ].html, "p", line, true, nil )
			end
		end
	end
end

local function makeDataForAllPages()
	
	for _,htmlObj in pairs( Reputable.guiTabs ) do
		if htmlObj.html then
			htmlObj.html.i = 1
			htmlObj.html.right = {}
			htmlObj.html.iRight = 3
		end
	--	if htmlObj.right then
		--	htmlObj.html.i = 1
	--	end
	end
	debug( "makeDataForAllPages() fired")
	
	--for _, zoneInfo in ipairs ( Reputable.instanceZones ) do
		--Reputable.guiTabs[ zoneInfo.cat ].html
		--makeDungeonHTMLlist ( zoneInfo.cat, zoneInfo )
	--end
	
	makeDungeonHTMLlist()
	
	local dailiesPage = Reputable.guiTabs[ "dailies" ].html
	dailiesPage.dailyFactionHeader = {}

	if GetDailyQuestsCompleted() >= GetMaxDailyQuests() then 
		Reputable:addLineToHTML( dailiesPage, "p", "|cFFFF0000"..NO_DAILY_QUESTS_REMAINING.."|r", nil, nil )
	end
	
	local timestamp = time() + GetQuestResetTime() + 1
	if not Reputable_Data.global.guiUseLocalTime then
		local st = C_DateAndTime.GetCurrentCalendarTime() -- server
		st.day = st.monthDay
		st.min = st.minute
		timestamp = math.floor( ( time(st) + GetQuestResetTime() + 1 ) / 3600 + 0.5 ) * 3600
	end
	
	Reputable.guiTabs[ "dailies" ].html.right[ 1 ] = DAILY.." "..RESET.." "..date(TIMESTAMP_FORMAT_HHMM_AMPM, timestamp )
	if Reputable_Data.global.dailyDungeons[ server ].dailyChangeOffset ~= 0 then
		Reputable.guiTabs[ "dailies" ].html.right[ 2 ] = DAILY.." "..COMMUNITIES_CREATE_DIALOG_ICON_SELECTION_BUTTON.." "..date(TIMESTAMP_FORMAT_HHMM_AMPM, timestamp + 3600 * Reputable_Data.global.dailyDungeons[ server ].dailyChangeOffset )
	end
	
	addPlayerToDailiesPage( Reputable.profileKey, Reputable_Data.global.ttShowCurrentInList and Reputable_Data.global.profileKeys[ Reputable.profileKey ] )
	if Reputable_Data.global.ttShowList then
		for key,show in pairs( Reputable_Data.global.profileKeys ) do
			if key ~= Reputable.profileKey then
				addPlayerToDailiesPage( key, show )
			end
		end
		--GameTooltip:AddLine( " " )
	end
	Reputable:addLineToHTML( dailiesPage, "p", "<br/>", nil, nil )

	if Reputable_Data.global.guiShowNormalWotLKDaily then
		Reputable:addLineToHTML( dailiesPage, "p", "|cffffff00Wotlk "..LFG_TYPE_DAILY_DUNGEON.."|r", nil, nil )
		if Reputable_Data.global.dailyDungeons[ server ].dailyNormalDungeonLK then
			Reputable:addDungeonToHTML( dailiesPage, Reputable.dailyInfo[ Reputable_Data.global.dailyDungeons[ server ].dailyNormalDungeonLK ].instanceID, 0, nil, nil)
			Reputable:addQuestToHTML( dailiesPage, Reputable_Data.global.dailyDungeons[ server ].dailyNormalDungeonLK, nil, nil )
		else
			Reputable:addLineToHTML( dailiesPage, "p", "|cff808080[ "..UNKNOWN.." - Speak with Archmage Timear in Dalaran City ]|r", true, nil)
		end
		Reputable:addLineToHTML( dailiesPage, "p", "<br/>", nil, nil )
	end

	if Reputable_Data.global.guiShowHeroicWotLKDaily then
		Reputable:addLineToHTML( dailiesPage, "p", "|cffffff00Wotlk "..LFG_TYPE_DAILY_HEROIC_DUNGEON.."|r", nil, nil )
		if Reputable_Data.global.dailyDungeons[ server ].dailyHeroicDungeonLK then
			Reputable:addDungeonToHTML( dailiesPage, Reputable.dailyInfo[ Reputable_Data.global.dailyDungeons[ server ].dailyHeroicDungeonLK ].instanceID, 1, nil, nil)
			Reputable:addQuestToHTML( dailiesPage, Reputable_Data.global.dailyDungeons[ server ].dailyHeroicDungeonLK, nil, nil )
		else
			Reputable:addLineToHTML( dailiesPage, "p", "|cff808080[ "..UNKNOWN.." - Speak with Archamage Lan'dalock in Dalaran City ]|r", true, nil)
		end
		Reputable:addLineToHTML( dailiesPage, "p", "<br/>", nil, nil )
	end

	if Reputable_Data.global.guiShowWotlkCookingDaily then
		Reputable:addLineToHTML( dailiesPage, "p", "|cffffff00Wotlk "..PROFESSIONS_COOKING.." "..DAILY.."|r", nil, nil )
		if Reputable_Data.global.dailyDungeons[ server ].dailyWotlkCookingQuest then
			Reputable:addQuestToHTML( dailiesPage, Reputable_Data.global.dailyDungeons[ server ].dailyWotlkCookingQuest, nil, nil )
		else
			Reputable:addLineToHTML( dailiesPage, "p", "|cff808080[ "..UNKNOWN.." - Speak with The Rokk in Shattrath City ]|r", true, nil)
		end
		Reputable:addLineToHTML( dailiesPage, "p", "<br/>", nil, nil )
	end

	if Reputable_Data.global.guiShowWotlkFishingDaily then
		Reputable:addLineToHTML( dailiesPage, "p", "|cffffff00Wotlk "..PROFESSIONS_FISHING.." "..DAILY.." |r", nil, nil )
		if Reputable_Data.global.dailyDungeons[ server ].dailyWotlkFishingQuest then
			Reputable:addQuestToHTML( dailiesPage, Reputable_Data.global.dailyDungeons[ server ].dailyWotlkFishingQuest, nil, nil )
		else
			Reputable:addLineToHTML( dailiesPage, "p", "|cff808080[ "..UNKNOWN.." - Speak with Marcia Chase in Dalaran ]|r", true, nil)
		end
		Reputable:addLineToHTML( dailiesPage, "p", "<br/>", nil, nil )
	end

	if Reputable_Data.global.guiShowNormalDaily then
		Reputable:addLineToHTML( dailiesPage, "p", "|cffffff00"..LFG_TYPE_DAILY_DUNGEON.."|r", nil, nil )
		if Reputable_Data.global.dailyDungeons[ server ].dailyNormalDungeon then
			Reputable:addDungeonToHTML( dailiesPage, Reputable.dailyInfo[ Reputable_Data.global.dailyDungeons[ server ].dailyNormalDungeon ].instanceID, 0, nil, nil)
			Reputable:addQuestToHTML( dailiesPage, Reputable_Data.global.dailyDungeons[ server ].dailyNormalDungeon, nil, nil )
		else
			Reputable:addLineToHTML( dailiesPage, "p", "|cff808080[ "..UNKNOWN.." - Speak with Nether-Stalker Mah'duun in Shattrath City ]|r", true, nil)
		end
		Reputable:addLineToHTML( dailiesPage, "p", "<br/>", nil, nil )
	end
	
	if Reputable_Data.global.guiShowHeroicDaily then
		Reputable:addLineToHTML( dailiesPage, "p", "|cffffff00"..LFG_TYPE_DAILY_HEROIC_DUNGEON.."|r", nil, nil )
		if Reputable_Data.global.dailyDungeons[ server ].dailyHeroicDungeon then
			Reputable:addDungeonToHTML( dailiesPage, Reputable.dailyInfo[ Reputable_Data.global.dailyDungeons[ server ].dailyHeroicDungeon ].instanceID, 1, nil, nil)
			Reputable:addQuestToHTML( dailiesPage, Reputable_Data.global.dailyDungeons[ server ].dailyHeroicDungeon, nil, nil )
		else
			Reputable:addLineToHTML( dailiesPage, "p", "|cff808080[ "..UNKNOWN.." - Speak with Wind Trader Zhareem in Shattrath City ]|r", true, nil)
		end
		Reputable:addLineToHTML( dailiesPage, "p", "<br/>", nil, nil )
	end

	if Reputable_Data.global.guiShowCookingDaily then
		Reputable:addLineToHTML( dailiesPage, "p", "|cffffff00"..PROFESSIONS_COOKING.." "..DAILY.."|r", nil, nil )
		if Reputable_Data.global.dailyDungeons[ server ].dailyCookingQuest then
			Reputable:addQuestToHTML( dailiesPage, Reputable_Data.global.dailyDungeons[ server ].dailyCookingQuest, nil, nil )
		else
			Reputable:addLineToHTML( dailiesPage, "p", "|cff808080[ "..UNKNOWN.." - Speak with The Rokk in Shattrath City ]|r", true, nil)
		end
		Reputable:addLineToHTML( dailiesPage, "p", "<br/>", nil, nil )
	end

	if Reputable_Data.global.guiShowFishingDaily then
		Reputable:addLineToHTML( dailiesPage, "p", "|cffffff00"..PROFESSIONS_FISHING.." "..DAILY.."|r", nil, nil )
		if Reputable_Data.global.dailyDungeons[ server ].dailyFishingQuest then
			Reputable:addQuestToHTML( dailiesPage, Reputable_Data.global.dailyDungeons[ server ].dailyFishingQuest, nil, nil )
		else
			Reputable:addLineToHTML( dailiesPage, "p", "|cff808080[ "..UNKNOWN.." - Speak with Old Man Barlo in Terokkar Forest ]|r", true, nil)
		end
		Reputable:addLineToHTML( dailiesPage, "p", "<br/>", nil, nil )
	end
	
	if Reputable_Data.global.guiShowPvPDaily then
		Reputable:addLineToHTML( dailiesPage, "p", "|cffffff00"..PVP.." "..DAILY.."|r", nil, nil )
		if Reputable_Data.global.dailyDungeons[ server ].dailyPvPQuest then
			Reputable:addQuestToHTML( dailiesPage, Reputable_Data.global.dailyDungeons[ server ].dailyPvPQuest, nil, nil )
		else
			if playerFaction == 'Alliance' then
				Reputable:addLineToHTML( dailiesPage, "p", "|cff808080[ "..UNKNOWN.." - Speak with an Alliance Brigadier General ]|r", true, nil)
			else
				Reputable:addLineToHTML( dailiesPage, "p", "|cff808080[ "..UNKNOWN.." - Speak with a Horde Warbringer ]|r", true, nil)
			end
		end
		Reputable:addLineToHTML( dailiesPage, "p", "<br/>", nil, nil )
	end
	
	for _, v in ipairs ( Reputable.guiTabs ) do
		if v.faction and Reputable.factionInfo[ v.faction ][ playerFaction ] ~= false then
			local reputationString = Reputable:getRepString( Reputable_Data[Reputable.profileKey].factions[v.faction] )
			local title = REPUTATION .. " " .. Reputable:createLink( "faction", v.faction, nil, nil, nil, nil ) .. " " .. reputationString
			local factionPage = Reputable.guiTabs[ v.name ].html
			factionPage.header = "<html><body><h1 align='center'>" ..title.. "</h1><br/>"
		--	local label = Reputable.guiTabs[ Reputable.guiTabs[ v.name ].num ].label
			
			if Reputable_Data[Reputable.profileKey].factions[v.faction] and Reputable_Data[Reputable.profileKey].factions[v.faction] >= 42000 then
				--label = "|cff00FF00"..label
				Reputable.gui.menu[ "menuBTN_" .. v.name ]:SetNormalFontObject( "GameFontGreenSmall" )
			end
			
			--consortium monthly gems
			if v.faction == 933 then
				local consortiumStanding = Reputable_Data[ Reputable.profileKey ].factions[933] or 0
				Reputable:addLineToHTML( factionPage, "h2", CALENDAR_REPEAT_MONTHLY.." "..SCENARIO_BONUS_REWARD, nil, nil )
				--Reputable:addLineToHTML( factionPage, "h2", consortiumStanding, nil, nil )
				if consortiumStanding >= 42000 then
					Reputable:addQuestToHTML( factionPage, 9887, nil, nil, nil, nil ) -- e
				elseif consortiumStanding >= 21000 then
					Reputable:addQuestToHTML( factionPage, 9885, nil, nil, nil, nil ) -- r
				elseif consortiumStanding >= 9000 then
					Reputable:addQuestToHTML( factionPage, 9884, nil, nil, nil, nil ) -- h
				else
					Reputable:addQuestToHTML( factionPage, 9886, nil, nil, nil, nil ) -- f
				end
				Reputable:addLineToHTML( factionPage, "p", "<br/>", nil, nil )
			end
			
			--check for repeatable quests
			if Reputable.factionInfo[ v.faction ].rquests then
				if Reputable_Data.global.guiShowExaltedDailies or not Reputable_Data[Reputable.profileKey].factions[v.faction] or Reputable_Data[Reputable.profileKey].factions[v.faction] < 42000 then
					Reputable:addLineToHTML( factionPage, "h2", "Repeatable " .. QUESTS_COLON, nil, nil )
					for _, questID in ipairs( Reputable.factionInfo[ v.faction ].rquests ) do
						local q = Reputable.questInfo[ questID ]
						if q then
							local repInc = 0
							if v.faction == q[5][1] then repInc = q[5][2] elseif v.faction == q[5][3] then repInc = q[5][4] end
							Reputable:addQuestToHTML( factionPage, questID, repInc, v.faction, nil, nil )
						else
							debug("Repeatable quest missing from questDB", questID)
						end
					end
					Reputable:addLineToHTML( factionPage, "p", "<br/>", nil, nil )
				end
			end
			
			
			if Reputable.questByFaction[ v.faction ] then
				factionPage.questCounter = { factionPage.i, 0, 0, 0, 0 } factionPage.i = factionPage.i + 1
				for _, chain in ipairs ( Reputable.questByFaction[ v.faction ] ) do
					if type( chain ) == 'string' then
						if factionPage.lastWasHeader then factionPage.i = factionPage.i - 1 end
						factionPage.lastWasHeader = true
						Reputable:addLineToHTML( factionPage, "h2", chain .. " " .. QUESTS_COLON, nil, nil )
					else
						for _, questID in ipairs ( chain ) do
							local levelColor, complete, inProgress, progressIcon, levelMin, levelTooLow, levelString, minF, minR, maxF, maxR, repTooLow, repTooHigh, requiredQuestComplete = Reputable:getQuestInfo( questID, nil, nil )
							local q = Reputable.questInfo[ questID ]
							if q then
								if Reputable.questInfo[ questID ][2] ~= Reputable.notFactionInt[ playerFaction ] then
									local ingoredQuestForRep = ( Reputable.ignoredQuestsForRep and Reputable.ignoredQuestsForRep[questID] ) or false
								--	if ingoredQuestForRep then debug( questID, ingoredQuestForRep ) end
									local repInc = 0
									if v.faction == q[5][1] then repInc = q[5][2] elseif v.faction == q[5][3] then repInc = q[5][4] end
									if ( q[12] ~= 1 or requiredQuestComplete == false ) and not repTooHigh then
										Reputable:addQuestToHTML( factionPage, questID, repInc, v.faction, nil, nil )
									end
									if q[12] ~= 1 and not repTooHigh and not ingoredQuestForRep then
										factionPage.questCounter[3] = factionPage.questCounter[3] + 1
										factionPage.questCounter[5] = factionPage.questCounter[5] + repInc
										if complete then
											factionPage.questCounter[2] = factionPage.questCounter[2] + 1
											factionPage.questCounter[4] = factionPage.questCounter[4] + repInc
										end
									end
									
									if q[13] == 1 then	
										Reputable:addQuestToHTML( dailiesPage, questID, repInc, v.faction, nil, nil )
									end
								end
							else debug("Quest missing from questDB", questID)
							end
						end
					end
				end
				local counterStr = REPUTATION .. " " .. QUEST_LOG_COUNT
				counterStr = string.gsub( counterStr, "%%d", factionPage.questCounter[2],1 )
				counterStr = string.gsub( counterStr, "%%d", factionPage.questCounter[3],1 )
				local remainingRep = factionPage.questCounter[5] - factionPage.questCounter[4]
				local remainingRepStr = ""
				if remainingRep > 0 then
					if Reputable_Data[Reputable.profileKey].factions[v.faction] then
						remainingRepStr = " => "..Reputable:getRepString( Reputable_Data[Reputable.profileKey].factions[v.faction] + remainingRep )
					else
						remainingRepStr = AVAILABLE..": |cFF8080FF"..Reputable:repWithMultiplier(remainingRep, nil).."|r"
					end
					
				end
				local counterRepStr = " |cFF8080FF ( " .. Reputable:repWithMultiplier(factionPage.questCounter[4], nil) .. " / ".. Reputable:repWithMultiplier(factionPage.questCounter[5], nil) .. " )|r ".. remainingRepStr
				Reputable:addLineToHTML( factionPage, "h2", counterStr .. counterRepStr, false, factionPage.questCounter[1] )
				Reputable:addLineToHTML( factionPage, "p", "<br/>", nil, nil )
				Reputable:addLineToHTML( factionPage, "p", "<br/>", nil, nil )
				
				if factionPage.questCounter[2] == factionPage.questCounter[3] then
					--label = label..Reputable:icons( 'tick' )
					local label = Reputable.guiTabs[ Reputable.guiTabs[ v.name ].num ].label..Reputable:icons( 'tick' )
					Reputable.gui.menu[ "menuBTN_" .. v.name ]:SetText( label )
				end
				--Reputable.gui.menu[ "menuBTN_" .. v.name ]:SetText(label)
			end
		end
	end
	
	
	for attunementID, data in pairs ( Reputable.attunements ) do
		local pageName = "attune" .. attunementID
		local page = Reputable.guiTabs[ pageName ].html
		local attunementComplete = false
		if data.check then
			if data.check.item then
				if GetItemCount( data.check.item, true ) > 0 then
					attunementComplete = true
				end
			end
			if data.check.quest then
				if type(data.check.quest) == 'table' then
					for _,thisQuestCheck in pairs ( data.check.quest ) do
						if C_QuestLog.IsQuestFlaggedCompleted( thisQuestCheck ) then attunementComplete = true end
					end
				else
					attunementComplete = C_QuestLog.IsQuestFlaggedCompleted( data.check.quest )
				end
			end
		end
		if attunementComplete then
			local label = Reputable.guiTabs[ Reputable.guiTabs[ pageName ].num ].label
			Reputable.gui.menu[ "menuBTN_" .. pageName ]:SetText("|cff00FF00"..label..Reputable:icons( 'tick' ))
			page.header = "<html><body><h1 align='center'>" ..label.. " (|cff00FF00"..COMPLETE.."|r)</h1><br/>"
		end
		if not attunementComplete or Reputable_Data.global.guiShowCompletedQuests then
			if data.requirements then
				if data.requirements.reputation then
					Reputable:addLineToHTML( page, "p", string.gsub( LOCKED_WITH_ITEM, "%%s", REPUTATION..":" ), nil, nil )
					for _, reputation in ipairs ( data.requirements.reputation ) do
						local factionName = GetFactionInfoByID( reputation[1] )
						if not factionName then
							if Reputable.factionInfo[ reputation[1] ] then factionName = Reputable.factionInfo[ reputation[1] ].name else factionName = "Unknown Faction" end
						end
						--Reputable_Data[Reputable.profileKey].factions[reputation[1]]
						local _,_,_,repReqStr = Reputable:getRepString( reputation[2] )
						local meetsRepRequirement = Reputable:icons( Reputable_Data[Reputable.profileKey].factions[reputation[1]] ~= nil and Reputable_Data[Reputable.profileKey].factions[reputation[1]] >= reputation[2], -8 )
						repReqStr = factionName.." "..repReqStr.." "..meetsRepRequirement.." "
						local currentRepStr = ""
						if Reputable_Data[Reputable.profileKey].factions[reputation[1]] then
							currentRepStr = Reputable:getRepString( Reputable_Data[Reputable.profileKey].factions[reputation[1]] )
						end
						Reputable:addLineToHTML( page, "p", "|cFF8080FF|Hreputable:faction:" .. reputation[1] .. "|h" .. repReqStr .. currentRepStr .. "|h|r", true, nil )
					end
					Reputable:addLineToHTML( page, "p", "<br/>", nil, nil )
				end
				if data.requirements.dungeons then
					Reputable:addLineToHTML( page, "p", string.gsub( LOCKED_WITH_ITEM, "%%s", DUNGEONS..":" ), nil, nil )
					for _, dungeon in ipairs ( data.requirements.dungeons ) do
						Reputable:addDungeonToHTML( page, dungeon[1], dungeon[2], nil, nil )
					end
					Reputable:addLineToHTML( page, "p", "<br/>", nil, nil )
				end
				if data.requirements.items then
					Reputable:addLineToHTML( page, "p", string.gsub( LOCKED_WITH_ITEM, "%%s", ITEMS..":" ), nil, nil )
					for _, item in ipairs ( data.requirements.items ) do
						Reputable:tryMakeItemLink( item[1], pageName, "tab", page.i, false, "", "|cffffd100 x"..item[2] )
					end
					Reputable:addLineToHTML( page, "p", "<br/>", nil, nil )
				end
			end
			if data.chain then
				Reputable:addLineToHTML( page, "p", "Attunement:", nil, nil )
				local pieceStart = page.i
				for _, piece in ipairs ( data.chain ) do
					if type( piece ) == 'number' then
						Reputable:addQuestToHTML( page, piece, nil, nil )
					elseif type( piece ) == 'string' then
					
					elseif piece[1] ~= Reputable.notFactionInt[ playerFaction ] then
						local bitStart = page.i
						local bitComplete = false
						for i, bit in ipairs ( piece ) do
							local first
							if i == 1 then first = true end
							if piece[i-1] == 1 or piece[i-1] == 2 then first = true end
							if bit ~= Reputable.factionInt[ playerFaction ] then
								if first and pieceStart ~= bitStart then Reputable:addLineToHTML( page, "p", "<br/>", nil, nil ) end
								if type( bit ) == 'number' then
									if Reputable_Data[ Reputable.profileKey ].quests[ bit ] == true then bitComplete = true end
									Reputable:addQuestToHTML( page, bit, nil, nil )
								else
									local stepType = bit:sub(1, 1)
									local stepNumber = bit:sub(2)
									local step
									if stepType == 'n' then
									elseif stepType == 'i' then
										local difficulty = tonumber( stepNumber:sub(1, 1) )
										local difficultyType = LFG_TYPE_DUNGEON
										if difficulty == 2 then
											difficulty = 0
									--		difficultyType = CHAT_MSG_INSTANCE_CHAT
										end
										Reputable:addDungeonToHTML( page, tonumber( stepNumber:sub(2) ), difficulty, difficultyType .. ": ", nil )
									elseif stepType == 'a' then
										if playerFaction == 'Alliance' then step = stepNumber end
									elseif stepType == 'h' then
										if playerFaction == 'Horde' then step = stepNumber end
									else
										step = bit
									end
									if step then Reputable:addLineToHTML( page, "h2", "|cffffd100 " .. step, true, nil ) end
								end
							end
						end
						if bitComplete and not Reputable_Data.global.guiShowCompletedQuests then page.i = bitStart end
					end
				end
				Reputable:addLineToHTML( page, "p", "<br/>", nil, nil )
				Reputable:addLineToHTML( page, "p", "<br/>", nil, nil )
			end
		else
			Reputable:addLineToHTML( page, "p", SPLASH_BOOST_HEADER, true, nil )
		end
	end
	
	if Reputable.brewfest then
		Reputable:addBrewfest()
	end
	
	if Reputable.HallowsEnd then
		Reputable:addHallowsEnd()
	end
	
	if Reputable.midsummer then
		Reputable:addMidsummer()
	end
	
	Reputable:addLineToHTML( dailiesPage, "p", "<br/>", nil, nil )
	Reputable:addLineToHTML( dailiesPage, "p", "<br/>", nil, nil )
	
	--classicFactionPages
	for questID in pairs ( Reputable.questInfo ) do
		if Reputable.questIgnore[ questID ] then return end
		local q = Reputable.questInfo[ questID ]
		local repIncrease = q[5][2]
		if q[12] ~= 1 and q[6] > 0 then
			if classicFactionPages[ q[5][1] ] then
				Reputable:addQuestToHTML( Reputable.guiTabs[ "faction"..q[5][1] ].html, questID, repIncrease, nil, true )
			elseif q[5][1] == 67 then	-- Horde
				Reputable:addQuestToHTML( Reputable.guiTabs[ "faction911" ].html, questID, repIncrease, nil, true )
				Reputable:addQuestToHTML( Reputable.guiTabs[ "faction76"  ].html, questID, repIncrease, nil, true )
				Reputable:addQuestToHTML( Reputable.guiTabs[ "faction530" ].html, questID, repIncrease, nil, true )
				Reputable:addQuestToHTML( Reputable.guiTabs[ "faction68"  ].html, questID, repIncrease, nil, true )
				Reputable:addQuestToHTML( Reputable.guiTabs[ "faction81"  ].html, questID, repIncrease, nil, true )
			elseif q[5][1] == 469 then	-- Alliance
				Reputable:addQuestToHTML( Reputable.guiTabs[ "faction930" ].html, questID, repIncrease, nil, true )
				Reputable:addQuestToHTML( Reputable.guiTabs[ "faction69"  ].html, questID, repIncrease, nil, true )
				Reputable:addQuestToHTML( Reputable.guiTabs[ "faction72"  ].html, questID, repIncrease, nil, true )
				Reputable:addQuestToHTML( Reputable.guiTabs[ "faction47"  ].html, questID, repIncrease, nil, true )
				Reputable:addQuestToHTML( Reputable.guiTabs[ "faction54"  ].html, questID, repIncrease, nil, true )
			elseif q[5][1] == 169 then	-- Steamwheedle Cartel
				Reputable:addQuestToHTML( Reputable.guiTabs[ "faction21"  ].html, questID, repIncrease, nil, true )
				Reputable:addQuestToHTML( Reputable.guiTabs[ "faction577" ].html, questID, repIncrease, nil, true )
				Reputable:addQuestToHTML( Reputable.guiTabs[ "faction369" ].html, questID, repIncrease, nil, true )
				Reputable:addQuestToHTML( Reputable.guiTabs[ "faction470" ].html, questID, repIncrease, nil, true )
			end
		end
	end
	for f in pairs( classicFactionPages ) do
		if Reputable_Data[Reputable.profileKey].factions[f] and Reputable_Data[Reputable.profileKey].factions[f] >= 42000 then
			Reputable.gui.menu[ "menuBTN_" .. "faction"..f ]:SetNormalFontObject( "GameFontGreenSmall" )
		end
		Reputable:addLineToHTML( Reputable.guiTabs[ "faction"..f ].html, "p", "<br/>", nil, nil )
		Reputable:addLineToHTML( Reputable.guiTabs[ "faction"..f ].html, "p", "<br/>", nil, nil )
	end
	
	Reputable.guiNeedsUpdate = false
end

local function createGUI( page )
	local menuW = 160

	Reputable.gui = CreateFrame("frame", "ReputableGUI", UIParent, BackdropTemplateMixin and "BackdropTemplate");
	local cont = Reputable.gui
	cont:SetBackdrop({
		  bgFile="Interface\\DialogFrame\\UI-DialogBox-Background",
		  edgeFile="Interface/Tooltips/UI-Tooltip-Border",
		  tile=1, tileSize=16, edgeSize=16,
		  insets={left=4, right=4, top=4, bottom=4}
	})
	cont:SetWidth(800)
	cont:SetHeight(420)
	cont:SetPoint("CENTER",UIParent)
	cont:EnableMouse(true)
	cont:SetMovable(true)
	cont:SetClampedToScreen( true )
	cont:SetResizable(true)
	cont:SetMinResize(400,120);
	cont:RegisterForDrag("LeftButton")
	cont:SetScript("OnDragStart", function(self) self:StartMoving() end)
	cont:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
	cont:SetFrameStrata("FULLSCREEN_DIALOG")
	tinsert(UISpecialFrames, "ReputableGUI")

	cont.closeBTN = CreateFrame("button","", cont, "UIPanelButtonTemplate")
	cont.closeBTN:SetHeight(24)
	cont.closeBTN:SetWidth(26)
	cont.closeBTN:SetPoint("TOPRIGHT", cont, "TOPRIGHT", -5, -5)
	cont.closeBTN:SetText("X")
	cont.closeBTN:SetScript("OnClick", function(self) cont:Hide() end)
	
	cont.settingsBTN = CreateFrame("button","", cont, "UIPanelButtonTemplate")
	cont.settingsBTN:SetHeight(24)
	cont.settingsBTN:SetWidth(80)
	cont.settingsBTN:SetPoint("RIGHT", cont.closeBTN, "LEFT", 0, 0)
	cont.settingsBTN:SetText( GAMEOPTIONS_MENU )
	cont.settingsBTN:SetScript("OnClick", function(self)  cont:Hide(); InterfaceOptionsFrame_OpenToCategory(addonName);InterfaceOptionsFrame_OpenToCategory(addonName) end)

	cont.showCompletedQuests = CreateFrame("CheckButton", nil, cont, "UICheckButtonTemplate");
	cont.showCompletedQuests:SetPoint("RIGHT", cont.settingsBTN, "LEFT", 0, -1);
	cont.showCompletedQuests:SetScript("OnEnter", function(self) GameTooltip:SetOwner(self, "ANCHOR_RIGHT",0,-32);  GameTooltip:SetText( TOOLTIP_TRACKER_FILTER_COMPLETED_QUESTS ); GameTooltip:Show() end)
	cont.showCompletedQuests:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
	if Reputable_Data.global.guiShowCompletedQuests then cont.showCompletedQuests:SetChecked(true) end
	cont.showCompletedQuests:SetScript("OnClick", function() Reputable_Data.global.guiShowCompletedQuests = cont.showCompletedQuests:GetChecked() Reputable:guiUpdate(true) end);

	cont.showExaltedDailies = CreateFrame("CheckButton", nil, cont, "UICheckButtonTemplate");
	cont.showExaltedDailies:SetPoint("RIGHT", cont.showCompletedQuests, "LEFT", 0, 0);
	cont.showExaltedDailies:SetScript("OnEnter", function(self) GameTooltip:SetOwner(self, "ANCHOR_RIGHT",0,-32);  GameTooltip:SetText( SHOW.." "..FACTION_STANDING_LABEL8.." repeatable "..QUESTS_LABEL ); GameTooltip:Show() end)
	cont.showExaltedDailies:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
	if Reputable_Data.global.guiShowExaltedDailies then cont.showExaltedDailies:SetChecked(true) end
	cont.showExaltedDailies:SetScript("OnClick", function() Reputable_Data.global.guiShowExaltedDailies = cont.showExaltedDailies:GetChecked() Reputable:guiUpdate(true) end);
	
	cont.resizeBTN = CreateFrame("Button", nil, cont)
	cont.resizeBTN:SetSize(16, 16)
	cont.resizeBTN:SetPoint("BOTTOMRIGHT")
	cont.resizeBTN:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
	cont.resizeBTN:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
	cont.resizeBTN:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
	cont.resizeBTN:SetScript("OnMouseDown", function(self, button)
		cont:StartSizing("BOTTOMRIGHT")
		cont:SetUserPlaced(true)
	end)
	cont.resizeBTN:SetScript("OnMouseUp", function(self, button)
		cont:StopMovingOrSizing()
		local width = cont.scrollFrameMain:GetWidth()
		cont.main:SetWidth( width )
		cont.html_right:SetWidth( width - 20 );
		cont.html_main:SetWidth( width - 20 );
		Reputable:loadHTML(nil)
	end)
		
	cont.title = cont:CreateFontString(nil, cont, "GameFontNormalLarge" )
	cont.title:SetText(addonName)
	cont.title:SetPoint("TOPLEFT",10,-10)
	
	cont.version = cont:CreateFontString(nil, cont, "GameFontDisable" )
	cont.version:SetText( "(v" .. version ..")" )
	cont.version:SetPoint("LEFT", cont.title, "RIGHT",5,0)
	
	cont.author = cont:CreateFontString(nil, cont, "GameFontDisable" )
	cont.author:SetText( string.gsub( PETITION_CREATOR, "%%s", author ) )
	cont.author:SetPoint("LEFT", cont.version, "RIGHT", 5, 0)
	
	cont.headerLine = cont:CreateLine()
	cont.headerLine:SetColorTexture(1,1,1,0.5)
	cont.headerLine:SetThickness(1)
	cont.headerLine:SetStartPoint("TOPLEFT",4,-32)
	cont.headerLine:SetEndPoint("TOPRIGHT",-4,-32)
	
	cont.menuLine = cont:CreateLine()
	cont.menuLine:SetColorTexture(1,1,1,0.5)
	cont.menuLine:SetThickness(1)
	cont.menuLine:SetStartPoint("TOPLEFT",menuW + 25,-32)
	cont.menuLine:SetEndPoint("BOTTOMLEFT",menuW + 25,3)
	
	cont.scrollFrameMenu = CreateFrame( "ScrollFrame", "$parent_ScrollFrame", cont, "UIPanelScrollFrameTemplate" );
	cont.scrollBar = _G[cont.scrollFrameMenu:GetName() .. "ScrollBar"];
	cont.scrollFrameMenu:SetWidth( menuW );
	cont.scrollFrameMenu:SetPoint( "TOPLEFT", 0, -35 );
	cont.scrollFrameMenu:SetPoint( "BOTTOM", 0, 10 );

	cont.menu = CreateFrame( "Frame", "$parent_ScrollChild", cont.scrollFrameMenu );
	cont.menu.y = 0
	cont.menu:SetWidth( cont.scrollFrameMenu:GetWidth() );
	cont.menu:SetAllPoints( cont.scrollFrameMenu );
	cont.scrollFrameMenu:SetScrollChild( cont.menu );
	
	cont.scrollFrameMain = CreateFrame( "ScrollFrame", "$parent_ScrollFrame", cont, "UIPanelScrollFrameTemplate" );
	cont.scrollBar = _G[cont.scrollFrameMain:GetName() .. "ScrollBar"];
	cont.scrollFrameMain:SetPoint( "TOPLEFT", menuW + 25, -35 );
	cont.scrollFrameMain:SetPoint( "BOTTOMRIGHT", -30, 10 );

	cont.main = CreateFrame( "Frame", "$parent_ScrollChild", cont.scrollFrameMain );
	cont.main.y = 0
	cont.main:SetWidth( cont.scrollFrameMain:GetWidth() );
	cont.main:SetAllPoints( cont.scrollFrameMain );
	cont.scrollFrameMain:SetScrollChild( cont.main );
	
	for name, layerData in pairs ( htmlLayers ) do
		Reputable.gui["html_" .. name] = CreateFrame( "SimpleHTML", "html_" .. name, Reputable.gui.main );
		local layer = Reputable.gui["html_" .. name]
		layer.y = 0
		layer:SetWidth( Reputable.gui.main:GetWidth() - ( layerData.margin[1] + layerData.margin[2] ) );
		layer:SetPoint( "LEFT", Reputable.gui.main, "LEFT", layerData.margin[1], 0 );
		layer:SetPoint( "RIGHT", Reputable.gui.main, "RIGHT", -layerData.margin[2], 0 );
		layer:SetPoint( "TOP", Reputable.gui.main, "TOP" );
		layer:SetPoint( "BOTTOM", Reputable.gui.main, "BOTTOM" );
	--	layer:SetFont('Fonts\\FRIZQT__.TTF', 12);
		layer:SetFont(STANDARD_TEXT_FONT, 12);
		layer:SetSpacing(6);
		layer.showItemTooltip = true
		layer:SetScript("OnHyperlinkEnter", function(...) Reputable:OnHyperlinkEnter(...) end )
		layer:SetScript("OnHyperlinkLeave", function() GameTooltip:Hide() Reputable.iconFrame:Hide() Reputable.iconFrame.heroic:Hide() end )
	--	layer:SetScript("OnHyperlinkClick", function(self, link, text, button) SetItemRef(link, text) Reputable:setFactionFromHyperLink( link ) end);
		layer:SetScript("OnHyperlinkClick", function(self, link, text, button) Reputable:insertChatLink( link, text, button ) Reputable:setFactionFromHyperLink( link ) end);
	end
	

	
	for k, v in ipairs ( Reputable.guiTabs ) do
		--if v.name ~= 'midsummer' or ( v.name == 'midsummer' and Reputable.midsummer ) then
		--if v.name ~= 'HallowsEnd' or ( v.name == 'HallowsEnd' and Reputable.HallowsEnd ) then
			local title = v.title
			local pagetype = ""
			if v.faction then
				if not Reputable.factionInfo[ v.faction ] then Reputable.factionInfo[ v.faction ] = {} end
				if not Reputable.factionInfo[ v.faction ].name then Reputable.factionInfo[ v.faction ].name = GetFactionInfoByID( v.faction ) or "Unknown Faction" end
				title = REPUTATION .. " " .. Reputable:createLink( "faction", v.faction, nil, nil, nil, nil )
				v.label = Reputable.factionInfo[ v.faction ].name
				v.name = "faction" .. v.faction
				if not v.cat then v.cat = 2 end
			elseif v.instance then
				if type( v.instance ) == 'number' then
					if Reputable.attunements[ v.instance ].name then
						title = Reputable.attunements[ v.instance ].name
					elseif Reputable.instance[ v.instance ] then
						title = Reputable.instance[ v.instance ].name
					end
				else
					title = v.instance
				end
				if not title then title = "Instance: "..v.instance end
				v.label = title
				v.name = "attune" .. v.instance
				if not v.cat then v.cat = 6 end
				pagetype = "attunement"
			end
			
			Reputable.guiTabs[v.name] = {
				html = {
					name = v.name,
					i = 1,
					header = "<html><body><h1 align='center'>" .. title .. "</h1><br/>",
					main = {},
					tab1 = {},
					right = {},
					iRight = 1,
					pagetype = pagetype,
				},
				num = k,
			}
			--if debug() or not v.faction or ( Reputable.factionInfo[ v.faction ] and Reputable.factionInfo[ v.faction ][ playerFaction ] ~= false ) then
			if not v.faction or ( Reputable.factionInfo[ v.faction ] and Reputable.factionInfo[ v.faction ][ playerFaction ] ~= false ) then
				if not Reputable.guiCats[ v.cat ].created then
					createSubTitle( cont.menu, Reputable.guiCats[ v.cat ].name, Reputable.guiCats[ v.cat ].label )
					Reputable.guiCats[ v.cat ].created = true
				end
				createMenuBTN( cont.menu, v.name, v.label )
			end
		--end
	end
	cont.main:SetHeight( 200 );
	cont.menu:SetHeight( 30 - cont.menu.y );
	
	if not page then page = 'dailies' end
	Reputable.tabOpen = page
	makeDataForAllPages()
	Reputable:loadHTML(nil)
end

function Reputable:guiUpdate( skipLogCheck, needsRefresh )
	Reputable:resetDailies(false)
	if not skipLogCheck then
		Reputable:getQuestLog( needsRefresh )
	else
		if Reputable.gui and Reputable.gui:IsVisible() then 
			makeDataForAllPages()
			Reputable:loadHTML(nil)
		else
			Reputable.guiNeedsUpdate = true
		end
	end
end

function Reputable:toggleGUI( show, page )
	Reputable:resetDailies(false)
	if Reputable.gui == nil then
		createGUI( page )
	elseif Reputable.gui:IsVisible() and not show then
		Reputable.gui:Hide()
	elseif show ~= false then
		local midsummerCurrencyBags = GetItemCount(23247)
		local midsummerCurrencyTotal = GetItemCount(23247, true)
		if Reputable.midsummerCurrencyTotal and Reputable.midsummerCurrencyTotal ~= midsummerCurrencyTotal or  Reputable.midsummerCurrencyBags and Reputable.midsummerCurrencyBags ~= midsummerCurrencyBags then Reputable.guiNeedsUpdate = true end
		if Reputable.guiNeedsUpdate then makeDataForAllPages() end
		Reputable.gui:Show()
		Reputable:loadHTML( page )
	end
end

-- [[ MiniMapIcon ]] --
function Reputable:toggleMiniMap()
	if Reputable_Data.global.mmShow then
		reputableMinimapIcon:Show("Reputable")
	else
		reputableMinimapIcon:Hide("Reputable")
	end
end

local function addPlayerToLDBToolTip( key, show, tooltip )
	if show then
		local k = Reputable_Data[key]
		if 	k.profile and server == k.profile.server then
			local color = "|c"..RAID_CLASS_COLORS[k.profile.class].colorStr
			local dailyCount = Reputable:getDailyCount( key )
			
			if dailyCount > 0 or key == Reputable.profileKey then
				tooltip:AddDoubleLine( color .. k.profile.name, "|cffffff00("..dailyCount.." / "..GetMaxDailyQuests()..")|r" )
			end
		end
	end
end

local function minimapButtonClick( button )
	if button=="LeftButton" then
		if IsShiftKeyDown() then
			local dungeonDailyText = ""
			if Reputable_Data.global.dailyDungeons[ server ].dailyNormalDungeonLK then
				dungeonDailyText = Reputable.instance[ Reputable.dailyInfo[ Reputable_Data.global.dailyDungeons[ server ].dailyNormalDungeonLK ].instanceID ].name
			end
			if Reputable_Data.global.dailyDungeons[ server ].dailyHeroicDungeonLK then
				if dungeonDailyText ~= "" then dungeonDailyText = dungeonDailyText .. " & " end
				dungeonDailyText = dungeonDailyText .. string.gsub( HEROIC_PREFIX, "%%s", Reputable.instance[ Reputable.dailyInfo[ Reputable_Data.global.dailyDungeons[ server ].dailyHeroicDungeonLK ].instanceID ].name )
			end
			if Reputable_Data.global.dailyDungeons[ server ].dailyNormalDungeon then
				dungeonDailyText = Reputable.instance[ Reputable.dailyInfo[ Reputable_Data.global.dailyDungeons[ server ].dailyNormalDungeon ].instanceID ].name
			end
			if Reputable_Data.global.dailyDungeons[ server ].dailyHeroicDungeon then 
				if dungeonDailyText ~= "" then dungeonDailyText = dungeonDailyText .. " & " end
				dungeonDailyText = dungeonDailyText .. string.gsub( HEROIC_PREFIX, "%%s", Reputable.instance[ Reputable.dailyInfo[ Reputable_Data.global.dailyDungeons[ server ].dailyHeroicDungeon ].instanceID ].name )
			end
			if dungeonDailyText ~= "" then
				local resetTime = " || "..( GameTooltipTextRight1:GetText() or LibDBIconTooltipTextRight1:GetText() or "" )
				local changeTime = ""
				if Reputable_Data.global.dailyDungeons[ server ].dailyChangeOffset ~= 0 then 
					changeTime  = " || "..( GameTooltipTextRight2:GetText() or LibDBIconTooltipTextRight2:GetText() or "" )
				end
				dungeonDailyText = DAILY.." "..DUNGEONS.."; "..dungeonDailyText .. resetTime .. changeTime
				ChatEdit_ActivateChat(DEFAULT_CHAT_FRAME.editBox)
				ChatEdit_InsertLink( dungeonDailyText )
				end
		else
			Reputable:toggleGUI()
		end
	elseif button=="RightButton" then
		InterfaceOptionsFrame_OpenToCategory(addonName);InterfaceOptionsFrame_OpenToCategory(addonName)
	end
end
local function minimapButtonOver( self, tooltip )
	Reputable.DataBrokerActiveTooltip = tooltip
	
	Reputable:addonMessage()
	tooltip:AddDoubleLine("|cFF8080FFReputable|r", RESET..": "..SecondsToTime(GetQuestResetTime()) )
	if Reputable_Data.global.dailyDungeons[ server ].dailyChangeOffset ~= 0 then 
	local nextChange = GetQuestResetTime() + 3600 * Reputable_Data.global.dailyDungeons[ server ].dailyChangeOffset
	if nextChange > 86400 then nextChange = nextChange - 86400 end
		tooltip:AddDoubleLine( " ", AVAILABLE.." "..DAILY.." "..COMMUNITIES_CREATE_DIALOG_ICON_SELECTION_BUTTON..": "..SecondsToTime( nextChange ), 0.5, 0.5, 0.5, 0.5, 0.5, 0.5 )
	end
	tooltip:AddLine(" ")
	--debug( tooltip:GetName() )
	Reputable.addDailiesToToolTip( tooltip )
	if Reputable_Data[Reputable.profileKey].watchedFactionID then
		Reputable.createFactionToolTip( self, Reputable_Data[Reputable.profileKey].watchedFactionID, tooltip )
	else
		addPlayerToLDBToolTip( Reputable.profileKey, Reputable_Data.global.ttShowCurrentInList and Reputable_Data.global.profileKeys[ Reputable.profileKey ], tooltip )
		if Reputable_Data.global.ttShowList then
			for key,show in pairs( Reputable_Data.global.profileKeys ) do
				if key ~= Reputable.profileKey then
					addPlayerToLDBToolTip( key, show, tooltip )
				end
			end
		end
	end
	local headerMade = false
	for factionID,change in pairs( Reputable.sessionStart.changes ) do
		if not headerMade then
			tooltip:AddLine(" ")
			tooltip:AddLine("|cFFFFFFFFThis Session:|r")
			headerMade = true
		end
		local repString = Reputable:getRepString( Reputable_Data[Reputable.profileKey].factions[factionID] )
		if change > 0 then change = "+" .. change end
		tooltip:AddDoubleLine( Reputable.factionInfo[ factionID ].name, repString .. " |cFF8080FF("..change..")|r" )
	end
	if Reputable_Data.global.mmTooltipShowOperations then
		tooltip:AddLine(" ")
		tooltip:AddDoubleLine("|cFFFFFFFF"..KEY_BUTTON1.."|r", "Open" )
		tooltip:AddDoubleLine("|cFFFFFFFF"..KEY_BUTTON2.."|r", GAMEOPTIONS_MENU )
		tooltip:AddDoubleLine("|cFFFFFFFF"..SHIFT_KEY_TEXT.."-"..KEY_BUTTON1.."|r", COMMUNITIES_INVITE_MANAGER_COLUMN_TITLE_LINK.." "..DAILY.." "..DUNGEONS  )
	end
	tooltip.timerLine = 1
	
	if tooltip:GetName() == "GameTooltip" then
		tooltip.owner = tooltip:GetOwner()
		tooltip:GetOwner().UpdateTooltip = function() Reputable:updateResetTime() end
	else
		reputableDataBroker.tooltipUpdater = C_Timer.NewTicker(0.2, function() Reputable:updateResetTime() end )
	end
end

function Reputable:initMiniMap()
	Reputable_Data.global.mmData.hide = not Reputable_Data.global.mmShow
	reputableDataBroker = LDB:NewDataObject("ReputableLDB", {
		type = "data source",
		label = "Reputable",
		icon = "Interface\\AddOns\\Reputable\\icons\\reputable_icon",
		OnClick = function(self, button)
			minimapButtonClick( button )
		end,
		OnTooltipShow = function(tooltip)
			minimapButtonOver( self, tooltip )
		end,
		OnLeave = function(tooltip)
			if reputableDataBroker.tooltipUpdater then reputableDataBroker.tooltipUpdater:Cancel() end
		end,
	})
	
	reputableMM = LDB:NewDataObject("Reputable", {
		type = "launcher",
		icon = "Interface\\AddOns\\Reputable\\icons\\reputable_icon",
		OnClick = function(clickedframe, button)
			minimapButtonClick( button )
		end,
		OnTooltipShow = function(tooltip)
			minimapButtonOver( self,tooltip )
		end,
		OnLeave = function(tooltip)
			if reputableDataBroker.tooltipUpdater then reputableDataBroker.tooltipUpdater:Cancel() end
		end,
	})
	reputableMinimapIcon:Register("Reputable", reputableMM, Reputable_Data.global.mmData )
	
	Reputable:setWatchedFaction()
end

local currentlyWatchedID
function Reputable:setWatchedFaction( factionID )
	if reputableDataBroker then
		currentlyWatchedID = Reputable_Data[Reputable.profileKey].watchedFactionID
		
		if ( factionID == nil and currentlyWatchedID == nil ) then
			--reputableDataBroker.label = "Reputable"
			reputableDataBroker.text = ""
		else
			if factionID and ( not currentlyWatchedID or currentlyWatchedID ~= factionID  ) then
				currentlyWatchedID = factionID
			end
			
			if Reputable.factionInfo[ currentlyWatchedID ] then
				Reputable_Data[Reputable.profileKey].watchedFactionID = currentlyWatchedID
			--	Reputable:getAllFactions()
				ReputationFrame_Update()
				
				local repString = Reputable:getRepString( Reputable_Data[Reputable.profileKey].factions[currentlyWatchedID] )
			--	reputableDataBroker.label = Reputable.factionInfo[ currentlyWatchedID ].name
				reputableDataBroker.text = "|cFF8080FF"..Reputable.factionInfo[ currentlyWatchedID ].name..":|r "..repString
				
				if Reputable_Data.global.ldbUseBlizzRepBar then
					local factionIndex = Reputable.factionInfo[ currentlyWatchedID ].index
					if not factionIndex then factionIndex = 0 end
					SetWatchedFactionIndex( factionIndex )
				end
			else
			--	reputableDataBroker.label = "Reputable"
				reputableDataBroker.text = ""
			end
		end
	end
end
