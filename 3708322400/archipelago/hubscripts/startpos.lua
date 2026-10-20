function init()
	local id = GetString("game.levelid")
	if string.find(id, "hub") and id ~= "hub46" then
		local reg = "savegame.hub."..id
		if GetBool(reg) then
			local loc = FindLocation("defaultplayer", true)
			SetPlayerSpawnTransform(GetLocationTransform(loc))
		else
			SetBool(reg, true)
		end
	end
end

