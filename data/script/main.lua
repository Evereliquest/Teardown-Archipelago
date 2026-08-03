#version 2 

#include "common.lua"
#include "game.lua"
#include "script/toolutilities.lua"
#include "script/include/player.lua"

pDisableTools = GetBoolParam("disabletools", false)
pBaseTools = GetBoolParam("basetools", false)
gCustomToolsChecked = false

valuableSound = nil
allToolsCheck = nil

function server.init()
	local enabled = GetInt("options.game.archipelago.enabled")
	local levelId = GetString("game.levelid")


	if enabled == 0 then
		if GetInt("savegame.mod.steam-3708322400.tool.sledge.enabled") == 1 then
			SetBool("game.tool.sledge.enabled", true)
		else
			SetBool("game.tool.sledge.enabled", false)
			SetBool("game.tool.sledge.selectable", false)
		end

		if GetInt("savegame.mod.steam-3708322400.tool.spraycan.enabled") == 1 then
			SetBool("game.tool.spraycan.enabled", true)
		else
			SetBool("game.tool.spraycan.enabled", false)
			SetBool("game.tool.spraycan.selectable", false)
		end

		if GetInt("savegame.mod.steam-3708322400.tool.extinguisher.enabled") == 1 then
			SetBool("game.tool.extinguisher.enabled", true)
		else
			SetBool("game.tool.extinguisher.enabled", false)
			SetBool("game.tool.extinguisher.selectable", false)
		end

		--- Regular Tools
		if GetInt("savegame.mod.steam-3708322400.tool.blowtorch.enabled") == 1 then
			SetBool("game.tool.blowtorch.enabled", true)
			SetInt("game.tool.blowtorch.ammo", GetInt("savegame.mod.steam-3708322400.tool.blowtorch.ammo"))
		end

		if GetInt("savegame.mod.steam-3708322400.tool.shotgun.enabled") == 1 then
			SetBool("game.tool.shotgun.enabled", true)
			SetInt("game.tool.shotgun.ammo", GetInt("savegame.mod.steam-3708322400.tool.shotgun.ammo"))
			SetInt("game.tool.shotgun.range", GetInt("savegame.mod.steam-3708322400.tool.shotgun.range"))
			SetInt("game.tool.shotgun.damage", GetInt("savegame.mod.steam-3708322400.tool.shotgun.damage"))
		end

		if GetInt("savegame.mod.steam-3708322400.tool.plank.enabled") == 1 then
			SetBool("game.tool.plank.enabled", true)
			SetInt("game.tool.plank.ammo", GetInt("savegame.mod.steam-3708322400.tool.plank.ammo"))
			SetInt("game.tool.plank.width", GetInt("savegame.mod.steam-3708322400.tool.plank.width"))
			SetInt("game.tool.plank.length", GetInt("savegame.mod.steam-3708322400.tool.plank.length"))
		end

		if GetInt("savegame.mod.steam-3708322400.tool.pipebomb.enabled") == 1 then
			SetBool("game.tool.pipebomb.enabled", true)
			SetInt("game.tool.pipebomb.ammo", GetInt("savegame.mod.steam-3708322400.tool.pipebomb.ammo"))
			SetInt("game.tool.pipebomb.damage", GetInt("savegame.mod.steam-3708322400.tool.pipebomb.damage"))
		end

		if GetInt("savegame.mod.steam-3708322400.tool.gun.enabled") == 1 then
			SetBool("game.tool.gun.enabled", true)
			SetInt("game.tool.gun.ammo", GetInt("savegame.mod.steam-3708322400.tool.gun.ammo"))
			SetInt("game.tool.gun.range", GetInt("savegame.mod.steam-3708322400.tool.gun.range"))
			SetInt("game.tool.gun.damage", GetInt("savegame.mod.steam-3708322400.tool.gun.damage"))
		end

		if GetInt("savegame.mod.steam-3708322400.tool.bomb.enabled") == 1 then
			SetBool("game.tool.bomb.enabled", true)
			SetInt("game.tool.bomb.ammo", GetInt("savegame.mod.steam-3708322400.tool.bomb.ammo"))
			SetInt("game.tool.bomb.damage", GetInt("savegame.mod.steam-3708322400.tool.bomb.damage"))
		end

		if GetInt("savegame.mod.steam-3708322400.tool.rocket.enabled") == 1 then
			SetBool("game.tool.rocket.enabled", true)
			SetInt("game.tool.rocket.ammo", GetInt("savegame.mod.steam-3708322400.tool.rocket.ammo"))
			SetInt("game.tool.rocket.damage", GetInt("savegame.mod.steam-3708322400.tool.rocket.damage"))
		end

		if GetInt("savegame.mod.steam-3708322400.tool.booster.enabled") == 1 then
			SetBool("game.tool.booster.enabled", true)
			SetInt("game.tool.booster.ammo", GetInt("savegame.mod.steam-3708322400.tool.booster.ammo"))
			SetInt("game.tool.booster.power", GetInt("savegame.mod.steam-3708322400.tool.booster.power"))
			SetInt("game.tool.booster.time", GetInt("savegame.mod.steam-3708322400.tool.booster.time"))
		end

		if GetInt("savegame.mod.steam-3708322400.tool.leafblower.enabled") == 1 then
			SetBool("game.tool.leafblower.enabled", true)
			SetInt("game.tool.leafblower.power", GetInt("savegame.mod.steam-3708322400.tool.leafblower.power"))
		end

		if GetInt("savegame.mod.steam-3708322400.tool.wire.enabled") == 1 then
			SetBool("game.tool.wire.enabled", true)
			SetInt("game.tool.wire.ammo", GetInt("savegame.mod.steam-3708322400.tool.wire.ammo"))
			SetInt("game.tool.wire.stretch", GetInt("savegame.mod.steam-3708322400.tool.stretch.power"))
		end

		if GetInt("savegame.mod.steam-3708322400.tool.turbo.enabled") == 1 then
			SetBool("game.tool.turbo.enabled", true)
			SetInt("game.tool.turbo.ammo", GetInt("savegame.mod.steam-3708322400.tool.turbo.ammo"))
			SetInt("game.tool.turbo.power", GetInt("savegame.mod.steam-3708322400.tool.turbo.power"))
		end

		if GetInt("savegame.mod.steam-3708322400.tool.explosive.enabled") == 1 then
			SetBool("game.tool.explosive.enabled", true)
			SetInt("game.tool.explosive.ammo", GetInt("savegame.mod.steam-3708322400.tool.explosive.ammo"))
			SetInt("game.tool.explosive.damage", GetInt("savegame.mod.steam-3708322400.tool.explosive.damage"))
		end

		if GetInt("savegame.mod.steam-3708322400.tool.rifle.enabled") == 1 then
			SetBool("game.tool.rifle.enabled", true)
			SetInt("game.tool.rifle.ammo", GetInt("savegame.mod.steam-3708322400.tool.rifle.ammo"))
		end

		if GetInt("savegame.mod.steam-3708322400.tool.steroid.enabled") == 1 then
			SetBool("game.tool.steroid.enabled", true)
			SetInt("game.tool.steroid.ammo", GetInt("savegame.mod.steam-3708322400.tool.steroid.ammo"))
			SetInt("game.tool.steroid.time", GetInt("savegame.mod.steam-3708322400.tool.steroid.time"))
		end
	end





	shared.enableValuables = not string.find(levelId, "sandbox") and not string.find(levelId, "ch_")
	initValuables()

	--Check if playing campaign level
	local id = GetString("game.levelid")
	local isMod = HasKey("game.mod")
	local campaign = gMissions[id] ~= nil or (string.sub(id, 1, 3) == "hub" and not isMod and not string.find(id, "sandbox"))
	if campaign then
		SetString("game.quicksavename", "quicksavecampaign")
	else
		SetString("game.quicksavename", "quicksave")
	end

	if gMissions[id] then
		SetInt("level.missionsScoreSum", getLevelScore(gMissions[id].level))
	end
	syncActivities(id, true, false)
	---syncModActivities()
	if isMod then
		local modId = GetString("game.mod")
		if modId == "dlc-artvandals" then
			SetPresence("dlc_artvandals")
		else
			SetPresence("mod")
		end
	else
		SetPresence(id)
	end

	server.defaultTools = {}
	if pBaseTools then
		server.defaultTools["sledge"] = { enabled = true }
		server.defaultTools["spraycan"] = { enabled = true }
		server.defaultTools["extinguisher"] = { enabled = true }
	else
		if not pDisableTools then
			local isCampaign = gMissions[id] ~= nil or (string.sub(id, 1, 3) == "hub")

			if isCampaign or not IsMultiplayer() then
				server.defaultTools = setupToolsAmmoScaling(gTools, gMissions, false)
			else
				server.defaultTools = setupToolsUpgradedFully()
			end
		end
	end
end

function server.setDefaultToolsForPlayer(player)
	for toolId,preset in pairs(server.defaultTools) do
		SetToolEnabled(toolId, preset.enabled, player)
		if preset.enabled and preset.ammo then
			SetToolAmmo(toolId, preset.ammo, player)
		end
	end
end

function server.handleCommand(cmd)
	if cmd == "quickload" then
		--After quickload, make sure valuables are consistent with savegame
		initValuables()
	end
end

function initValuables()
	local enabled = GetInt("options.game.archipelago.enabled")
	if shared.enableValuables then
		valuables = FindBodies("valuable", true)
		local valueMin = 10000
		local valueMax = 0
		local valueTotal = 0
		for i=1,#valuables do
			local id = GetTagValue(valuables[i], "valuable")
			local v = tonumber(GetTagValue(valuables[i], "value"))
			valueMin = math.min(valueMin, v)
			valueMax = math.max(valueMax, v)
			valueTotal = valueTotal + v
			if enabled == 0 then
				if GetBool("savegame.mod.steam-3708322400.valuable."..id) then
					if id ~= "hub_banana" then
						Delete(valuables[i])
					end
				end
			else
				if GetBool("savegame.valuable."..id) then
					Delete(valuables[i])
				end
			end
		end
		--print(#valuables .. " valuables worth $" .. valueTotal ..  " ($" .. valueMin .. "-$" .. valueMax .. ")")
		valuables = FindBodies("valuable", true)
		for i=1,#valuables do
			SetTag(valuables[i], "interact", "loc@GRAB_VALUABLE")
		end
	else
		local v = FindBodies("valuable", true)
		for i=1,#v do
			RemoveTag(v[i], "valuable")
			RemoveTag(v[i], "value")
		end
	end
end

function server.tick(dt)
	for p in PlayersAdded() do
		server.setDefaultToolsForPlayer(p)
		if IsToolEnabled("sledge", p) then
			SetPlayerTool("sledge", p)
		end
		if not IsPlayerHost(p) then
			RespawnPlayer(p)
		end
	end

	--Check if we're in sandbox mode and all tools should be onlocked
	--This cannot be done in init, since we don't know the init order
	if not allToolsCheck then
		if GetBool("level.sandbox") and GetBool("level.unlimitedammo") and GetInt("options.game.sandbox.unlocktools") == 1 then
			for id,tool in pairs(gTools) do
				SetBool("game.tool."..id..".enabled", true, true)
			end
		end
		allToolsCheck = true
	end

	-- check custom tools on first tick after all mods inited
	if not gCustomToolsChecked then
		gCustomToolsChecked = true
		---syncCustomToolsActivities()
	end



	if GetString("game.levelpath") == "data/level/carib.xml" then
		local enabled = GetInt("options.game.archipelago.enabled")
		if enabled == 0 then

			if GetInt("savegame.mod.steam-3708322400.tool.sledge.enabled") == 1 then
				SetBool("game.tool.sledge.enabled", true)
			else
				SetBool("game.tool.sledge.enabled", false)
				SetBool("game.tool.sledge.selectable", false)
			end

			if GetInt("savegame.mod.steam-3708322400.tool.spraycan.enabled") == 1 then
				SetBool("game.tool.spraycan.enabled", true)
			else
				SetBool("game.tool.spraycan.enabled", false)
				SetBool("game.tool.spraycan.selectable", false)
			end

			if GetInt("savegame.mod.steam-3708322400.tool.extinguisher.enabled") == 1 then
				SetBool("game.tool.extinguisher.enabled", true)
			else
				SetBool("game.tool.extinguisher.enabled", false)
				SetBool("game.tool.extinguisher.selectable", false)
			end

			if GetInt("savegame.mod.steam-3708322400.tool.blowtorch.enabled") == 1 then
				SetBool("game.tool.blowtorch.enabled", true)
			end

			if GetInt("savegame.mod.steam-3708322400.tool.shotgun.enabled") == 1 then
				SetBool("game.tool.shotgun.enabled", true)
			end

			if GetInt("savegame.mod.steam-3708322400.tool.plank.enabled") == 1 then
				SetBool("game.tool.plank.enabled", true)
			end

			if GetInt("savegame.mod.steam-3708322400.tool.pipebomb.enabled") == 1 then
				SetBool("game.tool.pipebomb.enabled", true)
			end

			if GetInt("savegame.mod.steam-3708322400.tool.gun.enabled") == 1 then
				SetBool("game.tool.gun.enabled", true)
			end

			if GetInt("savegame.mod.steam-3708322400.tool.bomb.enabled") == 1 then
				SetBool("game.tool.bomb.enabled", true)
			end

			if GetInt("savegame.mod.steam-3708322400.tool.rocket.enabled") == 1 then
				SetBool("game.tool.rocket.enabled", true)
			end

			if GetInt("savegame.mod.steam-3708322400.tool.booster.enabled") == 1 then
				SetBool("game.tool.booster.enabled", true)
			end

			if GetInt("savegame.mod.steam-3708322400.tool.leafblower.enabled") == 1 then
				SetBool("game.tool.leafblower.enabled", true)
			end

			if GetInt("savegame.mod.steam-3708322400.tool.wire.enabled") == 1 then
				SetBool("game.tool.wire.enabled", true)
			end

			if GetInt("savegame.mod.steam-3708322400.tool.turbo.enabled") == 1 then
				SetBool("game.tool.turbo.enabled", true)
			end

			if GetInt("savegame.mod.steam-3708322400.tool.explosive.enabled") == 1 then
				SetBool("game.tool.explosive.enabled", true)
			end

			if GetInt("savegame.mod.steam-3708322400.tool.rifle.enabled") == 1 then
				SetBool("game.tool.rifle.enabled", true)
			end

			if GetInt("savegame.mod.steam-3708322400.tool.steroid.enabled") == 1 then
				SetBool("game.tool.steroid.enabled", true)
			end
		end
	end



	--Handle valuables
	if shared.enableValuables then
		for p in Players() do
			local interactPressed = InputPressed("interact", p)
			local interactBody = GetPlayerInteractBody(p)
			for i=1, #valuables do
				local s = valuables[i]
				if s ~= 0 and IsHandleValid(s) then
					--Remove if broken
					if IsBodyBroken(s) then
						RemoveTag(s, "valuable")
						RemoveTag(s, "interact")
						valuables[i] = 0
					end

					--Set text when language changed
					if interactBody == s then
						SetTag(s, "interact", "loc@GRAB_VALUABLE")
					end

					--Clear if interacted
					if interactBody == s and interactPressed then
						local enabled = GetInt("options.game.archipelago.enabled")
						local id = GetTagValue(s, "valuable")
						if enabled == 0 then
							SetBool("savegame.mod.steam-3708322400.valuable."..id, true);
						else
							SetBool("savegame.valuable."..id, true);
						end
						local value = tonumber(GetTagValue(s, "value"))
						if not value then value = 0 end
						if enabled == 0 then
							SetInt("savegame.mod.steam-3708322400.cash", GetInt("savegame.mod.steam-3708322400.cash") + value)
						else
							SetInt("savegame.cash", GetInt("savegame.cash") + value)
						end
						local msg = GetTranslatedStringByKey("UI_HUD_NOTE_PICKED_UP," .. GetDescription(s) .. "," .. value)
						ClientCall(0, "client.pickup", msg, p)
						Delete(s)
					end
				end
			end
		end
	end
end

----------------------------------------------------------------------------------------------------------

function client.init()
	if shared.enableValuables then
		valuables = FindBodies("valuable", true)
		valuableAlpha = {}
		valuableSound = LoadSound("valuable.ogg")
	end
end


function client.pickup(msg, p)
	if not IsPlayerLocal(p) then
		msg = GetPlayerName(p) .. " " .. msg
	end
	SetString("hud.notification", msg)
	PlaySound(valuableSound, GetCameraTransform().pos, 1.0, false)
end


function client.tick(dt)
	if shared.enableValuables then
		for p in Players() do
			for i=1, #valuables do
				local s = valuables[i]
				if s ~= 0 and IsHandleValid(s) then
					--Outline and picking info
					if IsBodyVisible(s, 6) then
						if valuableAlpha[s] == nil then
							valuableAlpha[s] = 1
						end
					else
						valuableAlpha[s] = nil
					end
					if valuableAlpha[s] then
						valuableAlpha[s] = valuableAlpha[s] - GetTimeStep()*2
						if valuableAlpha[s] > 0 then
							DrawBodyHighlight(s, valuableAlpha[s])
						end
					end
				end
			end
		end
	end
end

