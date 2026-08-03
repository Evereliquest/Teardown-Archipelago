#version 2
-- This is the main script for heist game mode:
-- * Identifies the goal and all targets in the level
-- * Starts a timer when the alarm goes off
-- * Tracks mission time and time limit, if present
-- * Removes targets when they are picked up or moved to the goal trigger
-- * Communicates state and progression to HUD script through global variables
-- * Plays appropriate music depending on state

#include "ui/ui_helpers.lua"
#include "ui/ui_extensions.lua"
#include "common.lua"
#include "missions.lua"
#include "activities.lua"
#include "ui/map.lua"
#include "script/include/player.lua"

pTimeLimit = GetFloatParam("timelimit", 0)
pRequired = GetIntParam("required", 0)
pMusic = GetStringParam("music", "")
pHeistMusic = GetStringParam("heistmusic", "")
pFireAlarm = GetBoolParam("firealarm", true)
pHideOptional = GetBoolParam("hideoptional", false)
pWinMusic = GetStringParam("winmusic", "win.ogg")
pFailMusic = GetStringParam("failmusic", "fail.ogg")

heistTimeLeft = nil
shared.targets = nil
savedScore = nil

function server.init()
	SetFloat("level.extraheisttime", GetFloat("options.game.campaign.time"), true) --sync the extra heist time to clients
	SetFloat("level.missiontime", 0, true)
	SetFloat("level.alarmtimer", computeHeistAlarmTimer(1), true)
	SetFloat("level.timelimit", pTimeLimit, true)
	SetBool("level.alarm", false, true)
	SetString("level.state", "", true)

	shared.targets = FindBodies("target", true)
	targetShapeCount = {}
	local secondaryCount = 0
	primaryCount = 0	
	for i=1,#shared.targets do
		if HasTag(shared.targets[i], "optional") then
			secondaryCount = secondaryCount + 1
		else
			primaryCount = primaryCount + 1
		end
		if GetTagValue(shared.targets[i], "target") == "" then
			SetTag(shared.targets[i], "interact", "loc@PICK_UP_TARGET")
		end
		local shapes = GetBodyShapes(shared.targets[i])
		targetShapeCount[shared.targets[i]] = #shapes
	end

	SetBool("level.firealarm", pFireAlarm, true)

	--If the required number of targets is not specified as parameter it defaults to number of primary targets
	if pRequired > 0 then
		requiredCount = pRequired
	else
		requiredCount = primaryCount
		if requiredCount == 0 then
			requiredCount = secondaryCount
		end
	end

	if pHideOptional then
		secondaryCount = 0
	end
	
	SetInt("level.primary", primaryCount, true)
	SetInt("level.secondary", secondaryCount, true)
	SetInt("level.required", requiredCount, true)

	goal = FindTrigger("goal", true)

	clearedPrimary = 0
	clearedSecondary = 0
	
	targetSound = LoadSound("pickup.ogg")
	targetUnclearSound = LoadSound("error.ogg")
	alarmBackgroundLoop = LoadLoop("alarm-background.ogg")

	heistTimeLeft = 9999
end


function isTargetBroken(target)
	local shapes = GetBodyShapes(target)
	if #shapes < targetShapeCount[target] then
		return true
	else
		--Only check the first original shapes to avoid clearing a target
		--when additional shapes were placed on body afterwards (ie booster)
		for i=1,targetShapeCount[target] do
			if IsShapeBroken(shapes[i]) then
				return true
			end
		end
		return false
	end
end


function clearTarget(target)
	PlaySound(targetSound)

	if HasTag(target, "optional") then
		clearedSecondary = clearedSecondary + 1
	else
		clearedPrimary = clearedPrimary + 1
	end

	SetInt("level.clearedprimary", clearedPrimary, true)
	SetInt("level.clearedsecondary", clearedSecondary, true)
end


function unclearTarget(target)
	PlaySound(targetUnclearSound)

	if HasTag(target, "optional") then
		clearedSecondary = clearedSecondary - 1
	else
		clearedPrimary = clearedPrimary - 1
	end

	SetInt("level.clearedprimary", clearedPrimary, true)
	SetInt("level.clearedsecondary", clearedSecondary, true)
end


function server.tick(dt)
	--Play music on win and lose
	local state = GetString("level.state")
	if state ~= "" then
		if state == "win" then
			if GetString("game.levelid")=="cullington_bomb" then
				PlayMusic("ending.ogg")
			else
				PlayMusic(pWinMusic)
			end

			--Save score once
			if GetString("level.state") == "win" and not savedScore then
				saveScore()
				savedScore = true
			end
		else
			PlayMusic(pFailMusic)
		end
		return
	end

	if GetFloat("level.extraheisttime") ~= GetFloat("options.game.campaign.time") then
		SetFloat("level.extraheisttime", GetFloat("options.game.campaign.time"), true)
	end

	for p in Players() do
		--Set fail state if player dies
		if GetPlayerHealth(p) == 0 then
			SetString("level.state", "fail_dead", true)
		end
	end

	--Tick down alarm timer and lose if it reaches zero
	if GetBool("level.alarm") then
		local t = GetFloat("level.alarmtimer")
		t = t - dt
		if t <= 0.0 then
			t = 0.0
			SetString("level.state", "fail_alarmtimer", true)
		end
		SetFloat("level.alarmtimer", t, true)
		
		if pHeistMusic ~= "" then
			PlayMusic(pHeistMusic)
		else
			if GetString("game.levelid") == "carib_alarm" then
				PlayMusic("heist-carib.ogg")
			else
				PlayMusic("heist.ogg")
			end
		end
		
		PlayLoop(alarmBackgroundLoop)
	else
		SetFloat("level.alarmtimer", computeHeistAlarmTimer(GetPlayerCount()), true)

		if pMusic ~= "custom" then
			if pMusic ~= "" then
				PlayMusic(pMusic)
			else
				StopMusic()
			end
		end

		--Set off alarm if a lot of fires
		if pFireAlarm and GetFireCount() >= 100 then
			SetBool("level.alarm", true, true)
			SetString("hud.notification", "loc@UI_HUD_NOTE_ALARM_TRIGGERED_FIRE")
		end
	end

	--Tick mission time
	local missionTime = GetFloat("level.missiontime")
	missionTime = missionTime + dt
	--Lose if passed time limit
	local timeLimit = GetFloat("level.timelimit")
	if timeLimit > 0 and missionTime >= timeLimit then
		missionTime = timeLimit
		SetString("level.state", "fail_missiontimer", true)
	end
	SetFloat("level.missiontime", missionTime, true)
	
	--Compute time left
	if GetBool("level.alarm") then
		heistTimeLeft = GetFloat("level.alarmtimer")
	end
	timeLimit = GetFloat("level.timelimit")
	if timeLimit > 0 then
		local missionTimeLeft = math.max(0, timeLimit - GetFloat("level.missiontime"))
		heistTimeLeft = math.min(heistTimeLeft, missionTimeLeft)
	end

	if heistTimeLeft >= 9999 then
		SetFloat("level.timeleft", -1, true)
	else
		SetFloat("level.timeleft", heistTimeLeft, true)
	end

	for i=1, #shared.targets do
		if IsHandleValid(shared.targets[i]) then

			local targetType = GetTagValue(shared.targets[i], "target")
			if targetType == "heavy" then
				if IsBodyInTrigger(goal, shared.targets[i]) then
					clearTarget(shared.targets[i])
					Delete(shared.targets[i])
				end
			elseif targetType == "destroy" then
				if isTargetBroken(shared.targets[i]) then
					clearTarget(shared.targets[i])
					RemoveTag(shared.targets[i], "target")
					shared.targets[i] = 0
				end
			elseif targetType == "cleared" then
				clearTarget(shared.targets[i])
				RemoveTag(shared.targets[i], "target")
				shared.targets[i] = 0
			elseif targetType == "disabled" then
				RemoveTag(shared.targets[i], "target")
				if HasTag(shared.targets[i], "ok") then
					RemoveTag(shared.targets[i], "ok") 
					unclearTarget(shared.targets[i])
				end
				shared.targets[i] = 0
			elseif targetType == "ok" then
				if not HasTag(shared.targets[i], "ok") then
					SetTag(shared.targets[i], "ok")
					clearTarget(shared.targets[i])
				end
			elseif targetType == "custom" then
				--Cleared logic is in some other script for custom shared.targets
				if HasTag(shared.targets[i], "ok") then
					RemoveTag(shared.targets[i], "ok") 
					unclearTarget(shared.targets[i])
				end
			else
				for j in Players() do
					if GetPlayerInteractBody(j) == shared.targets[i] and InputPressed("interact", j) then
						if IsPlayerHost(j) and GetString("game.levelid") == "lee_login" and not GetBool("game.canquickload") and not GetBool("game.quicksaveinprogress") and not GetBool("level.alarm") then
							SetBool("hud.quicksavehint", true)
							SetPaused(true)
						else
							clearTarget(shared.targets[i])
							Delete(shared.targets[i])
						end
					end
				end
			end
		end
	end
	
	-- Complete when cleared target count is at least the required count AND all primary (if any) are cleared
	local complete = clearedPrimary + clearedSecondary >= requiredCount
	if primaryCount > 0 and clearedPrimary < primaryCount then
		complete = false
	end
	SetBool("level.complete", complete, true)
end

function client.tick(dt)
	for i=1, #shared.targets do
		if IsHandleValid(shared.targets[i]) then
			--Draw target outline
			local dist = VecLength(VecSub(GetPlayerPos(), GetBodyTransform(shared.targets[i]).pos))
			if dist < 8 and not HasTag(shared.targets[i], "nooutline") then
				local alpha = 0.6*(1-dist/8)
				if IsBodyDynamic(shared.targets[i]) and HasTag(shared.targets[i], "jointed") then
					local bodies = GetJointedBodies(shared.targets[i])
					for j=1,#bodies do
						DrawBodyOutline(bodies[j], alpha)
					end
				else
					DrawBodyOutline(shared.targets[i], alpha)
				end
			end
		end
	end
end

function client.draw()
	local state = GetString("level.state")
	local alarm = GetBool("level.alarm")
	local isCreativeModeEnabled = GetBool("game.creative.enabled")
	
	if state == "" and not isCreativeModeEnabled then
		drawTargetInfo()
	end
	
	if state=="" and not alarm and pFireAlarm then
		drawFireMeter()
	end
	
	if state=="" then
		drawTimer()
	end
end

------------------------------------------------------------------------------------
-- SAVE SCORE
------------------------------------------------------------------------------------

function saveScore()
	if not IsPlayerHost() then return end

	--Save score to registry if this is a campaign mission
	local missionId = GetString("game.levelid")
	local missionKey = ""
	local enabled = GetInt("options.game.archipelago.enabled")
	if gMissions[missionId] or GetBool("game.level.score.save") then
		local primary = GetInt("level.clearedprimary")
		local secondary = GetInt("level.clearedsecondary")
		local timeLeft = GetFloat("level.timeleft")
		local missionTime = GetFloat("level.missiontime")
		local score = primary + secondary
		
		if enabled == 0 then
			missionKey = "savegame.mod.steam-3708322400.mission."..missionId
		else
			missionKey = "savegame.mission."..missionId
		end
		local bestScore = GetInt(missionKey..".score")
		local bestTimeLeft = GetFloat(missionKey..".timeleft")
		local bestMissionTime = GetFloat(missionKey..".missiontime")

		--Determine if new score is better
		local saveNewScore = false
		if score > bestScore then
			saveNewScore = true
		elseif score == bestScore then
			if timeLeft > 0 then
				if timeLeft > bestTimeLeft then
					saveNewScore = true
				end
			else
				if missionTime < bestMissionTime then
					saveNewScore = true
				end
				if bestMissionTime == 0 then -- mission was skipped
					saveNewScore = true
				end
			end
		end
		
		--Save to registry
		if saveNewScore then
			SetBool("level.highscore", true)
			if GetInt(missionKey..".score") == 0 then
				if enabled == 0 then
					SetString("savegame.mod.steam-3708322400.lastcompleted", missionId)
				else
					SetString("savegame.lastcompleted", missionId)
				end
			end
			SetInt(missionKey..".score", score)
			SetFloat(missionKey..".timeleft", timeLeft)
			SetFloat(missionKey..".missiontime", missionTime)
			if timeLeft > 0 then
				Command("game.path.save", missionId.."-best")
			end
			syncActivities(missionId, false, true)
		end
	end
end


------------------------------------------------------------------------------------
-- TIMER
------------------------------------------------------------------------------------

function drawTimer()
	local timeLeft = GetFloat("level.timeleft")
	if timeLeft >= 0 then
		UiPush()
			UiFont("bold.ttf", 32)
			UiPush()
				UiTranslate(UiCenter()-50, 65)
				UiAlign("left")
				UiTextOutline(0, 0, 0, 1)
				UiColor(1, 1, 1)
				UiScale(2.0)
				if timeLeft <= 60 then
					UiText(tostring(math.ceil(timeLeft*10)/10))
				else
					local t = math.ceil(timeLeft)
					local m = math.floor(t/60)
					local s = math.ceil(t-m*60)
					if s < 10 then
						UiText(m .. ":0" .. s)
					else
						UiText(m .. ":" .. s)
					end
				end
			UiPop()
		UiPop()
	end
end


------------------------------------------------------------------------------------
-- TARGET INFO
------------------------------------------------------------------------------------
tiScale = 0
tiText = ""
tiTextTimer = 0
tiTextScale = 0
tiRequired = 0
tiOptional = 0

gTargetInfoContentWidth = {0,0}
gTargetInfoIconsWidth = {0,0}

function drawTargetInfo()
	local primary = GetInt("level.primary")
	local primaryTaken = GetInt("level.clearedprimary")
	local secondary = GetInt("level.secondary")
	local secondaryTaken = GetInt("level.clearedsecondary")
	local required = GetInt("level.required")

	local requiredPrimary = primary
	local requiredPrimaryTaken = primaryTaken
	local requiredSecondary = required - primary
	local requiredSecondaryTaken = clamp(secondaryTaken, 0, requiredSecondary)
	local requiredTaken = requiredPrimaryTaken + requiredSecondaryTaken
	local optional = secondary - requiredSecondary
	local optionalTaken = clamp(secondaryTaken-requiredSecondary, 0, optional)
	required = requiredPrimary + requiredSecondary

	if requiredTaken + optionalTaken > tiRequired + tiOptional then
		SetValue("tiTextScale", 1, "easeout", 0.4)
		if requiredTaken == required and requiredTaken > tiRequired then
			tiText = GetTranslatedStringByKey("TITEXT_MISSION_COMPLETE")
		elseif requiredTaken+optionalTaken == required+optional then
			tiText = GetTranslatedStringByKey("TITEXT_ALL_TARGETS")
		else
			tiText = GetTranslatedStringByKey("TITEXT_TARGET_CLEARED")
		end
		tiTextTimer = 3.0
	end
	tiRequired = requiredTaken
	tiOptional = optionalTaken

	local show = primaryTaken + secondaryTaken > 0
	if show and tiScale==0 then
		SetValue("tiScale", 1, "easeout", 0.5)
	elseif not show and tiScale==1 then
		SetValue("tiScale", 0, "easein", 0.5)
	end

	local mapFade = GetFloat("game.map.fade")
	local visible = math.max(tiScale, mapFade)
	local isMapShown = mapFade > 0
	local isBarAlwaysShown = tiScale == 1

	SetBool("game.hud.heistStatsVisible", visible > 0, true)

	if visible > 0 then
		UiPush()
			local offsetFromBottomToEdge = 30
			-- top left point
			local offsetFromBottom = 68
			local bboxH = 38
			if optional > 0 then
				offsetFromBottom = offsetFromBottom + 48
				bboxH = bboxH + 48
			end

			local indent = 10
			if LastInputDevice() == UI_DEVICE_GAMEPAD and isMapShown and not isBarAlwaysShown then
				offsetFromBottom = bboxH + indent
				bboxH = bboxH + indent
			elseif not isMapShown and isBarAlwaysShown then
				offsetFromBottom = offsetFromBottom + GetInt("game.hud.hintH")
			end

			SetInt("game.map.tgH", bboxH, true)

			local offsetY = GetInt("game.map.gpOffsetY")
			if isMapShown and not isBarAlwaysShown then
				offsetFromBottom = -offsetY + offsetFromBottom
			elseif isMapShown and isBarAlwaysShown then
				if offsetY > -(offsetFromBottomToEdge - indent) then
					offsetY = 0
				else
					offsetFromBottom = offsetFromBottom - (offsetFromBottomToEdge - indent)
				end

				offsetFromBottom = -offsetY + offsetFromBottom
			end

			UiTranslate(0, UiHeight() - offsetFromBottom)

			if tiTextScale > 0 then
				UiPush()
					UiFont("regular.ttf", 32)
					UiTranslateToScreenRightEdge(-32, -18)
					UiScale(1, tiTextScale)
					UiAlign("right middle")
					UiText(tiText)
					if tiTextTimer > 0 then
						tiTextTimer = tiTextTimer - GetTimeStep()
						if tiTextTimer <= 0 then
							SetValue("tiTextScale", 0, "easein", 0.25)
						end
					end
				UiPop()
			end

			local padding = 8
			for i=1,2 do
				if i == 1 or optional > 0 then
					UiPush()
						--draw background
						UiColor(0, 0, 0, 0.15 + 0.65 * mapFade)
						UiTranslateToScreenRightEdge(-30, 0)

						UiPush()
							UiAlign("top right")
							UiImageBox("ui/common/box-solid-10.png", gTargetInfoContentWidth[i] + 2 * padding - 5, 40, 10, 10)
						UiPop()

						UiTranslate(-padding, 0)
						UiBeginFrame()

						-- draw labels
						UiPush()
							UiColor(1,1,1)
							UiFont("regular.ttf", 27)
							UiAlign("middle right")

							local offsetFromIcons = 10
							UiTranslateToScreenRightEdge(-30 - padding - gTargetInfoIconsWidth[i] - offsetFromIcons, 22)
							if i == 1 then
								UiColor(1,1,1)
								UiText("loc@UI_TEXT_REQUIRED")
							else
								UiColor(1,1,1)
								UiText("loc@UI_TEXT_OPTIONAL")
							end
						UiPop()

						-- draw progress icons
						local icoWidth = 20
						UiTranslateToScreenRightEdge(-30 - icoWidth / 2 - padding, 20)

						UiBeginFrame()
						UiAlign("center middle")

						UiScale(1.3)
						if i==1 then
							UiColor(1,1,0.5)
							for i=1, primary do
								if i <= primaryTaken then
									UiImage("ui/hud/target-taken.png")
								else
									UiImage("ui/hud/target.png")
								end
								UiTranslate(-icoWidth - 4, 0)
							end
							for i=1, requiredSecondary do
								if i <= requiredSecondaryTaken then
									UiImage("ui/hud/target-taken.png")
								else
									UiImage("ui/hud/target.png")
								end
								UiTranslate(-icoWidth - 4, 0)
							end
						else
							UiColor(1,1,1)
							for i=1, optional do
								if i <= optionalTaken then
									UiImage("ui/hud/target-taken.png")
								else
									UiImage("ui/hud/target.png")
								end
								UiTranslate(-icoWidth - 4, 0)
							end
						end
					UiPop()

					gTargetInfoIconsWidth[i] = UiEndFrame()
					gTargetInfoContentWidth[i] = UiEndFrame()
					UiTranslate(0, 48)
				end
			end
		UiPop()
	end
end


------------------------------------------------------------------------------------
-- FIRE METER
------------------------------------------------------------------------------------

fmScale = 0
function drawFireMeter()
	local fireCount = math.clamp(GetFireCount(), 0, 100)
	if fireCount == 0 and fmScale == 1 then
		SetValue("fmScale", 0, "easein", 0.5)
	end
	if fireCount > 10 and fmScale == 0 then
		SetValue("fmScale", 1, "easeout", 0.5)
	end
	if fmScale > 0 then
		UiPush()
			UiAlign("center top")
			UiTranslate(UiCenter(), -70 + 70*fmScale)
			UiWindow(200, 50)
			UiFont("bold.ttf", 24)
			UiTextOutline(0,0,0,1, 0.1)
			UiPush()
				UiTranslate(UiCenter(), 20)
				UiText("loc@UI_TEXT_FIRE_ALERT")
			UiPop()
			UiTranslate(0, 48)
			local t = fireCount/100
			progressBar(200, 20, math.min(t, 1.0))
		UiPop()
	end
end

