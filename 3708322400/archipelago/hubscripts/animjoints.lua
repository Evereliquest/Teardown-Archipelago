#include "script/common.lua"

active = false
broken = false
activeTime = 0

function init()
	joints = FindJoints("anim", true)
	
	button = FindShape("button")
	onSnd = LoadSound("clickdown.ogg")
	offSnd = LoadSound("clickup.ogg")

	SetBool("level.targetpractice.active", active)
	
	SetTag(button, "interact", "loc@START_TARGETS")

end

function tick(dt)
	if broken then
		return
	end

	if GetPlayerInteractShape() == button and InputPressed("interact") then
		if active then
			active = false
			PlaySound(offSnd)
			SetTag(button, "interact", "loc@START_TARGETS")
			SetBool("level.targetpractice.active", active)
		else
			active = true			
			PlaySound(onSnd)
			SetTag(button, "interact", "loc@STOP_TARGETS")
			SetBool("level.targetpractice.active", active)
		end
	end

	if active then
		activeTime = activeTime + dt
		for i=1, #joints do
			local joint = joints[i]
			local t = GetTagValue(joint, "anim")
			if t == "sine" then
				local period = tonumber(GetTagValue(joint, "period")) or 4
				local offset = tonumber(GetTagValue(joint, "offset")) or 0
				local strength = tonumber(GetTagValue(joint, "strength")) or 1000
				local mi, ma = GetJointLimits(joint)
				mi = mi + 0.2
				ma = ma - 0.2
				local target = (math.sin(math.pi * 2 * (activeTime+offset)/period) * 0.5 + 0.5) * (ma-mi) + mi
				SetJointMotorTarget(joint, target, 10.0, strength)
			elseif t == "rot" then
				local speed = tonumber(GetTagValue(joint, "speed")) or 1
				local strength = tonumber(GetTagValue(joint, "strength")) or 1000
				SetJointMotor(joint, speed, strength)
			else
				SetJointMotor(joint, 0, 0)
			end
		end
	else
		for i=1, #joints do
			local joint = joints[i]
			local t = GetTagValue(joint, "anim")
			if t == "rot" then
				SetJointMotor(joint, 0, 0)
			end
		end
	end

	if IsShapeBroken(button) then
		RemoveTag(button, "interact")
		broken = true
	end
end

