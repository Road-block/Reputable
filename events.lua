local addonName, addon = ...
local Reputable = addon.a

if Reputable.brewfest then
	table.insert(Reputable.guiTabs, 1, { name = "events",	title = "Brewfest",	label = "Brewfest", cat = 5 } )
end

if Reputable.midsummer then
	table.insert(Reputable.guiTabs, 1, { name = "midsummer",	title = "Midsummer Fire Festival",	label = "Midsummer Fire Festival", cat = 5 } )
end

if Reputable.HallowsEnd then
	table.insert(Reputable.guiTabs, 1, { name = "HallowsEnd",	title = "Hallow's End",	label = "Hallow's End", cat = 5 } )
end

function Reputable:addBrewfest()
	if Reputable.brewfest then
		local dailiesPage = Reputable.guiTabs[ "dailies" ].html
		local pageName = Reputable.guiTabs[ "brewfest" ].html
		
		Reputable.brewfestCurrencyBags = GetItemCount(37829)
		Reputable.brewfestCurrencyTotal = GetItemCount(37829, true)
		local currencyString = "|cffffff00"..Reputable.brewfestCurrencyTotal
		if Reputable.brewfestCurrencyTotal > Reputable.brewfestCurrencyBags then
			currencyString = currencyString.." ("..INVTYPE_BAG..": "..Reputable.brewfestCurrencyBags..", "..BANK..": "..Reputable.brewfestCurrencyTotal - Reputable.brewfestCurrencyBags..")"
		end
		Reputable:addLineToHTML( pageName, "p", "<br/>", nil, nil )
		Reputable:tryMakeItemLink( 37829, pageName.name, "right", pageName.i, nil, nil, nil ); pageName.iRight = pageName.i
		Reputable:addLineToHTML( pageName, "p", BATTLE_PET_SOURCE_7.." "..CURRENCY..": "..currencyString.."|r", nil, nil )
		Reputable:addLineToHTML( pageName, "p", "<br/>", nil, nil )
		Reputable:addLineToHTML( pageName, "h2", "Repeatable " .. QUESTS_COLON, nil, nil )
		
		Reputable:addLineToHTML( dailiesPage, "p", "<br/>", nil, nil )
		Reputable:addLineToHTML( dailiesPage, "p", "|cffffff00"..BATTLE_PET_SOURCE_7..": Brewfest|r", nil, nil )
		for _, questID in ipairs( Reputable.questByGroup["Brewfest"].dailies ) do
			Reputable:addQuestToHTML( pageName, questID, nil, nil )
			Reputable:addQuestToHTML( dailiesPage, questID, nil, nil )
		end
		
		Reputable:addLineToHTML( pageName, "p", "<br/>", nil, nil )
		for _, chain in ipairs ( Reputable.questByGroup["Brewfest"].quests ) do
			if type( chain ) == 'string' then
				if pageName.lastWasHeader then pageName.i = pageName.i - 1 end
				pageName.lastWasHeader = true
				local header = ""
				local stepType, stepValue, stepDefault = strsplit(":", chain)
				if stepType == 'm' then header = ( C_Map.GetAreaInfo( stepValue ) or stepDefault ) .. ":" else header = chain .. ":" end
				Reputable:addLineToHTML( pageName, "h2", header, nil, nil )
			else
				for _, questID in ipairs ( chain ) do
					local levelColor, complete, inProgress, progressIcon, levelMin, levelTooLow, levelString, minF, minR, maxF, maxR, repTooLow, repTooHigh, requiredQuestComplete = Reputable:getQuestInfo( questID, nil, nil )
					local q = Reputable.questInfo[ questID ]
					if q then
						if Reputable.questInfo[ questID ][2] ~= Reputable.notFactionInt[ playerFaction ] then
							if ( q[12] ~= 1 or requiredQuestComplete == false ) and not repTooHigh then
								Reputable:addQuestToHTML( pageName, questID, nil, nil, true )
							end
						end
					else debug("Quest missing from questDB", questID)
					end
				end
			end
		end
		Reputable:addLineToHTML( pageName, "p", "<br/>", nil, nil )
		Reputable:addLineToHTML( pageName, "p", "<br/>", nil, nil )
	end
end

function Reputable:addHallowsEnd()
	if Reputable.HallowsEnd then
		local dailiesPage = Reputable.guiTabs[ "dailies" ].html
		local pageName = Reputable.guiTabs[ "HallowsEnd" ].html
			
		Reputable:addLineToHTML( pageName, "h2", "Repeatable " .. QUESTS_COLON, nil, nil )
		
		Reputable:addLineToHTML( dailiesPage, "p", "<br/>", nil, nil )
		Reputable:addLineToHTML( dailiesPage, "p", "|cffffff00"..BATTLE_PET_SOURCE_7..": HallowsEnd|r", nil, nil )
		for _, questID in ipairs( Reputable.questByGroup["HallowsEnd"].dailies ) do
			Reputable:addQuestToHTML( pageName, questID, nil, nil )
			Reputable:addQuestToHTML( dailiesPage, questID, nil, nil )
		end
		
		Reputable:addLineToHTML( pageName, "p", "<br/>", nil, nil )
		for _, chain in ipairs ( Reputable.questByGroup["HallowsEnd"].quests ) do
			if type( chain ) == 'string' then
				if pageName.lastWasHeader then pageName.i = pageName.i - 1 end
				pageName.lastWasHeader = true
				local header = ""
				local stepType, stepValue, stepDefault = strsplit(":", chain)
				if stepType == 'm' then header = ( C_Map.GetAreaInfo( stepValue ) or stepDefault ) .. ":" else header = chain .. ":" end
				Reputable:addLineToHTML( pageName, "h2", header, nil, nil )
			else
				for _, questID in ipairs ( chain ) do
					local levelColor, complete, inProgress, progressIcon, levelMin, levelTooLow, levelString, minF, minR, maxF, maxR, repTooLow, repTooHigh, requiredQuestComplete = Reputable:getQuestInfo( questID, nil, nil )
					local q = Reputable.questInfo[ questID ]
					if q then
						if Reputable.questInfo[ questID ][2] ~= Reputable.notFactionInt[ playerFaction ] then
							if ( q[12] ~= 1 or requiredQuestComplete == false ) and not repTooHigh then
								Reputable:addQuestToHTML( pageName, questID, nil, nil, true )
							end
						end
					else debug("Quest missing from questDB", questID)
					end
				end
			end
		end
		Reputable:addLineToHTML( pageName, "p", "<br/>", nil, nil )
		Reputable:addLineToHTML( pageName, "p", "<br/>", nil, nil )
	end
end

function Reputable:addMidsummer()
	if Reputable.midsummer then
		local dailiesPage = Reputable.guiTabs[ "dailies" ].html
		local pageName = Reputable.guiTabs[ "midsummer" ].html
		Reputable.midsummerCurrencyBags = GetItemCount(23247)
		Reputable.midsummerCurrencyTotal = GetItemCount(23247, true)
		local currencyString = "|cffffff00"..Reputable.midsummerCurrencyTotal
		if Reputable.midsummerCurrencyTotal > Reputable.midsummerCurrencyBags then
			currencyString = currencyString.." ("..INVTYPE_BAG..": "..Reputable.midsummerCurrencyBags..", "..BANK..": "..Reputable.midsummerCurrencyTotal - Reputable.midsummerCurrencyBags..")"
		end
		Reputable:addLineToHTML( pageName, "p", "<br/>", nil, nil )
		Reputable:tryMakeItemLink( 23247, pageName.name, "right", pageName.i, nil, nil, nil ); pageName.iRight = pageName.i
		Reputable:addLineToHTML( pageName, "p", BATTLE_PET_SOURCE_7.." "..CURRENCY..": "..currencyString.."|r", nil, nil )
		Reputable:addLineToHTML( pageName, "p", "<br/>", nil, nil )
		Reputable:addLineToHTML( pageName, "h2", "Repeatable " .. QUESTS_COLON, nil, nil )
		
		Reputable:addLineToHTML( dailiesPage, "p", "<br/>", nil, nil )
		Reputable:addLineToHTML( dailiesPage, "p", "|cffffff00"..BATTLE_PET_SOURCE_7..": Midsummer Fire Festival|r", nil, nil )
		for _, questID in ipairs( Reputable.questByGroup["Midsummer_fire_festival"].dailies ) do
			if questID == 11954 then
				if level >= 65 then
				elseif level >= 54 then questID = 11953 elseif level >= 45 then questID = 11952 elseif level >= 39 then questID = 11948 elseif level >= 26 then questID = 11947 else questID = 11917 end
			end
			Reputable:addQuestToHTML( pageName, questID, nil, nil )
			Reputable:addQuestToHTML( dailiesPage, questID, nil, nil )
		end
		
		Reputable:addLineToHTML( pageName, "p", "<br/>", nil, nil )
		for _, chain in ipairs ( Reputable.questByGroup["Midsummer_fire_festival"].quests ) do
			if type( chain ) == 'string' then
				if pageName.lastWasHeader then pageName.i = pageName.i - 1 end
				pageName.lastWasHeader = true
				local header = ""
				local stepType, stepValue, stepDefault = strsplit(":", chain)
				if stepType == 'm' then header = ( C_Map.GetAreaInfo( stepValue ) or stepDefault ) .. ":" else header = chain .. ":" end
				Reputable:addLineToHTML( pageName, "h2", header, nil, nil )
			else
				for _, questID in ipairs ( chain ) do
					if questID == 11954 then
						if level >= 65 then
						elseif level >= 54 then questID = 11953 elseif level >= 45 then questID = 11952 elseif level >= 39 then questID = 11948 elseif level >= 26 then questID = 11947 else questID = 11917 end
					end
					local levelColor, complete, inProgress, progressIcon, levelMin, levelTooLow, levelString, minF, minR, maxF, maxR, repTooLow, repTooHigh, requiredQuestComplete = Reputable:getQuestInfo( questID, nil, nil )
					local q = Reputable.questInfo[ questID ]
					if q then
						if Reputable.questInfo[ questID ][2] ~= Reputable.notFactionInt[ playerFaction ] then
							if ( q[12] ~= 1 or requiredQuestComplete == false ) and not repTooHigh then
								Reputable:addQuestToHTML( pageName, questID, nil, nil, true )
							end
						end
					else debug("Quest missing from questDB", questID)
					end
				end
			end
		end
		Reputable:addLineToHTML( pageName, "p", "<br/>", nil, nil )
		Reputable:addLineToHTML( pageName, "p", "<br/>", nil, nil )
	end
end
