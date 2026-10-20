t0 = GetFloatParam("t0", 10)
t1 = GetFloatParam("t1", 13)

tim = nil
p0 = nil
p1 = nil

function init()
	local locs = FindLocations()
	p0 = GetLocationTransform(locs[1]).pos
	p1 = GetLocationTransform(locs[2]).pos
	tim = 0
end

function tick(dt)
	tim = tim + dt
	local t
	if tim < t0 then
		t = 0
	elseif tim > t1 then
		t = 1
	else
		t = (tim-t0)/(t1-t0)
	end
	local p = VecLerp(p0, p1, t)
	local c = GetCameraTransform().pos
	local dist = VecLength(VecSub(c, p))
	SetCameraDof(dist)
end
