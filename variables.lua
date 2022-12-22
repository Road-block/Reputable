local addonName, addon = ...
local Reputable = addon.a

local bijous = { faction = 270, rep = 75, reward = {19858} }
local zgcoin = { faction = 270, rep = 25, reward = {19858}, level = 58, stack = "set of 3" }
local adwrit = { faction = 529, rep = 150, reward = {22523,22524} }

Reputable.repitems = {
--[[ TBC ]] --
	[32386] = { faction = 947,  rep = 1000,  quest = 11003, reward = { 28792,28793,28790,28791 }, Alliance = 32385 },				-- Magtheridon's Head (Horde)
	[32385] = { faction = 946,  rep = 1000,  quest = 11002, reward = { 28792,28793,28790,28791 }, Horde = 32386 },					-- Magtheridon's Head (Alliance)
	[32405] = { faction = 935,  rep = 1000,  quest = 11007, reward = { 30015,30007,30018,30017 } },									-- Verdant Sphere
-- T4
	[29755] = { quest = { WARLOCK = { reward = {28964}}, 			 MAGE    = { reward = {29077}}, 			HUNTER  = { reward = {29082}}		}}, -- Chestguard of the Fallen Hero
	[29754] = { quest = { SHAMAN  = { reward = {29038,29033,29029}}, PALADIN = { reward = {29071,29066,29062}}, ROGUE   = { reward = {29045}}		}}, -- Chestguard of the Fallen Champion
	[29753] = { quest = { DRUID   = { reward = {29096,29087,29091}}, PRIEST  = { reward = {29050,29056}}, 	    WARRIOR = { reward = {29019,29012}}	}}, -- Chestguard of the Fallen Defender
	[29759] = { quest = { WARLOCK = { reward = {28963}}, 			 MAGE    = { reward = {29076}}, 			HUNTER  = { reward = {29081}}		}}, -- Helm of the Fallen Hero
	[29760] = { quest = { SHAMAN  = { reward = {29035,29028,29040}}, PALADIN = { reward = {29073,29061,29068}}, ROGUE   = { reward = {29044}}		}}, -- Helm of the Fallen Champion
	[29761] = { quest = { DRUID   = { reward = {29093,29086,29098}}, PRIEST  = { reward = {29049,29058}}, 	    WARRIOR = { reward = {29021,29011}}	}}, -- Helm of the Fallen Defender
	[29756] = { quest = { WARLOCK = { reward = {28968}}, 			 MAGE    = { reward = {29080}}, 			HUNTER  = { reward = {29085}}		}}, -- Gloves of the Fallen Hero
	[29757] = { quest = { SHAMAN  = { reward = {29039,29032,29034}}, PALADIN = { reward = {29072,29065,29067}}, ROGUE   = { reward = {29048}}		}}, -- Gloves of the Fallen Champion
	[29758] = { quest = { DRUID   = { reward = {29097,29092,29090}}, PRIEST  = { reward = {29057,29055}}, 	    WARRIOR = { reward = {29020,29017}}	}}, -- Gloves of the Fallen Defender
	[29762] = { quest = { WARLOCK = { reward = {28967}}, 			 MAGE    = { reward = {29079}}, 			HUNTER  = { reward = {29084}}		}}, -- Pauldrons of the Fallen Hero
	[29763] = { quest = { SHAMAN  = { reward = {29037,29031,29043}}, PALADIN = { reward = {29064,29070,29075}}, ROGUE   = { reward = {29047}}		}}, -- Pauldrons of the Fallen Champion
	[29764] = { quest = { DRUID   = { reward = {29100,29095,29089}}, PRIEST  = { reward = {29054,29060}}, 	    WARRIOR = { reward = {29016,29023}}	}}, -- Pauldrons of the Fallen Defender
	[29765] = { quest = { WARLOCK = { reward = {28966}}, 			 MAGE    = { reward = {29078}}, 			HUNTER  = { reward = {29083}}		}}, -- Leggings of the Fallen Hero
	[29766] = { quest = { SHAMAN  = { reward = {29030,29036,29042}}, PALADIN = { reward = {29074,29063,29069}}, ROGUE   = { reward = {29046}}		}}, -- Leggings of the Fallen Champion
	[29767] = { quest = { DRUID   = { reward = {29094,29099,29088}}, PRIEST  = { reward = {29059,29053}}, 	    WARRIOR = { reward = {29022,29015}}	}}, -- Leggings of the Fallen Defender
-- T5
	[30238] = { quest = { WARLOCK = { reward = {30214}}, 			 MAGE    = { reward = {30196}}, 			HUNTER  = { reward = {30139}}		}}, -- Chestguard of the Vanquished Hero
	[30236] = { quest = { SHAMAN  = { reward = {30164,30169,30185}}, PALADIN = { reward = {30129,30123,30134}}, ROGUE   = { reward = {30144}}		}}, -- Chestguard of the Vanquished Champion
	[30237] = { quest = { DRUID   = { reward = {30216,30231,30222}}, PRIEST  = { reward = {30159,30150}}, 	    WARRIOR = { reward = {30118,30113}}	}}, -- Chestguard of the Vanquished Defender
	[30244] = { quest = { WARLOCK = { reward = {30212}}, 			 MAGE    = { reward = {30206}}, 			HUNTER  = { reward = {30141}}		}}, -- Helm of the Vanquished Hero
	[30242] = { quest = { SHAMAN  = { reward = {30166,30171,30190}}, PALADIN = { reward = {30125,30136,30131}}, ROGUE   = { reward = {30146}}		}}, -- Helm of the Vanquished Champion
	[30243] = { quest = { DRUID   = { reward = {30228,30219,30233}}, PRIEST  = { reward = {30152,30161}}, 	    WARRIOR = { reward = {30120,30115}}	}}, -- Helm of the Vanquished Defender
	[30241] = { quest = { WARLOCK = { reward = {30211}}, 			 MAGE    = { reward = {30205}}, 			HUNTER  = { reward = {31961}}		}}, -- Gloves of the Vanquished Hero
	[30239] = { quest = { SHAMAN  = { reward = {30189,30165,30170}}, PALADIN = { reward = {30130,30135,30124}}, ROGUE   = { reward = {30145}}		}}, -- Gloves of the Vanquished Champion
	[30240] = { quest = { DRUID   = { reward = {30232,30217,30223}}, PRIEST  = { reward = {30151,30160}}, 	    WARRIOR = { reward = {30119,30114}}	}}, -- Gloves of the Vanquished Defender
	[30250] = { quest = { WARLOCK = { reward = {30215}}, 			 MAGE    = { reward = {30210}}, 			HUNTER  = { reward = {30143}}		}}, -- Pauldrons of the Vanquished Hero
	[30248] = { quest = { SHAMAN  = { reward = {30168,30173,30194}}, PALADIN = { reward = {30138,30133,30127}}, ROGUE   = { reward = {30149}}		}}, -- Pauldrons of the Vanquished Champion
	[30249] = { quest = { DRUID   = { reward = {30230,30221,30235}}, PRIEST  = { reward = {30154,30163}}, 	    WARRIOR = { reward = {30122,30117}}	}}, -- Pauldrons of the Vanquished Defender
	[30247] = { quest = { WARLOCK = { reward = {30213}}, 			 MAGE    = { reward = {30207}}, 			HUNTER  = { reward = {30142}}		}}, -- Leggings of the Vanquished Hero
	[30245] = { quest = { SHAMAN  = { reward = {30172,30167,30192}}, PALADIN = { reward = {30132,30137,30126}}, ROGUE   = { reward = {30148}}		}}, -- Leggings of the Vanquished Champion
	[30246] = { quest = { DRUID   = { reward = {30229,30220,30234}}, PRIEST  = { reward = {30153,30162}}, 	    WARRIOR = { reward = {30121,30116}}	}}, -- Leggings of the Vanquished Defender
-- T6
	[31089] = { quest = { PALADIN = { reward = {30990,30991,30992}}, PRIEST  = { reward = {31065,31066}},		WARLOCK = { reward = {31052}}		}}, -- Chestguard of the Forgotten Conqueror
	[31091] = { quest = { WARRIOR = { reward = {30975,30976}},		 SHAMAN  = { reward = {31016,31017,31018}},	HUNTER  = { reward = {31004}}		}}, -- Chestguard of the Forgotten Protector
	[31090] = { quest = { ROGUE	  = { reward = {31028}},			 DRUID   = { reward = {31041,31042,31043}},	MAGE    = { reward = {31057}}		}}, -- Chestguard of the Forgotten Vanquisher
	[31097] = { quest = { PALADIN = { reward = {30987,30988,30989}}, PRIEST  = { reward = {31063,31064}},		WARLOCK = { reward = {31051}}		}}, -- Helm of the Forgotten Conqueror
	[31095] = { quest = { WARRIOR = { reward = {30972,30974}},		 SHAMAN  = { reward = {31012,31014,31015}},	HUNTER  = { reward = {31003}}		}}, -- Helm of the Forgotten Protector
	[31096] = { quest = { ROGUE	  = { reward = {31027}},			 DRUID   = { reward = {31037,31039,31040}},	MAGE    = { reward = {31056}}		}}, -- Helm of the Forgotten Vanquisher
	[31092] = { quest = { PALADIN = { reward = {30982,30983,30985}}, PRIEST  = { reward = {31060,31061}},		WARLOCK = { reward = {31050}}		}}, -- Gloves of the Forgotten Conqueror
	[31094] = { quest = { WARRIOR = { reward = {30969,30970}},		 SHAMAN  = { reward = {31007,31008,31011}},	HUNTER  = { reward = {31001}}		}}, -- Gloves of the Forgotten Protector
	[31093] = { quest = { ROGUE	  = { reward = {31026}},			 DRUID   = { reward = {31032,31034,31035}},	MAGE    = { reward = {31055}}		}}, -- Gloves of the Forgotten Vanquisher
	[31101] = { quest = { PALADIN = { reward = {30996,30997,30998}}, PRIEST  = { reward = {31069,31070}},		WARLOCK = { reward = {31054}}		}}, -- Pauldrons of the Forgotten Conqueror
	[31103] = { quest = { WARRIOR = { reward = {30979,30980}},		 SHAMAN  = { reward = {31022,31023,31024}},	HUNTER  = { reward = {31006}}		}}, -- Pauldrons of the Forgotten Protector
	[31102] = { quest = { ROGUE	  = { reward = {31030}},			 DRUID   = { reward = {31047,31048,31049}},	MAGE    = { reward = {31059}}		}}, -- Pauldrons of the Forgotten Vanquisher
	[31098] = { quest = { PALADIN = { reward = {30993,30994,30995}}, PRIEST  = { reward = {31067,31068}},		WARLOCK = { reward = {31053}}		}}, -- Leggings of the Forgotten Conqueror
	[31100] = { quest = { WARRIOR = { reward = {30977,30978}},		 SHAMAN  = { reward = {31019,31020,31021}},	HUNTER  = { reward = {31005}}		}}, -- Leggings of the Forgotten Protector
	[31099] = { quest = { ROGUE	  = { reward = {31029}},			 DRUID   = { reward = {31044,31045,31046}},	MAGE    = { reward = {31058}}		}}, -- Leggings of the Forgotten Vanquisher
	[34853] = { quest = { PALADIN = { reward = {34485,34487,34488}}, PRIEST  = { reward = {34527,34528}},		WARLOCK = { reward = {34541}}		}}, -- Belt of the Forgotten Conqueror
	[34854] = { quest = { WARRIOR = { reward = {34546,34547}},		 SHAMAN  = { reward = {34542,34543,34545}},	HUNTER  = { reward = {34549}}		}}, -- Belt of the Forgotten Protector
	[34855] = { quest = { ROGUE	  = { reward = {34558}},			 DRUID   = { reward = {34554,34555,34556}},	MAGE    = { reward = {34557}}		}}, -- Belt of the Forgotten Vanquisher
	[34848] = { quest = { PALADIN = { reward = {34431,34432,34433}}, PRIEST  = { reward = {34434,34435}},		WARLOCK = { reward = {34436}}		}}, -- Bracers of the Forgotten Conqueror
	[34851] = { quest = { WARRIOR = { reward = {34441,34442}},		 SHAMAN  = { reward = {34437,34438,34439}},	HUNTER  = { reward = {34443}}		}}, -- Bracers of the Forgotten Protector
	[34852] = { quest = { ROGUE	  = { reward = {34448}},			 DRUID   = { reward = {34444,34445,34446}},	MAGE    = { reward = {34447}}		}}, -- Bracers of the Forgotten Vanquisher
	[34856] = { quest = { PALADIN = { reward = {34559,34560,34561}}, PRIEST  = { reward = {34562,34563}},		WARLOCK = { reward = {34564}}		}}, -- Boots of the Forgotten Conqueror
	[34857] = { quest = { WARRIOR = { reward = {34568,34569}},		 SHAMAN  = { reward = {34565,34566,34567}},	HUNTER  = { reward = {34570}}		}}, -- Boots of the Forgotten Protector
	[34858] = { quest = { ROGUE	  = { reward = {34575}},			 DRUID   = { reward = {34571,34572,34573}},	MAGE    = { reward = {34574}}		}}, -- Boots of the Forgotten Vanquisher
-- Keys
	[30622] = { faction = 946,  level = 58 }, -- Flamewrought Key (Hellfire Citadel) Alliance
	[30637] = { faction = 947,  level = 58 },	-- Flamewrought Key (Hellfire Citadel) Horde
	[30623] = { faction = 942,  level = 58 },	-- Reservoir Key	(Coilfang Reservoir)
	[30633] = { faction = 1011, level = 58 },	-- Auchenai Key		(Auchindoun)
	[30635] = { faction = 989,  level = 58 },	-- Key of Time		(Caverns of Time)
	[30634] = { faction = 935,  level = 58 },	-- Warpforged Key	(Tempest Keep)
-- Cenarion Expedition
	[24401] = { faction = 942, rep = 250, max = 8999, reward = {24402}, level = 58, stack = 10 },						-- Unidentified Plant Parts
	[24407] = { faction = 942, rep = 500, max = 20999, level = 58 },													-- Uncatalogued Species
	[24368] = { faction = 942, rep = 75, level = 58 },																	-- Coilfang Armaments
-- Lower City
	[25719] = { faction = 1011, rep = 250, level = 58, max = 8999, stack = 30 }, 										-- Arakkoa Feather
-- The Consortium
	[25463] = { faction = 933, rep = 250, level = 58, max = 2999, stack = 3 },											-- Pair of Ivory Tusks
	[25416] = { faction = 933, rep = 250, level = 58, max = 2999, stack = 10 },											-- Oshu'gun Crystal Fragment
	[25433] = { faction = 933, rep = 250, level = 58, min = 3000, stack = 10, note= "Can aslo be used for Kurenai/Mag'har\nreputation (500 per 10)" },											-- Obsidian Warbeads
	[29209] = { faction = 933, rep = 250, level = 58, min = 3000, stack = 10 },											-- Zaxxis Insignia
	[31957] = { faction = 933, rep = 250, level = 58, min = 9000 },														-- Ethereum Prisoner I.D. Tag
	[31941] = { faction = 933, rep = 500, level = 58, min = 21000 },													-- Mark of the Nexus-King
-- Sporeggar	
	[24290] = { faction = 970, rep = 750, level = 58, stack = 10, max = 2999 },											-- Mature Spore Sac
	[24291] = { faction = 970, rep = 750, level = 58, stack = 6, max = 2999 },											-- Bog Lord Tendril
	[24245] = { faction = 970, rep = 750, level = 58, stack = 10, max = 2999 },											-- Glowcap
	[24449] = { faction = 970, rep = 750, level = 58, stack = 6, reward = {24245} },									-- Fertile Spores
	[24246] = { faction = 970, rep = 750, level = 58, stack = 5, min = 3000 },											-- Sanguine Hibiscus
-- The Scryers
	[29426] = { faction = 934, rep = 25, level = 58, min = 0, max = 8999 },												-- Firewing Signet
	[30810] = { faction = 934, rep = 25, level = 58, min = 0 },															-- Sunfury Signet
	[29739] = { faction = 934, rep = 350, level = 58, min = 0, reward = {29736} },										-- Arcane Tome
	[25744] = { faction = 934, rep = 250, level = 58, max = 1, stack = 8},												-- Dampscale Basilisk Eye
-- The Aldor
	[25802] = { faction = 932, rep = 250, level = 58, max = 1, stack = 8},												-- Dreadfang Venom Sac
	[29425] = { faction = 932, rep = 25, level = 58, min = 0, max = 8999},												-- Mark of Kil'jaeden
	[30809] = { faction = 932, rep = 25, level = 58, min = 0},															-- Mark of Sargeras
	[29740] = { faction = 932, rep = 350, level = 58, min = 0, reward={29735}},											-- Fel Armament
-- Netherwing
	[32506] = { faction = 1015, rep = 250, level = 70, stack = 20}, 													-- Netherwing Egg
	
--[[ Original ]]--
--[[ Raid ]]--
-- Ony
	[18422] = { faction = 76,  rep = 500,  quest = 7490, reward = { 18406,18403,18404 }, Alliance = 18423 },			-- Head of Onyxia (Horde)
	[18423] = { faction = 72,  rep = 500,  quest = 7495, reward = { 18406,18403,18404 }, Horde = 18422 },				-- Head of Onyxia (Alliance)
-- BWL
	[19002] = { faction = 76,  rep = 500,  quest = 7783, reward = { 19383,19366,19384 }, Alliance = 19003 },			-- Head of Nefarian (Horde)
	[19003] = { faction = 72,  rep = 500,  quest = 7781, reward = { 19383,19366,19384 }, Horde = 19002 },				-- Head of Nefarian (Alliance)
-- ZG
	[19802] = { faction = 270, rep = 500,  quest = 8183, reward = { 19948,19950,19949 } },								-- Heart of Hakkar
	[19716] = { faction = 270, level = 58, quest = { PALADIN = { questID = 8053, reward = {19827} }, MAGE    = { questID = 8060, reward = {19846} }, HUNTER  = { questID = 8062, reward = {19833} } }, min = 3000 },	-- Bindings
	[19717] = { faction = 270, level = 58, quest = { SHAMAN  = { questID = 8056, reward = {19830} }, ROGUE   = { questID = 8063, reward = {19836} }, WARRIOR = { questID = 8058, reward = {19824} } }, min = 3000 },	-- Armsplint
	[19718] = { faction = 270, level = 58, quest = { PRIEST  = { questID = 8061, reward = {19843} }, WARLOCK = { questID = 8059, reward = {19848} }, DRUID   = { questID = 8057, reward = {19840} } }, min = 3000 },	-- Stanchion
	[19719] = { faction = 270, level = 58, quest = { SHAMAN  = { questID = 8074, reward = {19829} }, ROGUE   = { questID = 8072, reward = {19835} }, WARRIOR = { questID = 8078, reward = {19823} } }, min = 9000 },	-- Girdle
	[19720] = { faction = 270, level = 58, quest = { PRIEST  = { questID = 8070, reward = {19842} }, WARLOCK = { questID = 8076, reward = {19849} }, DRUID   = { questID = 8064, reward = {19839} } }, min = 9000 },	-- Sash
	[19721] = { faction = 270, level = 58, quest = { PALADIN = { questID = 8054, reward = {19826} }, MAGE    = { questID = 8068, reward = {19845} }, HUNTER  = { questID = 8066, reward = {19832} } }, min = 9000 },	-- Shawl
	[19722] = { faction = 270, level = 58, quest = { SHAMAN  = { questID = 8075, reward = {19828} }, PALADIN = { questID = 8055, reward = {19825} }, DRUID   = { questID = 8065, reward = {19838} } }, min = 21000 },	-- Tabard
	[19723] = { faction = 270, level = 58, quest = { WARLOCK = { questID = 8077, reward = {20033} }, MAGE    = { questID = 8069, reward = {20034} }, WARRIOR = { questID = 8079, reward = {19822} } }, min = 21000 },	-- Kossack
	[19724] = { faction = 270, level = 58, quest = { PRIEST  = { questID = 8071, reward = {19841} }, ROGUE   = { questID = 8073, reward = {19834} }, HUNTER  = { questID = 8067, reward = {19831} } }, min = 21000 },	-- Aegis
-- AQ20
	[21220] = { faction = 609, rep = 350,  quest = 8791, reward = { 21504,21507,21505,21506 } },						-- Head of Ossirian the Unscarred
	[20888] = { faction = 609, level = 60, quest = { ROGUE   = { questID = 8701, reward = {21405} }, PRIEST  = { questID = 8697, reward = {21411} }, WARLOCK = { questID = 8702, reward = {21417} }, HUNTER  = { questID = 8704, reward = {21402} } },												  min = 9000 },	-- Ceremonial Ring
	[20884] = { faction = 609, level = 60, quest = { PALADIN = { questID = 8703, reward = {21396} }, SHAMAN  = { questID = 8698, reward = {21399} }, MAGE    = { questID = 8699, reward = {21414} }, DRUID   = { questID = 8700, reward = {21408} }, WARRIOR = { questID = 8556, reward = {21393} } }, min = 9000 },	-- Magisterial Ring
	[20885] = { faction = 609, level = 60, quest = { ROGUE   = { questID = 8693, reward = {21406} }, WARRIOR = { questID = 8557, reward = {21394} }, MAGE    = { questID = 8691, reward = {21415} }, PRIEST  = { questID = 8689, reward = {21412} } },												  min = 21000 },	-- Martial Drape
	[20889] = { faction = 609, level = 60, quest = { PALADIN = { questID = 8695, reward = {21397} }, SHAMAN  = { questID = 8690, reward = {21400} }, HUNTER  = { questID = 8696, reward = {21403} }, DRUID   = { questID = 8692, reward = {21409} }, WARLOCK = { questID = 8694, reward = {21418} } }, min = 21000 },	-- Regal Drape
	[20890] = { faction = 609, level = 60, quest = { MAGE    = { questID = 8707, reward = {21413} }, PRIEST  = { questID = 8705, reward = {21410} }, WARLOCK = { questID = 8710, reward = {21416} }, DRUID   = { questID = 8708, reward = {21407} } },												  min = 42000 },	-- Ornate Hilt
	[20886] = { faction = 609, level = 60, quest = { PALADIN = { questID = 8711, reward = {21395} }, SHAMAN  = { questID = 8706, reward = {21398} }, ROGUE   = { questID = 8709, reward = {21404} }, HUNTER  = { questID = 8712, reward = {21401} }, WARRIOR = { questID = 8558, reward = {21392} } }, min = 42000 },	-- Spiked Hilt
-- AQ40
	[20932] = { faction = 910, rep = 250, level = 60, quest = { PALADIN = { reward = {21388,21391} }, SHAMAN  = { reward = {21373,21376} }, WARLOCK = { reward = {21338,21335} }, MAGE    = { reward = {21344,21345} }, DRUID = { reward = {21355,21354} } }, min = 0 },	-- Bindings of Dominance
	[20928] = { faction = 910, rep = 250, level = 60, quest = { WARRIOR = { reward = {21333,21330} }, ROGUE   = { reward = {21359,21361} }, PRIEST  = { reward = {21349,21350} }, HUNTER  = { reward = {21365,21367} } },									  min = 0 },	-- Bindings of Command
	[20930] = { faction = 910, rep = 250, level = 60, quest = { PALADIN = { questID = 8628, reward = {21387} }, ROGUE   = { questID = 8639, reward = {21360} }, DRUID   = { questID = 8667, reward = {21353} }, SHAMAN  = { questID = 8623, reward = {21372} }, HUNTER  = { questID = 8657, reward = {21366} } }, min = 3000 },	-- Vek'lor's Diadem
	[20926] = { faction = 910, rep = 250, level = 60, quest = { WARRIOR = { questID = 8561, reward = {21329} }, WARLOCK = { questID = 8662, reward = {21337} }, MAGE    = { questID = 8632, reward = {21347} }, PRIEST  = { questID = 8592, reward = {21348} } },												  min = 3000 },	-- Vek'nilash's Circlet
	[20927] = { faction = 910, rep = 250, level = 60, quest = { WARRIOR = { questID = 8560, reward = {21332} }, ROGUE   = { questID = 8640, reward = {21362} }, MAGE    = { questID = 8631, reward = {21346} }, PRIEST  = { questID = 8593, reward = {21352} } },												  min = 3000 },	-- Ouro's Intact Hide
	[20931] = { faction = 910, rep = 250, level = 60, quest = { PALADIN = { questID = 8629, reward = {21390} }, WARLOCK = { questID = 8663, reward = {21336} }, DRUID   = { questID = 8668, reward = {21356} }, SHAMAN  = { questID = 8624, reward = {21375} }, HUNTER  = { questID = 8658, reward = {21368} } }, min = 3000 },	-- Skin of the Great Sandworm
	[20929] = { faction = 910, rep = 250, level = 60, quest = { PALADIN = { questID = 8627, reward = {21389} }, WARRIOR = { questID = 8562, reward = {21331} }, ROGUE   = { questID = 8638, reward = {21364} }, SHAMAN  = { questID = 8622, reward = {21374} }, HUNTER  = { questID = 8656, reward = {21370} } }, min = 9000 },	-- Carapace of the Old God
	[20933] = { faction = 910, rep = 250, level = 60, quest = { WARLOCK = { questID = 8661, reward = {21334} }, MAGE    = { questID = 8633, reward = {21343} }, DRUID   = { questID = 8666, reward = {21357} }, PRIEST  = { questID = 8603, reward = {21351} } },												  min = 9000 },	-- Husk of the Old God
	[21232] = { faction = 910, quest = 8789, reward = { 21242,21272,21244,21269 } },							-- Imperial Qiraji Armaments
	[21237] = { faction = 910, quest = 8790, reward = { 21273,21275,21268 } },								-- Imperial Qiraji Regalia
	[21230] = { faction = 910, rep = 1000, quest = 8784, repeatable = true },											-- Ancient Qiraji Artifact
	[21229] = { faction = 910, rep = 500,  level = 60 },																-- Qiraji Lord's Insignia
	[21221] = { faction = 910, rep = 500, quest = 8801, reward = { 21712,21710,21709 } },								-- Eye of C'Thun
-- Naxx
	[22520] = { quest = 9120, reward = { 23206,23207 } },										-- The Phylactery of Kel'Thuzad
	[22351] = { faction = 529, level = 60, quest = { PRIEST  = { questID = 9111, reward = {22512} }, MAGE   = { questID = 9095, reward = {22496} }, WARLOCK  = { questID = 9103, reward = {22504} } } },	-- Robe
	[22366] = { faction = 529, level = 60, quest = { PRIEST  = { questID = 9112, reward = {22513} }, MAGE   = { questID = 9096, reward = {22497} }, WARLOCK  = { questID = 9104, reward = {22505} } } },	-- Leggings
	[22367] = { faction = 529, level = 60, quest = { PRIEST  = { questID = 9113, reward = {22514} }, MAGE   = { questID = 9097, reward = {22498} }, WARLOCK  = { questID = 9105, reward = {22506} } } },	-- Circlet
	[22368] = { faction = 529, level = 60, quest = { PRIEST  = { questID = 9114, reward = {22515} }, MAGE   = { questID = 9098, reward = {22499} }, WARLOCK  = { questID = 9106, reward = {22507} } } },	-- Shoulderpads
	[22372] = { faction = 529, level = 60, quest = { PRIEST  = { questID = 9115, reward = {22516} }, MAGE   = { questID = 9099, reward = {22500} }, WARLOCK  = { questID = 9107, reward = {22508} } } },	-- Sandals
	[22371] = { faction = 529, level = 60, quest = { PRIEST  = { questID = 9116, reward = {22517} }, MAGE   = { questID = 9100, reward = {22501} }, WARLOCK  = { questID = 9108, reward = {22509} } } },	-- Gloves
	[22370] = { faction = 529, level = 60, quest = { PRIEST  = { questID = 9117, reward = {22518} }, MAGE   = { questID = 9101, reward = {22502} }, WARLOCK  = { questID = 9109, reward = {22510} } } },	-- Belt
	[22369] = { faction = 529, level = 60, quest = { PRIEST  = { questID = 9118, reward = {22519} }, MAGE   = { questID = 9102, reward = {22503} }, WARLOCK  = { questID = 9110, reward = {22511} } } },	-- Bindings
	[22349] = { faction = 529, level = 60, quest = { WARRIOR = { questID = 9034, reward = {22416} }, ROGUE  = { questID = 9077, reward = {22476} } } },	-- Breastplate
	[22352] = { faction = 529, level = 60, quest = { WARRIOR = { questID = 9036, reward = {22417} }, ROGUE  = { questID = 9078, reward = {22477} } } },	-- Legplates
	[22353] = { faction = 529, level = 60, quest = { WARRIOR = { questID = 9037, reward = {22418} }, ROGUE  = { questID = 9079, reward = {22478} } } },	-- Helmet
	[22354] = { faction = 529, level = 60, quest = { WARRIOR = { questID = 9038, reward = {22419} }, ROGUE  = { questID = 9080, reward = {22479} } } },	-- Pauldrons
	[22358] = { faction = 529, level = 60, quest = { WARRIOR = { questID = 9039, reward = {22420} }, ROGUE  = { questID = 9081, reward = {22480} } } },	-- Sabatons
	[22357] = { faction = 529, level = 60, quest = { WARRIOR = { questID = 9040, reward = {22421} }, ROGUE  = { questID = 9082, reward = {22481} } } },	-- Gauntlets
	[22356] = { faction = 529, level = 60, quest = { WARRIOR = { questID = 9041, reward = {22422} }, ROGUE  = { questID = 9083, reward = {22482} } } },	-- Waistguard
	[22355] = { faction = 529, level = 60, quest = { WARRIOR = { questID = 9042, reward = {22423} }, ROGUE  = { questID = 9084, reward = {22483} } } },	-- Bracers
	[22350] = { faction = 529, level = 60, quest = { HUNTER  = { questID = 9054, reward = {22436} }, DRUID  = { questID = 9086, reward = {22488} }, SHAMAN  = { questID = 9068, reward = {22464} }, PALADIN = { questID = 9043, reward = {22425} } } },	-- Tunic
	[22359] = { faction = 529, level = 60, quest = { HUNTER  = { questID = 9055, reward = {22437} }, DRUID  = { questID = 9087, reward = {22489} }, SHAMAN  = { questID = 9069, reward = {22465} }, PALADIN = { questID = 9044, reward = {22427} } } },	-- Legguards
	[22360] = { faction = 529, level = 60, quest = { HUNTER  = { questID = 9056, reward = {22438} }, DRUID  = { questID = 9088, reward = {22490} }, SHAMAN  = { questID = 9070, reward = {22466} }, PALADIN = { questID = 9045, reward = {22428} } } },	-- Headpiece
	[22361] = { faction = 529, level = 60, quest = { HUNTER  = { questID = 9057, reward = {22439} }, DRUID  = { questID = 9089, reward = {22491} }, SHAMAN  = { questID = 9071, reward = {22467} }, PALADIN = { questID = 9046, reward = {22429} } } },	-- Spaulders
	[22365] = { faction = 529, level = 60, quest = { HUNTER  = { questID = 9058, reward = {22440} }, DRUID  = { questID = 9090, reward = {22492} }, SHAMAN  = { questID = 9072, reward = {22468} }, PALADIN = { questID = 9047, reward = {22430} } } },	-- Boots
	[22364] = { faction = 529, level = 60, quest = { HUNTER  = { questID = 9059, reward = {22441} }, DRUID  = { questID = 9091, reward = {22493} }, SHAMAN  = { questID = 9073, reward = {22469} }, PALADIN = { questID = 9048, reward = {22426} } } },	-- Handguards
	[22363] = { faction = 529, level = 60, quest = { HUNTER  = { questID = 9060, reward = {22442} }, DRUID  = { questID = 9092, reward = {22494} }, SHAMAN  = { questID = 9074, reward = {22470} }, PALADIN = { questID = 9049, reward = {22431} } } },	-- Girdle
	[22362] = { faction = 529, level = 60, quest = { HUNTER  = { questID = 9061, reward = {22443} }, DRUID  = { questID = 9093, reward = {22495} }, SHAMAN  = { questID = 9075, reward = {22471} }, PALADIN = { questID = 9050, reward = {22424} } } },	-- Wristguards
--[[ Faction Items ]]--
--	Zandalari
	[19858] = { faction = 270, rep = 50 },																-- Zandalar Honor Token
	[19707] = bijous, [19708] = bijous, [19709] = bijous, [19710] = bijous, [19711] = bijous, [19712] = bijous, [19713] = bijous, [19714] = bijous, [19715] = bijous,
	[19698] = zgcoin, [19699] = zgcoin, [19700] = zgcoin, [19701] = zgcoin, [19702] = zgcoin, [19703] = zgcoin, [19704] = zgcoin, [19705] = zgcoin, [19706] = zgcoin,
--	Argent Dawn
	[22600] = adwrit, [22601] = adwrit, [22602] = adwrit, [22603] = adwrit, [22604] = adwrit, [22605] = adwrit, [22606] = adwrit, [22607] = adwrit,
	[22608] = adwrit, [22609] = adwrit, [22610] = adwrit, [22611] = adwrit, [22612] = adwrit, [22613] = adwrit, [22614] = adwrit, [22615] = adwrit, 
	[22616] = adwrit, [22617] = adwrit, [22618] = adwrit, [22620] = adwrit, [22621] = adwrit, [22622] = adwrit, [22623] = adwrit, [22624] = adwrit, 
	[12844] = { faction = 529, rep = 100 },																-- Argent Dawn Valor Token
	[12840] = { faction = 529, rep = 50, reward = {12844}, level = 50, stack = 20 },		-- Minion's Scourgestone
	[12841] = { faction = 529, rep = 50, reward = {12844}, level = 50, stack = 10 },		-- Invader's Scourgestone
	[12843] = { faction = 529, rep = 50, reward = {12844}, level = 50 },					-- Corruptor's Scourgestone
	[13920] = { faction = 529, rep = 150, quest = 5582, repeatable = true },								-- Healthy Dragon Scale
	[22526] = { faction = 529, rep = 1000, level = 55, stack = 30, min = 3000, quest = 9126, note = "After this quest is complete,\nit is repeatable for 20 reputaion", reward = {22524} },		-- Bone Fragments
	[22525] = { faction = 529, rep = 1000, level = 55, stack = 30, min = 3000, quest = 9124, note = "After this quest is complete,\nit is repeatable for 20 reputaion", reward = {22524} },		-- Crypt Fiend Parts
	[22527] = { faction = 529, rep = 1000, level = 55, stack = 30, min = 3000, quest = 9128, note = "After this quest is complete,\nit is repeatable for 20 reputaion", reward = {22523} },		-- Core of Elements
	[22528] = { faction = 529, rep = 1000, level = 55, stack = 30, min = 3000, quest = 9131, note = "After this quest is complete,\nit is repeatable for 20 reputaion", reward = {22523} },		-- Dark Iron Scraps
	[22529] = { faction = 529, rep = 1000, level = 55, stack = 30, min = 3000, quest = 9136, note = "After this quest is complete,\nit is repeatable for 20 reputaion", reward = {22523,22524} },  -- Savage Fronds
-- Timbermaw Hold
	[20741] = { faction = 576, rep = 700, quest = 8470, min = 0 },									-- Deadwood Ritual Totem
	[20742] = { faction = 576, rep = 700, quest = 8471, min = 0 },									-- Winterfall Ritual Totem
	[21377] = { faction = 576, rep = 150, stack = 5 },													-- Deadwood Headdress Feather
	[21383] = { faction = 576, rep = 150, stack = 5 },													-- Winterfall Spirit Beads
-- Thorium Brotherhood	
	[18944] = { faction = 59, rep = 25, stack = 2, min = 0, max = 2999, level = 45 },				-- Incendosaur Scale
	[18945] = { faction = 59, rep = 25, stack = 4, min = 3000, max = 8999, level = 45 },				-- Dark Iron Residue
	[11370] = { faction = 59, rep = 75, stack = 10, min = 9000, level = 60 },							-- Dark Iron Ore
	[17010] = { faction = 59, rep = 500, min = 9000, level = 60 },									-- Fiery Core
	[17011] = { faction = 59, rep = 500, min = 9000, level = 60 },									-- Lava Core
	[17012] = { faction = 59, rep = 300, min = 9000, level = 60, stack = 2 },							-- Core Leather
	[11382] = { faction = 59, rep = 500, min = 9000, level = 60 },									-- Blood of the Mountain
-- Shen'dralar
	[18401] = { faction = 809, rep = 500, reward = {18348}, questID = 7507, quest = { WARRIOR = true, PALADIN = true } },	-- Nostro's Compendium of Dragon Slaying
	[18364] = { faction = 809, rep = 500, reward = {18470}, questID = 7506, quest = { DRUID   = true } },					-- The Emerald Dream
	[18361] = { faction = 809, rep = 500, reward = {18473}, questID = 7503, quest = { HUNTER  = true } },					-- The Greatest Race of Hunters
	[18358] = { faction = 809, rep = 500, reward = {18468}, questID = 7500, quest = { MAGE    = true } },					-- The Arcanist's Cookbook
	[18359] = { faction = 809, rep = 500, reward = {18472}, questID = 7501, quest = { PALADIN = true } },					-- The Light and How to Swing It
	[18362] = { faction = 809, rep = 500, reward = {18469}, questID = 7504, quest = { PRIEST  = true } },					-- Holy Bologna: What the Light Won't Tell You
	[18356] = { faction = 809, rep = 500, reward = {18465}, questID = 7498, quest = { ROGUE   = true } },					-- Garona: A Study on Stealth and Treachery
	[18363] = { faction = 809, rep = 500, reward = {18471}, questID = 7505, quest = { SHAMAN  = true } },					-- Frost Shock and You
	[18360] = { faction = 809, rep = 500, reward = {18467}, questID = 7502, quest = { WARLOCK = true } },					-- Harnessing Shadows
	[18357] = { faction = 809, rep = 500, reward = {18466}, questID = 7499, quest = { WARRIOR = true } },					-- Codex of Defense

-- PvP
	[20558] = { faction = { Alliance = 890, Horde = 889 }, level = 15 },								-- Warsong Gulch Mark of Honor
	[20559] = { faction = { Alliance = 509, Horde = 510 }, level = 20 },								-- Arathi Basin Mark of Honor
	[20560] = { faction = { Alliance = 730, Horde = 729 }, level = 51 },								-- Alterac Valley Mark of Honor

-- Other	
	[11040] = { faction = { Alliance = 69, Horde = 81 }, rep = 75, level = 47, stack = 10 },			-- Morrowgrain
	[20404] = { faction = 609, rep = 500, level = 57, stack = 10 },										-- Encrypted Twilight Texts
	[11737] = { quest = 4484, repeatable = true, reward = {11647,11648,11649,11645,11646} },			-- Libram of Voracity
	[11733] = { quest = 4481, repeatable = true, reward = {11642} },									-- Libram of Constitution
	[11736] = { quest = 4483, repeatable = true, reward = {11644} },									-- Libram of Resilience
	[11732] = { quest = 4463, repeatable = true, reward = {11622} },									-- Libram of Rumination
	[11734] = { quest = 4482, repeatable = true, reward = {11643} },									-- Libram of Tenacity
	[18332] = { faction = 809, rep = 500, quest = 7483, repeatable = true, reward = {18329} },			-- Libram of Rapidity
	[18333] = { faction = 809, rep = 500, quest = 7484, repeatable = true, reward = {18330} },			-- Libram of Focus
	[18334] = { faction = 809, rep = 500, quest = 7485, repeatable = true, reward = {18331} },			-- Libram of Protection
	[ 9250] = { faction = 369, rep = 350, quest = 2876 },												-- Ship Schedules
	[18969] = { faction = 69,  rep = 250, quest = 7735 },												-- Pristine Yeti Hide
}

Reputable.repitemsets = {

	[19698]	= { 19698, 19699, 19700 },
	[19699]	= { 19698, 19699, 19700 },
	[19700]	= { 19698, 19699, 19700 },
	[19701] = { 19701, 19702, 19703 },
	[19702]	= { 19701, 19702, 19703 },
	[19703]	= { 19701, 19702, 19703 },
	[19704]	= { 19704, 19705, 19706 },
	[19705]	= { 19704, 19705, 19706 },
	[19706]	= { 19704, 19705, 19706 },
	[18944] = { 18944, 3857, 3356, 3575, 4234, note = { "x2", "", "x4 or", "x4 or", "x10" } },
}

Reputable.classbooks = {
	[22897] = { MAGE    = 28612 }, [24101] = { DRUID   = 31018 }, 			[21283] = { WARLOCK = 25311 }, [21285] = { PRIEST  = 25315 }, [21307] = { HUNTER  = 25296 }, [21300] = { ROGUE   = {25300,26863} },	[23320] = { SHAMAN  = 29228 }, [21289] = { PALADIN = 25291 }, [21298] = { WARRIOR = {25289,2048} }, 
	[22890] = { MAGE    = 28609 }, [21294] = { DRUID   = 25297 }, 			[21282] = { WARLOCK = 25309 }, [21287] = { PRIEST  = 25985 }, [21304] = { HUNTER  = 25294 }, [21302] = { ROGUE   = 25347 }, 		[21293] = { SHAMAN  = 25359 }, [21288] = { PALADIN = 25290 }, [21299] = { WARRIOR = {25288,25269,30357} }, 
	[21280] = { MAGE    = 25345 }, [21296] = { DRUID   = 25299 }, 			[21281] = { WARLOCK = 25307 }, [17414] = { PRIEST  = 21564 }, [21306] = { HUNTER  = 25295 }, [21303] = { ROGUE   = {25302,27448} },	[21291] = { SHAMAN  = 25357 }, [21290] = { PALADIN = 25292 }, [21297] = { WARRIOR = {25286,29707,30324} },  
	[21279] = { MAGE    = 25306 }, [21295] = { DRUID   = 25298 }, 			[22891] = { WARLOCK = 28610 }, [17413] = { PRIEST  = 21562 }, [16665] = { HUNTER  = 19801 }, [24102] = { ROGUE   = {31016,26865} },	[21292] = { SHAMAN  = 25361 }, [31505] = { PALADIN = 27140 }, [31505] = { WARRIOR = 30324 },
	[21214] = { MAGE    = 25304 }, [17683] = { DRUID   = 21850 }, 			[4213]  = { WARLOCK = 18540 }, [22393] = { PRIEST  = 27683 },  																							 		   [31503] = { PALADIN = 27141 }, [31506] = { WARRIOR = 30357 },
	[18600] = { MAGE    = 23028 }, [17682] = { DRUID   = 21849 },			[9214]  = { WARLOCK = 1122  }, [21284] = { PRIEST  = 25314 },  
	[22739] = { MAGE    = 28271 }, [22146] = { DRUID   = 26991 }, 			[31507] = { WARLOCK = 30459 }, [29549] = { PRIEST  = 25392 },
	[22153] = { MAGE    = 27127 }, [24345] = { DRUID   = {31709,27004} },								   [31837] = { PRIEST  = 39374 },
	[31500] = { MAGE    = 38704 },  
	[31501] = { MAGE    = 33717 },  
	[29550] = { MAGE    = 27090 },  
	[31496] = { MAGE    = 38692 },  
	[31498] = { MAGE    = 38697 },  
}

Reputable.junk = {
	--[[-- TBC --]]--
	[31739] = 10895, [28513] = 10144, [23801] = 9544, [23695] = 9475, [24221] = 9689, [25766] = 10009, [28664] = 10252, [24475] = 9821, [31754] = 10802, [24502] = 9853,
	[25771] = 10011, [25770] = 10011, [32888] = 10098,[31373] = 10804,[31372] = 10804,[28786] = 10256, [31360] = 10782, [25745] = { Horde = 9993, Alliance = 9992 },
	[30618] = { Horde = 10036, Alliance = 10035 }, [31812] = 10923, [18818] = 7631,

	--[[-- Classic Era --]]--
	[5251]  = 949,	[5505]  = 1023,	[7442]  = 2078,	[2154]  = 227,	[3248]  = 252,	[3898]  = 578,	[7846]  = 2500,	[5866]  = 1194,	[10515] = 3463,	[11108] = 3845,
	[11804] = 4491,	[11482] = 4321,	[10444] = 3449,	[11467] = 4283,	[12891] = 5245,	[15043] = 5903,	[12815] = 5097,	[11725] = 4450, [8047]  = 17,	[4649]  = 735,
	[6842] =  1701,	[7667]  = 2204,	[7668]  = 2201,	[9472]  = 2994, [6929]  = 1712, [12738] = 5060, [1358]  = 138,	[1361]  = 139,	[1362]  = 140,	[12346] = 4763,
	[12347] = 4763,	[12342] = 4763,	[12341] = 4763,	[12343] = 4763, [15209] = 5721, [16991] = { Horde = 6622, Alliance = 6624 }, [13157] = 5206, [13159] = 5206,
	[11568] = 4292, [11569] = 4292, [11570] = 4292, [29482] = 10385,
	--[] = ,
}

Reputable.instanceZones = {
	{ name = "Hellfire Citadel",		abv = "hfc",  cat = "dungeons", dungeons = { 543, 542, 540 }, heroicKey = { Alliance = 30622, Horde = 30637 }, faction = { Alliance = 946, Horde = 947 } }, -- 1
	{ name = "Coilfang Reservoir",		abv = "cfr",  cat = "dungeons", dungeons = { 547, 546, 545 }, heroicKey = 30623, faction = 942 },
	{ name = "Auchindoun (Mana Tombs)",	abv = "amt",  cat = "dungeons", dungeons = { 557 }, 		  heroicKey = 30633, faction = 933 },
	{ name = "Auchindoun",				abv = "auch", cat = "dungeons", dungeons = { 558, 556, 555 }, heroicKey = 30633, faction = 1011 },
	{ name = "Caverns of Time",			abv = "cot",  cat = "dungeons", dungeons = { 560, 269 }, 	  heroicKey = 30635, faction = 989 },
	{ name = "Tempest Keep",			abv = "tk",   cat = "dungeons", dungeons = { 554, 553, 552 }, heroicKey = 30634, faction = 935 },
	{ name = "Isle of Quel'Danas", 		abv = "iqd",  cat = "dungeons", dungeons = { 585 },  		  heroicQuest = 11492, faction = 1077 }, -- 7
	{ name = "Utgarde", abv = "ut", cat = "dungeonsWotlk", dungeons = { 574, 575 }, faction = { Alliance = 1037, Horde = 1052} }, -- 8
	{ name = "Nexus", abv = "nxk", cat = "dungeonsWotlk", dungeons = { 576, 578 }, faction = { Alliance = 1037, Horde = 1052} },
	{ name = "Azjol", abv = "az", cat = "dungeonsWotlk", dungeons = { 601, 619 }, faction = { Alliance = 1037, Horde = 1052} },
	{ name = "Zul'Drak", abv = "zd", cat = "dungeonsWotlk", dungeons = { 600, 604 }, faction = { Alliance = 1037, Horde = 1052} },
	{ name = "Dalaran", abv = "vh", cat = "dungeonsWotlk", dungeons = { 608 }, faction = { Alliance = 1037, Horde = 1052} },
	{ name = "Caverns of Time", abv = "cotlk", cat = "dungeonsWotlk", dungeons = { 595 }, faction = { Alliance = 1037, Horde = 1052}},
	{ name = "Ulduar", abv = "ul", cat = "dungeonsWotlk", dungeons = { 599, 602 }, faction = { Alliance = 1037, Horde = 1052} },
	{ name = "Argent Tournament", abv = "at", cat = "dungeonsWotlk", dungeons = { 650 }, faction = { Alliance = 1037, Horde = 1052} },
	{ name = "Icecrown Citadel", abv = "icc", cat = "dungeonsWotlk", dungeons = { 632, 658, 668 }, faction = { Alliance = 1037, Horde = 1052} }, -- 16
}
Reputable.instance = {
	[543] = { mapID = 3562,	zoneMID = 3535,	iz = 1, heroic = true, level = { 58, 60, 62 }, rep = { normal = { max = 8999, rep =  633 }, 																	heroic = { rep = 2500 } }, icon = "Achievement_Boss_OmarTheUnscarred_01" },
	[542] = { mapID = 3713, zoneMID = 3535,	iz = 1, heroic = true, level = { 58, 61, 63 }, rep = { normal = { max = 8999, rep =  750 }, 																	heroic = { rep = 2700 } }, icon = "Achievement_Boss_KelidanTheBreaker" },
	[540] = { mapID = 3714, zoneMID = 3535,	iz = 1, heroic = true, level = { 67, 70, 70 }, rep = { normal = { 			  rep = 1600 }, 																	heroic = { rep = 2900 } }, icon = "Achievement_Boss_KargathBladefist_01", accessKey = 28395 },
	[547] = { mapID = 3717, zoneMID = 3905, iz = 2, heroic = true, level = { 59, 62, 64 }, rep = { normal = { max = 8999, rep =  650 }, 																	heroic = { rep = 2750 } }, icon = "Achievement_Boss_Quagmirran" },
	[546] = { mapID = 3716, zoneMID = 3905, iz = 2, heroic = true, level = { 60, 63, 65 }, rep = { normal = { max = 8999, rep = 1000, note = "Some mobs will give rep through "..FACTION_STANDING_LABEL6 },	heroic = { rep = 2680 } }, icon = "Achievement_Boss_theBlackStalker" },
	[545] = { mapID = 3715, zoneMID = 3905, iz = 2, heroic = true, level = { 67, 70, 70 }, rep = { normal = { 			  rep = 1662 }, 																	heroic = { rep = 2559 } }, icon = "Achievement_Boss_Warlord_Kalithresh" },
	[557] = { mapID = 3792, zoneMID = 3917, iz = 3, heroic = true, level = { 62, 64, 66 }, rep = { normal = { max = 8999, rep = 1200 }, 																	heroic = { rep = 2400 } }, icon = "Achievement_Boss_Nexus_Prince_Shaffar" },
	[558] = { mapID = 3790, zoneMID = 3917, iz = 4, heroic = true, level = { 63, 65, 67 }, rep = { normal = { max = 8999, rep =  700 }, 																	heroic = { rep = 2000 } }, icon = "Achievement_Boss_Exarch_Maladaar" },
	[556] = { mapID = 3791, zoneMID = 3917, iz = 4, heroic = true, level = { 65, 67, 69 }, rep = { normal = { max = 8999, rep = 1035 }, 																	heroic = { rep = 2000 } }, icon = "Achievement_Boss_TalonKingIkiss" },
	[555] = { mapID = 3789, zoneMID = 3917, iz = 4, heroic = true, level = { 67, 70, 70 }, rep = { normal = { 			  rep = 1750 }, 																	heroic = { rep = 2700 } }, icon = "Achievement_Boss_Murmur", accessKey = 27991 },
	[560] = { mapID = 2367, zoneMID = 1941, iz = 5, heroic = true, level = { 64, 66, 68 }, rep = { normal = { 			  rep = 1300 }, 																	heroic = { rep = 2800 } }, icon = "Achievement_Boss_EpochHunter", accessQuest = 10277 },
	[269] = { mapID = 2366, zoneMID = 1941, iz = 5, heroic = true, level = { 68, 69, 70 }, rep = { normal = { 			  rep = 1200 }, 																	heroic = { rep = 1900 } }, icon = "Achievement_Boss_Aeonus_01", accessQuest = 10285 },
	[554] = { mapID = 3849, zoneMID = 3842, iz = 6, heroic = true, level = { 67, 69, 70 }, rep = { normal = { 			  rep = 1620 }, 																	heroic = { rep = 2100 } }, icon = "Achievement_Boss_PathaleonTheCalculator" },
	[553] = { mapID = 3847, zoneMID = 3842, iz = 6, heroic = true, level = { 67, 70, 70 }, rep = { normal = { 			  rep = 2200 }, 																	heroic = { rep = 3245 } }, icon = "Achievement_Boss_WarpSplinter" },
	[552] = { mapID = 3848, zoneMID = 3842, iz = 6, heroic = true, level = { 68, 70, 70 }, rep = { normal = { 			  rep = 1800 }, 																	heroic = { rep = 2600 } }, icon = "Achievement_Boss_Harbinger_Skyriss", accessKey = 31084 },
	[585] = { mapID = 4131, zoneMID = 4095, iz = 7, heroic = true, level = { 69, 70, 70 }, rep = { normal = { 			  rep = 1650 }, 																	heroic = { rep = 2350 } }, icon = "Achievement_Boss_Kael-thasSunstrider_01", heroicQuest = 11492 },
	-- wrath
	[574] = { mapID = 206, zoneMID = 495, iz = 8, heroic = true, level = { 68, 70, 75 }, rep = { normal = { rep = 0 }, heroic = { rep = 2000 }}, icon = "Achievement_Boss_Princekeleseth"},
	[575] = { mapID = 4271, zoneMID = 495, iz = 8, heroic = true, level = { 78, 80, 80 }, rep = { normal = { rep = 500 }, heroic = { rep = 2000 }}, icon = "Achievement_Boss_Kingymiron_01"},
	[576] = { mapID = 4265, zoneMID = 3537, iz = 9, heroic = true, level = { 70, 72, 75 }, rep = { normal = { rep = 0 }, heroic = { rep = 2000 }}, icon = "Achievement_Boss_Keristrasza"},
	[578] = { mapID = 4228, zoneMID = 3537, iz = 9, heroic = true, level = { 78, 80, 80 }, rep = { normal = { rep = 500 }, heroic = { rep = 2000 }}, icon = "Achievement_Boss_Eregos"},
	[601] = { mapID = 4277, zoneMID = 65, iz = 10, heroic = true, level = { 70, 72, 77 }, rep = { normal = { rep = 0 }, heroic = { rep = 2000 }}, icon = "Achievement_Boss_Anubarak"},
	[619] = { mapID = 4494, zoneMID = 65, iz = 10, heroic = true, level = { 71, 73, 78 }, rep = { normal = { rep = 0 }, heroic = { rep = 2000 }}, icon = "Achievement_Boss_Heraldvolazj"},
	[600] = { mapID = 4196, zoneMID = 394, iz = 11, heroic = true, level = { 72, 74, 78 }, rep = { normal = { rep = 0 }, heroic = { rep = 2000 }}, icon = "Achievement_Boss_Kingdred"},
	[604] = { mapID = 4416, zoneMID = 66, iz = 11, heroic = true, level = { 76, 78, 80 }, rep = { normal = { rep = 0 }, heroic = { rep = 2000 }}, icon = "Achievement_Boss_Galdarah"},
	[608] = { mapID = 4415, zoneMID = 4395, iz = 12, heroic = true, level = { 73, 75, 79 }, rep = { normal = { rep = 0 }, heroic = { rep = 2000 }}, icon = "Achievement_Boss_Cyanigosa"},
	[595] = { mapID = 4100, zoneMID = 1941, iz = 13, heroic = true, level = { 78, 80, 80 }, rep = { normal = { rep = 500 }, heroic = { rep = 2000 }}, icon = "Achievement_Boss_Infinitecorruptor"},
	[599] = { mapID = 4264, zoneMID = 67, iz = 14, heroic = true, level = { 75, 77, 80 }, rep = { normal = { rep = 0 }, heroic = { rep = 2000 }}, icon = "Achievement_Boss_Sjonnir"},
	[602] = { mapID = 4272, zoneMID = 67, iz = 14, heroic = true, level = { 78, 80, 80 }, rep = { normal = { rep = 500 }, heroic = { rep = 2000 }}, icon = "Achievement_Boss_Generalbjarngrim"},
	[650] = { mapID = 4723, zoneMID = 210, iz = 15, heroic = true, level = { 80, 80, 80 }, rep = { normal = { rep = 500 }, heroic = { rep = 2000 }}, icon = "Achievement_Boss_Blacknight"},
	[632] = { mapID = 4809, zoneMID = 210, iz = 16, heroic = true, level = { 80, 80, 80 }, rep = { normal = { rep = 500 }, heroic = { rep = 2000 }}, icon = "Achievement_Boss_Devourerofsouls"},
	[658] = { mapID = 4813, zoneMID = 210, iz = 16, heroic = true, level = { 80, 80, 80 }, rep = { normal = { rep = 500 }, heroic = { rep = 2000 }}, icon = "Achievement_Boss_Scourgelordtyrannus"},
	[668] = { mapID = 4820, zoneMID = 210, iz = 16, heroic = true, level = { 80, 80, 80 }, rep = { normal = { rep = 500 }, heroic = { rep = 2000 }}, icon = "Achievement_Boss_Lichking"},
	[230] = { mapID = 1584,	zoneMID = 25,	level = { 48, 52, 60 } },
	[229] = { mapID = 1583,	zoneMID = 25,	level = { 48, 55, 60 } },
	[249] = { mapID = 2159, zoneMID = 15,	level = { 52, 60, 60 }, accessKey = 16309 },
	[532] = { mapID = 2562, zoneMID = 41, 	raid = true, level = { 70, 70, 70 }, faction = 967, accessKey = 24490 },	-- kara
	[550] = { mapID = 3845, zoneMID = 3842, raid = true, level = { 70, 70, 70 } }, -- tk
	[544] = { mapID = 3836, zoneMID = 3535, raid = true, level = { 70, 70, 70 } }, -- mag
	[565] = { mapID = 3923, zoneMID = 3522, raid = true, level = { 70, 70, 70 } }, -- gruul
	[548] = { name = DUNGEON_FLOOR_COILFANGRESERVOIR1, zoneMID = 3905, raid = true, level = { 70, 70, 70 } }, -- ssc
	[564] = { mapID = 3959, zoneMID = 3520, raid = true, level = { 70, 70, 70 } }, -- bt
	[534] = { mapID = 3606, zoneMID = 440, raid = true, level = { 70, 70, 70 } }, -- mt hyjal
	[580] = { mapID = 4075, zoneMID = 4080, raid = true, level = { 70, 70, 70 } }, -- sunwell
}

Reputable.factionInfo = {
	[  946 ] = { name = "Honor Hold", iz = 1, Horde = false, rquests = { 10106 } },
	[  947 ] = { name = "Thrallmar", iz = 1, Alliance = false, rquests = { 10110 } },
	[  942 ] = { name = "Cenarion Expedition", iz = 2, rquests = { 9784, 9875, 9766 } },
	[  933 ] = { name = "The Consortium", iz = 3, rquests = { 9915, 9883, 9892, 10308, 10972, 10981 } },
	[ 1011 ] = { name = "Lower City", iz = 4, rquests = { 10918 } },
	[  989 ] = { name = "Keepers of Time", iz = 5 },
	[  935 ] = { name = "The Sha'tar", iz = 6 },
	[  967 ] = { name = "The Violet Eye" },
	[  970 ] = { name = "Sporeggar", rquests = { 9744,9742,9809,9807,9727,9714 } },
	[  978 ] = { name = "Kurenai", rquests = { 11502,10477 }, Horde = false },
	[  941 ] = { name = "The Mag'har", rquests = { 11503,10478 }, Alliance = false },
	[  934 ] = { name = "The Scryers", rquests={10025,10414,10415,10659,10658,10419} },
	[  932 ] = { name = "The Aldor", rquests={10019,10327,10326,10655,10654,10421} },
	[ 1012 ] = { name = "Ashtongue Deathsworn" },
	[ 1038 ] = { name = "Ogri'la", rquests={11027,11080,11023,11066,11051} },
	[ 1015 ] = { name = "Netherwing", rquests={11015,11018,11017,11016,11020,11035,11050,11076,11077,11055,11086,11101,11097}  },
	[ 1031 ] = { name = "Sha'tari Skyguard", rquests={11006,11074,11085,11008,11066,11023} },
	[ 1077 ] = { name = "Shattered Sun Offensive",	iz = 7 , rquests={
	11880,11875,11516,11515,11877, -- Permanent	
	-- 11524,11496, -- P1
	-- 11523,11525,11532,11538, -- P2
	-- 11523,11525,11533,11536,11537,11544,11542,11539 --P3
	11523,11525,11533,11536,11537,11544,11542,11543,11540,11541, --P4
	
	--11513, -- Portal Closed
	11547,11514, -- Portal Open
	
	--11545, -- Monument locked
	11548, -- Monument unlocked
	
	--11520, -- Alchemist locked
	11521,11546, -- Alchemist unlocked
	--
	} },
	--[ 69 ] = { rquests={ 7801 }, Horde = false},
		{ faction = 529	},	-- Arengt Dawn
--	[ 87	] = { name = "Bloodsail Buccaneers" },
	[ 21	] = { name = "Booty Bay" },
	[ 910	] = { name = "Brood of Nozdormu" },
	[ 609	] = { name = "Cenarion Circle" },
	[ 909	] = { name = "Darkmoon Faire" },
	[ 530	] = { name = "Darkspear Trolls", Alliance = false },
	[ 69	] = { name = "Darnassus", Horde = false },
--	[ 510	] = { name = "The Defilers	(pvp)
	[ 577	] = { name = "Everlook" },
	[ 930	] = { name = "Exodar", Horde = false },
--	[ 729	] = { name = "Frostwolf Clan	(pvp)
	[ 369	] = { name = "Gadgetzan" },
	[ 54	] = { name = "Gnomeregan Exiles", Horde = false },
	[ 749	] = { name = "Hydraxian Waterlords" },
	[ 47	] = { name = "Ironforge", Horde = false },
--	[ 509	] = { name = "The League of Arathor	(pvp)
	[ 76	] = { name = "Orgrimmar", Alliance = false },
	[ 470	] = { name = "Ratchet" },
--	[ 349	] = { name = "Ravenholdt	(Rogue)
--	[ 809	] = { name = "Shen'dralar	(Dire Maul)
	[ 911	] = { name = "Silvermoon City", Alliance = false },
--	[ 890	] = { name = "Silverwing Sentinels	(pvp)
--	[ 730	] = { name = "Stormpike Gaurd	(pvp)
	[ 72	] = { name = "Stormwind", Horde = false },
	[ 59	] = { name = "Thorium Brotherhood" },
	[ 81	] = { name = "Thunder Bluff", Alliance = false },
	[ 576	] = { name = "Timbermaw Hold" },
	[ 68	] = { name = "Undercity", Alliance = false },
--	[ 889	] = { name = "Warsong Outriders	(pvp)
--	[ 589	] = { name = "Wintersaber Trainers" },
	[ 270	] = { name = "Zandalar Tribe" },
	
	--Wotlk
	[ 1037  ] = { name = "Alliance Vanguard", Horde = false },
	[ 1050	] = { name = "Valiance Expedition", rquests = {11153,12289,12296,12444,13280,13284,13309,13333,13336}, Horde = false },
	[ 1052	] = { name = "Horde Expedition", rquests = {12170}, Alliance = false },
	[ 1064	] = { name = "The Taunka", Alliance = false },
	[ 1067	] = { name = "The Hand of Vengeance", Alliance = false },
	[ 1068	] = { name = "Explorers' League", rquests = {11391}, Horde = false },
	[ 1073	] = { name = "The Kalu'ak", rquests = {11945,11960,11472,24803,24806} },
	[ 1085	] = { name = "Warsong Offensive", rquests = {12270,12280,12284,12288,13283,13301,13310,13330,13331}, Alliance = false },
	[ 1090	] = { name = "Kirin Tor", rquests = {12958,12959,12960,12961,12962,12963,13100,13101,13102,13103,13107,13112,13113,13114,13115,13116,13148,13240,13241,13243,13244,13245,13246,13247,13248,13249,13250,13251,13252,13253,13254,13255,13256,13832,13833,13834,13836,13845,14199,14203,24579,24580,24581,24582,24583,24584,24585,24586,24587,24588,24589,24590} },
	[ 1091	] = { name = "The Wyrmrest Accord", rquests = {11940,12372,13414} },
	[ 1094	] = { name = "The Silver Covenant", rquests = {13625,13666,13669,13670,13671}, Horde = false },
	[ 1098	] = { name = "Knights of the Ebon Blade",rquests = {12813,12815,12838,12995,13069,13071,13092,13093,13788,13791,13793,13812,13813,13814,13863,13864} },
	[ 1104	] = { name = "Frenzyheart Tribe",rquests = {12702,12703,12732,12734,12741,12758,12759,12760} },
	[ 1105	] = { name = "The Oracles", rquests = {12704,12705,12726,12735,12736,12737,12761,12762}},
	[ 1106	] = { name = "Argent Crusade", rquests = {12501,12563,12587,12604,12541,12601,12602,13300,13302}},
	[ 1119	] = { name = "The Sons of Hodir", rquests = {12977,12981,12994,13003,13006,13046,13421,13559} },
	[ 1124	] = { name = "The Sunreavers", rquests = {13673,13674,13675,13676,13677}, Alliance = false },
	[ 1126	] = { name = "The Frostborn", rquests = {12869}, Horde = false },
	
	
	[ 1097	] = { name = "Wrath of the Lich King" },
	[ 1117	] = { name = "Sholazar Basin" },
	[ 1118	] = { name = "Classic" },
	
}


Reputable.factionByMapID = {
	-- Outland Zones
	[1955] = 1011,								-- Shattrath City
	[1944] = { Alliance = 946, Horde = 947 }, 	-- Hellfire Peninsula
	[1946] = 942,								-- Zangarmarsh
	[1952] = 1011,								-- Terokkar Forest
	[1951] = { Alliance = 978, Horde = 941 },	-- Nagrand
	[1949] = 942,								-- Blades Edge Mountains
	[1953] = 933,								-- Netherstorm
	[1948] = 1012,								-- Shadowmoon Valley
}

Reputable.extraQuestInfo = {
	[ 10849 ] = { requires = {{10863,10862}}},
--	[ 10849 ] = { requires = {{ Alliance = 10863, Horde = 10862 }}},
	[  9784	] = { item = 24401, npc = 17909, obj = { { "item",24401,10 } } },
	[  9875 ] = { item = 24407, npc = 17909, obj = { { "item",24407, 1 } } },
	[  9766 ] = { item = 24368, npc = 17841, obj = { { "item",24368, 1 } } },
	[ 10918 ] = { item = 25719, obj = { { "item",25719,30 } } },
	[  9915 ] = { item = 25463, obj = { { "item",25463,3 } } },
	[  9883 ] = { item = 25416, obj = { { "item",25416,10 } } },
	[  9892 ] = { item = 25433, obj = { { "item",25433,10 } } },
	[ 10972 ] = { item = 31957, obj = { { "item",31957,1 } } },
	[ 10981 ] = { item = 31941, obj = { { "item",31941,1 } } },
	[ 10308 ] = { item = 29209, obj = { { "item",29209,10 } } },
	[ 10888 ] = { requires = {10884,10885,10886}},
	[  9744 ] = { item = 24291, obj = { { "item",24291,6 } } },
	[  9742 ] = { item = 24290, obj = { { "item",24290,10 } } },
	[  9809 ] = { item = 24245, obj = { { "item",24245,10 } } },
	[  9807 ] = { item = 24449, obj = { { "item",24449,6 } } },
	[  9714 ] = { item = 24246, obj = { { "item",24246,5 } } },
	[  9928 ] = { requires = {10108} },
	[  9927 ] = { requires = {10108} },
	[  9931 ] = { requires = {9927,9928} },
	[  9932 ] = { requires = {9927,9928} },
	[  9933 ] = { requires = {9932} },
	[ 10477 ] = { item = 25433, obj = { { "item",25433,10 } } },
	[ 11049 ] = { item = 32506, obj = { { "item",32506,1 } } },
	[ 11050 ] = { item = 32506, obj = { { "item",32506,1 } } },
	[ 10414 ] = { item = 29426, obj = { { "item",29426,1 } } },
	[ 10415 ] = { item = 29426, obj = { { "item",29426,10 } } },
	[ 10659 ] = { item = 30810, obj = { { "item",30810,1 } } },
	[ 10658 ] = { item = 30810, obj = { { "item",30810,10 } } },
	[ 10419 ] = { item = 29739, obj = { { "item",29739,1 } } },
	[ 10025 ] = { item = 25744, obj = { { "item",25744,8 } } },
	[ 10019 ] = { item = 25802, obj = { { "item",25802,8 } } },
	[ 10327 ] = { item = 29425, obj = { { "item",29425,1 } } },
	[ 10326 ] = { item = 29425, obj = { { "item",29425,10 } } },
	[ 10655 ] = { item = 30809, obj = { { "item",30809,1 } } },
	[ 10654 ] = { item = 30809, obj = { { "item",30809,10 } } },
	[ 10421 ] = { item = 29740, obj = { { "item",29740,1 } } },
	[  9826 ] = { requires = {9824,9825} },
	[  5206 ] = { requires = {5168,5181} },
	[  6585 ] = { requires = {6582,6584,6583} },
	[ 10288 ] = { requires = {}},
	[ 11078 ] = { requires = {{11010,11102}}},
	[ 11023 ] = { requires = {{11010,11102}}},
	[ 10094 ] = { breadcrumb = {10177}},
	[ 10995 ] = { requires = {10983}},
	[ 10996 ] = { requires = {10983}},
	[ 10997 ] = { requires = {10983}},
	[ 10998 ] = { requires = {10995,10996,10997}},
	[ 10983 ] = { breadcrumb = {10984}},
	[ 10588 ] = { requires = {10523,10541,10579}},
	[  9067 ] = { breadcrumb = {9395}},
	[ 11488 ] = { breadcrumb = {11481, 11482}},
	
	[ 10732 ] = { breadcrumb = {							10731,10735,10740,10727,	10730,10734,10739,10726,	10729,10733,10738,10725	}},
	[ 10731 ] = { breadcrumb = {10732,10736,10741,10728,								10730,10734,10739,10726,	10729,10733,10738,10725	}},
	[ 10730 ] = { breadcrumb = {10732,10736,10741,10728,	10731,10735,10740,10727,								10729,10733,10738,10725	}},
	[ 10729 ] = { breadcrumb = {10732,10736,10741,10728,	10731,10735,10740,10727,	10730,10734,10739,10726								}},
	
	--Midsummer_fire_festival
	--[[
	[ 11972 ] = { requires = { 11955 } },
	[ 11955 ] = { requires = { 12012 } },
	[ 11954 ] = { requires = { 12012 } },
	[ 12012 ] = { requires = { 11891 } },
	[ 11891 ] = { requires = { 11886 } },--]]
}
Reputable.questIgnore = {
	[  9035 ] = true, -- class specific
}
Reputable.questByFaction = {
	[  942 ] = {"Hellfire Peninsula",{9373},{10443,10442,9372,10255},{10159},{10132},{10134,10349,10351},"Zangarmarsh",{9785},{9747,9788,10096,9894},{9895},{9802,9784,9875},{9752},{9716,9718,9720},{9731,9724,9732,9876,9738},{9778,9728},{9817},{9730},{9697,9701,9702,9708,9709},{9911},{9957},{9763},{9764,9765,9766},"Terokkar Forest",{9971},{9961,9960,9968,9978,9979,10112,9990,9994,10444,9996,10446,10005,9995,10448,9997,10447,10006},{9951},{10896},"Blade's Edge Mountains",{10682,10713},{10719,10894,10893,10722,10748},{10567,10607},{10753},{10770},{10771},{10810,10812,10819,10820,10821,10910,10904,10911,10912},"Netherstorm",{10426,10427,10429}},
	[  946 ] = {"Hellfire Peninsula",{10119,10288,10140,10254},{10141,10142,9355,10143,10144,9575,9607,10146,10340,10344,10163,10382,10394,10396,10397},{10482,10483,10484,10485,10903,10909,10916,10935,10936,10937},{10106},{10895},{10058},{10079,10099},{9587,9589},{9558,9417},{10055,10078},{10050,10057},{10395,10399,10400},{9563,9420},{9385},{10754,10762,10763,10764},{9493},{9494},{9492},{9524},{11002}},
	[  947 ] = {"Hellfire Peninsula",{10110},{9407,10120,10289,10291,10121,10123,10124,9572,9608,10208,10129,10162,10388,9400,9401,9405,9410,9406,9438,10390,10391,10392,10136,10389},{10809,10792,10813,10834},{10450,10449,10242,10538,10835,10864,10838,10875,10876},{10278,10294,10295},{10393},{10229,10230,10250,10258},{10220},{10086,10087},{9345,10213},{9588,9590},{9496},{9495},{10755,10756,10757,10758},{11003}},
	[ 1011 ] = {"Terokkar Forest",{10917,10918},{10863,10862,10847,10849,10839,10848,10861,10874,10889,10879,10852,10840,10030,10031},{10842},{10898},{10878},{10880,10881},{10887},{10913,10914,10915},{10922,10929,10930},{10097},{10178,10091},{10177,10094,10095}},
	[  933 ] = {"Mana-Tombs",{10165},{10216,10218},"Nagrand",{9913},{9914,9915},{9882,9883},{9925},{9900},{9893,9892},"Netherstorm",{10345},{10311,10310},{10353},{10413},{10425},{10315},{10317,10318},{10855,10856,10857},{10290,10293},{10335},{10336},{10348},{10417,10418,10423,10424,10430,10436},{10437,10438,10439},{10339,10384,10385,10405,10406,10408},{10422},{10411},{10270,10271,10281,10272,10273,10274},{10969,10970,10971,10972},{10973,10974,10976,10975,10977,10981,10982},{10265,10262,10308,10205,10266,10267,10268,10269,10275,10276}},
	[  989 ] = {"Shattrath City",{10279,10277},{10282,10283,10284,10285},{10296,10297}},
	[  935 ] = {"Nagrand",{10101,10102,10167,10168},"Terokkar Forest",{10877,10923},{10920,10921,10926},{10873},{10227,10228,10231,10251,10252,10253,10164},"Shadowmoon Valley",{10793,10781},{10708},"Shattrath City",{10210},{10280,10704,10882},{10883},{10884,10885,10886},{10888}},
	[  967 ] = {"Karazhan",{9824,9825,9826,9829,9831,9832,9836,9837,9838,9840,9843,9844,9860},{9630,9638,9639,9640,9645,9680,9631,9637,9644},"Violet Signets",{10732,10736,10741,10728},{10731,10735,10740,10727},{10730,10734,10739,10726},{10729,10733,10738,10725}},
	[  970 ] = {"Zangarmarsh",{9919},{9743,9744},{9739,9742},{9808,9809},{9806,9807},{9726,9727},{9715,9714},{9717},{9719},{9729}},
	[  978 ] = {"Zangarmarsh",{10116},{10115},{9835,9839},{9833},{9834,9905},{9830},{9902},"Nagrand",{9923,9924,9954,9955},{9917,9918,9920,9921,9922,10108,9928,9927,9931,9932,9933},{9869},{10476,10477},{9940},{9936},{9879},{9878},{9874},{9871,9873},{11502},{9956},{9938}},
	[  941 ] = {"Hellfire Peninsula",{9410,9406,9438,9441,9442,9447},"Terokkar Forest",{9888,9889,9890,9891,9906,9907,10107},"Nagrand",{9910,9916},{9939},{9935},{9934},{9870},{9863},{10479,10478},{9948},{9944,9945,9946},{9937},{9872},{9868},{9867},{9864,9865,9866},{10044,10045,10081,10082,10085,10101,10102,10167,10168,10170,10171,10172,10175,10212},{11503}},
	[ 1012 ] = {"Shadowmoon Valley",{--[[10683,10684,10685,10686,10568,10571,10574,10575,--]]10622,10628,10705,10706,10707,11052,10944,10946,10947,10948,10949,10985,10958,10957,10959}},
	[  934 ] = {"Shattrath City",{10210,10211,10552,10553},{10169},{11039},{10412,10414,10415},{10656,10659,10658},{10416,10419},{10024,10025},
	"Shadowmoon Valley",{10683,10684,10685,10686},{10807,10817},{10687,10688,10689},{10691,10692},"Netherstorm",{10189,10204,10193,10329,10194,10652,10197,10198,10330,10200,10338,10365,10341,10202,10432,10508,10509,10507}},
	[  932 ] = {"Shattrath City",{10210,10211,10551,10554},{10020,10021},{11038},{10017,10019},{10325,10327,10326},{10653,10655,10654},{10420,10421},
	"Shadowmoon Valley",{10568,10571,10574,10575},{10619,10816},{10587,10637,10640},{10650,10651},"Netherstorm",{10241,10313,10246},{10243,10245,10299,10321,10322,10323},{10328,10431,10380,10381,10407,10410,10409}},
	[ 1031 ] = {
"Shattrath City",{11096,11098},
"Terokkar Forest",{11093,11008,11085},{11004,11006,11005,11021,11024,11028,11056,11029,11885,11074,11073},
"Blade's Edge Mountains",{11062,11010,11023},{11119},{11065,11066},{11078},
"With Ogri'la",{11059,11026,11058},
},
	[ 1038 ] = {
UNLOCK.." "..REPUTATION,
{10984,10983,10995,10996,10997,10998,11000},
"Blade's Edge Mountains",
{11022,11009,11025,11058,11080},
{11030,11061,11079},
{11059},{11010,11023},
{11065,11066},{11091},{11026},{11060},{11051},{11027}},
	[ 1015 ] = {
UNLOCK.." "..REPUTATION,
{10804,10811,10814,10836,10837,10854,10858,10866,10870},
"Shadowmoon Valley",
{11012,11013,11014},{11041},{11019},{11049},
{11053,11075,11083,11081,11082,11054},
{11084,11089,11090},
{11099,11094,11100,11095},
{11107,11108},
"Race",
{11063,11064,11067,11068,11069,11070,11071},
},
	[ 1077 ] = {"Magisters' Terrace",{11481,11488,11490,11492},"Isle of Quel'Danas",{11526,11550,11517}},

--{11102},-- druid version of "Bombing run" -- need to impliment

--	[  529 ] = {
--		{5601,5142,5149},{5241,5211},{5168,5152,5153,5154,5210,5181,5206,5941},{5721,5942}, -- argent dawn
--	},
--	[  69 ] = { -- darn
--		{7792,7798,7799,7800,7801},
--	},

--Sons of hodir
[ 1119 ] = {{12915},{12924},{12956},{12966},{12967},{12975},{12976},{12977},{12981},{12985},{12987},{12994},{13001},{13003},{13006},{13010},{13011},{13046},{13108},{13420},{13421},{13559}},
--the Oracles
[ 1105 ] = {{12570},{12571},{12572},{12573},{12574},{12575},{12576},{12577},{12578},{12579},{12580},{12704},{12705},{12726},{12735},{12736},{12737},{12761},{12762}},
-- Alliance Vanguard
[ 1037 ] = {{13036}},
--The Hand of Vengeance
[ 1067 ] = {{11234},{11233},{11232},{11227},{11221},{11170},{11270},{11279},{11280},{11283},{11298},{11301},{11303},{11304},{11305},{11306},{11307},{11397},{11398},{11399},{12181},{12182},{12188},{12189},{12200},{12205},{12206},{12209},{12211},{12214},{12218},{12221},{12230},{12232},{12234},{12239},{12240},{12243},{12245},{12252},{12254},{12260},{12271},{12273},{12274},{12283},{12285},{12303},{12304},{12482},{12488},{12952},{13089},},
--Valiance Expedition
[ 1050 ] = {{11255},{11250},{11249},{11248},{11247},{11246},{11245},{11244},{11243},{11239},{11238},{11237},{11236},{11235},{11231},{11202},{11199},{11190},{11188},{11187},{11157},{11155},{11154},{11153},{11269},{11273},{11274},{11276},{11277},{11278},{11284},{11288},{11289},{11290},{11291},{11299},{11300},{11322},{11326},{11327},{11328},{11329},{11330},{11331},{11332},{11333},{11343},{11344},{11355},{11358},{11359},{11406},{11410},{11418},{11420},{11421},{11426},{11427},{11429},{11430},{11432},{11436},{11443},{11448},{11452},{11460},{11465},{11468},{11470},{11474},{11475},{11477},{11478},{11600},{11601},{11603},{11604},{11645},{11650},{11653},{11658},{11670},{11672},{11673},{11692},{11693},{11694},{11697},{11698},{11699},{11700},{11701},{11707},{11708},{11710},{11712},{11713},{11715},{11718},{11723},{11725},{11726},{11727},{11728},{11729},{11730},{11788},{11789},{11790},{11791},{11792},{11793},{11794},{11795},{11796},{11797},{11798},{11873},{11889},{11897},{11901},{11902},{11903},{11904},{11908},{11913},{11920},{11928},{11932},{11938},{11942},{11944},{11956},{11962},{11963},{11965},{12019},{12035},{12067},{12086},{12088},{12092},{12105},{12109},{12142},{12143},{12157},{12166},{12167},{12168},{12169},{12171},{12174},{12212},{12215},{12216},{12217},{12219},{12222},{12223},{12225},{12226},{12227},{12235},{12237},{12246},{12248},{12249},{12250},{12251},{12253},{12255},{12258},{12269},{12272},{12275},{12276},{12277},{12281},{12282},{12287},{12289},{12290},{12291},{12292},{12293},{12294},{12295},{12296},{12297},{12298},{12301},{12302},{12305},{12308},{12309},{12310},{12311},{12312},{12319},{12320},{12321},{12325},{12326},{12438},{12439},{12440},{12441},{12442},{12444},{12455},{12457},{12462},{12463},{12464},{12465},{12466},{12467},{12472},{12473},{12474},{12475},{12476},{12477},{12478},{12495},{12499},{12511},{12766},{12918},{13004},{13087},{13088},{13225},{13280},{13284},{13296},{13309},{13314},{13333},{13336},{13341},{13362},{13386},{13387},{13392},{13396},{13397},{13418},{13524},{24498},{24499},{24500},{24710},},
--Horde Expedition
[ 1052 ] = {{11254},{11253},{11241},{11230},{11229},{11167},{11272},{11282},{11285},{11295},{11309},{11310},{11423},{11424},{11639},{12041},{12063},{12064},{12069},{12090},{12096},{12170},{12175},{12176},{12177},{12178},{12481},},
--The Taunka
[ 1064 ] = {{11258},{11257},{11256},{11259},{11260},{11261},{11263},{11264},{11265},{11266},{11267},{11268},{11271},{11286},{11287},{11296},{11311},{11317},{11324},{11350},{11351},{11352},{11365},{11366},{11367},{11411},{11433},{11453},{11628},{11630},{11633},{11640},{11641},{11647},{11654},{11659},{11674},{11675},{11677},{11678},{11683},{11684},{11685},{11687},{11689},{11695},{11706},{11888},{11890},{11893},{11895},{11896},{11898},{11899},{11906},{11907},{11909},{11929},{11930},{11977},{11978},{11979},{11983},{12026},{12054},{12058},{12165},{12195},{12196},{12197},{12198},{12199},{12415},{12451},{12566},},
--The Hand of Vengeance
[ 1067 ] = {{11234},{11233},{11232},{11227},{11221},{11170},{11270},{11279},{11280},{11283},{11298},{11301},{11303},{11304},{11305},{11306},{11307},{11397},{11398},{11399},{12181},{12182},{12188},{12189},{12200},{12205},{12206},{12209},{12211},{12214},{12218},{12221},{12230},{12232},{12234},{12239},{12240},{12243},{12245},{12252},{12254},{12260},{12271},{12273},{12274},{12283},{12285},{12303},{12304},{12482},{12488},{12952},{13089},},
--Explorers' League
[ 1068 ] = {{11240},{11224},{11218},{11189},{11175},{11176},{11346},{11348},{11349},{11390},{11391},{11393},{11394},{11395},{11396},{11483},{11484},{11485},{11489},{11491},{11494},{11495},{11501},{12855},{12858},{12860},{12870},{12872},{12880},{12973},{13417},},
--the Kaluak
[ 1073 ] = {{11456},{11457},{11458},{11472},{11504},{11507},{11508},{11509},{11510},{11511},{11512},{11519},{11527},{11529},{11530},{11567},{11568},{11572},{11573},{11605},{11607},{11609},{11610},{11612},{11613},{11617},{11619},{11620},{11621},{11622},{11623},{11626},{11655},{11656},{11660},{11661},{11662},{11945},{11949},{11950},{11958},{11959},{11960},{11961},{11968},{12009},{12011},{12016},{12017},{12028},{12030},{12031},{12032},{12117},{12118},{12471},{24803},{24806},},
--Warsong Offensive
[ 1085 ] = {{11585},{11586},{11591},{11592},{11593},{11594},{11595},{11596},{11597},{11598},{11602},{11606},{11608},{11611},{11614},{11615},{11616},{11618},{11629},{11631},{11632},{11634},{11635},{11636},{11637},{11638},{11642},{11643},{11644},{11651},{11652},{11664},{11676},{11686},{11688},{11690},{11703},{11705},{11709},{11711},{11714},{11716},{11717},{11719},{11720},{11721},{11722},{11724},{11916},{11980},{12008},{12033},{12034},{12036},{12039},{12048},{12053},{12056},{12057},{12071},{12072},{12073},{12085},{12089},{12091},{12095},{12097},{12100},{12101},{12102},{12104},{12111},{12115},{12125},{12126},{12127},{12132},{12136},{12140},{12144},{12145},{12207},{12213},{12220},{12224},{12229},{12231},{12236},{12241},{12242},{12247},{12256},{12257},{12259},{12270},{12280},{12284},{12288},{12413},{12422},{12423},{12424},{12426},{12431},{12436},{12453},{12486},{12487},{12496},{12500},{12767},{12882},{12895},{12909},{12913},{12917},{13000},{13002},{13034},{13037},{13038},{13048},{13049},{13054},{13056},{13058},{13090},{13224},{13242},{13257},{13258},{13267},{13283},{13285},{13293},{13301},{13310},{13313},{13330},{13331},{13340},{13348},{13349},{13419},{13426},{24506},{24507},{24511},{24712},{24802},},
--Kirin Tor
[ 1090 ] = {{11576},{11582},{11587},{11590},{11646},{11648},{11663},{11671},{11680},{11681},{11682},{11733},{11900},{11905},{11910},{11911},{11912},{11914},{11995},{11996},{11999},{12000},{12004},{12005},{12055},{12059},{12060},{12061},{12065},{12066},{12083},{12084},{12098},{12106},{12107},{12110},{12172},{12173},{12728},{12790},{12791},{12794},{12796},{12958},{12959},{12960},{12961},{12962},{12963},{13094},{13095},{13100},{13101},{13102},{13103},{13107},{13112},{13113},{13114},{13115},{13116},{13148},{13159},{13240},{13241},{13243},{13244},{13245},{13246},{13247},{13248},{13249},{13250},{13251},{13252},{13253},{13254},{13255},{13256},{13830},{13832},{13833},{13834},{13836},{13845},{14103},{14151},{14199},{14203},{24431},{24579},{24580},{24581},{24582},{24583},{24584},{24585},{24586},{24587},{24588},{24589},{24590},},
--The Wyrmrest Accord
[ 1091 ] = {{11918},{11919},{11931},{11936},{11940},{11941},{11943},{11946},{11951},{11957},{11967},{11969},{11973},{12119},{12122},{12123},{12124},{12146},{12147},{12148},{12149},{12150},{12151},{12261},{12262},{12263},{12264},{12265},{12266},{12267},{12372},{12416},{12417},{12418},{12419},{12435},{12447},{12448},{12449},{12450},{12454},{12456},{12458},{12459},{12460},{12461},{12470},{12498},{12768},{12769},{13124},{13126},{13127},{13128},{13343},{13372},{13375},{13384},{13385},{13412},{13413},{13414},},
--The Silver Covenant
[ 1094 ] = {{13625},{13666},{13667},{13669},{13670},{13671},{13672},{13679},{13828},{13835},{13837},{24553},{24595},},
--Knights of the Ebon Blade
[ 1098 ] = {{12629},{12631},{12633},{12637},{12638},{12643},{12648},{12649},{12661},{12669},{12676},{12677},{12713},{12801},{12806},{12807},{12810},{12813},{12814},{12815},{12838},{12839},{12840},{12847},{12852},{12884},{12887},{12891},{12892},{12893},{12898},{12899},{12938},{12939},{12943},{12949},{12951},{12955},{12982},{12992},{12995},{12999},{13042},{13043},{13059},{13069},{13071},{13084},{13085},{13091},{13092},{13093},{13106},{13117},{13119},{13120},{13121},{13133},{13134},{13137},{13142},{13143},{13144},{13145},{13146},{13147},{13152},{13155},{13160},{13161},{13162},{13163},{13164},{13165},{13166},{13168},{13169},{13170},{13171},{13172},{13174},{13212},{13220},{13235},{13306},{13307},{13312},{13316},{13328},{13329},{13332},{13334},{13335},{13337},{13338},{13339},{13788},{13791},{13793},{13795},{13812},{13813},{13814},{13863},{13864},},
--Frenzyheart Tribe
[ 1104 ] = {{12528},{12529},{12530},{12531},{12532},{12533},{12534},{12535},{12536},{12537},{12538},{12539},{12702},{12703},{12732},{12734},{12741},{12758},{12759},{12760},},
--The Sunreavers
[ 1124 ] = {{13668},{13673},{13674},{13675},{13676},{13677},{13678},{13680},{13829},{13838},{13839},{24564},{24594},{24596},{24598},},
--The Frostborn
[ 1126 ] = {{12863},{12864},{12865},{12866},{12867},{12868},{12869},{12871},{12873},{12874},{12875},{12876},{12877},{12879},},
--Argent Crusade
[ 1106 ] = {{12501},{12502},{12503},{12504},{12505},{12508},{12509},{12512},{12519},{12527},{12541},{12542},{12545},{12552},{12553},{12554},{12555},{12562},{12563},{12564},{12568},{12583},{12584},{12585},{12587},{12588},{12591},{12594},{12596},{12597},{12598},{12599},{12601},{12602},{12604},{12606},{12609},{12610},{12740},{12857},{12859},{12883},{12894},{12901},{12902},{12903},{12904},{12914},{12916},{12919},{13008},{13039},{13040},{13045},{13068},{13070},{13072},{13073},{13075},{13076},{13077},{13079},{13080},{13081},{13082},{13083},{13086},{13104},{13105},{13110},{13118},{13122},{13125},{13130},{13135},{13136},{13138},{13139},{13140},{13141},{13157},{13211},{13221},{13226},{13227},{13229},{13300},{13302},{13364},{13403},{13481},{13482},{13633},{13634},{13641},{13643},{13663},{13664},{13682},{13702},{13732},{13733},{13734},{13735},{13736},{13737},{13738},{13739},{13740},{13789},{13790},{13794},{13809},{13810},{13811},{13846},{13861},{13862},{14016},{14017},{24442},},
}

Reputable.questByGroup = {
[ "Midsummer_fire_festival" ] = {
dailies = { 11921,11924,11926,11925,11954,11691 },
quests = {
QUESTS_LABEL,
{11882,11915},--"breadcrumb",
{11964,11966},
{11731,11922,11657,11923,11921,11926,11924,11925}, -- City Games
"Ahune Chain",
{11886,11891,12012,11954,11955,11696,11691,11972},
"m:676:Outland",
{11818,11775,11829,11787,11825,11782,11821,11778,11807,11767,11830,11799,11823,11779}, -- alliance
{11851,11747,11863,11758,11858,11754,11854,11750,11843,11736,11835,11759,11855,11752}, -- horde
POSTMASTER_PIPE_EASTERNKINGDOMS,
{9326,9330,9331,11935}, -- cities
{11804,11764,11766,11808,11810,11768,11813,11814,11816,11772,11774,11819,11776,11820,11822,11580,11832,11801,11781,11826,11784,11786,11827,11583,11828},	-- alliance
{11840,11732,11842,11737,11844,11739,11742,11743,11745,11848,11850,11853,11748,11749,11751,11584,11837,11761,11857,11860,11755,11862,11756,11581,11757},	-- horde
POSTMASTER_PIPE_KALIMDOR,
{9324,9325,9332,11933}, -- cities
{11805,11765,11806,11809,11811,11812,11769,11770,11815,11771,11817,11773,11777,11831,11800,11780,11824,11833,11802,11783,11785,11834,11803},	-- alliance
{11841,11734,11735,11738,11740,11845,11741,11846,11847,11744,11849,11746,11852,11836,11760,11856,11762,11753,11838,11859,11861,11839,11763},	-- horde
}},
[ "Brewfest" ] = {
dailies = { 12062,12020,11293,11407 },
quests = {
QUESTS_LABEL,
{11442,11447}, --welcome
--{12318},--"breadcrumb",
{12022,12191},--chug and chuck
{11318,11409},--learn ram racing
{11122,11412},--ram racing
{12193,12194},--Souvenir 
{12491,12492},--direbrew drop
}},
[ "HallowsEnd" ] = {
dailies = { 11405, 11219 },
quests = {
QUESTS_LABEL,
{8322},
{1657},
}},
}



Reputable.attunements = {
	[ 249 ] = {
	--	name = "Onyxia's Lair",
	--	requirements = { dungeons={{230,0},{229,0}} },/script DEFAULT_CHAT_FRAME:AddMessage("\124cffffffff\124Hitem:24487::::::::70:::::\124h[Second Key Fragment]\124h\124r");
		check = { quest = { 6502, 6602 }},	--{ item = 16309 },
		chain = {
			{1,"Head to Burning Steppes and speak with Helendis Riverhorn",4182},
			4183,4184,4185,4186,4223,4224,
			{1,4241,"i0230",
			"• Kill High Interrogator Gerstahn, loot |cffffffff|Hitem:11140:::::::::::::|h[Prison Cell Key]|h|r",
			"• You will find Marshal Windsor in a nearby prison cell"},
			{1,4242,
			"• Head back to Marshal Maxwell in the Burning Steppes",
			"• Marshal Maxwell does not give you the next quest"},
			{1,"i0230",
			"• Kill mobs inside Blackrock Depths for |cffffffff|Hitem:11446:::::::::::::|h[A Crumpled Up Note]|h|r",
			4264,
			"• Take the note to Marshal Windsor inside Blackrock Depths"},
			{1,4282,"i0230",
			"• Kill General Angerforge, loot |cffffffff|Hitem:11464:::::::::::::|h[Marshal Windsor's Lost Information]|h|r",
			"• Kill Golem Lord Argelmach, loot |cffffffff|Hitem:11465:::::::::::::|h[Marshal Windsor's Lost Information]|h|r",
			"• Return to Marshal Windsor inside Blackrock Depths",
			"|cFFFF5E13--- Ensure EVERYONE has turned in this quest before accepting the next ---|r"},
			{1,4322,"i0230",
			"• Escort Marshal Windsor around the prison cells, and back to the entrance",
			"• Wait for credit before leaving the instance",
			"• Head back to Marshal Maxwell in the Burning Steppes"},
			{1,6402,
			"• Head to Stormwind and speak to Squire Rowe near the gates",
			"• Squire Rowe calls for Marshal Windsor"},
			{1,6403,
			"• Follow Reginald Windsor through Stormwind",
			"• Stand back and watch the fight"},
			{1,6501,
			"• Head to Winterspring and find Haleh to the southwest of Everlook"},
			{1,6502,"i0229",
			"• Kill the final boss in UBRS, General Drakkisath",
			"• Loot |cffffffff|Hitem:16663:::::::::::::|h[Blood of the Black Dragon Champion]|h|r",
			"• Return to Haleh in Winterspring",
			"• Recieve from quest your |cff0070dd|Hitem:16309:::::::::::::|h[Drakefire Amulet]|h|r",
			"• This needs to be in you bags to enter Onyxia's Lair"},
			
			{2, "Head to Kargath in the Badlands and speak with Warlord Goretooth",4903,"i0229",
			"• Kill the three required bosses in LBRS",
			"• Check around each for |cffffffff|Hitem:12562:::::::::::::|h[Important Blackrock Documents]|h|r",
			"• Head back to Warlord Goretooth in the Badlands"},
			{4941},
			{2, 4974, "i0229",
			"• Kill Warchief Rend Blackhand in UBRS and loot |cffffffff|Hitem:12630:::::::::::::|h[Head of Rend Blackhand]|h|r",
			"• Return to Thrall in Orgrimmar"},
			{2, 6566,
			"• Speak to Thrall and listen to what he has to say"},
			{2, 6567,
			"• Head to Desolace and find Rexxar who patrols the main road"},
			{2, 6568,
			"• Head to Western Plaguelands",
			"• Find Myranda the Hag near Uther's Tomb in Sorrow Hill"},
			{2, 6569, "i0229",
			"• Kill dragon mobs in UBRS and collect 20 x |cffffffff|Hitem:16786:::::::::::::|h[Black Dragonspawn Eye]|h|r",
			"• Return to Myranda the Hag in Western Plaguelands"},
			{2, 6570,
			"• Head to Dustwallow Marsh and find Emberstrife in a cave to the south of The Wyrmbog",
			"• Use the item Myranda the Hag gave you: |cffffffff|Hitem:16787:::::::::::::|h[Amulet of Draconic Subversion]|h|r",
			"• Speak with Emberstrife"},
			{2, 6582,
			"|cFFFF5E13--- ".. LEVEL .. " 60 " .. ELITE .. " ---|r",
			"• Found to the southwest of Everlook in Winterspring"},
			{2, 6584,
			"|cFFFF5E13--- ".. LEVEL .. " 61 " .. ELITE .. " ---|r",
			"• Found at the entrance of the Caverns of Time in Tanaris"},
			{2, 6583,
			"|cFFFF5E13--- ".. LEVEL .. " 62 " .. ELITE .. " ---|r",
			"• Found in the Swamp of Sorrows, patrolling to the southeast of the Sunken Temple"},
			{2, 6585,
			"|cFFFF5E13--- ".. LEVEL .. " 62 " .. ELITE .. " ---|r",
			"• Found in eastern Wetlands, patrolling the path to Grim Batol"},
			
			{2, 6601,
			"• Return to Rexxar in Desolace"},
			{2, 6602, "i0229",
			"• Kill the final boss in UBRS, General Drakkisath",
			"• Loot |cffffffff|Hitem:16663:::::::::::::|h[Blood of the Black Dragon Champion]|h|r",
			"• Return to Rexxar in Desolace",
			"• Recieve from quest your |cff0070dd|Hitem:16309:::::::::::::|h[Drakefire Amulet]|h|r",
			"• This needs to be in you bags to enter Onyxia's Lair"},
		},
	},
	[ 532 ] = {
	--	name = "Karazhan",
		check = { item = 24490 },
		requirements = { dungeons={{555,0},{545,0},{552,0},{269,0}} },
		chain = {
			{"Head to Deadwind Pass and speak with Archmage Alturus",
			9824},9825,9826,9829,
			{9831,"i0555",
			"• After killing Murmur, loot the arcane container in the room",
			"• Kill the Guardian that appears and loot |cffffffff|Hitem:24514::::::::70:::::|h[First Key Fragment]|h|r"},
			{9832,"i0545",
			"• Open the arcane container underwater near the first boss, Hydromancer Thespia",
			"• Kill the Guardian that appears and loot |cffffffff|Hitem:24487:::::::::::::|h[Second Key Fragment]|h|r",
			"i0552","• Open the arcane container after Zereketh, in the voidwalker room",
			"• Kill the Guardian that appears and loot |cffffffff|Hitem:24488:::::::::::::|h[Third Key Fragment]|h|r"},
			{9836,"i0269"},{9837}
		},
	},
	[ 555 ] = {
		check = { item = 27991 },
		requirements = { dungeons={{556,0}} },
		chain = {
			{ "i0556",
			"• Kill the final boss, Talon King Ikiss",
			"• From the chest that appears, loot |cffffffff|Hitem:27991::::::::::::::|h[Shadow Labyrinth Key]|h|r"}
		},
	},
	[ 552 ] = {
		check = { item = 31084 },
		requirements = { dungeons={{554,0},{553,0}} },
		chain = {
			{ "Head to Area 52 in the Netherstorm and speak with Nether-Stalker Khay'ji",
			10265},10262,10205,10266,10267,10268,10269,10275,
			{ 10276,
			"|cFFFF5E13--- ".. LEVEL .. " 70 " .. ELITE .. " ---|r"},
			{ 10280 },
			{ 10704,"i0554",
			"• Kill the final boss, Pathaleon the Calculator",
			"• Loot |cffffffff|Hitem:31086:::::::::::::|h[Bottom Shard of the Arcatraz Key]|h|r",
			"i0553",
			"• Kill the final boss, Warp Splinter",
			"• Loot |cffffffff|Hitem:31085:::::::::::::|h[Top Shard of the Arcatraz Key]|h|r"}
		},
	},
	[ 269 ] = {
		name = DUNGEON_FLOOR_TANARIS18,
		check = { quest = 10285 },
		requirements = { dungeons={{560,0}} },
		chain = {
			{"Head to Caverns of Time in Tanaris and speak with the Steward of Time",
			10279},{10277,
			"• This unlocks Old Hillsbrad Foothills"},
			{10282,"i0560",
			"• Speak to Erozion near the start of the instance"},
			{10283,"i0560",
			"• Speak to the dragon nearby and have him fly you to the keep",
			"• Head to the lower level and fight your way into all five buildings",
			"• Inside each building find a barrel for |cffffffff|Hitem:25853:::::::::::::|h[Pack of Incendiary Bombs]|h|r",
			"• Head back to the upper level and enter the keep",
			"• Thrall can be found in a jail downstairs",
			"|cFFFF5E13--- Ensure EVERYONE has turned in this quest before accepting the next ---|r"},
			{10284,"i0560",
			"• Escort Thrall to the Inn at Tarren Mill and kill the final boss",
			"• Watch the scene until the quest completes",
			"• Return to Erozion near the entrance"},
			{10285,
			"• Leave the instance and find Andormu in the Caverns of Time"}
		},
	},
	[ 540 ] = {
		check = { item = 28395 },
		requirements = { items={{23445,4},{22445,2},{22574,4}} },
		chain = {
			{
			"Kill Smith Gorlunk in Shadowmoon Valley (67.6, 36.4)",
			"a• Loot |cffffffff|Hitem:31239:::::::::::::|h[Primed Key Mold]|h|r",
			"h• Loot |cffffffff|Hitem:31241:::::::::::::|h[Primed Key Mold]|h|r",
			10754,10755},
			10762,10756,
			{10763,10757,
			"• Hand in these items:",
			"- |cffffffff|Hitem:23445:::::::::::::|h[Fel Iron Bar]|h|r x 4",
			"- |cffffffff|Hitem:22445:::::::::::::|h[Arcane Dust]|h|r x 2",
			"- |cffffffff|Hitem:22574:::::::::::::|h[Mote of Fire]|h|r x 4"},
			{10764,10758,
			"|cFFFF5E13--- ".. LEVEL .. " 70 " .. ELITE .. " ---|r",
			"• You do not need credit for the kill",
			"• On a Fel Reaver's corpse use |cffffffff|Hitem:31251:::::::::::::|h[Unfired Key Mold]|h|r"
			},
			
		},
	},
	[ "Nightbane" ] = {
		check = { quest = 9644 },
		requirements = { reputation={{967,9000}}, dungeons={{532,0},{540,1},{556,1}}},
		chain = {
			{"Head to Deadwind Pass and speak with Archmage Alturus",9630,"i2532",
			"• Wravien can be found in the library, after Curator",
			"• Extra trash needs to be cleared, or soft reset once Shade of Aran is dead"},
			{9638,"i2532","• In the library near Wravien"},
			{9639,"i2532","• In the library near Wravien and Gradav"},
			{9640,"i2532","• Kill the Shade of Aran","• Everyone on the quest can loot |cffffffff|Hitem:23933|h[Medivh's Journal]|h|r"},
			{9645,"i2532","• Head to the Master's Terrace and use |cffffffff|Hitem:23934|h[Medivh's Journal]|h|r",
			"(The location Nightbane is summoned and fought)","• Watch the scene until the quest completes",
			"• Return to Archmage Alturus outside Karazhan"},
			{9680,"• Near the entrance to Karazhan, South West about 50 yards","(Cannot be looted/completed in a raid group)"},
			{9631},
			{9637,"i1540","• Defeat the first boss, Grand Warlock Nethekurse","• Loot |cffffffff|Hitem:25462|h[Tome of Dusk]|h|r",
			"i1556","• Defeat the first boss, Darkweaver Syth","• Loot |cffffffff|Hitem:25461|h[Book of Forgotten Names]|h|r"},
			{9644,"i2532","• Kill Nightbane and loot |cffffffff|Hitem:24139|h[Faint Arcane Essence]|h|r",
			"• Return to Archmage Alturus outside Karazhan",
			"• On completion you keep |cffffffff|Hitem:24140|h[Blackened Urn]|h|r",
			"• If deleted after completion you can replace |cffffffff|Hitem:24140|h[Blackened Urn]|h|r from Archmage Alturus",
			"(This may be better than keeping in your bags/bank)"},
			
		},
	},
	[ 550 ] = { -- tk
		check = { quest = 10888 },
		requirements = { dungeons={{540,1},{545,1},{555,1},{552,1},{544,0}} },
		chain = {
			{1,"Head to Shadowmoon Valley and speak with Earthmender Sophurus", 10680},
			{2,"Head to Shadowmoon Valley and speak with Earthmender Splinthoof", 10681},
			10458,10480,10481,
			{10513},10514,10515,10519,--10884,
			{10521},10522,10523,
			{10527},10528,10537,10540,10541,
			{10546},10547,10550,10570,10576,10577,10578,10579,
			{10588},
			{"Speak with Khadgar in Shattrath City", 10883},
			
			{10884,"i1540",
			"• Defeat the first boss, Grand Warlock Nethekurse",
			"• Starting the \"Gauntlet of fire\" event starts a 55 minute timer",
			" * After 55 minutes the Executioner kills the first prisoner",
			" * After another 10 minutes the Executioner kills the second prisoner",
			" * After another 15 minutes the Executioner kills the third prisoner",
			"• Kill the Executioner at the end within the total 80 minutes",
			"• Loot |cffffffff|Hitem:31716:::::::::::::|h[Unused Axe of the Executioner]|h|r"},
			{10885,"i1545",
			"• Kill the final boss, Warlord Kalithresh",
			"• Loot |cffffffff|Hitem:31721|h[Kalithresh's Trident]|h|r",
			"i1555",
			"• Kill the final boss, Murmur",
			"• Loot |cffffffff|Hitem:31722|h[Murmur's Essence]|h|r"},
			{10886,"i1552",
			"• Engage the final boss, Harbinger Skyriss",
			"• Ensure Millhouse Manastorm survives"},
			{10888,"i2544",
			"• Kill Magtheridon and return to A'dal in Shattrath",
			"• Receive |cffffffff|Hitem:31704|h[The Tempest Key!]|h|r"},
		},
	},
	
	[ 548 ] = { -- ssc
		check = { quest = 10901 },
		requirements = { dungeons={{547,1},{565,0},{532,0}} },
		chain = {
			{"i1547","• Kill the first boss, Mennu the Betrayer",
			"• Run up the ramp, jump in the water, clear mobs on the left",
			"• Find Skar'this the Heretic inside a cage",10900},
			{10901,"i2565","• Kill the last boss, Grull the Dragonkiller",
			"• Loot |cffffffff|Hitem:31750|h[Earthen Signet]|h|r",
			"i2532","|cFFFF5E13--- Someone in your raid needs to be able to summon Nightbane ---|r",
			"• Kill Nightbane and loot |cffffffff|Hitem:31751|h[Blazing Signet]|h|r",
			"i1547","• Return to Skar'this the Heretic"},
		}
	},
}

Reputable.interchangableQuests = {
	-- Netherstorm
	[10299] = 10329,	[10329] = 10299,
	[10321] = 10330,	[10330] = 10321,
	[10322] = 10338,	[10338] = 10322,
	[10323] = 10365,	[10365] = 10323,
	[10407] = 10508,	[10508] = 10407,
	[10409] = 10507,	[10507] = 10409,	--	Deathblow to the Legion / Turning Point
	-- SMV
	[10568] = 10683,	[10683] = 10568,
	[10571] = 10684,	[10684] = 10571,
	[10574] = 10685,	[10685] = 10574,
	[10575] = 10686,	[10686] = 10575,
	[10619] = 10807,	[10807] = 10619,
	[10816] = 10817,	[10817] = 10816,
	[10587] = 10687,	[10687] = 10587,
	[10637] = 10688,	[10688] = 10637,
	[10640] = 10689,	[10689] = 10640,
	[10650] = 10691,	[10691] = 10650,
	[10651] = 10692,	[10692] = 10651,
	
	[11099] = 11094,	[11094] = 11099,
	[11100] = 11095,	[11095] = 11100,
}

Reputable.membershipBenefits = {
	[9886] = true,
	[9884] = true,
	[9885] = true,
	[9887] = true,
}

Reputable.brewfestBarks = { [11293] = true, [11294] = true, [11407] = true, [11408] = true }
Reputable.dailyInfo = {
	-- wrath
	[13240] = { instanceID = 578, normalWotlk = true, rep = {1090,75 } },
	[13241] = { instanceID = 575, normalWotlk = true, rep = {1090,75 } },
	[13243] = { instanceID = 595, normalWotlk = true, rep = {1090,75 } },
	[13244] = { instanceID = 602, normalWotlk = true, rep = {1090,75 } },
	[13190] = { instanceID = 619, heroicWotlk = true },
	[14199] = { instanceID = 650, heroicWotlk = true, rep = {1090,75 } },
	[13245] = { instanceID = 574, heroicWotlk = true, rep = {1090,75 } },
	[13246] = { instanceID = 576, heroicWotlk = true, rep = {1090,75 } },
	[13247] = { instanceID = 578, heroicWotlk = true, rep = {1090,75 } },
	[13248] = { instanceID = 575, heroicWotlk = true, rep = {1090,75 } },
	[13249] = { instanceID = 600, heroicWotlk = true, rep = {1090,75 } },
	[13250] = { instanceID = 604, heroicWotlk = true, rep = {1090,75 } },
	[13251] = { instanceID = 595, heroicWotlk = true, rep = {1090,75 } },
	[13251] = { instanceID = 599, heroicWotlk = true, rep = {1090,75 } },
	[13253] = { instanceID = 602, heroicWotlk = true, rep = {1090,75 } },
	[13254] = { instanceID = 601, heroicWotlk = true, rep = {1090,75 } },
	[13255] = { instanceID = 619, heroicWotlk = true, rep = {1090,75 } },
	[13256] = { instanceID = 608, heroicWotlk = true, rep = {1090,75 } },

	[11500] = { instanceID = 585, normal = true, rep = {933,250,1077,250 } },
	[11383] = { instanceID = 269, normal = true, rep = {933,250,989,250 } },
	[11376] = { instanceID = 555, normal = true, rep = {933,250,1011,250 } },
	[11364] = { instanceID = 540, normal = true, rep = { Alliance = {933,250,946,250}, Horde = {933,250,947,250} } },
	[11387] = { instanceID = 554, normal = true, rep = {933,250,935,250 } },
	[11371] = { instanceID = 545, normal = true, rep = {933,250,942,250 } },
	[11385] = { instanceID = 553, normal = true, rep = {933,250,935,250 } },
	[11389] = { instanceID = 552, normal = true, rep = {933,250,935,250 } },
	[11499] = { instanceID = 585, heroic = true, rep = {933,250,1077,250 } },
	[11388] = { instanceID = 552, heroic = true, rep = {933,350,935,350 } },
	[11386] = { instanceID = 554, heroic = true, rep = {933,350,935,350 } },
	[11384] = { instanceID = 553, heroic = true, rep = {933,350,935,350 } },
	[11354] = { instanceID = 543, heroic = true, rep = { Alliance = {933,350,946,350}, Horde = {933,350,947,350} } },
	[11362] = { instanceID = 542, heroic = true, rep = { Alliance = {933,350,946,350}, Horde = {933,350,947,350} } },
	[11363] = { instanceID = 540, heroic = true, rep = { Alliance = {933,350,946,350}, Horde = {933,350,947,350} } },
	[11370] = { instanceID = 545, heroic = true, rep = {933,350,942,350 } },
	[11368] = { instanceID = 547, heroic = true, rep = {933,350,942,350 } },
	[11369] = { instanceID = 546, heroic = true, rep = {933,350,942,350 } },
	[11378] = { instanceID = 560, heroic = true, rep = {933,350,989,350 } },
	[11382] = { instanceID = 269, heroic = true, rep = {933,350,989,350 } },
	[11372] = { instanceID = 556, heroic = true, rep = {933,350,1011,350 } },
	[11374] = { instanceID = 558, heroic = true, rep = {933,350,1011,350 } },
	[11373] = { instanceID = 557, heroic = true, rep = {933,500 } },
	[11375] = { instanceID = 555, heroic = true, rep = {933,350,1011,350 } },
	-- Cooking Dailies
	[11380] = { cooking = true },
	[11377] = { cooking = true },
	[11381] = { cooking = true },
	[11379] = { cooking = true },
	
	-- Fishing Dailies
	[11665] = { fishing = true },
	[11669] = { fishing = true },
	[11668] = { fishing = true },
	[11666] = { fishing = true },
	[11667] = { fishing = true },
	
	-- Wotlk Fishing Dailies
	[13836] = { fishingWotlk = true },
	[13833] = { fishingWotlk = true },
	[13830] = { fishingWotlk = true },
	[13834] = { fishingWotlk = true },
	[13832] = { fishingWotlk = true },
	
	-- Wotlk Cooking Dailies Horde
	[13115] = { cookingWotlk = true },
	[13113] = { cookingWotlk = true },
	[13112] = { cookingWotlk = true },
	[13116] = { cookingWotlk = true },
	[13114] = { cookingWotlk = true },
	
	-- Wotlk Cooking Dailies Alliance
	[13103] = { cookingWotlk = true },
	[13101] = { cookingWotlk = true },
	[13100] = { cookingWotlk = true },
	[13107] = { cookingWotlk = true },
	[13102] = { cookingWotlk = true },
	
	-- PvP Dailies
	[11335] = { pvp = true, Horde    = 11339 },	-- AB
	[11339] = { pvp = true, Alliance = 11335 },	-- AB
	[11336] = { pvp = true, Horde    = 11340 },	-- AV
	[11340] = { pvp = true, Alliance = 11336 },	-- AV
	[11337] = { pvp = true, Horde    = 11341 },	-- EotS
	[11341] = { pvp = true, Alliance = 11337 },	-- EotS
	[11338] = { pvp = true, Horde    = 11342 },	-- WSG
	[11342] = { pvp = true, Alliance = 11338 },	-- WSG
	
}
--Reputable.dailyDungeonNames = {}
Reputable.dailyInfoNames = {}
--Reputable.dailyCooking = {
--	[11380] = {  },
--	[11377] = {  },
--	[11381] = {  },
--	[11379] = {  },
--}
--Reputable.dailyCookingNames = {}

Reputable.factionStandingColours = {
	"|cffcc2222",	-- Hated
	"|cffff0000",	-- Hostile
	"|cffee6622",	-- Unfriendly
	"|cffffff00",	-- Neutral
	"|cff00ff00",	-- Friendly
	"|cff00ff88",	-- Honored
	"|cff00ffcc",	-- Revered
	"|cff00ffff",	-- Exalted
}

Reputable.factionStandingMax = {
	36000,	-- Hated
	3000,	-- Hostile
	3000,	-- Unfriendly
	3000,	-- Neutral
	6000,	-- Friendly
	12000,	-- Honored
	21000,	-- Revered
	999,	-- Exalted
}

Reputable.factionInt = { Alliance = 1, Horde = 2 }
Reputable.notFactionInt = { Alliance = 2, Horde = 1 }

Reputable.dailyChangeOffset = {
	[ 10 ] = 7,		-- AEST
	[ 11 ] = 7,		-- AEDT
	[ -7 ] = 0,		-- PDT
	[ -8 ] = 0,		-- PST
	[ -4 ] = 22,	-- EDT
	[ -5 ] = 22,	-- EST
}

Reputable.guiCats = {
	--[ 1 ] = { name = "events", label = BATTLE_PET_SOURCE_7 },
	[ 1 ] = { name = "dungeons", label = DUNGEONS },	
	[ 2 ] = { name = "reputations", label = REPUTATION.." Wotlk" },
	[ 3 ] = { name = "reputationsTBC", label = EXPANSION_NAME1.." "..REPUTATION },
	[ 4 ] = { name = "reputationsClassic", label = EXPANSION_NAME0.." (Unsorted)" },
	[ 5 ] = { name = "events", label = BATTLE_PET_SOURCE_7 },
	[ 6 ] = { name = "attunementsTBC", label = EXPANSION_NAME0.." Attunements" },
}

Reputable.guiTabs = {
	--{ name = "midsummer",	title = "Midsummer Fire Festival",	label = "Midsummer Fire Festival", cat = 5 },

		--{ name = "events",	title = "Brewfest",	label = "Brewfest", cat = 5 },
	--{ name = "HallowsEnd",	title = "Hallow's End",	label = "Hallow's End", cat = 5 },
	{ name = "dungeonsWotlk",	title = EXPANSION_NAME2 .. " " .. DUNGEONS, 	label = EXPANSION_NAME2, cat = 1 },
	{ name = "dungeons",	title = EXPANSION_NAME1 .. " " .. DUNGEONS, 	label = EXPANSION_NAME1, cat = 1 },
	{ name = "dailies", 	title = ALL.." "..DAILY.." "..QUESTS_LABEL, label = ALL.." "..DAILY.." "..QUESTS_LABEL, cat = 2 },
	--{ name = "reputations",	title = REPUTATION.." " ..EXPANSION_NAME2, 	label = EXPANSION_NAME2, cat = 2 },
	--{ name = "reputations",	title = REPUTATION.." " ..EXPANSION_NAME1, 	label = EXPANSION_NAME2, cat = 2 },
	--{ name = "attunementsTBC",	title = EXPANSION_NAME1.." Attunements", 	label = EXPANSION_NAME1, cat = 6 },
	
	--{ faction = 1090, cat = 3 }, --kirin tor
	
	-- { instance = 532 },
	-- { instance = "Nightbane" },
	-- { instance = 555 },
	-- { instance = 552 },
	-- { instance = 269 },
	-- { instance = 540 },
	-- { instance = 550 },
	-- { instance = 548 },
	--{ instance = 249, cat = 6 }, -- testing (ony)
	--{ faction =  529 }, -- testing argentdawn
	--{ faction =  69, cat = 6 }, -- testing darnassus
}
