#include "tools.lua"

function setToolAmmoScaling(toolId) 
	local ammoScale = 1
	local s = GetFloat("options.game.campaign.ammo")
	if s == -1 then
		ammoScale = 0
	else
		ammoScale = ammoScale + s/100
	end

	if HasKey("game.tool."..toolId..".ammo.max") then
		local value = GetInt("game.tool."..toolId..".ammo.max")					
		if ammoScale ~= 1 then
			value = math.floor(value * ammoScale)
		end
		SetInt("game.tool."..toolId..".ammo.max", value)							
		SetInt("game.tool."..toolId..".ammo", value)							

	end
end

function setupToolsAmmoScaling(toolsToSet, missions, useModProgression)
	local toolPresets = {}

	local id = GetString("game.levelid")
	local savegamePrefix = ""
	local enabled = GetInt("options.game.archipelago.enabled")
	if enabled == 0 then
		savegamePrefix = "savegame.mod.steam-3708322400"
	else
		savegamePrefix = useModProgression and "savegame.mod" or "savegame"
	end
	local isCampaign = missions[id] ~= nil or (string.sub(id, 1, 3) == "hub")

	local ammoScale = 1
	local s = GetFloat("options.game.campaign.ammo")
	if isCampaign then
		if s == -1 then
			ammoScale = 0
		else
			ammoScale = ammoScale + s/100
		end
	end

	local allToolsUnlocked = not isCampaign and GetInt("options.game.sandbox.unlocktools") == 1
	for toolId,tool in pairs(toolsToSet) do
		local saveEnabled = GetBool(savegamePrefix..".tool."..toolId..".enabled")
		if allToolsUnlocked or saveEnabled then
			SetBool("game.tool."..toolId..".enabled", true, true)
		end
		local toolEnabled = GetBool("game.tool."..toolId..".enabled")
		if toolEnabled then
			toolPresets[toolId] = { enabled = true }
			for j=1, #tool.upgrades do
				local prop = tool.upgrades[j].id
				local value = tool.upgrades[j].default
				local saved = GetInt(savegamePrefix..".tool."..toolId.."."..prop)
				if saved > value then
					value = saved 
				end
				if prop == "ammo" then
					if ammoScale ~= 1 then
						value = math.floor(value * ammoScale)
					end
					toolPresets[toolId].ammo = value
					SetInt("game.tool."..toolId..".ammo.max", value, true)
				end
				SetInt("game.tool."..toolId.."."..prop, value, true)
			end
		end
	end

	if isCampaign then
		SetFloat("game.tool.shotgun.spread", 0.075, true)
		SetFloat("game.tool.rifle.range", 1000, true)
		SetFloat("game.tool.rocket.speed", 20.0, true)
	end

	return toolPresets
end

function setupToolsUpgradedFully()
	local toolPresets = {}

	for toolId,tool in pairs(gTools) do		
		toolPresets[toolId] = { enabled = true }

		for j=1, #tool.upgrades do
			local prop = tool.upgrades[j].id
			local max = tool.upgrades[j].max
			SetInt("game.tool."..toolId.."."..prop, max, true)
			if prop == "ammo" then
				toolPresets[toolId].ammo = max
			end
		end
	end

	SetFloat("game.tool.shotgun.spread", 0.045, true)
	SetFloat("game.tool.rifle.range", 1000, true)
	SetFloat("game.tool.rocket.speed", 30.0, true)

	return toolPresets
end