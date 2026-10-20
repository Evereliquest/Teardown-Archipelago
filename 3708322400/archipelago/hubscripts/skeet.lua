count = 0
timer = 0
score = 0
active = false
broken = false

function init()
	skeetSnd = LoadSound("skeet.ogg")
	machine = FindShape("machine")
	emitPos = GetLocationTransform(FindLocation("emit")).pos
	onSnd = LoadSound("clickdown.ogg")
	offSnd = LoadSound("clickup.ogg")
	startSnd = LoadSound("skeet-start.ogg")
	finishSnd = LoadSound("skeet-finish.ogg")
	scoreSnd = LoadSound("skeet-score.ogg")
	button = FindShape("button")
end

function tick(dt)
	if broken then
		return
	end
	if GetPlayerInteractShape() == button and InputPressed("interact") then
		if count > 0 then
			count = 0
			active = false
			PlaySound(offSnd)
			SetTag(button, "interact", "loc@START")
		else
			count = 10
			score = 0
			active = true
			timer = 2
			PlaySound(onSnd)
			PlaySound(startSnd)
			SetTag(button, "interact", "loc@STOP")
		end
	end
	if count > 0 then
		timer = timer - dt
		if timer <= 0 then
			local pos = emitPos
			local vel = VecScale(VecNormalize(Vec(-1.0, 0.7, math.random()-0.5)), math.random()*6+14)
			local t = Transform(pos)
			local entities = Spawn('<body dynamic="true"><vox file="LEVEL/script/skeet-target.vox" strength="10"/></body>', t)
			local b = entities[1]
			SetBodyVelocity(b, vel)
			SetBodyAngularVelocity(b, Vec(0, -15, 0))
			SetTag(entities[2], "skeet")
			PlaySound(skeetSnd, pos)
			timer = 0.8 + math.random()*0.8
			count = count - 1
		end
	end
	local skeet = FindShapes("skeet", true)
	for i=1, #skeet do
		local s = skeet[i]
		local p = GetShapeWorldTransform(s).pos
		local vel = GetBodyVelocity(GetShapeBody(s))
		if p[2] < 0 or VecLength(vel) < 1 then
			RemoveTag(s, "skeet")
		else
			if IsShapeBroken(s) then
				score = score + 1
				PlaySound(scoreSnd)
				RemoveTag(s, "skeet")
				local mi,ma = GetShapeBounds(s)
				local as = QueryAabbShapes(mi, ma)
				for j=1, #as do
					local s2 = as[j]
					local b2 = GetShapeBody(s2)
					if IsBodyDynamic(b2) and GetBodyMass(b2) < 50 then
						Delete(b2)
					end
				end
			end
		end
	end
	if count == 0 and #skeet == 0 and active then
		PlaySound(finishSnd)
		active = false
		SetTag(button, "interact", "loc@START")
	end
	if IsShapeBroken(machine) or IsShapeBroken(button) then
		RemoveTag(button, "interact")
		broken = true
	end
	SetBool("level.skeet.active", active)
	SetInt("level.skeet.count", count)
	SetInt("level.skeet.score", score)
end

