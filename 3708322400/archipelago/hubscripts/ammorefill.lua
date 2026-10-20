#include "game.lua"

isOutsideTrigger = true

function init()
	ammotrigger = FindTrigger("Ammotrigger")
	refillSound = LoadSound("tool_pickup.ogg")
end

function tick(dt)
	if IsPointInTrigger(ammotrigger, GetPlayerPos()) then
		if isOutsideTrigger then
			for id,tool in pairs(gTools) do
				local enabled = GetBool("game.tool."..id..".enabled")
				if enabled then
					for j=1, #tool.upgrades do
						local prop = tool.upgrades[j].id
						local value = tool.upgrades[j].default
						local saved = GetInt("savegame.tool."..id.."."..prop)
						if saved > value then
							value = saved
						end
						SetInt("game.tool."..id.."."..prop, value)
						if prop == "ammo" then
							SetInt("game.tool."..id..".ammo.max", value)							
						end
					end
				end
			end
			PlaySound(refillSound)
			SetString("hud.notification", GetTranslatedStringByKey("UI_HUD_NOTE_AMMO_REFILL"))
		end
		isOutsideTrigger = false
	else
		isOutsideTrigger = true
	end
end
