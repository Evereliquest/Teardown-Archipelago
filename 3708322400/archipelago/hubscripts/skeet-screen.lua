frame = 0

function update()
	frame = frame + 1
end

function draw()
	UiFont("bold.ttf", 24)
	UiTranslate(UiCenter(), UiMiddle()-20)
	UiAlign("center middle")
	UiColor(1, 0.8, 0.5)
	
	local active = GetBool("level.skeet.active")
	local count = GetInt("level.skeet.count")
	local score = GetInt("level.skeet.score")
	if active then
		UiPush()
			UiScale(1.5)
			if count == 10 then
				UiText("loc@UI_TEXT_GET_READY")
			else
				UiText(GetTranslatedStringByKey("UI_TEXT_SCORE") .. " " .. score)
			end
		UiPop()
	else
		UiPush()
			local text = GetTranslatedStringByKey("UI_TEXT_SKEETMASTER")
			local w = UiGetTextSize(text)
			local scale = 1.5
			if w * scale > UiWidth() - 20 then
				scale = 1.0
			end
			UiScale(scale)
			UiText(text)
		UiPop()
		UiTranslate(0, 25)
		if frame%50 > 10 then
			UiPush()
				UiScale(0.7)
				UiText("loc@UI_TEXT_PRESS_BUTTON")
			UiPop()
		end
		UiTranslate(0, 30)
		if score > 0 then
			UiText(GetTranslatedStringByKey("UI_TEXT_LAST_SCORE") .. " " .. score)
		end
	end
end

