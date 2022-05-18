local addonName, addon = ...
local Reputable = CreateFrame("Frame"), {};
addon.a = Reputable

Reputable.midsummer = false
Reputable.brewfest = false
local today = tonumber(date("%m%d", time()))
if today > 620 and today < 706 then Reputable.midsummer = true end 
if today > 919 and today < 1007 then Reputable.brewfest = true end 

local resetAllDataVersion = 1.05

Reputable.playerName = UnitName("player")
Reputable.server = GetRealmName()

Reputable.profileKey = format("%s-%s", Reputable.playerName, Reputable.server)
Reputable.gender = UnitSex("player");
Reputable.level = UnitLevel("player")
local _,playerClass = UnitClass("player")
local playerFaction = UnitFactionGroup("player")
Reputable.race = UnitRace("player")

local foundFactions = 0
local rewardItemCache = { list = { } }
local waitingForData = {}
local initiated = false;

local version = GetAddOnMetadata(addonName, "Version") or 9999;

Reputable.debug = function ( text, ... )
	if text == nil then return Reputable_Data.global.debug end
	if Reputable_Data and Reputable_Data.global and ( Reputable_Data.global.debug or text == "toggle" ) then
		if text == "toggle" then Reputable_Data.global.debug = not Reputable_Data.global.debug; text = Reputable_Data.global.debug and "On" or "Off" end print( "|cFF8080FFReputable debugger:|r", text, ... )
	end
end
local debug = Reputable.debug

local showRewardTooltip = {	
	GameTooltip = CreateFrame("GameTooltip", "showRewardTooltip1", GameTooltip, "GameTooltipTemplate"),
	ItemRefTooltip = CreateFrame("GameTooltip", "showRewardTooltip2", ItemRefTooltip, "GameTooltipTemplate"),
}
showRewardTooltip.GameTooltip.shoppingTooltips = { ShoppingTooltip1, ShoppingTooltip2 };
showRewardTooltip.ItemRefTooltip.shoppingTooltips = { ShoppingTooltip1, ShoppingTooltip2 };

Reputable.sessionStart = { changes = {} }

Reputable.iconFrame = CreateFrame("frame", "iconFrame", GameTooltip )
Reputable.iconFrame:SetPoint("TOPRIGHT",GameTooltip,"TOPLEFT",0,-1);
Reputable.iconFrame:SetSize(32,32)
Reputable.iconFrame:Hide()
Reputable.iconFrame.texture = Reputable.iconFrame:CreateTexture()
Reputable.iconFrame.texture:SetAllPoints()
Reputable.iconFrame.heroic = Reputable.iconFrame:CreateFontString(nil, Reputable.iconFrame, "GameFontNormalLarge" )
--Reputable.iconFrame.heroic:SetText("|TInterface\\LFGFrame\\UI-LFG-ICON-HEROIC:16:16:-2:8|t")--:0:0:32:32:0:0:0:0|t")
Reputable.iconFrame.heroic:SetText("|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_8:8:8:-4:12|t")--:0:0:32:32:0:0:0:0|t")
Reputable.iconFrame.heroic:SetPoint("TOPLEFT",0,-5)
Reputable.iconFrame.heroic:Hide()

function Reputable:repWithMultiplier( repValue, round )
	local multiplier = 1
	if Reputable_Data.global.repMultiplier then
		if Reputable.race == "Human" then multiplier = 1.1 end
	end
	repValue = repValue * multiplier
	if round then
		repValue = math.floor( repValue + 0.5 )
	end
	return repValue
end

function Reputable:getQuestInfo( questID, key, factionID )
	if not key then key = Reputable.profileKey end
	local k = Reputable_Data[ key ]
	--[[
	if Reputable_Data[ key ].quests[ questID ] == nil or Reputable_Data[ key ].quests[ questID ] == false then
		local interchangableQuestId = Reputable.interchangableQuests[ questID ]
		if interchangableQuestId and Reputable_Data[ key ].quests[ interchangableQuestId ] ~= nil and Reputable_Data[ key ].quests[ interchangableQuestId ] ~= false then
		--	questID = interchangableQuestId
		end
	end
	--]]
	
	local colour, complete, inProgress, progressIcon, levelMin, levelTooLow, levelString, minF, minR, maxF, maxR, repTooLow, repTooHigh, requiredQuestComplete
	
	local q = Reputable.questInfo[ questID ]
	if q then
		Reputable:getQuestStatus( questID )
		local extraInfo = Reputable.extraQuestInfo[ questID ]
		colour = "|cFFFFFC01"
	
		progressIcon = 'qavail'
		if q[4] == -1 then q[4] = MAX_PLAYER_LEVEL_TABLE[GetExpansionLevel()] end
		--if q[3] == 0 then q[3] = q[4] end
		if q[3] == 0 then q[3] = 1 end
		local difficulty = GetQuestDifficultyColor( q[4] )
		if k.profile.level < q[3] then colour = '|cFFFF0000' levelTooLow = true progressIcon = 'qlow'
		elseif k.profile.level < q[4] - 3 then colour = '|cFFFF8040'
		elseif k.profile.level > ( q[4] + 10 ) then colour = '|cFF808080'
			--if q[12] ~= 1 then
			--	if difficulty.font == "QuestDifficulty_Trivial" then repIncrease = repIncrease * 0.2 end
			--end
			
		elseif difficulty.font == "QuestDifficulty_Trivial" then colour = '|cFF808080'
		elseif k.profile.level > ( q[4] + 3 ) then colour = '|cFF40BF40' end

		levelString = LEVEL .. " " .. q[3] .. " (" .. q[4] .. ")"
		if q[3] == q[4] then levelString = LEVEL .. " " .. q[3] end
		levelMin = q[3]
		
		if q[8] ~= 0 then
			minF = q[8]
			minR = q[9]
			repTooLow = true
			if k.factions[q[8]] and k.factions[q[8]] > q[9] then
				repTooLow = false
			end
		end
		if q[10] ~= 0 and q[11] < 41000 then
			maxF = q[10]
			maxR = q[11]
			repTooHigh = false
			if k.factions[q[10]] and k.factions[q[10]] > q[11] then
				repTooHigh = true
			end
		end
		if factionID and q[12] == 1 then
			local checkFaction = q[5][1]
			if checkFaction ~= factionID then checkFaction = q[5][3] end
			if checkFaction and checkFaction == factionID then
			
				if k.factions[checkFaction] and k.factions[checkFaction] >= 42000 then
					repTooHigh = true
				end
			end
		end
		
		complete = false
		--[[
		if Reputable_Data[ key ].quests[ questID ] == nil or Reputable_Data[ key ].quests[ questID ] == false then
			local interchangableQuestId = Reputable.interchangableQuests[ questID ]
			if interchangableQuestId and Reputable_Data[ key ].quests[ interchangableQuestId ] ~= nil and Reputable_Data[ key ].quests[ interchangableQuestId ] ~= false then
				if Reputable_Data[ key ].quests[ interchangableQuestId ] == true then
					complete = true
					progressIcon = 'tick'
				else
					inProgress = Reputable_Data[ key ].quests[ interchangableQuestId ]
					if inProgress == 1 then progressIcon = 'qdone' else progressIcon = 'qprog' end
				end
			end
		else
			if Reputable_Data[ key ].quests[ questID ] == true then
				complete = true
				progressIcon = 'tick'
			else
				inProgress = Reputable_Data[ key ].quests[ questID ]
				if inProgress == 1 then progressIcon = 'qdone' else progressIcon = 'qprog' end
			end
		end
		--]]
		
		if Reputable_Data[ key ].quests[ questID ] ~= nil and Reputable_Data[ key ].quests[ questID ] ~= false then
			if Reputable_Data[ key ].quests[ questID ] == true then
				complete = true
				progressIcon = 'tick'
			else
				inProgress = Reputable_Data[ key ].quests[ questID ]
				if inProgress == 1 then progressIcon = 'qdone' else progressIcon = 'qprog' end
			end
		end
		
		if q[13] == 1 then
			complete = ( Reputable_Data[key].savedDailies and Reputable_Data[key].savedDailies[ questID ] ) or false
		end
		if q[7] ~= 0 then
			if complete then Reputable_Data[ key ].quests[ q[7] ] = true end
			Reputable:getQuestStatus( q[7] )
			if Reputable_Data[ key ].quests[ q[7] ] == true then
				requiredQuestComplete = true
			else
				requiredQuestComplete = false
			end
		end
		if extraInfo and extraInfo.requires then
			local requirementsMet = true
				for _, quest in pairs ( extraInfo.requires ) do
					if type(quest) == 'table' then
						local eitherComplete = false
						for _, either in pairs ( quest ) do
							if complete then Reputable_Data[ key ].quests[ either ] = true end
							Reputable:getQuestStatus( either )
							if Reputable_Data[ key ].quests[ either ] == true then eitherComplete = true end
						end
						if not eitherComplete then requirementsMet = false end
					else
						if complete then Reputable_Data[ key ].quests[ quest ] = true end
						Reputable:getQuestStatus( quest )
						if Reputable_Data[ key ].quests[ quest ] ~= true then requirementsMet = false end
					end
				end
			requiredQuestComplete = requirementsMet
		end
	--	if not complete and ( repTooLow or repTooHigh or requiredQuestComplete ) == false then progressIcon = 'lock'
		if not complete and ( repTooLow or repTooHigh or requiredQuestComplete == false ) then progressIcon = 'lock'
		elseif q[12] == 1 then progressIcon = '' end
	end
	return colour, complete, inProgress, progressIcon, levelMin, levelTooLow, levelString, minF, minR, maxF, maxR, repTooLow, repTooHigh, requiredQuestComplete
end

function Reputable:getInstanceInfo( instanceID, heroic, key )
	if not key then key = Reputable.profileKey end
	local k = Reputable_Data[ key ]
	local colour, levelTooLow, levelString, requiredQuestComplete, accessKeyMissing, heroicKeyMissing
	if instanceID and Reputable.instance[ instanceID ] then
		Reputable:getInstanceStatus( instanceID )
		local d = Reputable.instance[ instanceID ]
		local iz = Reputable.instanceZones[ d.iz ]
		if d.accessKey then
			local haveKey
			if k.instances and k.instances[ instanceID ] then
				haveKey	= k.instances[ instanceID ].accessKey
			end
			if not haveKey then accessKeyMissing = true end
		end
		if d.accessQuest then
			requiredQuestComplete = k.quests[ d.accessQuest ] or false
		end
		colour = '|cFFFFFC01'
		if heroic then
			local heroicKey = iz.heroicKey
			if heroicKey then
				if type(heroicKey) == 'table' then heroicKey = heroicKey[ k.profile.faction ] end
				local haveHeroicKey
				if k.instances then
					haveHeroicKey = k.instances.heroicKeys[ heroicKey ]
				end
				if not haveHeroicKey then heroicKeyMissing = true end
			end
			local heroicQuest = iz.heroicQuest
			if heroicQuest then
				requiredQuestComplete = k.quests[ d.heroicQuest ] or false
			end
			levelString = LEVEL .." 70|r"
			if k.profile.level < 70 then
				colour = '|cFFFF0000'
				levelTooLow = true
			end
		else
			if k.profile.level < d.level[1] then
				colour = '|cFFFF0000'
				levelTooLow = true
			elseif k.profile.level < d.level[2] then
				colour = '|cFFFF8040'
			elseif k.profile.level > d.level[3] then
				colour = '|cFF40BF40'
			end
			local lvlLimit = " - " .. d.level[3]
			if d.level[3] > 70 then lvlLimit = " - 70" end
			if d.level[2] == 70 then lvlLimit = "" end
			levelString = LEVEL .. " " .. d.level[1] .. " (" .. d.level[2] .. lvlLimit .. ")|r"
		end	
	end
	return colour, levelTooLow, levelString, requiredQuestComplete, accessKeyMissing, heroicKeyMissing
end

function Reputable:getRewardCache( id )
	local isReward = false
	local item = Reputable.repitems[ id ]
	
	if ( item.Alliance or item.Horde ) and not item.bothLoaded then
		item.bothLoaded = true
		if item.Alliance then Reputable:getRewardCache( item.Alliance ) end
		if item.Horde then Reputable:getRewardCache( item.Horde ) end
	end
	
	local name = GetItemInfo( id )
	if name then
		item.isCached = true
	else
		item.isCached = false
		rewardItemCache.list[ id ] = true
	end
	
	if not item.rewardCache then
		if item.reward then
			item.rewardCache = { list = item.reward }
		end

		if item.quest then
			if type(item.quest) == 'table' then
				item.rewardCache = { list = {}, classes = {} }
				
				for k,v in pairs( item.quest ) do
					local className = LOCALIZED_CLASS_NAMES_MALE[ k ]
					if v == true then
						if not item.rewardCache.classes[ item.reward[1] ] then
							item.rewardCache.classes[ item.reward[1] ] = className
						else
							item.rewardCache.classes[ item.reward[1] ] = item.rewardCache.classes[ item.reward[1] ] .. ", " .. className
						end
						item.rewardCache.list = item.reward
					else
						for i,v2 in ipairs( v.reward ) do
							local count = ""
							if #v.reward > 1 then count = " " .. i end
							item.rewardCache.classes[ v2 ] = className .. count
							if k == playerClass then
								table.insert( item.rewardCache.list, 1, v2 )
							else
								table.insert( item.rewardCache.list, v2 )
							end
						end
					end
				end
			end
		end
	end
		
	if item.rewardCache then
		isReward = true
		local allCached = true
		for _,itemID in pairs( item.rewardCache.list ) do
			local name = GetItemInfo( itemID )
			if name then
				item.rewardCache[ itemID ] = true
			else
				item.rewardCache[ itemID ] = false
				allCached = false
				rewardItemCache.list[ itemID ] = id
			end
		end
		if not item.isCached then allCached = false end
		item.rewardCache.allCached = allCached
		item.rewardCache.showing = item.rewardCache.showing or 1
	end
	
	return isReward
end

local allIcons = {
		['tick']		= "|TInterface\\RaidFrame\\ReadyCheck-Ready:0:0:0:%s|t",
		['cross']		= "|TInterface\\RaidFrame\\ReadyCheck-NotReady:0:0:0:%s|t",
		['lock']		= "|TInterface\\LFGFrame\\UI-LFG-ICON-LOCK:0:0:2:%s:32:32:0:28:0:28|t",
		['no']			= "|TInterface\\Buttons\\UI-GroupLoot-Pass-Up:0:0:0:%s|t",
		['Alliance']	= "|TInterface\\TargetingFrame\\UI-PVP-ALLIANCE:0:0:-3:%s:64:64:0:32:0:38|t",
		['Horde']		= "|TInterface\\TargetingFrame\\UI-PVP-HORDE:0:0:0:%s:64:64:0:38:0:36|t",
	--	['rest']		= "|TInterface\\CharacterFrame\\UI-StateIcon:20:20:" .. ( 0 + adjX ) .. ":" .. ( 0 + adjY ) .. ":64:64:0:32:0:32|t",
	--	['star']		= "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_1:14:14:0:" .. ( 0 + adjY ) .. "|t",
		['star']		= "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_1:0:0:0:%s|t",
		['qdone']		= "|cffffd100 ?|r",
		['qprog']		= "|cFF808080 ?|r",
		['qlow']		= "|cFF808080 !|r",
		['qavail']		= "|cffffd100 !|r",
	}
function Reputable:icons( icon, adjY, adjX )
	if not adjY then adjY = 0 end
	if icon == true or ( type( icon ) == 'number' and icon > 0 ) then
		icon = 'tick'
	elseif icon == false or ( type( icon ) == 'number' and icon == 0 ) then
		icon = 'cross'
	end
	local iconImg = ""
	if icon ~= nil and icon ~= "" then iconImg = string.gsub( allIcons[ icon ], "%%s", adjY ) end
	return iconImg
end

function Reputable:setDailyOffest( setOffset, announce )
	local timestamp = time() 
	local dt1 = C_DateAndTime.GetCurrentCalendarTime() -- server
	dt1.day = dt1.monthDay
	dt1.min = dt1.minute
	local dt4 = date( "!*t", timestamp )  -- UTC 
	local dt5 = date( "!*t", timestamp + GetQuestResetTime() + 1 )  -- UTC reset time

	local stUTCdiff = math.floor( (time(dt1)-time(dt4))/3600 + 0.5 )
	local serverRestTime = math.floor( ( time(dt1) + GetQuestResetTime() + 1 ) / 3600 + 0.5 ) * 3600
	local dailyChangeOffset = setOffset or Reputable.dailyChangeOffset[ stUTCdiff ] or 0
	
	Reputable_Data.global.dailyDungeons[ Reputable.server ].dailyChangeOffset = dailyChangeOffset
	local nextChange = GetQuestResetTime() + 3600 * dailyChangeOffset
	if nextChange > 86400 then nextChange = nextChange - 86400 end
	Reputable_Data.global.dailyDungeons[ Reputable.server ].dailyChangeTime = time() + nextChange
	Reputable:resetDailies( true )
	
	if announce then
		print( "|cFF8080FFReputable: |rv", version, "|cFF8080FFRealm:|r", Reputable.server, "|cFF8080FFUTC offset:|r", stUTCdiff )
		print( "Current time || Server:", date("%c", time(dt1) ),      "|| UTC:", date("%c", time(dt4) ) )
		print( "Reset time || Server:",   date("%I:%M%p", serverRestTime ), "|| UTC:", date("%I:%M%p", time(dt5) ) )
		print( "Random dailies are set to change", dailyChangeOffset, "hours after dailies reset at", date("%I:%M%p", serverRestTime + dailyChangeOffset * 3600 ), "servertime." )
		if not setOffset then print( "If this is incorrect please report these details on Reputable's curseforge page or discord" ) end
	end
end

SLASH_REPUTABLE1= "/reputable";
SLASH_REPUTABLE2= "/rep";
function SlashCmdList.REPUTABLE(msg, ...)
	local _, _, cmd, args = string.find(msg, "%s?(%w+)%s?(.*)")
	if cmd == "options" then
		InterfaceOptionsFrame_OpenToCategory(addonName);InterfaceOptionsFrame_OpenToCategory(addonName)
	elseif cmd == "debug" then
		debug( "toggle" )
	elseif cmd == "dailyreset" then
		Reputable_Data.global.dailyDungeons[ Reputable.server ].dailyResetTime = 0
		Reputable_Data.global.dailyDungeons[ Reputable.server ].dailyChangeTime = 0
		Reputable:resetDailies( true )
		Reputable:guiUpdate( true )
	elseif msg == "test" then
		local randomtime = (math.random(100)+20 ) /100
		local myTimer = C_Timer.NewTimer(randomtime, function() debug("Random test waited",randomtime) end )
		--myTimer:Cancel()
	elseif cmd == "version" then
		
		debug( "Version:", version )
		local build, wowEra, buildType = strsplit("-",version);
		build = tonumber( build )
		debug( "Build:", build, buildType )
	elseif cmd == "dailyTime" then
	
		local setOffset = tonumber( args )
		if setOffset then
			setOffset = math.floor( setOffset )
			if setOffset < 0 then setOffset = 0 end
			if setOffset > 23 then setOffset = 23 end
		end
		
		Reputable:setDailyOffest( setOffset, true )
	else
		Reputable:toggleGUI( true )
	end
end

local addonMsgChannels = {
	["GUILD"] = { lastMsg = "", lastMsgTime = 0 },
	["PARTY"] = { lastMsg = "", lastMsgTime = 0 },
	["YELL"]  = { lastMsg = "", lastMsgTime = 0 },
}
local function okToSend( channel )
	if UnitInBattleground("Player") then return end
	if channel == "GUILD" and GetGuildInfo("player") then
		return "GUILD"
	end
	if channel == "PARTY" and IsInGroup() and GetNumGroupMembers() > 1 then
		if IsInRaid() then return "RAID"
		elseif IsInGroup() then return "PARTY" end
	end
	if channel == "YELL" then
		return "YELL"
	end
	return false
end

local function sendMessage( sendChannel, message, msgQuests )
	--if sendChannel == "RAID" then sendChannel = "PARTY" end
	--local sendChannel = okToSend( sendChannel )
	if okToSend( sendChannel ) then
		C_ChatInfo.SendAddonMessage("REPUTABLE", message, okToSend( sendChannel ) )
		--addonMsgChannels[ sendChannel ].lastMsg = msgQuests
		--addonMsgChannels[ sendChannel ].lastMsgTime = time()
	end
end

function Reputable:sendAddonMessage( all, channel, ignore, responseNeeded )
	if not Reputable.addonMessagePrefixRegistered then return end 
	Reputable:resetDailies(false) -- Checks if dailies need to be reset
	
	local nextChange = GetQuestResetTime() + 3600 * Reputable_Data.global.dailyDungeons[ Reputable.server ].dailyChangeOffset
	if nextChange > 86400 then nextChange = nextChange - 86400 end
	if nextChange < 10 or nextChange > 86390 then return end 
	
	if channel and channel == "RAID" then channel = "PARTY" end
	if ignore and ignore == "RAID" then ignore = "PARTY" end
	local action = "send"
	local missingData = false
	local dND, dNDR, dHD, dHDR, dCQ, dCQR, dFQ, dFQR, dPvPQ, dPvPQR = "", "", "", "", "", "", "", "", "", ""
	
	if Reputable_Data.global.dailyDungeons[ Reputable.server ].dailyNormalDungeon then
		dND    = Reputable_Data.global.dailyDungeons[ Reputable.server ].dailyNormalDungeon
		dNDR   = Reputable_Data.global.dailyDungeons[ Reputable.server ].dailyNormalDungeonReset
	end
	if Reputable_Data.global.dailyDungeons[ Reputable.server ].dailyHeroicDungeon then
		dHD    = Reputable_Data.global.dailyDungeons[ Reputable.server ].dailyHeroicDungeon
		dHDR   = Reputable_Data.global.dailyDungeons[ Reputable.server ].dailyHeroicDungeonReset
	end
	if Reputable_Data.global.dailyDungeons[ Reputable.server ].dailyCookingQuest then
		dCQ    = Reputable_Data.global.dailyDungeons[ Reputable.server ].dailyCookingQuest
		dCQR   = Reputable_Data.global.dailyDungeons[ Reputable.server ].dailyCookingQuestReset
	end
	if Reputable_Data.global.dailyDungeons[ Reputable.server ].dailyFishingQuest then
		dFQ    = Reputable_Data.global.dailyDungeons[ Reputable.server ].dailyFishingQuest
		dFQR   = Reputable_Data.global.dailyDungeons[ Reputable.server ].dailyFishingQuestReset
	end
	if Reputable_Data.global.dailyDungeons[ Reputable.server ].dailyPvPQuest then
		dPvPQ  = Reputable_Data.global.dailyDungeons[ Reputable.server ].dailyPvPQuest
		dPvPQR = Reputable_Data.global.dailyDungeons[ Reputable.server ].dailyPvPQuestReset
	end
	
	if dND == "" or dHD == "" or dCQ == "" or dFQ == "" or dPvPQ == "" then missingData = true end
	
	local message = action..":"..version..":"..dND..":"..dNDR..":"..dHD..":"..dHDR..":"..dCQ..":"..dCQR..":"..dFQ..":"..dFQR..":"..dPvPQ..":"..dPvPQR
	local msgQuests = dND..":"..dHD..":"..dCQ..":"..dFQ..":"..dPvPQ
	
	--debug( "Channel:",ignore, "I have missing data:", missingData, "User requires reponse:", responseNeeded )
	if ignore or responseNeeded or missingData then
		for thisChannel in pairs ( addonMsgChannels ) do
		--	if msgQuests ~= addonMsgChannels[ thisChannel ].lastMsg or time() > addonMsgChannels[ thisChannel ].lastMsgTime + 10 then
			if #msgQuests > #addonMsgChannels[ thisChannel ].lastMsg or time() > addonMsgChannels[ thisChannel ].lastMsgTime + 10 then
				if all or channel == thisChannel or ( ignore and ignore ~= thisChannel ) then
					local sendChannel = okToSend( thisChannel )
					
					if okToSend( thisChannel ) then
						
						local randomtime = (math.random(500)+100 ) /100
						addonMsgChannels[ thisChannel ].lastMsg = msgQuests
						addonMsgChannels[ thisChannel ].lastMsgTime = time() + randomtime
						addonMsgChannels[ thisChannel ].waitTimer = C_Timer.NewTimer(randomtime, function() sendMessage( thisChannel, message, msgQuests ) end )
					end
				end
			end
		end
	end
end

local addonMsgArray = {
	{ name = "dailyNormalDungeon" },
	{ name = "dailyHeroicDungeon" },
	{ name = "dailyCookingQuest" },
	{ name = "dailyFishingQuest" },
	{ name = "dailyPvPQuest" },
}
Reputable.needOldVersionMessage = true
function Reputable:addonMessage( message, channel )
	if not Reputable.addonMessagePrefixRegistered then return end 
	Reputable:resetDailies(false) -- Checks if dailies need to be reset
	
	local nextChange = GetQuestResetTime() + 3600 * Reputable_Data.global.dailyDungeons[ Reputable.server ].dailyChangeOffset
	if nextChange > 86400 then nextChange = nextChange - 86400 end
	if nextChange < 10 or nextChange > 86390 then return end
	
	if message then
		local respond = nil
		local responseNeeded = false
		local broadCast = nil
		local a = addonMsgArray
		local action, sentVersion
		action, sentVersion, a[1].questID, a[1].timeLeft, a[2].questID, a[2].timeLeft, a[3].questID, a[3].timeLeft, a[4].questID, a[4].timeLeft, a[5].questID, a[5].timeLeft = strsplit(":", message);
		if action == "send" then
			local build, wowEra, buildType = strsplit("-",version); build = tonumber( build )
			local sentBuild, sentWowEra, sentBuildType = strsplit("-",sentVersion); sentBuild = tonumber( sentBuild )
			
			if not sentBuildType and sentBuild > build and Reputable.needOldVersionMessage then
				print( "|cFF8080FFReputable|r v"..version.. " "..ADDON_INTERFACE_VERSION..". "..sentVersion.." "..AVAILABLE )
				Reputable.needOldVersionMessage = false
			end
			
			if sentBuild > 1.20 then
			
				local recievedChannel = channel
				if recievedChannel == "RAID" then recievedChannel = "PARTY" end
				if addonMsgChannels[ recievedChannel ] and addonMsgChannels[ recievedChannel ].waitTimer then addonMsgChannels[ recievedChannel ].waitTimer:Cancel() end
				
				for i = 1, #a do
					a[i].questID = tonumber( a[i].questID )
					a[i].timeLeft = tonumber( a[i].timeLeft )
				
					if a[i].questID  then
						local questExpires = a[i].timeLeft + 3600 * Reputable_Data.global.dailyDungeons[ Reputable.server ].dailyChangeOffset
						if questExpires < 86400 then
							if questExpires >= nextChange then
								if Reputable_Data.global.dailyDungeons[ Reputable.server ][ a[i].name ] == nil or Reputable_Data.global.dailyDungeons[ Reputable.server ][ a[i].name ] ~= a[i].questID then
									if not Reputable_Data.global.dailyDungeons[ Reputable.server ][ a[i].name .. "Reset" ] or Reputable_Data.global.dailyDungeons[ Reputable.server ][ a[i].name .. "Reset" ] > a[i].timeLeft then
										Reputable_Data.global.dailyDungeons[ Reputable.server ][ a[i].name ] = a[i].questID
										Reputable_Data.global.dailyDungeons[ Reputable.server ][ a[i].name .. "Reset" ] = a[i].timeLeft
										guiNeedsUpdate = true
										broadCast = channel
									end
								end
							end
						end
					elseif Reputable_Data.global.dailyDungeons[ Reputable.server ][ a[i].name ] then
					--	if sentBuild > 1.15 then
							respond = channel
							responseNeeded = true
					--	end
					end
				end
			
				if respond or broadCast then Reputable:sendAddonMessage( false, respond, broadCast, responseNeeded ) end
				
				if broadCast then Reputable:guiUpdate( true ) end
			end
		end
	else
		Reputable:sendAddonMessage( true, nil, nil )
	end
end


local function cycleReward( tooltip )
	local link = select(2, tooltip:GetItem())
	if link then
		local id = tonumber( string.match(link, "item:(%d*)") )
		if Reputable.repitems[ id ] then
			local item = Reputable.repitems[ id ]
			local thisToolTip = tooltip:GetName()
			if item.rewardCache and #item.rewardCache.list > 1 then
				item.rewardCache.showing = item.rewardCache.showing + 1
				if item.rewardCache.showing > #item.rewardCache.list then item.rewardCache.showing = 1 end
				showRewardTooltip[thisToolTip]:ClearLines()
				showRewardTooltip[thisToolTip]:SetHyperlink("item:"..item.rewardCache.list[ item.rewardCache.showing ] )
			end
		end
	end
end

local questWasInProg = {}
local questHeaderWasCollapsed = {}
function Reputable:getQuestLog( needsRefresh )
	--debug( "|cFF00FF00Checking quest log" )
	local needsRefresh = false
	for i = 1, #questHeaderWasCollapsed do questHeaderWasCollapsed[i] = nil end
	
	
	for k,v in pairs ( Reputable_Data[Reputable.profileKey].quests ) do
		if v ~= true and v ~= false then
			questWasInProg[ k ] = v
			Reputable_Data[Reputable.profileKey].quests[ k ] = nil
		end
	end
	--local haveQuestToWatch = false
	local numEntries = GetNumQuestLogEntries()
	for questIndex = 1, numEntries do
		local title, level, suggestedGroup, isHeader, isCollapsed, isComplete, frequency, questID = GetQuestLogTitle(questIndex)
		questHeaderWasCollapsed[ questIndex ] = isCollapsed
		if isHeader and isCollapsed then
			ExpandQuestHeader(questIndex)
			numEntries = GetNumQuestLogEntries()
		end
		if questID then
			if Reputable.questInfo[ questID ] and Reputable_Data[Reputable.profileKey].quests[ questID ] ~= true then
			--	haveQuestToWatch = true
				if isComplete then 
					Reputable_Data[Reputable.profileKey].quests[ questID ] = 1
					if questWasInProg[ questID ] ~= 1 then
						needsRefresh = true
					--	debug("Quest progress complete:", questID, "[", Reputable.questInfo[ questID ][1], "]" )
					end
				else
					local questProgress = ""
					local numObjs = GetNumQuestLeaderBoards(questIndex)
					if numObjs > 0 then
						for objectiveIndex = 1, numObjs do
							local desc, type, done = GetQuestLogLeaderBoard(objectiveIndex, questIndex)
							if numObjs == 1 then
								if desc then questProgress = string.match(desc,': (.*)') or "" end
								if questProgress == "0/1" then questProgress = "" end
							else
								questProgress = questProgress .. " • " .. desc .. "\n"
							end
						end
					end
					if questProgress ~= questWasInProg[ questID ] then
			--			debug("Quest progress changed:", questID, "[", Reputable.questInfo[ questID ][1], "]", questProgress )
						needsRefresh = true
					end
					Reputable_Data[Reputable.profileKey].quests[ questID ] = questProgress
				end
			end
		end
	end
	
	for i=1, #questHeaderWasCollapsed do
		if questHeaderWasCollapsed[#questHeaderWasCollapsed + 1 - i] then
			CollapseQuestHeader( #questHeaderWasCollapsed + 1 - i )
		end
	end
	
	--Reputable.haveQuestToWatch = haveQuestToWatch
	for k,v in pairs ( questWasInProg ) do
		if v ~= nil and Reputable_Data[Reputable.profileKey].quests[ k ] == nil then
			if v ~= Reputable_Data[Reputable.profileKey].quests[ k ] then
			--	debug( "Quest abandoned?", k )
				questWasInProg[ k ] = nil
				needsRefresh = true
			end
		end
	end
	if Reputable.needsRefresh or needsRefresh then
		Reputable:guiUpdate( true )
		Reputable.needsRefresh = false
	end
end


function Reputable:getQuestStatus( questID, recheck )
	if Reputable_Data and Reputable_Data[Reputable.profileKey] then
		if not Reputable.extraQuestInfo[ questID ] then Reputable.extraQuestInfo[ questID ] = {} end
		if not Reputable.extraQuestInfo[ questID ].checkedThisSession or recheck then
	--	if not Reputable.extraQuestInfo[ questID ].checkedThisSession then
			if Reputable.questInfo[ questID ] and Reputable.questInfo[ questID ][13] == 1 then
				Reputable_Data[ Reputable.profileKey ].quests[ questID ] = nil
			--	if questID ~= 11691 then -- Trouble with [Summon Ahune] not resetting on blizzards end
					local complete = C_QuestLog.IsQuestFlaggedCompleted( questID )
					if complete and Reputable.questInfo[ questID ][2] ~= Reputable.notFactionInt[ playerFaction ] then
						if Reputable_Data[Reputable.profileKey].savedDailies == nil then Reputable_Data[Reputable.profileKey].savedDailies = {} end
						Reputable_Data[Reputable.profileKey].savedDailies[ questID ] = complete
			--			debug( "Daily", questID, complete)
					end
			--	end
			end
			local query = true
			if Reputable.questInfo[ questID ] and Reputable.questInfo[ questID ][12] == 1 then query = false end -- (is repeatable)
			if query and Reputable_Data[Reputable.profileKey].quests[ questID ] ~= true then
				if C_QuestLog.IsQuestFlaggedCompleted( questID ) then Reputable_Data[Reputable.profileKey].quests[ questID ] = true end
			else
				if Reputable.extraQuestInfo[ questID ].breadcrumb then
					for _, breadcrumb in pairs ( Reputable.extraQuestInfo[ questID ].breadcrumb ) do
						Reputable_Data[Reputable.profileKey].quests[ breadcrumb ] = true
					end
				end
			end
			
			if Reputable.dailyInfo[ questID ] and Reputable.dailyInfo[ questID ].rep then
				if Reputable.dailyInfo[ questID ].rep[ playerFaction ] then Reputable.dailyInfo[ questID ].rep = Reputable.dailyInfo[ questID ].rep[ playerFaction ] end
				Reputable.questInfo[ questID ][5] = Reputable.dailyInfo[ questID ].rep
			end
			
			Reputable.extraQuestInfo[ questID ].checkedThisSession = true
		end
		
		if not Reputable.extraQuestInfo[ questID ].localizedName then
			Reputable.extraQuestInfo[ questID ].localizedName = true
			local name = C_QuestLog.GetQuestInfo(questID)
			--debug( questID, name )
			if name and Reputable.questInfo[ questID ] then
				Reputable.questInfo[ questID ][1] = name
			else
				C_Timer.After(2, function() Reputable.extraQuestInfo[ questID ].localizedName = false end ) -- Throttles server queries
			end
		end
	end
end

Reputable:SetScript("OnEvent", function (self, event, ...)
	--if event ~= "GET_ITEM_INFO_RECEIVED" then print( event, ... ) end
	--if event == "QUEST_LOG_UPDATE" and Reputable.initiated then
	if event == "PLAYER_LOGIN" then
		Reputable[event] = true
		Reputable:initiate()
	elseif event == "ADDON_LOADED" then
		local thisAddon = ...
		if thisAddon == "Reputable" then
			Reputable[event] = true
			Reputable:initiate()
		end
	else
		if event == "UNIT_QUEST_LOG_CHANGED" and Reputable.initiated then
			--if Reputable.haveQuestToWatch ~= false then Reputable:guiUpdate() end
			Reputable:guiUpdate()
		elseif event == "MODIFIER_STATE_CHANGED" then
			local button, state = ...
			if button == "LALT" or button == "RALT" or button == "LSHIFT" or button == "RSHIFT" then
				local link
				local tt
				if ItemRefTooltip:IsVisible() then tt = ItemRefTooltip; link = select(2, ItemRefTooltip:GetItem())
				elseif GameTooltip:IsVisible() then tt = GameTooltip; link = select(2, GameTooltip:GetItem()) end
				if link then
					local id = tonumber( string.match(link, "item:(%d*)") )
					if Reputable.repitems[ id ] then
						tt:ClearLines()
						tt:SetHyperlink(link)
					end
				end
			elseif ( button == "LCTRL" or button == "RCTRL" ) and state == 1 and Reputable_Data.global.ttShowRewards then
				cycleReward( GameTooltip )
				cycleReward( ItemRefTooltip )
			end
		elseif event == "GET_ITEM_INFO_RECEIVED" then
			local itemID, success = ...
			if success then
				if rewardItemCache.list[ itemID ] then
					local repItem
					if rewardItemCache.list[ itemID ] == true then
						repItem = Reputable.repitems[ itemID ]
						repItem.isCached = true
					else
						repItem = Reputable.repitems[ rewardItemCache.list[ itemID ] ]
						repItem.rewardCache[ itemID ] = true
					end
					local allCached = true
					if repItem.rewardCache then
						for _,rewardItemID in pairs( repItem.rewardCache.list ) do
							if not repItem.rewardCache[ rewardItemID ] then allCached = false end
						end
					end
					if not repItem.isCached then allCached = false end
					if repItem.rewardCache then repItem.rewardCache.allCached = allCached end
					
					if allCached and repItem.rewardCache and repItem.rewardCache.waitingToSend then
						Reputable:sendRewardsList( repItem.rewardCache.waitingToSend[1],repItem.rewardCache.waitingToSend[2],repItem.rewardCache.waitingToSend[3],repItem.rewardCache.waitingToSend[4] )
					end
					

				elseif waitingForData[ itemID ] then
					Reputable:tooltipScan( itemID )
				elseif Reputable.waitingForItemHTML[ itemID ] then

					local pageIsOpen = false
					for k, v in ipairs (Reputable.waitingForItemHTML[ itemID ]) do

						Reputable:tryMakeItemLink( itemID, v[1], v[2], v[3], v[4], v[5], v[6] )
						if v[1] == Reputable.tabOpen then pageIsOpen = true end
					end
					if pageIsOpen then Reputable:loadHTML(nil) end
					Reputable.waitingForItemHTML[ itemID ] = nil
				end			
			end
		elseif event == "PLAYER_LEVEL_UP" then
			Reputable:guiUpdate()
			Reputable.level = ...
			Reputable_Data[Reputable.profileKey].profile.level = Reputable.level
		elseif event == "QUEST_TURNED_IN" then

			local questID = ...
			SendSystemMessage( "reputable_system_msg:questCompleted:"..questID );
			if Reputable_Data[Reputable.profileKey].quests[ questID ] == false then Reputable_Data[Reputable.profileKey].quests[ questID ] = true end
			if Reputable.questInfo[ questID ] then
				if Reputable.questInfo[ questID ][12] == 0 then
					Reputable_Data[Reputable.profileKey].quests[ questID ] = true
				--	debug( "Quest in GUI turned in", questID )
					Reputable:guiUpdate( false, true )
				end
				if Reputable.questInfo[ questID ][13] == 1 then
					if Reputable_Data[Reputable.profileKey].savedDailies == nil then Reputable_Data[Reputable.profileKey].savedDailies = {} end
					Reputable_Data[Reputable.profileKey].savedDailies[ questID ] = true
				--	debug( "Daily quest turned in", questID )
					Reputable:guiUpdate( false, true )
				end
			end
		elseif event == "ITEM_PUSH" then
			Reputable:guiUpdate( true )
		elseif event == "LEARNED_SPELL_IN_TAB" then
			local spellID = ...
			if Reputable_Data[Reputable.profileKey].classbooks[ spellID ] == false then Reputable_Data[Reputable.profileKey].classbooks[ spellID ] = true end
		elseif event == "PLAYER_LEAVING_WORLD" then
			if playerClass == "ROGUE" and not Reputable_Data[Reputable.profileKey].classbooks[ 25347 ] then	-- Rogues poison book exception, scans tooltip for book
				Reputable:tooltipScan( 21302 )
			end
		elseif event == "UPDATE_FACTION" then
			Reputable:getAllFactions()
		elseif event == "QUEST_ACCEPTED" then
			local questIndex = ...
			local _,_,_,_,_,_,_,questID = GetQuestLogTitle(questIndex)
			--debug( questID )
			--Reputable.lastQuestAccepted = questID
		--	SendSystemMessage( "reputable_filter:".. string.gsub( ERR_QUEST_ACCEPTED_S, "%%s", questID ) );
			SendSystemMessage( "reputable_system_msg:questAccepted:"..questID );
			if Reputable.questInfo[ questID ] and Reputable.questInfo[ questID ][12] == 0 then
			--	debug("Quest in GUI accepted", questID)
				Reputable:guiUpdate( false, true )
			end
		elseif event == "GOSSIP_SHOW" then
			local guid = UnitGUID("npc")
			if guid then
			--	debug( GetGossipAvailableQuests() )
				local _, _, _, _, _, npcID, _ = strsplit("-",guid);
				if npcID == "24370" or npcID == "24369" or npcID == "24393" or npcID == "15351" or npcID == "15350" then
					local questName = GetGossipAvailableQuests()
					if Reputable.dailyInfoNames[ questName ] then
						local resetTime = GetQuestResetTime()
						local questID = Reputable.dailyInfoNames[ questName ]
						
						if Reputable.dailyInfo[ questID ].heroic then
							Reputable_Data.global.dailyDungeons[ Reputable.server ].dailyHeroicDungeon = questID
							Reputable_Data.global.dailyDungeons[ Reputable.server ].dailyHeroicDungeonReset = resetTime
							Reputable:addonMessage()
						elseif Reputable.dailyInfo[ questID ].normal then
							Reputable_Data.global.dailyDungeons[ Reputable.server ].dailyNormalDungeon = questID
							Reputable_Data.global.dailyDungeons[ Reputable.server ].dailyNormalDungeonReset = resetTime
							Reputable:addonMessage()
						elseif Reputable.dailyInfo[ questID ].pvp then
							Reputable_Data.global.dailyDungeons[ Reputable.server ].dailyPvPQuest = questID
							Reputable_Data.global.dailyDungeons[ Reputable.server ].dailyPvPQuestReset = resetTime
							Reputable:addonMessage()
						end
					--	debug( questID, questName )
						
						Reputable:guiUpdate( true )
					end
				end
			end
		elseif event == "QUEST_DETAIL" then
			local questID = GetQuestID()
			if questID and Reputable.dailyInfo[ questID ] then
				local resetTime = GetQuestResetTime()
				if Reputable.dailyInfo[ questID ].cooking then
					Reputable_Data.global.dailyDungeons[ Reputable.server ].dailyCookingQuest = questID
					Reputable_Data.global.dailyDungeons[ Reputable.server ].dailyCookingQuestReset = resetTime
					Reputable:addonMessage()
				elseif Reputable.dailyInfo[ questID ].fishing then
					Reputable_Data.global.dailyDungeons[ Reputable.server ].dailyFishingQuest = questID
					Reputable_Data.global.dailyDungeons[ Reputable.server ].dailyFishingQuestReset = resetTime
					Reputable:addonMessage()
				end
				Reputable:guiUpdate( true )
			end
		elseif event == "GROUP_JOINED" then
			Reputable:sendAddonMessage( false, "PARTY", nil )
		elseif event == "CHAT_MSG_ADDON" then
			local prefix, message, channel, sender, target, zoneChannelID, localID, name, instanceID = ...
			if prefix == "REPUTABLE" then
				if sender ~= Reputable.playerName and sender ~= Reputable.profileKey then
					debug( "<-", message, channel, sender )
					Reputable:addonMessage( message, channel )
				else
					debug( "->", message, channel, sender )
				end
			end
		elseif event == "PLAYER_ENTERING_WORLD" then
		elseif event == "ZONE_CHANGED_NEW_AREA" then
			Reputable:switchingZones()
		end
	end
end)

function Reputable:switchingZones()
	if Reputable_Data.global.ldbAutoZone then
		local factionID
		if IsInInstance() then
			local instanceID = select(8, GetInstanceInfo())
			if instanceID and Reputable.instance[ instanceID ] then
				local iz = Reputable.instanceZones[ Reputable.instance[ instanceID ].iz ]
				if iz then
					factionID = iz.faction
				elseif Reputable.instance[ instanceID ].faction then
					factionID = Reputable.instance[ instanceID ].faction
				end
			end
		else
			local zone = C_Map.GetBestMapForUnit("player")
		--	local subZone = GetMinimapZoneText()
			
			if Reputable.factionByMapID[ zone ] then factionID = Reputable.factionByMapID[ zone ] end
			
		--	for mapID, factionByMap in pairs ( Reputable.factionByMapID ) do
		--		local subZoneFromMapID = C_Map.GetAreaInfo(mapID)
		--		if subZoneFromMapID and subZone and subZoneFromMapID == subZone then factionID = factionByMap end
		--	end
		end
		if factionID then
			if type(factionID) == 'table' then factionID = factionID[ playerFaction ] end
			
			--debug( Reputable.factionInfo[ factionID ].name )
			Reputable:setWatchedFaction( factionID )
		end
	end
end

function Reputable:initiate()
	if Reputable.PLAYER_LOGIN and Reputable.ADDON_LOADED then

		local build, wowEra = strsplit("-",version);
		build = tonumber( build )
		--print( build )
		--if not Reputable_Data.global.version or Reputable_Data.global.version < resetAllDataVersion then
		
		local defaultData = {
			profileKeys = {},
			lastLogInMonth = 0,
			cframeHideOriginal = true,
			cframeOutputNum = 1,
			cframeColourize = true,
			cframeEnabled = true,
			cframeShowRewards = true,
			ttShowChatItemsOnMouseOver = true,
			ttShowJunk = true,
			ttShowRewards = true,
			ttShowFaction = true,
			ttShowRepGain = true,
			ttShowStanding = true,
			ttShowList = true,
			ttShowCurrentInList = true,
			ttQuestieAddAlts = true,
			ttQuestieShowOnMouseOver = true,
			mmShow = true,
			mmData = {},
			mmTooltipShowAvailableDailies = true,
			mmTooltipShowOperations = true,
			repMultiplier = true,
			ldbUseBlizzRepBar = false,
			ldbAuto = true,
			ldbAutoZone = true,
			guiShowCompletedQuests = true,
			guiShowExaltedDailies = true,
			guiUseLocalTime = true,
			guiShowNormalDaily = true,
			guiShowHeroicDaily = true,
			guiShowCookingDaily = true,
			guiShowFishingDaily = true,
			guiShowPvPDaily = true,
			repInQuestLog = true,
			xpToolTip = true,
			debug = false,
		}
		
		if Reputable_Data == nil then
		--if Reputable_Data == nil or not Reputable_Data.global.version or Reputable_Data.global.version < resetAllDataVersion then
		--	debug( "Reset data")
			Reputable_Data = {
				global = defaultData
			}
		end
		for option, default in pairs( defaultData ) do
			if Reputable_Data.global[option] == nil then Reputable_Data.global[option] = default end
		end
		if Reputable_Data.global.profileKeys[Reputable.profileKey] == nil then Reputable_Data.global.profileKeys[Reputable.profileKey] = true end
		--[[DELETES OLD DATA!!!--]]
		--if Reputable_Data[ format("%s-%s", playerName, server) ] then
		--	Reputable_Data[profileKey] = Reputable_Data[ format("%s-%s", playerName, server) ]
		--	Reputable_Data[ format("%s-%s", playerName, server) ] = nil
		--	Reputable_Data.global.profileKeys[ format("%s-%s", playerName, server) ] = nil
		--end
		--[[]]--
		if Reputable_Data[Reputable.profileKey] == nil then Reputable_Data[Reputable.profileKey] = {} end
		Reputable_Data[Reputable.profileKey].profile = {
												name	= Reputable.playerName,
												server	= Reputable.server,
												gender	= Reputable.gender,
												level	= Reputable.level,
												class	= playerClass,
												faction	= playerFaction,
											}
		
		if Reputable_Data.global.dailyDungeons == nil then Reputable_Data.global.dailyDungeons = {} end
		if Reputable_Data.global.dailyDungeons[ Reputable.server ] == nil then Reputable_Data.global.dailyDungeons[ Reputable.server ] = {} end
		if Reputable_Data[Reputable.profileKey].instances == nil then Reputable_Data[Reputable.profileKey].instances = { heroicKeys = {} } end
		if Reputable_Data[Reputable.profileKey].quests == nil then Reputable_Data[Reputable.profileKey].quests = {} end
		if Reputable_Data.global.dailyDungeons[ Reputable.server ].dailyChangeOffset == nil then Reputable:setDailyOffest() end
		--if Reputable_Data.global.dailyDungeons[ Reputable.server ].dailyChangeOffset == nil then Reputable:setDailyOffest() end
		--C_Timer.After(5, function() Reputable:UpdateData() end ) -- Delays data grab on login (in seconds). Unnecessary?
		Reputable:getAllFactions( true )
		for k,v in pairs( Reputable.repitems ) do
			if v.quest and not v.repeatable then
				local questID, rewards
				if type(v.quest) == 'table' then
					if v.quest[ playerClass ] then
						if v.quest[ playerClass ] == true then
							questID = v.questID
							rewards = v.reward
						else
							questID = v.quest[ playerClass ].questID
							rewards = v.quest[ playerClass ].reward
						end
					end
				else
					questID = v.quest
					rewards = v.reward
				end
				if questID and not Reputable_Data[Reputable.profileKey].quests[ questID ] then
					local questCompleted = false;
					questCompleted = C_QuestLog.IsQuestFlaggedCompleted( questID )
					if rewards then
						for i,reward in pairs( rewards ) do
							if GetItemCount( reward, true ) > 0 then questCompleted = true end
						end
					end
					Reputable_Data[Reputable.profileKey].quests[ questID ] = questCompleted
				end
			end
		end
		
		if Reputable_Data[Reputable.profileKey].classbooks == nil then Reputable_Data[Reputable.profileKey].classbooks = {} end
		for k,v in pairs( Reputable.classbooks ) do
			if v[playerClass] and not Reputable_Data[Reputable.profileKey].classbooks[ v[playerClass] ] then
				if k == 21302 and playerClass == "ROGUE" then	-- Rogues poison book exception, scans tooltip for book instead
					Reputable:tooltipScan( k )
				else
					local thisBookKnown = false
					if type(v[playerClass]) == 'table' then
						for _,thisSpellCheck in pairs ( v[playerClass] ) do
							if IsSpellKnown( thisSpellCheck ) then thisBookKnown = true end
						end
						Reputable_Data[Reputable.profileKey].classbooks[ v[playerClass][1] ] = thisBookKnown
					else
						Reputable_Data[Reputable.profileKey].classbooks[ v[playerClass] ] = IsSpellKnown( v[playerClass] )
					end
				end
			end
		end
		
		Reputable:resetDailies( true )
		
		
		local lastLogInMonth = tonumber(date("%m%y", time()))
		if Reputable_Data.global.lastLogInMonth ~= lastLogInMonth then
			Reputable_Data.global.lastLogInMonth = lastLogInMonth
			for key in pairs( Reputable_Data.global.profileKeys ) do
				if Reputable_Data[ key ].quests then
					for membershipQuest in pairs ( Reputable.membershipBenefits ) do
						Reputable_Data[ key ].quests[ membershipQuest ] = nil
					end
				end
			end
		end
		
		Reputable.addonMessagePrefixRegistered = C_ChatInfo.RegisterAddonMessagePrefix("REPUTABLE")
		C_Timer.After(8, function()
			Reputable:addonMessage()
		end )
		Reputable:initOptions()
		Reputable:initMiniMap()
		for k,v in pairs( Reputable.instance ) do
			if v.mapID then
			--	local mapName = C_Map.GetAreaInfo( v.mapID )
			--	if mapName then Reputable.instance[k].name = mapName end
				Reputable.instance[k].name = C_Map.GetAreaInfo( v.mapID ) or "Instance: "..k
			end
			if v.zoneMID then
				Reputable.instance[k].subzone = C_Map.GetAreaInfo( v.zoneMID ) or ""
			end
		end
		Reputable_Data.global.version = build
		
		Reputable.initiated = true
		Reputable:guiUpdate()
	end
end

Reputable.needDailyLocalizedNames = true
function Reputable:resetDailies( check )
	--local savedResetTime = Reputable_Data.global.dailyResetTime or 0
	local savedResetTime = Reputable_Data.global.dailyDungeons[ Reputable.server ].dailyResetTime or 0
	local savedChangeTime = Reputable_Data.global.dailyDungeons[ Reputable.server ].dailyChangeTime or 0
	--Reputable_Data.global.dailyDungeons[ Reputable.server ].dailyChangeOffset
	if time() > savedChangeTime then
		debug("Dailies have changed")
		Reputable_Data.global.dailyDungeons[ Reputable.server ].dailyNormalDungeon = nil
		Reputable_Data.global.dailyDungeons[ Reputable.server ].dailyHeroicDungeon = nil
		Reputable_Data.global.dailyDungeons[ Reputable.server ].dailyCookingQuest = nil
		Reputable_Data.global.dailyDungeons[ Reputable.server ].dailyFishingQuest = nil
		Reputable_Data.global.dailyDungeons[ Reputable.server ].dailyPvPQuest = nil
		Reputable_Data.global.dailyDungeons[ Reputable.server ].dailyNormalDungeonReset = 90000
		Reputable_Data.global.dailyDungeons[ Reputable.server ].dailyHeroicDungeonReset = 90000
		Reputable_Data.global.dailyDungeons[ Reputable.server ].dailyCookingQuestReset = 90000
		Reputable_Data.global.dailyDungeons[ Reputable.server ].dailyFishingQuestReset = 90000
		Reputable_Data.global.dailyDungeons[ Reputable.server ].dailyPvPQuestReset = 90000
		local nextChange = GetQuestResetTime() + 3600 * Reputable_Data.global.dailyDungeons[ Reputable.server ].dailyChangeOffset
		if nextChange > 86400 then nextChange = nextChange - 86400 end
		Reputable_Data.global.dailyDungeons[ Reputable.server ].dailyChangeTime = time() + nextChange
		Reputable:guiUpdate()
	end
	if time() > savedResetTime then
		--check = true
		debug("Saved dailies have been reset")
		for key,show in pairs( Reputable_Data.global.profileKeys ) do
			local k = Reputable_Data[key]
			if k.profile and Reputable.server == k.profile.server then
				if k.savedDailies then
					for daily in pairs ( k.savedDailies ) do
						k.savedDailies[daily] = nil
					end
				end
			end
		end
		Reputable_Data.global.dailyDungeons[ Reputable.server ].dailyResetTime = time() + GetQuestResetTime()
		Reputable:guiUpdate()
	end

	if Reputable_Data.global.dailyDungeons[ Reputable.server ].dailyPvPQuest then
		if Reputable.dailyInfo[ Reputable_Data.global.dailyDungeons[ Reputable.server ].dailyPvPQuest ][ playerFaction ] then
			Reputable_Data.global.dailyDungeons[ Reputable.server ].dailyPvPQuest = Reputable.dailyInfo[ Reputable_Data.global.dailyDungeons[ Reputable.server ].dailyPvPQuest ][ playerFaction ]
		end
	end
	
	if Reputable.needDailyLocalizedNames then
		local needDailyLocalizedNames = false
		for questID, data in pairs( Reputable.dailyInfo ) do
			if not data.name then
				local name = C_QuestLog.GetQuestInfo(questID)
				if name then
					Reputable.dailyInfoNames[name] = questID
					Reputable.dailyInfo[questID].name = name
				else
					needDailyLocalizedNames = true
				end
			end
		end
		Reputable.needDailyLocalizedNames = needDailyLocalizedNames
	end
		
	if check then
		--debug( "Quest check")
		local k = Reputable_Data[ Reputable.profileKey ]
		if k.savedDailies then
			for daily in pairs ( k.savedDailies ) do
				k.savedDailies[daily] = nil
			end
		end

		for questID in pairs ( Reputable.questInfo ) do
			Reputable:getQuestStatus( questID, true )
		end
		Reputable:guiUpdate()
		--[[
		for dqID in pairs ( Reputable.dailyInfo ) do
		--	debug( dqID )
			if C_QuestLog.IsQuestFlaggedCompleted( dqID ) then
				if Reputable_Data[Reputable.profileKey].savedDailies == nil then Reputable_Data[Reputable.profileKey].savedDailies = {} end
				Reputable_Data[Reputable.profileKey].savedDailies[ dqID ] = true
			end
			
		end
		for factionID in pairs ( Reputable.questByFaction ) do
			if Reputable.factionInfo[factionID].rquests then
				for _,questID in pairs ( Reputable.factionInfo[factionID].rquests ) do
					if Reputable.questInfo[ questID ][13] == 1 then
						if C_QuestLog.IsQuestFlaggedCompleted( questID ) then
							if Reputable_Data[Reputable.profileKey].savedDailies == nil then Reputable_Data[Reputable.profileKey].savedDailies = {} end
							Reputable_Data[Reputable.profileKey].savedDailies[ questID ] = true
						end
					end
				end
			end
		end
		--]]
	end
end

function Reputable:getDailyCount( key )
	local k = Reputable_Data[key]
	local dailyCount = 0
	local dailyList = ""
	if 	k.profile then
		local countDungeonNoraml = 0
		local countDungeonHeroic = 0
		local countCooking = 0
		local countFishing = 0
		local countPvP = 0
		local countBrewfestBarkQuest = 0
		local normal, heroic, cooking, fishing, pvp, brewfestBarkQuest = "","","","","",""
		if k.savedDailies then
			for questID in pairs ( k.savedDailies ) do
				if Reputable.dailyInfo[ questID ] or Reputable.brefestBarks[ questID ] then
					if 	   Reputable.brefestBarks[ questID ] 	  then countBrewfestBarkQuest = 1; brewfestBarkQuest = "["..Reputable.questInfo[ questID ][1].."]\n"
					elseif Reputable.dailyInfo[ questID ].normal  then countDungeonNoraml = 1; normal  = "["..LFG_TYPE_DAILY_DUNGEON.."]\n"
					elseif Reputable.dailyInfo[ questID ].heroic  then countDungeonHeroic = 1; heroic  = "["..LFG_TYPE_DAILY_HEROIC_DUNGEON.."]\n"
					elseif Reputable.dailyInfo[ questID ].cooking then countCooking 	  = 1; cooking = "["..PROFESSIONS_COOKING.." "..DAILY.."]\n"
					elseif Reputable.dailyInfo[ questID ].fishing then countFishing 	  = 1; fishing = "["..PROFESSIONS_FISHING.." "..DAILY.."]\n"
					elseif Reputable.dailyInfo[ questID ].pvp     then countPvP			  = 1; pvp	   = "["..PVP.." "..DAILY.."]\n" end
				else dailyCount = dailyCount + 1; dailyList = dailyList.."["..Reputable.questInfo[ questID ][1].."]\n" end
			end
			dailyCount = dailyCount + countDungeonNoraml + countDungeonHeroic + countCooking + countFishing + countPvP + countBrewfestBarkQuest
			dailyList = normal..heroic..cooking..fishing..pvp..brewfestBarkQuest..dailyList
		end
	end
	
	return dailyCount, dailyList
end

function Reputable:getRepString( repValue, thisGender, factionName )
	if not thisGender then thisGender = Reputable.gender end
	local standingID
	local dispValue = repValue
	local link
	local standingText
	local normal = "-"
	local noBrackets = "-"
	local colour = "|cffffd100"
	
	if repValue then
		if repValue < -6000			then standingID = 1; dispValue = repValue + 42000
		elseif repValue < -3000		then standingID = 2; dispValue = repValue + 6000
		elseif repValue < 0			then standingID = 3; dispValue = repValue + 3000
		elseif repValue < 3000		then standingID = 4
		elseif repValue < 9000		then standingID = 5; dispValue = repValue - 3000
		elseif repValue < 21000		then standingID = 6; dispValue = repValue - 9000
		elseif repValue < 42000		then standingID = 7; dispValue = repValue - 21000
		elseif repValue >= 42000	then standingID = 8 end
		
		colour = Reputable.factionStandingColours[standingID]
		standingText = GetText("FACTION_STANDING_LABEL"..standingID, thisGender)
		
		if standingID ~= 8 then
			normal = standingText .. " (" .. dispValue .. "/" .. Reputable.factionStandingMax[standingID] .. ")|r"
			noBrackets = standingText .. " " .. dispValue .. "/" .. Reputable.factionStandingMax[standingID] .. "|r"
		else
			normal = standingText
			noBrackets = standingText
		end
		if factionName then
			link = Reputable.playerName .." is " .. standingText .. " with " .. factionName .. ". (" .. dispValue .. " /" .. Reputable.factionStandingMax[standingID] .. ")"
		end
	end
	
	return colour..normal, normal, colour..noBrackets, noBrackets, standingText, dispValue, link
end

function Reputable:getInstanceStatus( instanceID )
	if Reputable.instance[ instanceID ] then
		if Reputable.instance[ instanceID ].iz then
			local heroicKeyID = Reputable.instanceZones[ Reputable.instance[ instanceID ].iz ].heroicKey	
			if heroicKeyID then
				if type(heroicKeyID) == 'table' then heroicKeyID = heroicKeyID[ playerFaction ] end 
				
				local heroicKey = Reputable_Data[Reputable.profileKey].instances.heroicKeys[ heroicKeyID ] or false
				if not heroicKey then
					local haveKey = GetItemCount( heroicKeyID, true )
					if haveKey == 1 then heroicKey = true end
				end
				Reputable_Data[Reputable.profileKey].instances.heroicKeys[ heroicKeyID ] = heroicKey
			end
		end

		if Reputable.instance[ instanceID ].accessKey then
			if not Reputable_Data[Reputable.profileKey].instances[ instanceID ] then Reputable_Data[Reputable.profileKey].instances[ instanceID ] = {} end
			local accessKey = Reputable_Data[Reputable.profileKey].instances[ instanceID ].accessKey or false
			if not accessKey then
				local haveKey = GetItemCount( Reputable.instance[ instanceID ].accessKey, true )
				if haveKey == 1 then accessKey = true end
			end
			Reputable_Data[Reputable.profileKey].instances[ instanceID ].accessKey = accessKey
		end
	end
end

local function addPlayerToInstanceTooltip( instanceID, key, show, heroic, displayLevel, factionID )
	if show then
		local k  = Reputable_Data[key]
		if Reputable.factionInfo[ factionID ][ k.profile.faction ] == false then return end
		if 	k.profile and Reputable.server == k.profile.server and k.profile.level >= displayLevel then
			local levelLock = '' local accessKeyLock = '' local heroicKeyLock = '' local accessQuestLock = ''
			local thisPlayerColour, levelTooLow, levelString, requiredQuestComplete, accessKeyMissing, heroicKeyMissing = Reputable:getInstanceInfo( instanceID, heroic, key )
			if levelTooLow then levelLock = thisPlayerColour .. " (" .. Reputable:icons( 'no' ) .. k.profile.level .. ")|r" end
			if accessKeyMissing then accessKeyLock = Reputable:icons( 'lock' ) end
			if heroicKeyMissing then heroicKeyLock = Reputable:icons( 'lock' ) end
			if requiredQuestComplete == false then accessQuestLock = Reputable:icons( 'lock' ) end
			local reputationString = Reputable:getRepString( k.factions[factionID], k.profile.gender )
			local color = RAID_CLASS_COLORS[k.profile.class]
			GameTooltip:AddDoubleLine( heroicKeyLock .. accessKeyLock .. accessQuestLock .. k.profile.name .. levelLock, reputationString, color.r, color.g, color.b )
		end
	end
end

local function createInstanceToolTip( frame, instanceID, linkData )
	GameTooltip:SetOwner(frame, "ANCHOR_CURSOR", 0, 20)
	Reputable:getInstanceStatus( instanceID )
	local d = Reputable.instance[ instanceID ]
	local iz = Reputable.instanceZones[ d.iz ]
	local factionName
	local factionID
	if iz then
		factionID = iz.faction
		if type(factionID) == 'table' then factionID = factionID[ playerFaction ] end
		factionName = GetFactionInfoByID( factionID );
		if not factionName then
			if Reputable.factionInfo[ factionID ] then factionName = Reputable.factionInfo[ factionID ].name else factionName = "Unknown Faction" end
		end
	end
	local difficulty = "(" .. PLAYER_DIFFICULTY1 .. ")"
	local displayLevel = d.level[1] - 10
	local requirementHeroicKey
	local requirementAccessKey
	local requirementAccessQuest
	local heroic = select( 4, strsplit(":", linkData) )
	if heroic then heroic = tonumber( heroic ) end
	local colour, levelTooLow, levelString, requiredQuestComplete, accessKeyMissing, heroicKeyMissing = Reputable:getInstanceInfo( instanceID, heroic, nil )
	local locked = ""
	if levelTooLow then locked = Reputable:icons( 'no' ) end
	if d.icon then
		Reputable.iconFrame.texture:SetTexture( "Interface\\AddOns\\Reputable\\icons\\" .. d.icon )
		Reputable.iconFrame:Show()
	end
	local rep
	local limit
	local repGain = ""
	local note
	if d.rep then
		local rep = d.rep.normal
		if heroic then rep = d.rep.heroic end
		if rep.rep then repGain = "~" .. Reputable:repWithMultiplier(rep.rep, true) .. " per run" end
		if rep.max then 
			local _,_,_,maxR = Reputable:getRepString( rep.max )
			limit = "|cffffffff" .. maxR .. "|r"
			if Reputable_Data[Reputable.profileKey].factions[factionID] and Reputable_Data[Reputable.profileKey].factions[factionID] > rep.max then limit = "|cFFFF0000" .. maxR .. "|r" end
		end
		if rep.note then limit = limit .. "*"; note = rep.note end
	end
	if heroic then
		Reputable.iconFrame.heroic:Show()
		difficulty = "(" .. PLAYER_DIFFICULTY2 .. ")"
		displayLevel = 60
		local heroicKey = iz.heroicKey
		if heroicKey then
			if type(heroicKey) == 'table' then heroicKey = heroicKey[ playerFaction ] end
			local heroicKeyLink = select(2, GetItemInfo(heroicKey))
			if not heroicKeyLink then heroicKeyLink = "|cff9d9d9d[Item: " .. heroicKey .. "]|r" end
			local haveKey = Reputable_Data[Reputable.profileKey].instances.heroicKeys[ heroicKey ]
			requirementHeroicKey = "|cffffffff" .. string.gsub( LOCKED_WITH_ITEM, "%%s", heroicKeyLink ) .. "|r" .. Reputable:icons( haveKey )
			if not haveKey then locked = Reputable:icons( 'lock' ) end
		end
		if d.heroicQuest then
			requirementAccessQuest = "|cffffffff" .. string.gsub( LOCKED_WITH_ITEM, "%%s", BATTLE_PET_SOURCE_2 .. " " .. Reputable:createLink( "quest" , d.heroicQuest, nil, nil, nil, nil ) ) .. "|r" .. Reputable:icons( requiredQuestComplete )
		end
	end
	if d.raid then difficulty = "(" .. RAID .. ")" end
	if d.accessKey then
		local accessKeyLink = select(2, GetItemInfo(d.accessKey))
		if not accessKeyLink then accessKeyLink = "|cff9d9d9d[Item: " .. d.accessKey .. "]|r" end
		local haveKey = Reputable_Data[Reputable.profileKey].instances[ instanceID ].accessKey
		requirementAccessKey = "|cffffffff" .. string.gsub( LOCKED_WITH_ITEM, "%%s", accessKeyLink ) .. "|r" .. Reputable:icons( haveKey )
		if not haveKey then locked = Reputable:icons( 'lock' ) end
	end
	if d.accessQuest then
		requirementAccessQuest = "|cffffffff" .. string.gsub( LOCKED_WITH_ITEM, "%%s", BATTLE_PET_SOURCE_2 .. " " .. Reputable:createLink( "quest" , d.accessQuest, nil, nil, nil, nil ) ) .. "|r" .. Reputable:icons( requiredQuestComplete )
	end
	GameTooltip:AddDoubleLine( locked .. d.name, difficulty)
	GameTooltip:AddDoubleLine( "|cffffffff" .. d.subzone .. "|r", colour..levelString )
	if factionName then GameTooltip:AddDoubleLine( "|cffffd100" .. factionName .. ":|r", "|cffffd100" .. repGain .. "|r" ) end
	if limit then GameTooltip:AddDoubleLine( "|cffffffff" .. LFG_TYPE_DUNGEON .. " " .. MAXIMUM .. ":|r", limit ) end
	if requirementHeroicKey then GameTooltip:AddLine( requirementHeroicKey ) end
	if requirementAccessKey then GameTooltip:AddLine( requirementAccessKey ) end
	if requirementAccessQuest then GameTooltip:AddLine( requirementAccessQuest ) end
	GameTooltip:AddLine( " " )
	if factionName then
		addPlayerToInstanceTooltip( instanceID, Reputable.profileKey, Reputable_Data.global.ttShowCurrentInList and Reputable_Data.global.profileKeys[ Reputable.profileKey ], heroic, displayLevel, factionID )
		if Reputable_Data.global.ttShowList then
			for key,show in pairs( Reputable_Data.global.profileKeys ) do
				if key ~= Reputable.profileKey then
					addPlayerToInstanceTooltip( instanceID, key, show, heroic, displayLevel, factionID )
				end
			end
		end
	end
	if note then GameTooltip:AddLine( "* " .. note ) end
	if debug() then GameTooltip:AddDoubleLine( "InstanceID", instanceID ) end
	GameTooltip:Show()
end 

local function addFactionToQuestToolip( tooltip, thisRepObj, i, repTooHigh )
	local factionID = thisRepObj[i]
	local factionName;
	if factionID ~= 0 then
		local fontColour = "|cffffd100"
		if repTooHigh or ( Reputable_Data[Reputable.profileKey].factions[factionID] and Reputable_Data[Reputable.profileKey].factions[factionID] >= 42000 ) then fontColour = "|cff808080" end
		factionName = GetFactionInfoByID( factionID )
		if not factionName then
			if Reputable.factionInfo[ factionID ] then factionName = Reputable.factionInfo[ factionID ].name else factionName = UNKNOWN.." "..FACTION  end
		end
		local plus = "+"
		if thisRepObj[i+1] < 0 then plus = "" end
		tooltip:AddDoubleLine( fontColour .. factionName .. ":|r", fontColour..plus.. Reputable:repWithMultiplier(thisRepObj[i+1],nil) .. " " .. REPUTATION .. "|r" )
	end
end

local function addPlayerToQuestToolTipList( tooltip, key, questID, show )
	if show then
		local k  = Reputable_Data[key]
		if 	k.profile and Reputable.server == k.profile.server and Reputable.questInfo[ questID ][2] ~= Reputable.notFactionInt[ k.profile.faction ] then
			local levelColor, complete, inProgress, progressIcon, levelMin, levelTooLow, levelString, minF, minR, maxF, maxR, repTooLow, repTooHigh, requiredQuestComplete = Reputable:getQuestInfo( questID, key, nil )
			local eligible = true
			local closeToLevel = true
			local color = RAID_CLASS_COLORS[k.profile.class]
			if requiredQuestComplete == false then eligible = false end
			local levelLow = ""
			local factionString = ""
			if repTooLow or repTooHigh then eligible = false end
			if k.profile.level < levelMin - 5 then
				closeToLevel = false
			elseif k.profile.level < levelMin then
				eligible = false
				levelLow = " |cFF808080(" .. k.profile.level .. ")|r"
			end
			if Reputable.membershipBenefits[ questID ] then
				local consortiumStanding = k.factions[933] or 0
				factionString = Reputable:getRepString( k.factions[933] ) .. " "
				--tooltip:AddDoubleLine( k.profile.name..levelLow, Reputable:icons( 'lock' ), color.r, color.g, color.b )
			end
			
			if not eligible then
				local interchangableQuestId = Reputable.interchangableQuests[ questID ]
				if interchangableQuestId then
					eligible = true
					levelColor, complete, inProgress, progressIcon, levelMin, levelTooLow, levelString, minF, minR, maxF, maxR, repTooLow, repTooHigh, requiredQuestComplete = Reputable:getQuestInfo( interchangableQuestId, key, nil )
				--	if complete or inProgress then eligible = true end
					if requiredQuestComplete == false then eligible = false end
					if repTooLow or repTooHigh then eligible = false end
					if k.profile.level < levelMin then eligible = false end
				end
			end
			
			if closeToLevel then
				if eligible then
					local status = Reputable:icons( 'qavail' ) .. " "
					if complete then
						status = Reputable:icons( complete )
					elseif inProgress then
						if inProgress == 1 then
							status = COMPLETE
						else
							status = WINTERGRASP_IN_PROGRESS
							if not string.find(inProgress, "\n") and inProgress ~= '' then status = inProgress end
						end
					end
					tooltip:AddDoubleLine( k.profile.name..levelLow, factionString..status, color.r, color.g, color.b )
					if inProgress and inProgress ~= 1 and string.find(inProgress, "\n") then
						tooltip:AddLine( inProgress )
					end
				else
					tooltip:AddDoubleLine( k.profile.name..levelLow, factionString..Reputable:icons( 'lock' ), color.r, color.g, color.b )
				end
				--[[
				if eligible then
					local status = Reputable:icons( 'qavail' ) .. " "
					if complete then
						status = Reputable:icons( complete )
					elseif inProgress then
						if inProgress == 1 then
							status = COMPLETE
						else
							status = WINTERGRASP_IN_PROGRESS
							if not string.find(inProgress, "\n") and inProgress ~= '' then status = inProgress end
						end
					end
					tooltip:AddDoubleLine( k.profile.name..levelLow, factionString..status, color.r, color.g, color.b )
					if inProgress and inProgress ~= 1 and string.find(inProgress, "\n") then
						tooltip:AddLine( inProgress )
					end
				else
					tooltip:AddDoubleLine( k.profile.name..levelLow, factionString..Reputable:icons( 'lock' ), color.r, color.g, color.b )
				end
				--]]
			end
		end
	end
end

local function createQuestToolTip( frame, questID )
	GameTooltip.timerLine = nil
	GameTooltip:SetOwner(frame, "ANCHOR_CURSOR", 0, 20)
	local q = Reputable.questInfo[ questID ]
	local extraInfo = Reputable.extraQuestInfo[ questID ]
	--local npc = Reputable.npcInfo[ q.npc ]
	local repeatable = ""
	local daily = ""
	local pvp = ""
	
	local levelColor, complete, inProgress, progressIcon, levelMin, levelTooLow, levelString, minF, minR, maxF, maxR, repTooLow, repTooHigh, requiredQuestComplete = Reputable:getQuestInfo( questID, nil, nil )

	if q[12] == 1 then repeatable = "|cFF67BCFF" end
	if q[13] == 1 then daily = " (" .. DAILY .. ")" end
	if q[14] == 1 then local dailyFaction if q[2] == 1 then dailyFaction = "Alliance" elseif q[2] == 2 then dailyFaction = "Horde" end pvp = Reputable:icons( dailyFaction, 2 ) end
	
	GameTooltip:AddDoubleLine( pvp..repeatable..q[1]..daily, levelColor .. levelString )
	addFactionToQuestToolip( GameTooltip, q[5], 1, repTooHigh )
	if q[5][3] then addFactionToQuestToolip( GameTooltip, q[5], 3, repTooHigh ) end
	if q[5][5] then addFactionToQuestToolip( GameTooltip, q[5], 5, repTooHigh ) end
	if q[5][7] then addFactionToQuestToolip( GameTooltip, q[5], 7, repTooHigh ) end
	if minF then
		local c = "|cFF00FF00" if repTooLow then c = "|cFFFF0000" end
		local _,_,_,minRStr = Reputable:getRepString( minR )
		GameTooltip:AddLine( c .. string.gsub( LOCKED_WITH_ITEM, "%%s", minRStr .. "|r" ) )
	end
	if maxF then 
		local c = "|cFF00FF00" if repTooHigh then c = "|cFFFF0000" end
		local _,_,_,maxRStr = Reputable:getRepString( maxR )
		GameTooltip:AddLine( c .. MAXIMUM .. " " .. maxRStr .. "|r" )
	end
	if q[7] ~= 0 then
		GameTooltip:AddLine( "|cFFFFFFFF" .. string.gsub( LOCKED_WITH_ITEM, "%%s", BATTLE_PET_SOURCE_2 .. " " .. Reputable:createLink( "quest" , q[7], nil, true, nil, nil ) ) .. "|r" )
	end

	if extraInfo and extraInfo.requires then
		for _, reqQuestID in pairs ( extraInfo.requires ) do
			if type(reqQuestID) == 'table' then
				GameTooltip:AddLine( "|cffffffff" .. string.gsub( LOCKED_WITH_ITEM, "%%s", BATTLE_PET_SOURCE_2 .. " " .. Reputable:createLink( "quest" , reqQuestID[1], nil, true, nil, nil ) ) .. "|r" )
				for _, either in pairs (reqQuestID) do
				end
			else
				GameTooltip:AddLine( "|cffffffff" .. string.gsub( LOCKED_WITH_ITEM, "%%s", BATTLE_PET_SOURCE_2 .. " " .. Reputable:createLink( "quest" , reqQuestID, nil, true, nil, nil ) ) .. "|r" )
			end
		end
	end
	if inProgress then
		GameTooltip:AddLine( " •"..QUEST_TOOLTIP_ACTIVE )
	elseif complete then
		GameTooltip:AddLine( " •"..QUEST_COMPLETE )
	end
	if q[15] then 
		GameTooltip:AddLine( " \n"..q[15], 1,1,1,true )
	end 
	if extraInfo and extraInfo.obj then
		GameTooltip:AddLine( " \n"..OBJECTIVES_LABEL..":" )
		for _, obj in ipairs( extraInfo.obj ) do
			local objectiveText
			if obj[1] == 'item' then
				objectiveText = select(2, GetItemInfo( obj[2] ))
				if not objectiveText then objectiveText = "|cff9d9d9d[Item: " .. obj[2] .. "]|r" end
			end
			GameTooltip:AddLine( "|cFFFFFFFF - " .. objectiveText .. "|cFFFFFFFF x" .. obj[3] .. "|r")
		end
	end
	
	GameTooltip:AddLine( " " )
	addPlayerToQuestToolTipList( GameTooltip, Reputable.profileKey, questID, Reputable_Data.global.ttShowCurrentInList and Reputable_Data.global.profileKeys[ Reputable.profileKey ] )
	if Reputable_Data.global.ttShowList then
		for key,show in pairs( Reputable_Data.global.profileKeys ) do
			if key ~= Reputable.profileKey then
				addPlayerToQuestToolTipList( GameTooltip, key, questID, show )
			end
		end
		GameTooltip:AddLine( " " )
	end
	
	if debug() then GameTooltip:AddDoubleLine( "QuestID:", questID ) end
	if q[13] == 1 then
		GameTooltip:AddDoubleLine( format( DAILY.." "..QUEST_LOG_COUNT , GetDailyQuestsCompleted(), GetMaxDailyQuests() ), RESET..": "..SecondsToTime(GetQuestResetTime()) )
		GameTooltip.timerLine = GameTooltip:NumLines()
		GameTooltip.owner = frame
		frame.UpdateTooltip = function() Reputable:updateResetTime() end
	end
	GameTooltip:Show()
end

local function addPlayerToFactionToolTipList( key, factionID, show, tt, mmtt )
	if not tt then tt = GameTooltip end
	if show then
		local k  = Reputable_Data[key]
		if not mmtt and Reputable.factionInfo[ factionID ][ k.profile.faction ] == false then return end
		local dailiesCount = ""
		if 	k.profile and Reputable.server == k.profile.server then
			local reputationString = Reputable:getRepString( k.factions[factionID], k.profile.gender )
			local color = RAID_CLASS_COLORS[k.profile.class]
			if mmtt then
				local dailyCount = Reputable:getDailyCount( key )
				dailiesCount = "|cffffff00("..dailyCount.." / "..GetMaxDailyQuests()..")|r "
			end
			tt:AddDoubleLine( dailiesCount .. k.profile.name, reputationString, color.r, color.g, color.b )
		end
	end
end

Reputable.addDailiesToToolTip = function ( tt )
	if Reputable_Data.global.mmTooltipShowAvailableDailies then
		local lineAdded = false
		if Reputable_Data.global.guiShowNormalDaily and Reputable_Data.global.dailyDungeons[ Reputable.server ].dailyNormalDungeon then
			local levelColor, complete, inProgress, progressIcon, levelMin, levelTooLow, levelString, minF, minR, maxF, maxR, repTooLow, repTooHigh, requiredQuestComplete = Reputable:getQuestInfo( Reputable_Data.global.dailyDungeons[ Reputable.server ].dailyNormalDungeon, nil, nil )
			local dungeonID = Reputable.dailyInfo[ Reputable_Data.global.dailyDungeons[ Reputable.server ].dailyNormalDungeon ].instanceID
			local levelLock = '' local accessKeyLock = '' local heroicKeyLock = '' local accessQuestLock = '' local allLocks = ''
			local colour, levelTooLow, levelString, requiredQuestComplete, accessKeyMissing, heroicKeyMissing = Reputable:getInstanceInfo( dungeonID, false, nil )
			if accessKeyMissing then accessKeyLock = Reputable:icons( 'lock' ) end
			if requiredQuestComplete == false then accessQuestLock = Reputable:icons( 'lock' ) end
			allLocks = " "..levelLock .. accessKeyLock .. accessQuestLock
			tt:AddDoubleLine( Reputable:icons( complete ).."|cffffff00"..LFG_TYPE_DAILY_DUNGEON.."|r", Reputable:createLink( "instance" , dungeonID, false, nil, nil, nil )..allLocks )
			lineAdded = true
		end
		if Reputable_Data.global.guiShowHeroicDaily and Reputable_Data.global.dailyDungeons[ Reputable.server ].dailyHeroicDungeon then
			local levelColor, complete, inProgress, progressIcon, levelMin, levelTooLow, levelString, minF, minR, maxF, maxR, repTooLow, repTooHigh, requiredQuestComplete = Reputable:getQuestInfo( Reputable_Data.global.dailyDungeons[ Reputable.server ].dailyHeroicDungeon, nil, nil )
			local dungeonID = Reputable.dailyInfo[ Reputable_Data.global.dailyDungeons[ Reputable.server ].dailyHeroicDungeon ].instanceID
			local levelLock = '' local accessKeyLock = '' local heroicKeyLock = '' local accessQuestLock = '' local allLocks = ''
			local colour, levelTooLow, levelString, requiredQuestComplete, accessKeyMissing, heroicKeyMissing = Reputable:getInstanceInfo( dungeonID, true, nil )
			if heroicKeyMissing then heroicKeyLock = Reputable:icons( 'lock' ) end
			if accessKeyMissing then accessKeyLock = Reputable:icons( 'lock' ) end
			if requiredQuestComplete == false then accessQuestLock = Reputable:icons( 'lock' ) end
			allLocks = " "..levelLock .. heroicKeyLock .. accessKeyLock .. accessQuestLock
			tt:AddDoubleLine( Reputable:icons( complete ).."|cffffff00"..LFG_TYPE_DAILY_HEROIC_DUNGEON.."|r", Reputable:createLink( "instance" , dungeonID, true, nil, nil, nil )..allLocks )
			lineAdded = true
		end
		
		if Reputable_Data.global.guiShowCookingDaily and Reputable_Data.global.dailyDungeons[ Reputable.server ].dailyCookingQuest then
			local questID = Reputable_Data.global.dailyDungeons[ Reputable.server ].dailyCookingQuest
			local levelColor, complete, inProgress, progressIcon, levelMin, levelTooLow, levelString, minF, minR, maxF, maxR, repTooLow, repTooHigh, requiredQuestComplete = Reputable:getQuestInfo( questID, nil, nil )
			tt:AddDoubleLine( Reputable:icons( complete ).."|cffffff00"..PROFESSIONS_COOKING.." "..DAILY.."|r", Reputable:createLink( "quest" , questID, nil, nil, nil, nil ) )
			lineAdded = true
		end
		if Reputable_Data.global.guiShowFishingDaily and Reputable_Data.global.dailyDungeons[ Reputable.server ].dailyFishingQuest then
			local questID = Reputable_Data.global.dailyDungeons[ Reputable.server ].dailyFishingQuest
			local levelColor, complete, inProgress, progressIcon, levelMin, levelTooLow, levelString, minF, minR, maxF, maxR, repTooLow, repTooHigh, requiredQuestComplete = Reputable:getQuestInfo( questID, nil, nil )
			tt:AddDoubleLine( Reputable:icons( complete ).."|cffffff00"..PROFESSIONS_FISHING.." "..DAILY.."|r", Reputable:createLink( "quest" , questID, nil, nil, nil, nil ) )
			lineAdded = true
		end
		if Reputable_Data.global.guiShowPvPDaily and Reputable_Data.global.dailyDungeons[ Reputable.server ].dailyPvPQuest then
			local questID = Reputable_Data.global.dailyDungeons[ Reputable.server ].dailyPvPQuest
			local levelColor, complete, inProgress, progressIcon, levelMin, levelTooLow, levelString, minF, minR, maxF, maxR, repTooLow, repTooHigh, requiredQuestComplete = Reputable:getQuestInfo( questID, nil, nil )
			tt:AddDoubleLine( Reputable:icons( complete ).."|cffffff00"..PVP.." "..DAILY.."|r", Reputable:createLink( "quest" , questID, nil, nil, nil, nil ) )
			lineAdded = true
		end
		if lineAdded then tt:AddLine(" ") end
	end
end

Reputable.createFactionToolTip = function ( frame, factionID, mmtt )
	local tt = GameTooltip
	tt:SetOwner(frame, "ANCHOR_CURSOR", 0, 20)
	if mmtt then
		tt = mmtt
		tt.owner = frame
		tt:ClearLines()
		tt:AddDoubleLine("|cFF8080FFReputable|r", RESET..": "..SecondsToTime(GetQuestResetTime()) )
		if Reputable_Data.global.dailyDungeons[ Reputable.server ].dailyChangeOffset ~= 0 then
			local nextChange = GetQuestResetTime() + 3600 * Reputable_Data.global.dailyDungeons[ Reputable.server ].dailyChangeOffset
			if nextChange > 86400 then nextChange = nextChange - 86400 end
			tt:AddDoubleLine( " ", AVAILABLE.." "..DAILY.." "..COMMUNITIES_CREATE_DIALOG_ICON_SELECTION_BUTTON..": "..SecondsToTime( nextChange ), 0.5, 0.5, 0.5, 0.5, 0.5, 0.5 )
		end
		tt:AddLine(" ")
		Reputable.addDailiesToToolTip( tt )
	end

	local factionName,factionDescription ,factionStanding,barMin,barMax,value = GetFactionInfoByID( factionID );
	if not factionName then
		if Reputable.factionInfo[ factionID ] then factionName = Reputable.factionInfo[ factionID ].name else factionName = "Unknown Faction" end
		factionDescription = ""
	end
	
	if mmtt then
		tt:AddDoubleLine( " ", factionName )
	else
		tt:AddLine( factionName )
	end
	
	local change = Reputable.sessionStart.changes[ factionID ]
	if change and not mmtt then
		if change > 0 then change = "+" .. change end
		tt:AddDoubleLine( "Change this session:",change,0.5,0.5,1,0.5,0.5,1 )
	end
	
	if not mmtt then tt:AddLine( factionDescription .. "\n\n", 1, 1, 1, 1 ) end
	
	addPlayerToFactionToolTipList( Reputable.profileKey, factionID, Reputable_Data.global.ttShowCurrentInList and Reputable_Data.global.profileKeys[ Reputable.profileKey ], tt, mmtt )
	if Reputable_Data.global.ttShowList then
		for key,show in pairs( Reputable_Data.global.profileKeys ) do
			if key ~= Reputable.profileKey then
				addPlayerToFactionToolTipList( key, factionID, show, tt, mmtt )
			end
		end
	end
	tt:Show()
end
local createFactionToolTip = Reputable.createFactionToolTip

local function addRepToToolTip( self, id, showFull )
	local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemIcon,
		itemSellPrice, itemClassID, itemSubClassID, bindType, expacID, itemSetID, isCraftingReagent = GetItemInfo( id )
	
	local item = Reputable.repitems[ id ]
	local factionID = item.faction
	if type(factionID) == 'table' then factionID = item.faction[ playerFaction ] end
	if itemMinLevel == nil then itemMinLevel = 0 end
	if item.level then itemMinLevel = item.level end
	local requiredStanding = ""
	
	if item.min then
		local _,_,_,minR,standingText,dispValue = Reputable:getRepString( item.min )
		local display = minR
		if dispValue == 0 then display = standingText end
		requiredStanding = requiredStanding .. "|cffffffff" .. string.gsub( LOCKED_WITH_ITEM, "%%s", display .. "|r\n" )
	end
	if item.max then 
		local _,_,_,maxR = Reputable:getRepString( item.max )
		requiredStanding = requiredStanding .. "|cffffffff" .. MAXIMUM .. " " .. maxR .. "|r\n"
	end
	
	
	
	if factionID then
		local factionName,_,factionStanding,barMin,barMax,value = GetFactionInfoByID( factionID );
		
		if not factionName then if Reputable.factionInfo[ factionID ] then factionName = Reputable.factionInfo[ factionID ].name else factionName = "Unknown Faction" end end

		local stack = ""
		if item.stack then stack = " (per " .. item.stack .. ")" end
		local itemrep = ""

		if item.rep then  itemrep = Reputable:repWithMultiplier( item.rep, nil ) end
		local repIncrease = ""
		if itemrep and Reputable_Data.global.ttShowRepGain then repIncrease = ": ".. itemrep .. stack end

		local factionHeader = ""
		if Reputable_Data.global.ttShowFaction then
			factionHeader = "|cffffd100" .. factionName .. repIncrease .. "\124r\n"
		end
		local factionStandingtext = ""
		if Reputable_Data.global.ttShowStanding then
			factionStandingtext = "|cffffd100Faction not encountered yet".."\124r\n"
			if Reputable_Data[Reputable.profileKey].factions[factionID] then
				local reputationString = Reputable:getRepString( Reputable_Data[Reputable.profileKey].factions[factionID] )
				factionStandingtext = reputationString.."\124r\n"
			end
		end
		if _G[ self:GetName().."TextLeft2" ]:GetText() then
			_G[ self:GetName().."TextLeft2" ]:SetText( factionHeader..factionStandingtext..requiredStanding.._G[ self:GetName().."TextLeft2" ]:GetText())
		else
			self:AddLine( factionHeader..factionStandingtext..requiredStanding )
		end
	end

	local itemRewards = Reputable:getRewardCache( id )
	local classRewards = false
	--local soulbound = false
	local startsquest = false
	for i = 1, self:NumLines() do
		local thisLine = _G[ self:GetName().."TextLeft"..i ]:GetText()
		if thisLine and string.find( thisLine, ITEM_STARTS_QUEST ) then startsquest = i end
	--	if thisLine and string.find( thisLine, ITEM_SOULBOUND ) then soulbound = i end
	end
	
	if item.quest then
		local questID
		if type(item.quest) == 'table' then
			classRewards = true
			if item.quest[ playerClass ] then
				if item.quest[ playerClass ] == true then
					questID = item.questID
				else
					questID = item.quest[ playerClass ].questID
				end
			end
		else
			questID = item.quest
		end
		if questID then
			local questStatus = Reputable:icons( 'cross' )
			if item.repeatable then
				questStatus = "|cff82c5ff(?)|r"
			elseif Reputable_Data[Reputable.profileKey].quests[ questID ] then
				questStatus = Reputable:icons( 'tick' )
			end
			if startsquest then
				_G[ self:GetName().."TextLeft"..startsquest ]:SetText(_G[ self:GetName().."TextLeft"..startsquest ]:GetText().. " " .. questStatus )
			elseif _G[ self:GetName().."TextLeft3" ]:GetText() then
				_G[ self:GetName().."TextLeft3" ]:SetText( _G[ self:GetName().."TextLeft3" ]:GetText().. " " .. questStatus )
			end
		end
	end
	
	local function addPlayerToList( key, show )
		if show then
			local k  = Reputable_Data[key]
			if 	k.profile and Reputable.server == k.profile.server and not item[ k.profile.faction ] then
				local color = RAID_CLASS_COLORS[k.profile.class]
				local reqlevel = ""
				if k.profile.level < itemMinLevel then reqlevel = "|cff808080 ("..k.profile.level..")" end
				
				local rewardForThisClass = true
				if classRewards and not item.quest[ k.profile.class ] then rewardForThisClass = false end
				
				local complete = ""
				local questForThisAlt = false
				local thisQuestId
				if classRewards then
					if item.quest[ k.profile.class ] then
						if  item.quest[ k.profile.class ] == true then
							thisQuestId = item.questID
						else
							thisQuestId = item.quest[ k.profile.class ].questID
						end
					end
				else
					thisQuestId = item.quest
				end
				if thisQuestId and not item.repeatable then
					questForThisAlt = true

					complete = Reputable:icons( 'cross' )
					if k.quests[ thisQuestId ] then complete = Reputable:icons( 'tick' ) end
					if k.quests[ thisQuestId ] == nil then complete = "|cff808080 (?)" end
				end
				
				if factionID then
					local reputationString = Reputable:getRepString( k.factions[factionID], k.profile.gender )
					if ( k.profile.level >= itemMinLevel and ( rewardForThisClass or questForThisAlt ) ) or IsAltKeyDown() then self:AddDoubleLine( k.profile.name..reqlevel..complete, reputationString, color.r, color.g, color.b ) end
				end
			end
		end
	end
	if showFull ~= false then
		addPlayerToList( Reputable.profileKey, Reputable_Data.global.ttShowCurrentInList and Reputable_Data.global.profileKeys[ Reputable.profileKey ] )
		if Reputable_Data.global.ttShowList then
			for key,show in pairs( Reputable_Data.global.profileKeys ) do
				if key ~= Reputable.profileKey then
					addPlayerToList( key, show )
				end
			end
		end
	end

	if Reputable.repitemsets[ id ] then
		self:AddLine( " " )
		self:AddLine( "Set:" )
		for i,v in ipairs( Reputable.repitemsets[ id ] ) do
			local thisItemLink = select( 2, GetItemInfo( Reputable.repitemsets[ id ][i] ) ) or ""
			local note = ""
			if Reputable.repitemsets[ id ].note then note = Reputable.repitemsets[ id ].note[i] end
			
			local countBags = GetItemCount(Reputable.repitemsets[ id ][i])
			local countTotal = GetItemCount(Reputable.repitemsets[ id ][i], true)
			local bankText = ""
			if countTotal - countBags ~= 0 then bankText = "(".. (countTotal - countBags) .. " in bank) " end
			self:AddDoubleLine( thisItemLink.." "..note, bankText .. countTotal )
		end		
	end
	if item.note then self:AddLine("* ".. item.note) end
	self:Show()
	
	if itemRewards then
		if Reputable_Data.global.ttShowRewards then
			local thisToolTip = self:GetName()
			showRewardTooltip[thisToolTip]:SetOwner(self, "ANCHOR_NONE")
			showRewardTooltip[thisToolTip]:SetHyperlink("item:"..item.rewardCache.list[ item.rewardCache.showing ] )
			
			local tooltip, anchorFrame, shoppingTooltip1, shoppingTooltip2 = GameTooltip_InitializeComparisonTooltips(showRewardTooltip[thisToolTip]);
			local primaryItemShown, secondaryItemShown = shoppingTooltip1:SetCompareItem(shoppingTooltip2, tooltip);
			shoppingTooltip1:SetCompareItem(shoppingTooltip2, tooltip);
				
			if IsShiftKeyDown() then shoppingTooltip1:Show() else shoppingTooltip1:Hide() end
			
			local screenW = GetScreenWidth() or 0
			local ttC = 0
			local ttW = showRewardTooltip[thisToolTip]:GetWidth() or 0
			local ttR = self:GetRight() or 0
			if shoppingTooltip1:IsVisible() then ttC = shoppingTooltip1:GetWidth() end
			if screenW - (ttR + ttC) < ttW then
				showRewardTooltip[thisToolTip]:ClearAllPoints()
				showRewardTooltip[thisToolTip]:SetPoint("TOPRIGHT",thisToolTip,"TOPLEFT",0,0);
				shoppingTooltip1:ClearAllPoints()
				shoppingTooltip1:SetPoint("TOPRIGHT",showRewardTooltip[thisToolTip],"TOPLEFT",0,0)
			else
				showRewardTooltip[thisToolTip]:ClearAllPoints()
				showRewardTooltip[thisToolTip]:SetPoint("TOPLEFT",thisToolTip,"TOPRIGHT",0,0);
				shoppingTooltip1:ClearAllPoints()
				shoppingTooltip1:SetPoint("TOPLEFT",showRewardTooltip[thisToolTip],"TOPRIGHT",0,0)
			end
		end
	end
end

local function addClassBookToToolTip( self, id )
	local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemIcon,
		itemSellPrice, itemClassID, itemSubClassID, bindType, expacID, itemSetID, isCraftingReagent = GetItemInfo( id )
	if not itemMinLevel then itemMinLevel = 0 end
	for key,show in pairs( Reputable_Data.global.profileKeys ) do
		--if key ~= Reputable.profileKey then
			local k  = Reputable_Data[key]
			if 	k.profile and Reputable.server == k.profile.server then
				if Reputable.classbooks[ id ][ k.profile.class ] then
					local color = RAID_CLASS_COLORS[k.profile.class]
					local isLearned = "|cff808080?"
					
					local reqlevel = ""
					if k.profile.level < itemMinLevel then reqlevel = "|cff808080 ("..k.profile.level..")" end
					
					if k.classbooks then
						local thisBookSpell = Reputable.classbooks[ id ][ k.profile.class ]
						if type(thisBookSpell) == 'table' then thisBookSpell = thisBookSpell[1] end
						isLearned = Reputable:icons( k.classbooks[ thisBookSpell ] )
					end
					self:AddDoubleLine( k.profile.name .. reqlevel, isLearned, color.r, color.g, color.b )
					self:Show()
				end
			end
		--end
	end
end

local function addJunkmessageToToolTip( itemID )
	local questID = Reputable.junk[ itemID ]
	if type(questID) == 'table' then

		questID = Reputable.junk[ itemID ][ playerFaction ]
	end
	if C_QuestLog.IsQuestFlaggedCompleted( questID ) then
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine("* This can now be destroyed")
		GameTooltip:Show()
	end
end



function Reputable:createLink( linkType, id, heroic, showProgress, icon, factionID, nameIconVAlign )

	local name = linkType .. ": " .. id
	local link
	local linkData = ""
	local iconStr = ""
	local suffix = ""

	if linkType == "item" then
		link = select(2, GetItemInfo(id))
	else
		local fontColor = "|cFFFFFC01"
		if linkType == "faction" then
			fontColor = "|cFF8080FF"
			if Reputable.factionInfo[ id ] and Reputable.factionInfo[ id ].name then
				name = Reputable.factionInfo[ id ].name
			else
				local factionName,factionDescription ,factionStanding,barMin,barMax,value = GetFactionInfoByID( id );
				if factionName then name = factionName end
			end
		elseif linkType == "instance" then
			local d = Reputable.instance[ id ]
			if d then
				name = d.name
				fontColor = Reputable:getInstanceInfo( id, heroic, nil )
				if d.raid then name = RAID..": "..name end
			end
			if heroic then
				name = string.gsub( HEROIC_PREFIX, "%%s", name )
				linkData = linkData .. ":1"
			end

		elseif linkType == "quest" and Reputable.questInfo[ id ] then
			local q = Reputable.questInfo[ id ]
			name = q[1]
			local levelColor, complete, inProgress, progressIcon, levelMin, levelTooLow, levelString, minF, minR, maxF, maxR, repTooLow, repTooHigh, requiredQuestComplete = Reputable:getQuestInfo( id, nil, factionID )
			fontColor = levelColor
			if showProgress then suffix = Reputable:icons( progressIcon ) end
			if not complete and repTooHigh then fontColor = "|cFF808080" end
			if q[12] == 1 and not levelTooLow and not repTooHigh then fontColor = "|cFF67BCFF" end
			if q[13] == 1 then name = name.." (" .. DAILY .. ")" end
			--if q[14] == 1 then local dailyFaction if q[2] == 1 then dailyFaction = "Alliance" elseif q[2] == 2 then dailyFaction = "Horde" end name = Reputable:icons( dailyFaction, -9 ) .. name end
			if q[14] == 1 then
				if not nameIconVAlign then nameIconVAlign = 0 end
				local dailyFaction if q[2] == 1 then dailyFaction = "Alliance" elseif q[2] == 2 then dailyFaction = "Horde" end
				name = Reputable:icons( dailyFaction, nameIconVAlign ) .. name
			end
		end
		if icon then iconStr = icon end
		link = iconStr .. fontColor .. "|Hreputable:" .. linkType .. ":" .. id .. linkData .. "|h[" .. name .. "]|h" .."|r" .. suffix .. " "
	end
	return link
end

--function Reputable:updateResetTime( self, tt )
function Reputable:updateResetTime()
	local tooltip = Reputable.DataBrokerActiveTooltip or GameTooltip
	--debug("tooltip update running")
	if tooltip:IsVisible() and tooltip.timerLine then
		local tt = tooltip:GetName()
		_G[tt.."TextRight"..tooltip.timerLine]:SetText( RESET..": "..SecondsToTime(GetQuestResetTime()) )
	--	_G[tt.."TextRight"..tooltip.timerLine]:SetText( RESET..": "..GetQuestResetTime() )
		
		if Reputable_Data.global.dailyDungeons[ Reputable.server ].dailyChangeOffset ~= 0 then
			local nextChange = GetQuestResetTime() + 3600 * Reputable_Data.global.dailyDungeons[ Reputable.server ].dailyChangeOffset
			if nextChange > 86400 then nextChange = nextChange - 86400 end
			_G[tt.."TextRight"..tooltip.timerLine+1]:SetText( AVAILABLE.." "..DAILY.." "..COMMUNITIES_CREATE_DIALOG_ICON_SELECTION_BUTTON..": "..SecondsToTime( nextChange ) )
		end
	elseif tooltip.owner then
		tooltip.owner.UpdateTooltip = nil
		tooltip.owner = nil
	end
end

local function createDailiesListTooltip( frame, key )
	local k = Reputable_Data[key]
	if 	k.profile and Reputable.server == k.profile.server then
		local color = "|c"..RAID_CLASS_COLORS[k.profile.class].colorStr
		local dailyCount, dailyList = Reputable:getDailyCount( key )
		GameTooltip.timerLine = nil
		GameTooltip:SetOwner(frame, "ANCHOR_CURSOR", 0, 20)
		GameTooltip.owner = frame
		--debug( frame)
		GameTooltip:AddDoubleLine( color..k.profile.name, "|cffffff00("..dailyCount.." / "..GetMaxDailyQuests()..")|r" )
		GameTooltip:AddLine(" ")
		if dailyCount > 0  then
			GameTooltip:AddLine(dailyList)
			GameTooltip:AddLine(" ")
		end
		GameTooltip:AddDoubleLine( " ",RESET..": "..SecondsToTime(GetQuestResetTime()) )
		GameTooltip.timerLine = GameTooltip:NumLines()
		GameTooltip:Show()
	end
end

function Reputable:OnHyperlinkEnter(self, linkData)
	if not linkData or not Reputable.initiated then return end
	local doHandle = string.match(linkData, "reputable:")
	local item = string.match(linkData, "item:")
	local questieID = tonumber( string.match(linkData, "questie:(%d*)") )

	if doHandle then
		self.UpdateTooltip = nil
		local instanceID = tonumber( string.match(linkData, "instance:(%d*)") )
		local factionID  = tonumber( string.match(linkData,  "faction:(%d*)") )
		local questID    = tonumber( string.match(linkData,    "quest:(%d*)") )
		local dailiesListKey = string.match(linkData, "dailiesList:(...*)")
		if instanceID and Reputable.instance[ instanceID ] then
			createInstanceToolTip( self, instanceID, linkData )
		elseif factionID then
			createFactionToolTip( self, factionID, nil )
		elseif questID and Reputable.questInfo[ questID ] then
			createQuestToolTip( self, questID )
		elseif dailiesListKey then
			createDailiesListTooltip( self, dailiesListKey )
			self.UpdateTooltip = function() Reputable:updateResetTime() end
		end
	end
	--if item and self.showItemTooltip then
	if Reputable_Data.global.ttShowChatItemsOnMouseOver and item then
		GameTooltip:SetOwner(self, "ANCHOR_CURSOR", 0, 20)
		GameTooltip:SetHyperlink( linkData )
		GameTooltip:Show()
	end
	if questieID and Reputable.questInfo[ questieID ]  and Reputable_Data.global.ttQuestieShowOnMouseOver then
		createQuestToolTip( self, questieID )
	end
end

function Reputable:setFactionFromHyperLink( linkData )
	if IsControlKeyDown() and Reputable.initiated then 
		local factionID  = tonumber( string.match(linkData, "faction:(%d*)") )
	--	local instanceID = tonumber( string.match(link, "reputable:instance:(%d*)") )
		if factionID then
			Reputable:setWatchedFaction( factionID )
		end
	end
end

for i = 1, NUM_CHAT_WINDOWS do
	local frame = _G["ChatFrame"..i]
	frame:SetScript("OnHyperlinkEnter", function(...) Reputable:OnHyperlinkEnter(...) end )
	frame:SetScript("OnHyperlinkLeave", function() GameTooltip:Hide() end )
	--frame:HookScript("OnHyperlinkClick", function(self, linkData ) Reputable:setFactionFromHyperLink( linkData ) end )
end

local function parseChatLink( link, text, button )
    if (IsShiftKeyDown() and ChatEdit_GetActiveWindow() and button == "LeftButton") then
        local handle, linkType, id, _ = string.split(":", link)
        if handle == 'reputable' then
            id = tonumber(id)
			local name = string.match(text, "%[(.*)%]" )
			local output = ''
			if linkType == 'instance' then
				output = name
			elseif linkType == 'quest' then
				if Questie then output = "[".. Reputable.questInfo[ id ][1] .. " (".. id .. ")]"
				else output = "["..Reputable.questInfo[ id ][1].."]" end
			elseif linkType == 'faction' then
				local _,_,_,_,_,_,reputationString = Reputable:getRepString( Reputable_Data[Reputable.profileKey].factions[id], nil, name )
				output = reputationString
				if not output then output = name end
			end
			return output
        end
    elseif IsControlKeyDown() then
        local handle, linkType, id, _ = string.split(":", link)
        if handle == 'reputable' and linkType == 'quest' then
			id = tonumber(id)
			local q = Reputable.questInfo[ id ]
			if q and q[12] ~= 1 then
				if Reputable.ingoredQuestsForRep == nil then Reputable.ingoredQuestsForRep = {} end
				if Reputable.ingoredQuestsForRep[id] == nil then Reputable.ingoredQuestsForRep[id] = true else Reputable.ingoredQuestsForRep[id] = nil end
				Reputable:guiUpdate( true )
			end
		end
	end
end

function Reputable:insertChatLink( link, text, button )
	ChatEdit_InsertLink( parseChatLink( link, text, button ) )
end

hooksecurefunc("ChatFrame_OnHyperlinkShow", function( self, link, text, button )
	if not Reputable.initiated then return end
	local output = parseChatLink( link, text, button)
	if output then
		local msg = ChatFrame1EditBox:GetText()
        if msg then
			ChatFrame1EditBox:SetText("")
			ChatEdit_InsertLink(string.gsub(msg, "%|c(.*)%|H" .. link .. ".*%|r", output))
		end
    end
end)

local oldItemSetHyperlink = ItemRefTooltip.SetHyperlink
function ItemRefTooltip:SetHyperlink(link, ...)
	local doHandle = string.match(link, "reputable:")
	if doHandle and Reputable.initiated then
		local instanceID = tonumber( string.match(link, "instance:(%d*)") )
		local factionID  = tonumber( string.match(link,  "faction:(%d*)") )
		if instanceID then
			if Reputable.instance[ instanceID ] then
				Reputable:toggleGUI( true )
				if Reputable.attunements[ instanceID ] then
					Reputable:loadHTML( 'attune'..instanceID )
				else
					Reputable:loadHTML( 'dungeons' )
				end
			end
		elseif factionID then
			if Reputable.questByFaction[ factionID ] and Reputable.factionInfo[ factionID ][ playerFaction ] ~= false then
				Reputable:toggleGUI( true )
				Reputable:loadHTML( 'faction'..factionID )		
			end
		end
	else
       oldItemSetHyperlink(self, link, ...)
    end
end

-- TEMP DISABLED LINKING OF ITEM REWARDS --
--[[
local oldSendChatMessage = SendChatMessage
function SendChatMessage( msg, chatType, lang, channel )
	local link = string.match(msg, "^(\|c.*\|r)$")
	local _,count = string.gsub(msg, "\|c", "\|c" )
	local itemID =  tonumber( string.match(msg, "item:(%d*)") )
	if Reputable_Data.global.cframeShowRewards and link and count == 1 and itemID and Reputable.repitems[ itemID ] then
		local hasRewards = Reputable:getRewardCache( itemID )
		if hasRewards then
			Reputable:sendRewardsList( chatType, lang, channel, itemID )
		else
			oldSendChatMessage( msg, chatType, lang, channel )
		end
	else
		oldSendChatMessage( msg, chatType, lang, channel )
	end
end
--]]

function Reputable:sendRewardsList( chatType, lang, channel, itemID )
	local item = Reputable.repitems[ itemID ]
	if item and item.rewardCache then
		if item.rewardCache.allCached then
			local itemName, itemLink = GetItemInfo( itemID )
			local newMSG = itemLink .. " " .. REWARDS .. ":"
			item.rewardCache.waitingToSend = false
			oldSendChatMessage( newMSG, chatType, lang, channel )
			for k, v in pairs ( item.rewardCache.list ) do
				local itemName, itemLink = GetItemInfo( v )
				local count = k
				if item.rewardCache.classes and item.rewardCache.classes[ v ] then count = item.rewardCache.classes[ v ] end
				oldSendChatMessage( count..": "..itemLink, chatType, lang, channel )
			end
		else
			item.rewardCache.waitingToSend = { chatType, lang, channel, itemID }
		end
	end
end

hooksecurefunc(ItemRefTooltip, "SetHyperlink", function(self, link )
	local id = tonumber( string.match(link, "item:(%d*)") )
	local questieID = tonumber( string.match(link, "questie:(%d*)") )
	if id then
		if Reputable.repitems[ id ] then
			if Reputable.repitems[ id ][ playerFaction ] then id = Reputable.repitems[ id ][ playerFaction ] end
			addRepToToolTip( self, id, true )
		elseif Reputable.classbooks[ id ] then
			addClassBookToToolTip( self, id )
		end
	end
	if questieID and Reputable_Data and Reputable_Data.global.ttQuestieAddAlts then
		self:AddLine( " " )
		if Reputable_Data.global.ttShowList then
			for key,show in pairs( Reputable_Data.global.profileKeys ) do
				if key ~= Reputable.profileKey then
					addPlayerToQuestToolTipList( self, key, questieID, show )
				end
			end
			self:AddLine( " " )
		end
		self:Show()
	end
end)


GameTooltip:HookScript("OnTooltipSetItem", function(self)
	local link = select(2, self:GetItem())
	if link then
		local id = tonumber( string.match(link, "item:(%d*)") )
		if id then
			if Reputable.repitems[ id ] then
				if Reputable.repitems[ id ][ playerFaction ] then id = Reputable.repitems[ id ][ playerFaction ] end
				addRepToToolTip( self, id, true )
			elseif Reputable.classbooks[ id ] then
				addClassBookToToolTip( self, id )
			elseif Reputable.junk[ id ] and Reputable_Data and Reputable_Data.global.ttShowJunk then
				addJunkmessageToToolTip( id )
			end
		end
	end
end)

local function addRewardInfoToRewardToolTip( tooltip, link )
	if link then
		local id = tonumber( string.match(link, "item:(%d*)") )
		if Reputable.repitems[ id ] then
			local item = Reputable.repitems[ id ]
			local showingReward = item.rewardCache.list[ item.rewardCache.showing ]
			if Reputable.repitems[ showingReward ] then addRepToToolTip( tooltip, showingReward, false ) end
			local countBags = GetItemCount(showingReward)
			local countTotal = GetItemCount(showingReward, true)
			local countBank = countTotal - countBags
			local isEquipped = IsEquippedItem(showingReward)
			local countBagsstr = "" local isEquippedstr = "" local countBankstr = ""
			if isEquipped then isEquippedstr = "Equipped"; countBags = countBags - 1 end
			if countBags > 0 then countBagsstr = " ("..INVTYPE_BAG..": " .. countBags .. ")" end
			if countBank > 0 then countBankstr = " ("..BANK..": " .. countBank .. ")" end
			if countTotal > 0 then tooltip:AddDoubleLine( " ",isEquippedstr.. countBagsstr.. countBankstr ) end
			if #item.rewardCache.list > 1 then tooltip:AddDoubleLine( "Press CTRL to cycle rewards",item.rewardCache.showing.."/"..#item.rewardCache.list ) end
			tooltip:Show()
		end
	end
end
showRewardTooltip.ItemRefTooltip:HookScript("OnTooltipSetItem", function(self)
	local link = select(2, ItemRefTooltip:GetItem())
	addRewardInfoToRewardToolTip( self, link )
end)
showRewardTooltip.GameTooltip:HookScript("OnTooltipSetItem", function(self)
	local link = select(2, GameTooltip:GetItem())
	addRewardInfoToRewardToolTip( self, link )
end)

local Reputable_msg_filter_rep = function(frame, event, message, ...)
	local hideRepMessage = true
	if Reputable_Data and Reputable_Data.global then hideRepMessage = Reputable_Data.global.cframeHideOriginal end
	return hideRepMessage
end
ChatFrame_AddMessageEventFilter("CHAT_MSG_COMBAT_FACTION_CHANGE", Reputable_msg_filter_rep)

local Reputable_msg_filter_quest_accept = function(frame, event, message, ...)
	local questAccepted = string.find(message, ERR_QUEST_ACCEPTED_S:gsub('%%s','') )
	if questAccepted then Reputable.lastQuestAcceptedMSG = message return true end
	local questCompleted = string.find(message, ERR_QUEST_COMPLETE_S:gsub('%%s','') )
	if questCompleted then  Reputable.lastQuestCompletedMSG = message return true end
	
	local filter, messageType, id = strsplit(":",message);
	if filter == "reputable_system_msg" then
		id = tonumber(id)
		local questLink = Reputable:createLink( "quest", id )
		if messageType == "questAccepted" then
			if Reputable.questInfo[ id ] then
				message = string.gsub( ERR_QUEST_ACCEPTED_S, "%%s", questLink )
			else
				message = Reputable.lastQuestAcceptedMSG
			end
		elseif messageType == "questCompleted" then
			if Reputable.questInfo[ id ] then
				message = string.gsub( ERR_QUEST_COMPLETE_S, "%%s", questLink )
			else
				message = Reputable.lastQuestCompletedMSG
			end
		end
		return false, message, ...
	end
end
ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", Reputable_msg_filter_quest_accept)

local function repBarOnEnter( self, ... )
	if not Reputable.initiated then return end
	local name, description, standingId, barMin, barMax, earnedValue, atWarWith, canToggleAtWar,
				isHeader, isCollapsed, hasRep, isWatched, isChild, factionID, hasBonusRepGain, canBeLFGBonus = GetFactionInfo(self.index)
	if factionID then
		createFactionToolTip( self, factionID, nil )
		local note = "|cFFffd100•|r|cFF8080FF Ctrl-Click to watch faction|r"
		if Reputable_Data[Reputable.profileKey].watchedFactionID == factionID then
			note = "|cFFffd100•|r|cFF8080FF Reputable is watching this faction|r"
		end
		GameTooltipTextLeft2:SetText( note.."\n\n"..GameTooltipTextLeft2:GetText() )
		if GameTooltipTextRight2:GetText() then GameTooltipTextRight2:SetText( " \n\n"..GameTooltipTextRight2:GetText() ) end
		GameTooltip:Show()
	end
end

ReputationWatchBar:HookScript("OnEnter", function(self) createFactionToolTip( self, self.factionID, nil ) end)
ReputationWatchBar:HookScript("OnLeave", function(self) GameTooltip:Hide() end)

hooksecurefunc("ReputationBar_OnClick", function( self )
	if IsControlKeyDown() and Reputable.initiated then
		local _,_,_,_,_,_,_,_,_,_,_,_,_,factionID = GetFactionInfo(self.index)
		
		if factionID == Reputable_Data[Reputable.profileKey].watchedFactionID then
			factionID = nil
			Reputable_Data[Reputable.profileKey].watchedFactionID = nil
			ReputationFrame_Update()
		end
		
		Reputable:setWatchedFaction( factionID )
		repBarOnEnter( self )
		ReputationDetailFrame:Hide()
	end
end)

hooksecurefunc("ReputationFrame_Update", function()
	if not Reputable.initiated then return end
	local thisRepBarIndex
	local numFactions = GetNumFactions()
	
	for factionIndex = 1, numFactions do
		local name, description, standingId, barMin, barMax, earnedValue, atWarWith, canToggleAtWar,
			isHeader, isCollapsed, hasRep, isWatched, isChild, factionID, hasBonusRepGain, canBeLFGBonus = GetFactionInfo(factionIndex)
		if Reputable_Data[Reputable.profileKey] and Reputable_Data[Reputable.profileKey].watchedFactionID and factionID == Reputable_Data[Reputable.profileKey].watchedFactionID then thisRepBarIndex = factionIndex end
	end	
	--		factionHeaderWasCollapsed[ factionIndex ] = isCollapsed
	--		if isHeader and isCollapsed then
	--			ExpandFactionHeader(factionIndex)
	--			numFactions = GetNumFactions()
	--		end
	for i = 1, NUM_FACTIONS_DISPLAYED do
		local thisRepBar = _G["ReputationBar"..i]
	--	if thisRepBar and thisRepBar.title and Reputable_Data[Reputable.profileKey].watchedFactionID and Reputable.factionInfo[ Reputable_Data[Reputable.profileKey].watchedFactionID ] then
		if thisRepBar and thisRepBar.title then
	--		if thisRepBar.index == Reputable.factionInfo[ Reputable_Data[Reputable.profileKey].watchedFactionID ].index then
			if thisRepBarIndex and thisRepBar.index == thisRepBarIndex then
				thisRepBar.title:SetText("•")
			else
				thisRepBar.title:SetText("")
			end
		end
	end
end)


MainMenuExpBar:HookScript("OnEnter", function(self)
	if Reputable_Data and Reputable_Data.global.xpToolTip then
		ExhaustionTick.timer = nil
		GameTooltip:SetOwner(self, "ANCHOR_CURSOR", 0, 20)
		local currentXP = UnitXP("player")
		local maxXP = UnitXPMax("player")
		local rested = GetXPExhaustion() or 0
		local restedMax = maxXP * 1.5
		local remainingXP = maxXP - currentXP
		local eccessRested = 0
		
		local restTime = ( 100*(restedMax-rested)/restedMax) / 10 * 3 * 8 * 60 * 60
		
		if Reputable.level == 68 then
			if rested > remainingXP + 779700 then
				rested = remainingXP + 779700
			end
			if restedMax > remainingXP + 779700 then
				restTime = (( 100*(restedMax-rested)/restedMax) - ( 100*( restedMax - (remainingXP + 779700) ) / (restedMax) ) ) / 10 * 3 * 8 * 60 * 60
				restedMax = remainingXP + 779700
			end
		elseif Reputable.level == 69 then
			if rested > remainingXP then rested = remainingXP end
				restTime = (( 100*(restedMax-rested)/restedMax) - ( 100*( restedMax - (remainingXP) ) / (restedMax) ) ) / 10 * 3 * 8 * 60 * 60
			if restedMax > remainingXP then restedMax = remainingXP end
		end
		
		local levelPercent = math.floor(10000*currentXP/maxXP) / 100
		local restedPercent = math.floor(10000*rested/restedMax) / 100
		local remainingPercent = math.ceil(10000*remainingXP/maxXP) / 100
		local levelShow = Reputable.level + math.floor(100*currentXP/maxXP)/100
		local resting = ""
		
		if IsResting() then resting = "|cff4ee44e"..TUTORIAL_TITLE30 .."|r" end
		GameTooltip:AddDoubleLine( "|cFF8080FF"..COMBAT_XP_GAIN.."|r", "|cFFbbbbbb("..LEVEL.." "..levelShow..")|r" )
		GameTooltip:AddDoubleLine( " ", resting )
		GameTooltip:AddDoubleLine( XP, "|cFFFFFFFF"..FormatLargeNumber(currentXP).."/"..FormatLargeNumber(maxXP).."|r (".. levelPercent .."%)" )
		GameTooltip:AddDoubleLine( TUTORIAL_TITLE26, "|cFFFFFFFF"..FormatLargeNumber(rested).."/"..FormatLargeNumber(restedMax).."|r (".. restedPercent .."%)" )
		GameTooltip:AddDoubleLine( XP.." "..GARRISON_FOLLOWER_XP_STRING, "|cFFFFFFFF" .. FormatLargeNumber(remainingXP) .. "|r (" .. remainingPercent .. "%)" )
		if restTime > 0 then GameTooltip:AddDoubleLine( "Time to max rested", SecondsToTime( restTime ) ) end
		GameTooltip:Show()
	end
end)

local questRepFrame = CreateFrame( "Frame", "ReputableQuestLogReputationFrame", QuestInfoRewardsFrame );
questRepFrame:SetPoint( "LEFT", 5, 0 );
questRepFrame:SetWidth( 100 );
questRepFrame:SetHeight( 40 );
questRepFrame:SetPoint( "TOP", QuestInfoRewardsFrame, "BOTTOM", 0, -10 );
questRepFrame.text = questRepFrame:CreateFontString(nil, questRepFrame, "QuestFont" )
questRepFrame.text:SetPoint("TOPLEFT")
questRepFrame.text:SetJustifyH("LEFT");

local questLogRepFrame = CreateFrame( "Frame", "ReputableQuestLogReputationFrame", QuestLogDetailScrollChildFrame );
questLogRepFrame:SetPoint( "LEFT", 5, 0 )
questLogRepFrame:SetWidth( 100 );
questLogRepFrame:SetHeight( 40 );
questLogRepFrame.text = questLogRepFrame:CreateFontString(nil, questLogRepFrame, "QuestFont" )
questLogRepFrame.text:SetPoint("TOPLEFT")
questLogRepFrame.text:SetJustifyH("LEFT")

local function addFactionToQuestLog( thisRepObj, i, repTooHigh, repeatable, questLvl )
	local factionID = thisRepObj[i]
	local factionName;
	local returnString = ""
	local repIncrease = thisRepObj[ i + 1 ]
	--[[
	if repeatable ~= 1 then
		local difficulty = GetQuestDifficultyColor( questLvl )
		if difficulty.font == "QuestDifficulty_Trivial" then repIncrease = repIncrease * 0.2 end
	end
	--]]
	repIncrease = Reputable:repWithMultiplier( repIncrease, nil )
	if factionID ~= 0 then
		local fontColour = "|cffffd100"
		factionName = GetFactionInfoByID( factionID )
		if not factionName then
			if Reputable.factionInfo[ factionID ] then factionName = Reputable.factionInfo[ factionID ].name else factionName = UNKNOWN.." "..FACTION  end
		end
		
		local plus = "+"
		if repIncrease < 0 then plus = "" end
		returnString = plus..repIncrease.." "..factionName.." "..REPUTATION
		
		if factionID == 934 then returnString = returnString .. "\n" .. ( -1.1 * repIncrease ) .." "..Reputable.factionInfo[ 932 ].name.." "..REPUTATION end
		if factionID == 932 then returnString = returnString .. "\n" .. ( -1.1 * repIncrease ) .." "..Reputable.factionInfo[ 934 ].name.." "..REPUTATION end
	end
	return returnString
end
		--if classicFactionPages[ q[5][1] ] then
		--	local pageName = Reputable.guiTabs[ "faction"..q[5][1] ].html
		--	addQuestToHTML( pageName, questID, repIncrease, nil )
		--end

hooksecurefunc("QuestLog_UpdateQuestDetails", function()
	if not Reputable.initiated then return end
	questLogRepFrame:Hide()
	if Reputable_Data and Reputable_Data.global.repInQuestLog then
		local questIndex = GetQuestLogSelection()
		local title, level, suggestedGroup, isHeader, isCollapsed, isComplete, frequency, questID = GetQuestLogTitle( questIndex )

		if questID and Reputable.questInfo[ questID ] then
			local q = Reputable.questInfo[ questID ]
			local levelColor, complete, inProgress, progressIcon, levelMin, levelTooLow, levelString, minF, minR, maxF, maxR, repTooLow, repTooHigh, requiredQuestComplete = Reputable:getQuestInfo( questID, nil, nil )

			local questLogRepString = addFactionToQuestLog( q[5], 1, repTooHigh, q[12], q[4] )
			if q[5][3] then questLogRepString = questLogRepString .. "\n" .. addFactionToQuestLog( q[5], 3, repTooHigh, q[12], q[4] ) end
			if q[5][5] then questLogRepString = questLogRepString .. "\n" .. addFactionToQuestLog( q[5], 5, repTooHigh, q[12], q[4] ) end
			if q[5][7] then questLogRepString = questLogRepString .. "\n" .. addFactionToQuestLog( q[5], 7, repTooHigh, q[12], q[4] ) end
			
			if questLogRepString ~= "" then 
				questLogRepFrame:Show()
			--	questLogRepFrame.text:SetTextColor( QuestFont:GetTextColor() )
				questLogRepFrame.text:SetTextColor( QuestLogQuestDescription:GetTextColor() )
				
				local anchorFrame = QuestLogRewardTitleText
				if not QuestLogRewardTitleText:IsVisible() then
					QuestLogRewardTitleText:Show()
				end
				if QuestLogMoneyFrame:IsVisible() then
					anchorFrame = QuestLogMoneyFrame
				end
				for i = 1, 10 do
					local thisItemFrame = _G[ "QuestLogItem".. i ]
					if thisItemFrame:IsVisible() and thisItemFrame:GetBottom() < anchorFrame:GetBottom() then anchorFrame = thisItemFrame end
				end
				questLogRepFrame.text:SetText( questLogRepString )
				questLogRepFrame:SetPoint( "TOP", anchorFrame, "BOTTOM", 0, -5 );
				QuestFrame_SetAsLastShown(questLogRepFrame)
			end
		end
	end
end)

hooksecurefunc("QuestInfo_Display", function()
	questRepFrame:Hide()
	if Reputable_Data and Reputable_Data.global.repInQuestLog then
		questID = GetQuestID();
		if questID and questID ~= 0 and Reputable.questInfo[ questID ] then
			local q = Reputable.questInfo[ questID ]
			local levelColor, complete, inProgress, progressIcon, levelMin, levelTooLow, levelString, minF, minR, maxF, maxR, repTooLow, repTooHigh, requiredQuestComplete = Reputable:getQuestInfo( questID, nil, nil )

			local questLogRepString = addFactionToQuestLog( q[5], 1, repTooHigh, q[12], q[4] )
			if q[5][3] then questLogRepString = questLogRepString .. "\n" .. addFactionToQuestLog( q[5], 3, repTooHigh, q[12], q[4] ) end
				
			if questLogRepString ~= "" then
				if QuestInfoRewardsFrame:IsVisible() then
					questRepFrame:Show()
				--	questRepFrame.text:SetTextColor( QuestInfoDescriptionText:GetTextColor() )
					C_Timer.After(0.01, function() questRepFrame.text:SetTextColor( QuestInfoDescriptionText:GetTextColor() ) end )
					questRepFrame.text:SetText( questLogRepString )
				else 
					QuestInfoRewardText:SetText(GetRewardText().."\n\n\n" .. questLogRepString )
				end
			end
		end
	end
end)

local factionHeaderWasCollapsed = {}
local lastUpdate = { time = 0 }
function Reputable:getAllFactions( initiate )
	if ( initiate or initiated ) then
		Reputable:UnregisterEvent("UPDATE_FACTION")

		if Reputable_Data[Reputable.profileKey].factions == nil then Reputable_Data[Reputable.profileKey].factions = {} end
		local watchedFaction
		
		local numFactions = GetNumFactions()
		for factionIndex = 1, numFactions do
			local name, description, standingId, barMin, barMax, earnedValue, atWarWith, canToggleAtWar,
				isHeader, isCollapsed, hasRep, isWatched, isChild, factionID, hasBonusRepGain, canBeLFGBonus = GetFactionInfo(factionIndex)
			factionHeaderWasCollapsed[ factionIndex ] = isCollapsed
			
			if isHeader and isCollapsed then
				ExpandFactionHeader(factionIndex)
				numFactions = GetNumFactions()
			end
				
			local thisRepBar = getglobal( "ReputationBar" .. factionIndex )
			if thisRepBar then
				if not thisRepBar.ReputableScriptAdded then
					thisRepBar:HookScript('OnEnter', repBarOnEnter)
					thisRepBar:HookScript('OnLeave', function() GameTooltip:Hide() end)
					thisRepBar.ReputableScriptAdded = true
					
					thisRepBar.title = thisRepBar:CreateFontString(nil, thisRepBar, "GameFontNormalLarge" )
					thisRepBar.title:SetPoint("RIGHT",0,0)
				end
			end
			if factionID and ( hasRep or not isHeader ) then

				if isWatched then watchedFaction = factionID end
				
				if not Reputable.factionInfo[ factionID ] then Reputable.factionInfo[ factionID ] = {} end
				Reputable.factionInfo[ factionID ].name = name
				Reputable.factionInfo[ factionID ].index = factionIndex
				
					
				if initiate then
					Reputable_Data[Reputable.profileKey].factions[ factionID ] = earnedValue
					Reputable.sessionStart[ factionID ] = earnedValue
					lastUpdate.time = GetServerTime()
				else
					local oldValue = Reputable_Data[Reputable.profileKey].factions[ factionID ]
					if earnedValue ~= oldValue then
						Reputable_Data[Reputable.profileKey].factions[ factionID ] = earnedValue
						if Reputable.sessionStart[ factionID ] then
							Reputable.sessionStart.changes[ factionID ] = earnedValue - Reputable.sessionStart[ factionID ]
						else 
							Reputable.sessionStart[ factionID ] = earnedValue
						end
						
						local setWatched = true
						local now = GetServerTime()
						local change = 0
						if oldValue then change = earnedValue - oldValue end
						
						if Reputable_Data.global.cframeEnabled then
							local link = Reputable:createLink( "faction", factionID, nil, nil, nil, nil )

							local _,_,repStringC,repString = Reputable:getRepString( earnedValue )
							
							if Reputable_Data.global.cframeColourize then
								repString = repStringC
							end
							local changeString = ""
							if oldValue then
								local positive = " +"
								if change < 0 then positive = " " end
								changeString = positive .. change
							end
							local newmessage = link .. changeString .. " ("..repString .. ")"
							
							local chatFrameOutput = Reputable_Data.global.cframeOutputNum
							local testname,_,_,_,_,_,chatFrameVisible,_,chatFrameDocked = GetChatWindowInfo(chatFrameOutput)
							if not ( chatFrameVisible or chatFrameDocked ) then chatFrameOutput = 1 end
							local chatframe = getglobal( "ChatFrame" .. chatFrameOutput )
							chatframe:AddMessage(newmessage,0.5,0.5,1)
						end
						
						if now < lastUpdate.time + 2 then
							if lastUpdate.change > change then
								setWatched = false
								change = lastUpdate.change
							end
						end
						if setWatched and Reputable_Data.global.ldbAuto then Reputable:setWatchedFaction( factionID ) end
						
						Reputable:guiUpdate( true )
						lastUpdate.time = now
						lastUpdate.change = change
					end
				end
			end
		end
		if Reputable_Data.global.ldbUseBlizzRepBar and watchedFaction ~= Reputable_Data[Reputable.profileKey].watchedFactionID then
			Reputable:setWatchedFaction( watchedFaction )
		end
		
		for i=1, #factionHeaderWasCollapsed do
			if factionHeaderWasCollapsed[#factionHeaderWasCollapsed + 1 - i] then
				CollapseFactionHeader( #factionHeaderWasCollapsed + 1 - i )
			end
		end
		for i = 1, #factionHeaderWasCollapsed do factionHeaderWasCollapsed[i] = nil end
		
		initiated = true;
		Reputable:RegisterEvent("UPDATE_FACTION")
	end
	
end

function Reputable:tooltipScan( itemID )
	local tip = reputableTooltipScanner or CreateFrame("GameTooltip", "reputableTooltipScanner", nil, "GameTooltipTemplate")
	tip:SetOwner(WorldFrame, "ANCHOR_NONE")
	tip:ClearLines()
	tip:SetHyperlink("item:" .. itemID)
	local lines = tip:NumLines()
	local header = reputableTooltipScannerTextLeft1:GetText()
	local known = false
	local spellID = Reputable.classbooks[ itemID ][ playerClass ]
	if header == RETRIEVING_ITEM_INFO then
		waitingForData[ itemID ] = true
	else
		waitingForData[ itemID ] = false
		for i = 1, tip:NumLines() do
			if _G["reputableTooltipScannerTextLeft" .. i]:GetText() == ITEM_SPELL_KNOWN then known = true end
		end
	end
	Reputable_Data[Reputable.profileKey].classbooks[ spellID ] = known
end


-- Register Events
Reputable:RegisterEvent("PLAYER_LOGIN")
Reputable:RegisterEvent("ADDON_LOADED")
Reputable:RegisterEvent("MODIFIER_STATE_CHANGED")
Reputable:RegisterEvent("PLAYER_LEVEL_UP")
Reputable:RegisterEvent("GET_ITEM_INFO_RECEIVED")
Reputable:RegisterEvent("QUEST_TURNED_IN")
Reputable:RegisterEvent("LEARNED_SPELL_IN_TAB")
Reputable:RegisterEvent("PLAYER_LEAVING_WORLD")
Reputable:RegisterEvent("UPDATE_FACTION")
Reputable:RegisterEvent("ITEM_PUSH")
Reputable:RegisterEvent("QUEST_ACCEPTED")
--Reputable:RegisterEvent("QUEST_LOG_UPDATE")
Reputable:RegisterEvent("UNIT_QUEST_LOG_CHANGED")
Reputable:RegisterEvent("GOSSIP_SHOW")
Reputable:RegisterEvent("QUEST_DETAIL")
Reputable:RegisterEvent("CHAT_MSG_ADDON")
Reputable:RegisterEvent("GROUP_JOINED")
Reputable:RegisterEvent("PLAYER_ENTERING_WORLD")
--Reputable:RegisterEvent("ZONE_CHANGED")
Reputable:RegisterEvent("ZONE_CHANGED_NEW_AREA")
--Reputable:RegisterEvent("ZONE_CHANGED_INDOORS")
