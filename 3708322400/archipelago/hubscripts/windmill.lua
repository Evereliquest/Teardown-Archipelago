time = nil

function init()
	mainJ = FindJoint("mainjoint")
	propJ = FindJoint("propellerjoint")
	mSpeed = GetFloatParam("mSpeed", 0.0)
	pSpeed = GetFloatParam("pSpeed", 0.0)

	SetJointMotor(mainJ,mSpeed,30)
	SetJointMotor(propJ,pSpeed,30)
	change = math.random(5.0,10.0)
	time = 0.0
end

function tick(dt)
	time = time + dt
	if time > change then
		local newMVel = math.random(-mSpeed*100,mSpeed*100)/100
		local newPVel = math.random(pSpeed*100,pSpeed*200)/100

		SetJointMotor(mainJ,newMVel,30)
		SetJointMotor(propJ,newPVel,30)
		change = time + math.random(5.0,20.0)
	end
end