#include "script/common.lua"
#include "missions.lua"
#include "messages.lua"
#include "challenges.lua"
#include "tools.lua"
#include "activities.lua"

------------------------------------------------------------------------------
-- Levels
------------------------------------------------------------------------------

gLevels = {}
gLevels["lee"] =
{
	map_title = "LVL_MAP_TITLE_LEE_CHEMICALS",
	map_x = 1448,
	map_y = 624,
	title = "loc@LVL_MAP_TITLE_LEE_CHEMICALS",
	image = "terminal/level/lee.png",
	desc = "loc@LVL_DESC_LEE_CHEMICALS",
}

gLevels["marina"] =
{
	map_title = "LVL_MAP_TITLE_WEST_POINT_MARINA",
	map_x = 273,
	map_y = 618,
	title = "loc@LVL_TITLE_WEST_POINT_MARINA",
	image = "terminal/level/marina.png",
	desc = "loc@LVL_DESC_WEST_POINT_MARINA",
}

gLevels["mansion"] =
{
	map_title = "LVL_MAP_TITLE_VILLA_GORDON",
	map_x = 814,
	map_y = 321,
	title = "loc@LVL_TITLE_VILLA_GORDON",
	image = "terminal/level/mansion.png",
	desc = "loc@LVL_DESC_VILLA_GORDON",
}

gLevels["caveisland"] =
{
	map_title = "LVL_MAP_TITLE_HOLLOWROCK_ISLAND",
	map_x = 359,
	map_y = 883,
	title = "loc@LVL_TITLE_HOLLOWROCK_ISLAND",
	image = "terminal/level/caveisland.png",
	desc = "loc@LVL_DESC_HOLLOWROCK_ISLAND",
}

gLevels["mall"] =
{
	map_title = "LVL_MAP_TITLE_EVERTIDES_MALL",
	map_x = 472,
	map_y = 342,
	title = "loc@LVL_TITLE_THE_EVERTIDES_MALL",
	image = "terminal/level/mall.png",
	desc = "loc@LVL_DESC_THE_EVERTIDES_MALL",
}

gLevels["frustrum"] =
{
	map_title = "LVL_MAP_TITLE_FRUSTRUM",
	map_x = 1160,
	map_y = 562,
	title = "loc@LVL_TITLE_FRUSTRUM",
	image = "terminal/level/frustrum.png",
	desc = "loc@LVL_DESC_FRUSTRUM",
}

gLevels["factory"] =
{
	map_title = "LVL_MAP_TITLE_QUILEZ_SECURITY",
	map_x = 1129,
	map_y = 190,
	title = "loc@LVL_TITLE_QUILEZ_SECURITY",
	image = "terminal/level/factory.png",
	desc = "loc@LVL_DESC_QUILEZ_SECURITY",
}

gLevels["carib"] =
{
	map_title = "LVL_MAP_TITLE_ISLA_ESTOCASTICA",
	map_x = 1770,
	map_y = 830,
	title = "loc@LVL_TITLE_ISLA_ESTOCASTICA",
	image = "terminal/level/carib.png",
	desc = "loc@LVL_DESC_ISLA_ESTOCASTICA",
}

gLevels["cullington"] =
{
	map_title = "LVL_MAP_TITLE_CULLINGTON",
	map_x = 910,
	map_y = 820,
	title = "loc@LVL_TITLE_CULLINGTON",
	image = "terminal/level/cullington.png",
	desc = "loc@LVL_DESC_CULLINGTON",
}


------------------------------------------------------------------------------
-- Clients
------------------------------------------------------------------------------

gClients = {}
gClients["tracy"]=
{
	name = "loc@CLIENT_NAME_TRACY",
	image = "terminal/client/tracy.png"
}

gClients["parisa"]=
{
	name = "loc@CLIENT_NAME_PARISA_TERDIMAN",
	image = "terminal/client/parisa.png"
}

gClients["gordon"]=
{
	name = "loc@CLIENT_NAME_GORDON_WOO",
	image = "terminal/client/gordon.png"
}

gClients["lee"]=
{
	name = "loc@CLIENT_NAME_LAWRENCE_LEE_JUNIOR",
	image = "terminal/client/lee.png"
}

gClients["gjk"]=
{
	name = "loc@CLIENT_NAME_GILLIAN_JOHNSON",
	image = "terminal/client/gillian.png"
}

gClients["wlf"]=
{
	name = "loc@CLIENT_NAME_ANTON_WOLFE",
	image = "terminal/client/wlf.png"
}

gClients["lcc"]=
{
	name = "loc@CLIENT_NAME_LCKELLE_CITY_COUNCIL",
	image = "terminal/client/lcc.png"
}

gClients["tuxedolabs"]=
{
	name = "loc@CLIENT_NAME_TUXEDO_LABS",
	image = "terminal/client/tuxedolabs.png"
}

gClients["amanatides"]=
{
	name = "loc@CLIENT_NAME_AMANATIDES",
	image = "terminal/client/amanatides.png"
}

gClients["elena"]=
{
	name = "loc@CLIENT_NAME_ELENA_FERNNDEZ",
	image = "terminal/client/elena.png"
}

gClients["penitentiary"]=
{
	name = "loc@CLIENT_NAME_LCKELLE_STATE_PENITENTIARY",
	image = "terminal/client/penitentiary.png"
}

------------------------------------------------------------------------------
-- Ranks
------------------------------------------------------------------------------

gRanks =
{
	{score=0, name="loc@RANK_NAME_DEMOLISHER"},
	{score=5, name="loc@RANK_NAME_AMATEUR", tool="blowtorch"},
	{score=10, name="loc@RANK_NAME_NOVICE", tool="shotgun"},
	{score=15, name="loc@RANK_NAME_TRESPASSER", tool="plank"},
	{score=20, name="loc@RANK_NAME_BREAKER", tool="pipebomb"},
	{score=30, name="loc@RANK_NAME_CROOK", tool="gun"},
	{score=40, name="loc@RANK_NAME_WRECKER", tool="bomb"},
	{score=50, name="loc@RANK_NAME_TALENTED", tool="wire"},
	{score=60, name="loc@RANK_NAME_BALLISTIC", tool="rocket"},
	{score=70, name="loc@RANK_NAME_CRACKERJACK", tool="leafblower"},
	{score=80, name="loc@RANK_NAME_PROFESSIONAL", tool="booster"},
	{score=90, name="loc@RANK_NAME_MIDNIGHTER", tool="turbo"},
	{score=100, name="loc@RANK_NAME_EXPERT", tool="explosive"},
	{score=110, name="loc@RANK_NAME_TOP_DOG", tool="rifle"},
	{score=120, name="loc@RANK_NAME_HOT_SHOT", tool="steroid"},
	{score=130, name="loc@RANK_NAME_GENIUS", cash=1000},
	{score=140, name="loc@RANK_NAME_SAVANT", cash=2000},
	{score=160, name="loc@RANK_NAME_GURU", cash=3000},
	{score=180, name="loc@RANK_NAME_MASTERMIND", cash=4000},
	{score=200, name="loc@RANK_NAME_VIRTUOSO", cash=5000},
}


------------------------------------------------------------------------------
-- Sandbox levels
------------------------------------------------------------------------------

gSandbox = 
{		
	{ id="lee_sandbox", level="lee", name="loc@SANDBOX_NAME_LEE_CHEMICALS", image="menu/level/lee.png", file="lee.xml", layers="sandbox"},
	{ id="marina_sandbox", level="marina", name="loc@SANDBOX_NAME_MARINA", image="menu/level/marina.png", file="marina.xml", layers="sandbox"},
	{ id="mansion_sandbox", level="mansion", name="loc@SANDBOX_NAME_VILLA_GORDON", image="menu/level/mansion.png", file="mansion.xml", layers="sandbox"},
	{ id="caveisland_sandbox", level="caveisland", name="loc@SANDBOX_NAME_HOLLOWROCK", image="menu/level/caveisland.png", file="caveisland.xml", layers="sandbox"},
	{ id="mall_sandbox", level="mall", name="loc@SANDBOX_NAME_EVERTIDES", image="menu/level/mall.png", file="mall.xml", layers="sandbox"},
	{ id="frustrum_sandbox", level="frustrum", name="loc@SANDBOX_NAME_FRUSTRUM", image="menu/level/frustrum.png", file="frustrum.xml", layers="sandbox"},
	{ id="hub_carib_sandbox", level="hub_carib", name="loc@SANDBOX_NAME_MURATORI_BEACH", image="menu/level/hub_carib.png", file="hub_carib.xml", layers="sandbox"},
	{ id="carib_sandbox", level="carib", name="loc@SANDBOX_NAME_ISLA_ESTOCASTICA", image="menu/level/carib.png", file="carib.xml", layers="sandbox"},
	{ id="factory_sandbox", level="factory", name="loc@SANDBOX_NAME_QUILEZ_SECURITY", image="menu/level/factory.png", file="factory.xml", layers="sandbox"},
	{ id="cullington_sandbox", level="cullington", name="loc@SANDBOX_NAME_CULLINGTON", image="menu/level/cullington.png", file="cullington.xml", layers="sandbox"},
}
	
	
------------------------------------------------------------------------------
-- Cinematic ending sequences
------------------------------------------------------------------------------

gCinematic = 
{
	ending1 = 
	{
		music = "win.ogg",
		esc = "hub",
		parts = 
		{
			{ id="ending10", file="lee.xml", layers="part1ending"},
		}
	},

	ending2 = 
	{
		music = "ending.ogg",
		esc = "menu",
		parts = 
		{
			{ id="ending20", file="hub.xml", layers="part2 part2ending"},
			{ id="ending21", file="mansion.xml", layers="part2ending"},
			{ id="ending22", file="marina.xml", layers="part2ending"},
		}
	}
}


------------------------------------------------------------------------------
-- Expansions
------------------------------------------------------------------------------

gExpansions = 
{
	{ level="dlc-artvandals", image="menu/expansion/artvandals_new.png", name="loc@TITLE_ART_VANDALS", isEmbedded = true, available=true },
	{ level="dlc-space", image="menu/expansion/space.png", name="loc@TITLE_SPACE", available=true, dlcName="Space" },
	{ level="dlc-wildwestheist", image="menu/expansion/wildwestheist.png", name="loc@TITLE_WILDWEST_HAIST", dlcName = "TimeCampers", available=true },
	{ level="dlc-folkrace", image="menu/expansion/folkrace.png", name="loc@TITLE_FOLKRACE", dlcName = "Folkrace", available=true }
	
}

gDlcs = 
{
    ["TimeCampers"] = "TITLE_WILDWEST_HAIST",
    ["Folkrace"] = "TITLE_FOLKRACE",
    ["QuilezRoller"] = "Quilez R0113R",
    ["UserMods1"] = "Mod Pack #1",
    ["UserMods2"] = "Mod Pack #2",
    ["UserMods3"] = "Mod Pack #3",
    ["UserMods4"] = "Mod Pack #4",
    ["UserMods5"] = "Mod Pack #5",
	["RelicHunters"] = "",
    ["builtin"] = "TITLE_BUILT-IN"
}

local archpath = GetString("savegame.mod.steam-3708322400.path")
--local archpath = "C:/Users/evere/OneDrive/Documents/Teardown/mods/Archipelago Randomizer/main.xml"

function getHubVersion()
	local current = 0
	if GetInt("savegame.mission.mall_intro.score") > 0 then current = 1 end
	if GetInt("savegame.mission.lee_computers.score") > 0 then current = 2 end
	if GetInt("savegame.mission.lee_login.score") > 0 then current = 3 end
	if GetInt("savegame.mission.marina_demolish.score") > 0 then current = 4 end
	if GetInt("savegame.mission.marina_cars.score") > 0 then current = 5 end
	if GetInt("savegame.mission.marina_gps.score") > 0 or GetInt("savegame.mission.mansion_pool.score") > 0 then current = 6 end
	if GetInt("savegame.mission.lee_tower.score") > 0 then current = 7 end
	if GetInt("savegame.mission.mansion_art.score") > 0 then current = 8 end
	if GetInt("savegame.mission.marina_art_back.score") > 0 then current = 9 end
	if GetInt("savegame.mission.caveisland_computers.score") > 0 then current = 10 end
	if GetInt("savegame.mission.mansion_safe.score") > 0 then current = 11 end
	if GetInt("savegame.mission.lee_powerplant.score") > 0 then current = 12 end
	if GetInt("savegame.mission.caveisland_dishes.score") > 0 then current = 13 end
	if GetInt("savegame.mission.lee_flooding.score") > 0 then current = 15 end
	if GetInt("savegame.mission.frustrum_chase.score") > 0 then current = 16 end
	
	--PART 2
	if GetInt("savegame.mission.frustrum_chase.score") > 0 then current = 20 end
	if GetInt("savegame.mission.factory_espionage.score") > 0 then current = 21 end
	if GetInt("savegame.mission.caveisland_ingredients.score") > 0 then current = 22 end
	if GetInt("savegame.mission.frustrum_tornado.score") > 0 then current = 23 end
	if GetInt("savegame.mission.mall_shipping.score") > 0 then current = 24 end

	--Carib	
	if GetInt("savegame.message.carib_alarm") > 0 then current = 31 end
	if GetInt("savegame.mission.carib_alarm.score") > 0 then current = 32 end
	if GetInt("savegame.mission.carib_barrels.score") > 0 then current = 33 end
	if GetInt("savegame.mission.carib_destroy.score") > 0 then current = 34 end

	--Back in lockelle
	if GetInt("savegame.message.frustrum_vehicle") > 0 then current = 40 end
	if GetInt("savegame.mission.frustrum_vehicle.score") > 0 then current = 41 end
	if GetInt("savegame.mission.mall_radiolink.score") > 0 then current = 42 end
	if GetInt("savegame.mission.factory_robot.score") > 0 then current = 43 end
	if GetInt("savegame.mission.factory_explosive.score") > 0 then current = 44 end
	if GetInt("savegame.mission.caveisland_roboclear.score") > 0 then current = 45 end
	if GetInt("savegame.mission.cullington_bomb.score") > 0 then current = 46 end

	return current
end

function saveAndStartLevel(mission, title, image, path, layers, passThrough)
	SetString("game.lobby.level.mission", mission)
	SetString("game.lobby.level.title", title)
	SetString("game.lobby.level.image", image)
	SetString("game.lobby.level.path", path)
	SetString("game.lobby.level.layers", layers)
	SetBool("game.lobby.level.pass", passThrough)
	StartLevel(mission, path, layers, passThrough)
end

function saveAndStartModLevel(mod, layers)
	SetString("game.lobby.level.mod", mod)
	SetString("game.lobby.level.layers", layers)
	Command("mods.play", mod, layers)
end

function saveAndStartModLevelWithGameMode(mod, layers, gameMode)
	local mission = gameMode
	SetString("game.lobby.level.mission", mission)
	SetString("game.lobby.level.layers", layers)
	Command("mods.play", mod, layers, mission, gameMode)
end

function startHub()
	local enabled = GetInt("options.game.archipelago.enabled")
	local v = getHubVersion()
	if enabled == 0 then
		saveAndStartLevel("hub", "-", "", "RAW:" ..archpath, "")
	else
		if v >= 30 and v < 39 then
			saveAndStartLevel("hub"..v, "-", "", "hub_carib.xml", "v"..v)
		else
			if v < 20 then
				saveAndStartLevel("hub"..v, "-", "", "hub.xml", "part1 v"..v)
			else
				saveAndStartLevel("hub"..v, "-", "", "hub.xml", "part2 v"..v)
			end
		end
	end
end

function skipMission(id)
	local enabled = GetInt("options.game.archipelago.enabled")
	if gMissions[id] then
		if enabled == 0 then
			SetString("savegame.lastcompleted", id)
		else
			SetInt("savegame.mission."..id..".score", gMissions[id].required)
			SetString("savegame.lastcompleted", id)
			syncActivities(id, false, true)
		end
	end
end

function isInMission()
	local modId = GetString("game.mod")
	local missionId = GetString("game.levelid")

	return modId == "" and (missionId == "" or gMissions[missionId])
end	

function exitMission()
	if isInMission() then
		startHub()
	else
		Menu()
	end
end

function startCinematic(cinematic, noLoadingScreen)
	local c = gCinematic[cinematic].parts[1]
	saveAndStartLevel(c.id, "-", "", c.file, c.layers, noLoadingScreen)
end

function isLevelUnlocked(level)
	local enabled = GetInt("options.game.archipelago.enabled")
	if enabled == 0 then
		local missions = ListKeys("savegame.mod.steam-3708322400.mission")
		for i=1,#missions do
			local missionId = missions[i]
			if gMissions[missionId] and GetBool("savegame.mod.steam-3708322400.mission."..missionId) then
				if missionId ~= "mall_intro" and missionId ~= "factory_espionage" and gMissions[missionId].level == level then
					return true
				end
			end
		end
		return false
	else
		local missions = ListKeys("savegame.mission")
		for i=1,#missions do
			local missionId = missions[i]
			if gMissions[missionId] and GetBool("savegame.mission."..missionId) then
				if missionId ~= "mall_intro" and missionId ~= "factory_espionage" and gMissions[missionId].level == level then
					return true
				end
			end
		end
		return false
	end
end

function getLevelScore(levelId)
	local enabled = GetInt("options.game.archipelago.enabled")
	local score = 0
	for id,mission in pairs(gMissions) do
		if enabled == 0 then
			if mission.level == levelId then
				score = score + GetInt("savegame.mod.steam-3708322400.mission."..id..".score")
			end
		else
			if mission.level == levelId then
				score = score + GetInt("savegame.mission."..id..".score")
			end
		end
	end
	return score
end

function getScoreDetails(id, score, missionList)
	local missions = missionList or gMissions
	local mission = missions[id];

	local details = {}
	details.required = mission.required
	details.optional = mission.primary + mission.secondary - mission.required

	if score >= mission.required then
		details.requiredTaken = mission.required
	else
		details.requiredTaken = score
	end

	details.optionalTaken = clamp(score - mission.required, 0, mission.primary + mission.secondary - mission.required)

	details.bonuses = 0
	details.bonusesTaken = 0
	details.bonus = {}
	local s = mission.primary + mission.secondary
	for i=1, #mission.bonus do
		local t = mission.bonus[i]

		if score >= s then
			details.bonuses = details.bonuses + 1
			details.bonus[i] = {}
			details.bonus[i].desc = GetTranslatedStringByKey("TXT_SCORE_SECONDS_LEFT," .. t)
			if score > s then
				details.bonus[i].score = 1
				details.bonusesTaken = details.bonusesTaken + 1
			else
				details.bonus[i].score = 0
			end
		end
		s = s + 1
	end

	return details
end
