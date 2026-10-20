timeSinceShot = nil
function init()
	local body = FindBody("practicetarget")
	
	joint = FindJoint()
	mi, ma = GetJointLimits(joint)
	SetJointMotorTarget(joint, mi, 2)
	RemoveTag(body, "practicetarget")
	active = true
	armed = true
	timeSinceShot = 0
end

function tick(dt)
	timeSinceShot = timeSinceShot + dt
	if GetBool("level.targetpractice.active") then
		if not active and timeSinceShot > 2 then
			active = true
			armed = false
			SetJointMotorTarget(joint, ma, 2, 100)
		end
		
		if active then
			local movement = GetJointMovement(joint)
			if movement > ma-0.1 then
				SetJointMotor(joint, 0, 0)
				armed = true
			end
			if armed and movement < mi+0.3 then
				active = false
				armed = false
				timeSinceShot = 0
				SetJointMotorTarget(joint, mi, 2)
			end
		end
	else
		active = false
		armed = false
		SetJointMotorTarget(joint, mi, 2)
	end
end

