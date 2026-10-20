#include "script/wheels.lua"

function init()
	enabled = true
	if GetBool("savegame.mission.frustrum_vehicle") or GetBool("savegame.mission.mall_decorations") then
		enabled = false
		local loc = FindLocation("defaultplayer", true)
		SetPlayerSpawnTransform(GetLocationTransform(loc))
		Delete(FindBody("taxi"))
		return
	end
	
	taxi = FindBody("taxi")
	taxiVel = Vec(0,0,0)
	taxiTransform = GetBodyTransform(taxi)
	if enabled then
		local taxiSound = LoadSound("taxi.ogg")
		PlaySound(taxiSound)
	end
	wheelInit(taxi)
end

function tick(dt)
	if enabled and GetTime() > 1.5 then
		local fwd = TransformToParentVec(taxiTransform, Vec(0, 0, 1))
		taxiVel = VecAdd(taxiVel, VecScale(fwd, dt*4.0))
		taxiTransform.pos = VecAdd(taxiTransform.pos, VecScale(taxiVel, dt))
		wheelUpdate(-VecLength(taxiVel))
		SetBodyTransform(taxi, taxiTransform)
	end
end

function draw()
	if GetTime() < 1.5 then
		SetBool("hud.disable", true)
		UiColor(0,0,0)
		UiRect(UiWidth(), UiHeight())
	end
end
