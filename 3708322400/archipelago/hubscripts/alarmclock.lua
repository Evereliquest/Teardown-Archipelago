function init()
	shape = FindShape("clock")
	sound = LoadSound("LEVEL/script/alarmclock/alarmclock.ogg")
	f = 0
	done = false
end

function update(dt)
	if not done then
		f = f + 1
		if f%30 == 20 then
			local pos = GetBodyTransform(GetShapeBody(shape)).pos
			PlaySoundForUser(sound, 0, pos)
		end
		if f%30 > 20 then
			SetShapeEmissiveScale(shape, 1)
		else
			SetShapeEmissiveScale(shape, 0)
		end
		if IsShapeBroken(shape) then
			done = true
		end
	end
end
