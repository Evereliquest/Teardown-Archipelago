#include "script/common.lua"
#include "script/wheels.lua"

function init()
	enabled = true
	if GetBool("savegame.mission.mall_intro") then
		enabled = false
		local loc = FindLocation("defaultplayer", true)
		SetPlayerSpawnTransform(GetLocationTransform(loc))
		Delete(FindBody("bus"))
		return
	end

	gateLocation = FindLocation("gate")
	gateTrigger = FindTrigger("gate")
	gateNearTrigger = FindTrigger("gatenear")
	gateDoneTrigger = FindTrigger("gatedone")
	gateNear = false
	gateDone = false

	doorLocation = FindLocation("door")
	doorTrigger = FindTrigger("door")
	doorRubbleTrigger = FindTrigger("rubble")
	doorDoneTrigger = FindTrigger("doordone")
	doorRubbleDone = false
	doorDone = false
	
	toolsLocation = FindLocation("tools")
	toolsTrigger = FindTrigger("tools")
	toolsDone = false

	fuseLocation = FindLocation("fuse")
	fuseOutsideTrigger = FindTrigger("fuseoutside")
	fuseInsideTrigger = FindTrigger("fuseinside")
	fuseLight = FindShape("fuselight")
	fuseBody = FindBody("fuse")
	fuseDone = false

	terminalLocation = FindLocation("terminal")
	terminalTrigger = FindTrigger("terminal")
	terminalDone = false
	
	powerOn = LoadSound("LEVEL/script/tutorial/poweron.ogg")
	arrow = LoadSprite("gfx/arrowdown.png")
	
	--Turn off tv and terminal and make them non-interactive until power is on
	tv = FindScreen("tv", true)
	terminal = FindScreen("terminal", true)
	SetScreenEnabled(tv, false)
	SetScreenEnabled(terminal, false)
	RemoveTag(GetShapeBody(GetScreenShape(tv)), "interact")
	RemoveTag(GetShapeBody(GetScreenShape(terminal)), "interact")
	
	--Turn off all the lights
	lights = FindShapes("light", true)
	for i=1, #lights do
		SetShapeEmissiveScale(lights[i], 0)
	end
	
	--Disable all tools
	local tools = ListKeys("game.tool")
	for i=1,#tools do
		local k = "game.tool."..tools[i]..".enabled"
		if GetBool(k) then
			SetBool(k, false)
		end
	end
	SetString("game.player.tool", "none")	
	
	--gateDone = true
	--doorDone = true
	--toolsDone = true
	
	bus = FindBody("bus")
	busVel = Vec(0,0,0)
	busTransform = GetBodyTransform(bus)
	busSound = LoadSound("LEVEL/script/tutorial/bus.ogg")
	busActive = false
	
	wheelInit(bus)
end


function drawArrow(location)
	if GetBool("game.map.enabled") then
		return
	end
	local t = GetLocationTransform(location)
	t.rot = QuatLookAt(t.pos, GetCameraTransform().pos)
	local offset = 1.5 + math.sin(4.0*GetTime())*0.5
	t.pos[2] = t.pos[2] + offset
	DrawSprite(arrow, t, 2, 2, .3, .3, .3, 3, false, true)
	DrawSprite(arrow, t, 2, 2, 1, 1, 1, 1, true, true)
end


function tick(dt)
	if not enabled then
		return
	end

	if GetTime() > 2.5 then
		if not busActive then
			PlaySound(busSound)
			busActive = true
		end
		local fwd = TransformToParentVec(busTransform, Vec(0, 0, 1))
		busVel = VecAdd(busVel, VecScale(fwd, dt*2.0))
		busTransform.pos = VecAdd(busTransform.pos, VecScale(busVel, dt))
		wheelUpdate(-VecLength(busVel))
		SetBodyTransform(bus, busTransform)
	end

	local curinput = GetString("game.input.curdevice")
	local p = GetPlayerPos()
	local hintimageInputOffsetX = 164
	if not gateDone then
		if IsPointInTrigger(gateTrigger, p) then
			if curinput == "mouse" then
				SetString("hud.hintimage", "ui/hud/tutorial/opendoor_empty_no_text.png")
				SetString("hud.hintimage.input", "ui/hud/tutorial/mouse_rmb.png")
				SetInt("hud.hintimage.offsetx", 212)
				SetInt("hud.hintimage.offsety", 115)
			else
				pushHintIcons {
					image = "ui/hud/tutorial/empty.png",
					padding = 10,
					margin = {top = 20},
					input = {
						GetString("game.input.grab.icon"),
						GetString("game.input.camerax.icon"),
					}
				}
			end
			SetString("hud.hintimage.text", GetTranslatedStringByKey("UI_TEXT_TUTORIAL_OPEN"))
			SetInt("hud.hintimage.text.offsety", 65)
		else
			if not gateNear and IsPointInTrigger(gateNearTrigger, p) then
				gateNear = true
				Command("pros.eventTutorial", "1")
			end
			if gateNear then
				SetString("hud.hintinfo", GetTranslatedStringByKey("UI_HUD_HINT_OPEN_THE"))
				drawArrow(gateLocation)
			else
				SetString("hud.hintinfo", GetTranslatedStringByKey("UI_HUD_HINT_WALK_HOME"))
			end
		end
		if IsPointInTrigger(gateDoneTrigger, p) then
			gateDone = true
			Command("pros.eventTutorial", "2")
		end
	elseif not doorDone then
		if IsPointInTrigger(doorTrigger, p) then
			if not doorRubbleDone and IsTriggerEmpty(doorRubbleTrigger) then
				doorRubbleDone = true
			end
			if doorRubbleDone then
				if curinput == "mouse" then
					SetString("hud.hintimage", "ui/hud/tutorial/opendoor_empty_no_text.png")
					SetString("hud.hintimage.input", "ui/hud/tutorial/mouse_rmb.png")
					SetInt("hud.hintimage.offsetx", 212)
					SetInt("hud.hintimage.offsety", 115)
				else
					pushHintIcons {
						image = "ui/hud/tutorial/empty.png",
						padding = 10,
						margin = {top = 20},
						input = {
							GetString("game.input.grab.icon"),
							GetString("game.input.camerax.icon"),
						}
					}
				end
				SetString("hud.hintimage.text", GetTranslatedStringByKey("UI_TEXT_TUTORIAL_OPEN"))
				SetInt("hud.hintimage.text.offsety", 65)
			else
				SetString("hud.hintimage", "ui/hud/tutorial/empty.png")
				if curinput == "mouse" then
					SetString("hud.hintimage.input", "ui/hud/tutorial/mouse_rmb.png")
					SetInt("hud.hintimage.offsetx", hintimageInputOffsetX)
					SetInt("hud.hintimage.offsety", 120)
				else
					local str = GetString("game.input.grab.icon")
					if str ~= "" then
						SetString("hud.hintimage.input", str)
						SetInt("hud.hintimage.offsetx", hintimageInputOffsetX)
						SetInt("hud.hintimage.offsety", 120)
					end
				end
				SetString("hud.hintimage.text", GetTranslatedStringByKey("UI_TEXT_TUTORIAL_HOLD"))
				SetInt("hud.hintimage.text.offsety", 70)
			end
		else
			SetString("hud.hintinfo", GetTranslatedStringByKey("UI_HUD_HINT_GO_INSIDE"))
			drawArrow(doorLocation)
		end
		if IsPointInTrigger(doorDoneTrigger, p) then
			doorDone = true
			Command("pros.eventTutorial", "3")
		end
	elseif not toolsDone then
		if not IsPointInTrigger(toolsTrigger, p) then
			SetString("hud.hintinfo", GetTranslatedStringByKey("UI_HUD_HINT_PICK_UP"))
			drawArrow(toolsLocation)
		end
		if GetBool("game.tool.sledge.enabled") and GetBool("game.tool.spraycan.enabled") and GetBool("game.tool.extinguisher.enabled") then
			toolsDone = true
			Command("pros.eventTutorial", "4")
		end
	elseif not fuseDone then
		SetTag(fuseBody, "interact", "loc@REPLACE_FUSE")
		if IsPointInTrigger(fuseOutsideTrigger, p) then
			SetString("hud.hintimage", "ui/hud/tutorial/empty.png")
			if curinput == "mouse" then
				SetString("hud.hintimage.input", "ui/hud/tutorial/mouse_lmb.png")
				SetInt("hud.hintimage.offsetx", hintimageInputOffsetX)
				SetInt("hud.hintimage.offsety", 120)
			else
				local str = GetString("game.input.usetool.icon")
				if str ~= "" then
					SetString("hud.hintimage.input", str)
					SetInt("hud.hintimage.offsetx", hintimageInputOffsetX)
					SetInt("hud.hintimage.offsety", 120)
				end
			end
			SetString("hud.hintimage.text", GetTranslatedStringByKey("UI_TEXT_TUTORIAL_USE"))
			SetInt("hud.hintimage.text.offsety", 70)
		elseif IsPointInTrigger(fuseInsideTrigger, p) then
			SetString("hud.hintimage", "ui/hud/tutorial/empty.png")
			if curinput == "mouse" then
				SetString("hud.hintimage.input", "ui/hud/tutorial/flashlight_icon.png")
				SetInt("hud.hintimage.offsetx", hintimageInputOffsetX)
				SetInt("hud.hintimage.offsety", 120)
			else
				local str = GetString("game.input.flashlight.icon")
				if str ~= "" then
					SetString("hud.hintimage.input", str)
					SetInt("hud.hintimage.offsetx", hintimageInputOffsetX)
					SetInt("hud.hintimage.offsety", 120)
				end
			end
			SetString("hud.hintimage.text", GetTranslatedStringByKey("UI_TEXT_TUTORIAL_FLASHLIGHT"))
			SetInt("hud.hintimage.text.offsety", 70)
		else
			SetString("hud.hintinfo", GetTranslatedStringByKey("UI_HUD_HINT_REPLACE_THE"))
			drawArrow(fuseLocation)
		end
		if GetPlayerInteractBody() == fuseBody and InputPressed("interact") then
			PlaySound(powerOn)
			RemoveTag(fuseBody, "interact")
			fuseDone = true
			Command("pros.eventTutorial", "5")
			SetShapeEmissiveScale(fuseLight, 0)
			for i=1, #lights do
				SetShapeEmissiveScale(lights[i], 1)
			end
			SetScreenEnabled(tv, true)
			SetScreenEnabled(terminal, true)
			SetTag(GetShapeBody(GetScreenShape(tv)), "interact")
			SetTag(GetShapeBody(GetScreenShape(terminal)), "interact")
		end
	elseif not terminalDone then
		if not IsPointInTrigger(fuseInsideTrigger, p) then
			if not IsPointInTrigger(terminalTrigger, p) then
				SetString("hud.hintinfo", GetTranslatedStringByKey("UI_HUD_HINT_GO_INSIDE_2"))
				drawArrow(terminalLocation)
			end
			if GetBool("game.player.usescreen") then
				terminalDone = true
				Command("pros.eventTutorial", "6")
			end
		end
	end
end
