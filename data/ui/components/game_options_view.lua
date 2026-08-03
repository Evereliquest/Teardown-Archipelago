#include "game_options_logic.lua"
#include "ui/ui_extensions.lua"
#include "common_components.lua"

function drawComponent_f442_6190_LabelSetting_431_5156(p0)
    -- draw frame F442_6190_LabelSetting
    UiPush()
        UiColorFilter(1.0, 1.0, 1.0, 1)
        UiPush()
            UiTranslate(2.0, 47.0)
            UiColor(1, 1, 1, 1)
            UiImageBox("common/rect_c#d9d9d9_o0.40.png", 1005.0, 2.0, 2, 2)
        UiPop()
        UiPush()
            UiAlign("top center")
            UiTranslateToScreenCenter(0, 16)
            UiColor(1.0, 1.0, 1.0, 0.800000011920929)
            UiFont("bold.ttf", 27)
            UiText(p0)
        UiPop()
    UiPop()
end

function drawComponent_f442_6198_StatItem_442_6198(p1, p2)
    -- draw frame F442_6198_StatItem
    UiPush()
        UiColorFilter(1.0, 1.0, 1.0, 1)
        UiPush()
            UiTranslate(11.947021484375, 15.123976898193405)
            UiColor(1.0, 1.0, 1.0, 0.800000011920929)
            UiFont("regular.ttf", 27)
            UiText(p1)
        UiPop()
        UiPush()
        	UiAlign("top right")
            UiTranslate(970.228271484375, 15.388014984130905)
            UiColor(1.0, 1.0, 1.0, 1)
            UiFont("regular.ttf", 27)
            UiText(p2)
        UiPop()
    UiPop()
end


GameSettings = {}
GameSettings.listItems = {}
GameSettings.listItemsHost = {}
GameSettings.listItemsClient = {}

GameSettings.item1 = 
{
    w = 1008.0,
    h = 50.0,
    isDropdown = true,

    draw = function()
        local selectedItem = GameSettings.listItems[GameSettings.scrollBar.selectedIdx]
        if selectedItem ~= nil and selectedItem.isDropdown then
            GameSettings.alternateIcons = {{ ico = "[[menu:menu_accept;iconsize=42,42]]", txt = "loc@UI_CHANGE" }}
        end   

        if GameLanguage.dropDownData.isOpened then
            GameSettings.alternateIcons = 
            {
                { ico = "[[menu:menu_accept;iconsize=42,42]]", txt = "loc@UI_BUTTON_SELECT" },
                { ico = "[[menu:gamepad_dpad_updown;iconsize=42,42]]", txt = "loc@UI_CHANGE" }
            }
            if IsRunningOnSteam() then
                GameSettings.alternateIcons[2].ico = "[[menu:gamepad_dpad_up;iconsize=42,42]], [[menu:gamepad_dpad_down;iconsize=42,42]]"
            end
        end

        drawComponent_f218_285_Settings_layout_218_273(gameLanguageText, GameLanguage.dropDownData)
    end,
}
table.insert(GameSettings.listItems, GameSettings.item1)
table.insert(GameSettings.listItemsHost, GameSettings.item1)
table.insert(GameSettings.listItemsClient, GameSettings.item1)

GameSettings.item2 = 
{
    w = 1008.0,
    h = 110.0,

    draw = function(self)
        UiPush()
            enableArchipelagoTooltip.x = self.w + 100
            enableArchipelagoTooltip.y = 0
            UiColorFilter(1.0, 1.0, 1.0, 1)
            UiTranslate(0.0, 60.0)
            drawOptionsListItemWithStepper(enableArchipelagoText, stepperEnableArchipelagoParams, enableArchipelagoTooltip)
            UiTranslate(0.0, -60.0)
            drawComponent_f442_6190_LabelSetting_431_5156(ArchipelagoText)
        UiPop()
    end,
}
table.insert(GameSettings.listItems, GameSettings.item2)
table.insert(GameSettings.listItemsHost, GameSettings.item2)

if IsRunningOnIOS() then
    GameSettings.itemTouchLayoutVariant =
    {
        w = 1008.0,
        h = 50.0,

        draw = function(self)
            UiPush()
                drawOptionsListItemWithStepper(touchLayoutVariantText, stepperTouchLayoutVariantParams)
            UiPop()
        end,
    }
    table.insert(GameSettings.listItems, GameSettings.itemTouchLayoutVariant)
    table.insert(GameSettings.listItemsHost, GameSettings.itemTouchLayoutVariant)
    table.insert(GameSettings.listItemsClient, GameSettings.itemTouchLayoutVariant)
end

GameSettings.item3 = 
{
    w = 1008.0,
    h = 110.0,

    draw = function(self)
        -- draw frame F439_5832_item
        UiPush()
            UiColorFilter(1.0, 1.0, 1.0, 1)
            UiTranslate(0.0, 60.0)
            alarmTooltip.x = self.w + 100
            alarmTooltip.y = 0
            drawOptionsListItemWithStepper(alarmTimeText, stepperAlarmTimeParams, alarmTooltip)
            UiTranslate(0.0, -60.0)
            drawComponent_f442_6190_LabelSetting_431_5156(campaignLabelText)
        UiPop()
    end,
}
table.insert(GameSettings.listItems, GameSettings.item3)
table.insert(GameSettings.listItemsHost, GameSettings.item3)

GameSettings.item4 = 
{
    w = 1008.0,
    h = 50.0,

    draw = function(self)
        adjustAmmoTooltip.x = self.w + 100
        adjustAmmoTooltip.y = 0
        drawOptionsListItemWithStepper(ammoValueText, stepperAmmoValueParams, adjustAmmoTooltip)
    end,
}
table.insert(GameSettings.listItems, GameSettings.item4)
table.insert(GameSettings.listItemsHost, GameSettings.item4)

GameSettings.item5 = 
{
    w = 1008.0,
    h = 50.0,

    draw = function(self)
        adjustHealthTooltip.x = self.w + 100
        adjustHealthTooltip.y = 0
        drawOptionsListItemWithStepper(healthValueText, stepperHealthValueParams, adjustHealthTooltip)
    end,
}
table.insert(GameSettings.listItems, GameSettings.item5)
table.insert(GameSettings.listItemsHost, GameSettings.item5)

GameSettings.item6 = 
{
    w = 1008.0,
    h = 50.0,

    draw = function(self)
        missionSkippingTooltip.x = self.w + 100
        missionSkippingTooltip.y = 0
        drawOptionsListItemWithStepper(missionSkippingText, stepperMissionSkippingParams, missionSkippingTooltip)
    end,
}
table.insert(GameSettings.listItems, GameSettings.item6)
table.insert(GameSettings.listItemsHost, GameSettings.item6)

GameSettings.item7 = 
{
    w = 1008.0,
    h = 50.0,

    draw = function(self)
        allowSpawnTooltip.x = self.w + 100
        allowSpawnTooltip. y = 0
        drawOptionsListItemWithStepper(allowSpawnText, stepperAllowSpawnParams, allowSpawnTooltip)
    end,
}
table.insert(GameSettings.listItems, GameSettings.item7)
table.insert(GameSettings.listItemsHost, GameSettings.item7)

GameSettings.item8 = 
{
    w = 1008.0,
    h = 110.0,

    draw = function(self)
        -- draw frame F439_5833_item
        UiPush()
            unlockLevelsTooltip.x = self.w + 100
            unlockLevelsTooltip.y = 0
            UiColorFilter(1.0, 1.0, 1.0, 1)
            UiTranslate(0.0, 60.0)
            drawOptionsListItemWithStepper(unlockLevelsText, stepperUnlockLevelsParams, unlockLevelsTooltip)
            UiTranslate(0.0, -60.0)
            drawComponent_f442_6190_LabelSetting_431_5156(sandboxLabelText)
        UiPop()
    end,
}
table.insert(GameSettings.listItems, GameSettings.item8)
table.insert(GameSettings.listItemsHost, GameSettings.item8)

GameSettings.item9 = 
{
    w = 1008.0,
    h = 50.0,

    draw = function(self)
        unlockToolsTooltip.x = self.w + 100
        unlockToolsTooltip.y = 0
        drawOptionsListItemWithStepper(unlockToolsText, stepperUnlockToolsParams, unlockToolsTooltip)
    end,
}
table.insert(GameSettings.listItems, GameSettings.item9)
table.insert(GameSettings.listItemsHost, GameSettings.item9)

GameSettings.item10 = 
{
    w = 1008,
    h = 110,

    draw = function(self)
        miscTooltip.x = self.w + 100
        miscTooltip.y = 0
        UiTranslate(0.0, 60.0)
        drawOptionsListItemWithStepper(disableCharText, stepperDisableCharParams)
        UiTranslate(0.0, -60.0)
        drawComponent_f442_6190_LabelSetting_431_5156(miscLabelText)
    end,
}
if IsRunningOnPC() then
    table.insert(GameSettings.listItems, GameSettings.item10)
    table.insert(GameSettings.listItemsHost, GameSettings.item10)
    table.insert(GameSettings.listItemsClient, GameSettings.item10)
end


GameSettings.item11 = 
{
    w = 1008.0,
    h = 80.0,

    draw = function(self)
        -- draw frame F439_5833_item
        UiPush()
            multiplayerSubscriptionsTooltip.x = self.w + 100
            multiplayerSubscriptionsTooltip.y = 0
            UiColorFilter(1.0, 1.0, 1.0, 1)
            UiTranslate(0.0, 60.0)
            drawOptionsListItemWithStepper(multiplayerSubscriptionsText, stepperMultiplayerSubscriptionsParams, multiplayerSubscriptionsTooltip)
            UiTranslate(0.0, -60.0)
            drawComponent_f442_6190_LabelSetting_431_5156(multiplayerLabelText)
        UiPop()
    end,
}

table.insert(GameSettings.listItems, GameSettings.item11)
table.insert(GameSettings.listItemsHost, GameSettings.item11)
table.insert(GameSettings.listItemsClient, GameSettings.item11)

GameSettings.item12= 
{
    w = 1008,
    h = 260,

    draw = function(self)
        UiTranslate(0.0, 50.0)
        drawComponent_f442_6190_LabelSetting_431_5156(savegamesLabelText)
        UiTranslate(0.0, 60.0)
        drawComponent_f442_6198_StatItem_442_6198(missionsPlayedLabelText, missionsPlayedValueText)
        UiTranslate(0.0, 50.0)
        drawComponent_f442_6198_StatItem_442_6198(toolsUnlockedLabelText, toolsUnlockedValueText)
        UiTranslate(0.0, 50.0)
        drawComponent_f442_6198_StatItem_442_6198(totalScoreLabelText, totalScoreValueText)
    end,
}
table.insert(GameSettings.listItems, GameSettings.item12)
table.insert(GameSettings.listItemsHost, GameSettings.item12)

GameSettings.backGround = 
{
    w = 12.0,
    h = 485.0,

    draw = function(self)
        UiPush()
            UiColor(1, 1, 1, 1)
            UiImageBox("common/rect_c#525252_o1.00_cr4.png", self.w, self.h, 4, 4)
        UiPop()
    end,
}
GameSettings.thumb = 
{
    w = 8.0,
    h = 127.0,

    draw = function(self)
        UiPush()
            UiTranslate(2.0, 2.0)
            UiColor(1, 1, 1, 1)
            UiImageBox("common/rect_c#ffffff_o1.00_cr3.png", self.w, self.h, 3, 3)
        UiPop()
    end,
}

GameSettings.scrollBar = UiCreateScrollBar(GameSettings.thumb, GameSettings.backGround)
GameSettings.scrollBar.scrollbarOffset = 20

function drawGameOptionsHint()
    if LastInputDevice() == UI_DEVICE_MOUSE or LastInputDevice() == UI_DEVICE_TOUCHSCREEN then
        UiPush()
            local showSavePath = not IsRunningOnIOS()
            if showSavePath then
                UiAlign("top center")
            else
                UiTranslate(0, 70)
                UiAlign("middle center")
            end

            UiColor(0.8, 0.8, 0.8, 1)
            UiButtonHoverColor(1.25, 1.25, 0.625, 1)
            UiButtonImageBox("common/rect_c#000000_o0.00_sw1.50_sc#ffffff_so0.30_cr4.png", 6, 6, 1, 1, 1)
            
            if IsPlayerHost() then
                UiFont("regular.ttf", 27)
                if UiTextButton(resetProgressButtonParams.text, 271.5, 39.5) then
                    resetProgressButtonParams:onPressed()
                end

                if showSavePath then
                    UiTranslate(0, 45)
                    UiPush()
                        UiAlign("top center")
                        UiColor(0.8, 0.8, 0.8)
                        UiText("loc@UI_TEXT_YOUR_SAVEGAME", true)
                        UiText(GetString("game.savegamepath"))
                    UiPop()
                end
            end
        UiPop()
    else
        UiPush()
            UiTranslate(0, 70)
            UiColor(1, 1, 1, 1)

            local icons = GameSettings.actionIcons
            table.insert(icons, { ico = "[[menu:interact;iconsize=42,42]]", txt = "loc@UI_BUTTON_RESET_PROGRESS" })
            table.insert(icons, { ico = "[[menu:menu_cancel;iconsize=42,42]]", txt = "loc@UI_BACK" })	

            UiDrawHintsCentered(icons)

            if IsPlayerHost() then
                if InputPressed("interact") then
                    resetProgressButtonParams:onPressed()
                end
            end
        UiPop()
    end
end

GameSettings.actionIcons = nil
GameSettings.alternateIcons = nil

function drawGameOptions()
    GameStats:update()
    GameLanguage:update()

    -- determine correct action ico for gamepad hint
    GameSettings.actionIcons = {{ ico = "[[menu:gamepad_dpad_leftright;iconsize=42,42]]", txt = "loc@UI_CHANGE" }}
    if IsRunningOnSteam() then
        GameSettings.actionIcons = {{ ico = "[[menu:gamepad_dpad_left;iconsize=42,42]], [[menu:gamepad_dpad_right;iconsize=42,42]]", txt = "loc@UI_CHANGE" }}
    end

    if GameSettings.alternateIcons ~= nil then
        GameSettings.actionIcons = GameSettings.alternateIcons
        GameSettings.alternateIcons = nil
    end

    UiPush()
    	UiAlign("top left")
        UiTranslate(-495, -50)
        UiColorFilter(1.0, 1.0, 1.0, 1)
        -- draw frame F442_5999_Stats
        UiPush()
            UiTranslate(13.0, 86.0)
            local listHeight = LastInputDevice() == UI_DEVICE_GAMEPAD and 534 or 485
            GameSettings.scrollBar.background.h = listHeight

            if IsMultiplayer() then
                if IsPlayerHost() then
                    UiList(1008.0, listHeight, GameSettings.listItemsHost, GameSettings.scrollBar)
                else
                    UiList(1008.0, listHeight, GameSettings.listItemsClient, GameSettings.scrollBar)
                end
            else
                UiList(1008.0, listHeight, GameSettings.listItems, GameSettings.scrollBar)
            end
        UiPop()
        UiPush()
            UiTranslateToWindowCenter(0, 5)
            UiColor(1.0, 1.0, 1.0, 0.800000011920929)
            UiFont("regular.ttf", 22)
            UiPush()
                UiAlign("center")
                UiWordWrap(1008.0)
                UiTextAlignment("center")
                UiText(gameTabDescriptionText)
            UiPop()
        UiPop()

        UiTranslateToScreenCenter(0, 600)
        drawGameOptionsHint()
    UiPop()
end