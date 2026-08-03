#include "activities.lua"
#include "ui/ui_extensions.lua"
#include "common_components.lua"

gameTabDescriptionText = ""

savegamesLabelText = ""

missionsPlayedLabelText = ""
missionsPlayedValueText = ""

toolsUnlockedLabelText = ""
toolsUnlockedValueText = ""

totalScoreLabelText = ""
totalScoreValueText = ""

gameLanguageText = ""

GameStats = {}

ArchipelagoText = ""
enableArchipelagoText = ""
stepperEnableArchipelagoParams = {}
enableArchipelagoTooltip = {}

GameLanguage = {}

touchLayoutVariantText = ""
stepperTouchLayoutVariantParams = {}

alarmTimeText = ""
stepperAlarmTimeParams = {}
alarmTooltip = {}

campaignLabelText = ""

ammoValueText = ""
stepperAmmoValueParams = {}
adjustAmmoTooltip = {}

healthValueText = ""
stepperHealthValueParams = {}
adjustHealthTooltip = {}


missionSkippingText = "loc@UI_TEXT_MISSION_SKIPPING"
stepperMissionSkippingParams = {}
missionSkippingTooltip = {}

allowSpawnText = ""
stepperAllowSpawnParams = {}
allowSpawnTooltip = {}

unlockLevelsText = ""
stepperUnlockLevelsParams = {}
unlockLevelsTooltip = {}

sandboxLabelText = ""

unlockToolsText = ""
stepperUnlockToolsParams = {}
unlockToolsTooltip = {}
resetProgressButtonParams = {}

miscLabelText = ""
stepperDisableCharParams = {}
disableCharText = ""
miscTooltip = {}

multiplayerLabelText = ""
stepperMultiplayerSubscriptionsParams = {}
multiplayerSubscriptionsText = ""
multiplayerSubscriptionsTooltip = {}

resetProgressWarningParams = {}

resetProgressDialogState = {}

function game_options_logic_init()
    gameTabDescriptionText = "loc@UI_TEXT_WE_HAVE"

    savegamesLabelText = "loc@UI_BUTTON_SAVEGAME"


    missionsPlayedLabelText = "loc@UI_TEXT_MISSIONS_PLAYED"
    missionsPlayedValueText = ""

    toolsUnlockedLabelText = "loc@UI_TEXT_TOOLS_UNLOCKED"
    toolsUnlockedValueText = ""

    totalScoreLabelText = "loc@UI_TEXT_TOTAL_SCORE"
    totalScoreValueText = ""

    GameStats = 
    {
        totalScore = 0,
        missionCount = 0,
        missions = {},
        tools = {},

        update = function(self)
            self.tools = ListKeys("savegame.tool")
            self.missions = ListKeys("savegame.mission")
            self.missionCount = 0
            self.totalScore = 0
            for i=1,#self.missions do
                local s = GetInt("savegame.mission."..self.missions[i]..".score")
                if s > 0 then
                    self.totalScore = self.totalScore + s
                    self.missionCount = self.missionCount + 1
                end
            end

            missionsPlayedValueText = tostring(self.missionCount)
            toolsUnlockedValueText = tostring(#self.tools)
            totalScoreValueText = tostring(self.totalScore)
        end
    }

    ArchipelagoText = "Archipelago"
    enableArchipelagoText = "Enable Archipelago"
    stepperEnableArchipelagoParams = 
    {
        currentIdx = GetInt("options.game.archipelago.enabled") + 1,
        allValues = {"loc@UI_BUTTON_ENABLED", "loc@UI_BUTTON_DISABLED"},
        isCyclic = false,

        getCurrentValue = function(self)
            return self.allValues[self.currentIdx]
        end,

        onNext = function(self)
            self.currentIdx = self.currentIdx + 1
            if self.currentIdx > #self.allValues then
                self.currentIdx = 1
            end
            SetInt("options.game.archipelago.enabled", self.currentIdx - 1)
        end,

        onPrev = function(self)
            self.currentIdx = self.currentIdx - 1
            if self.currentIdx < 1 then
                self.currentIdx = #self.allValues
            end
            SetInt("options.game.archipelago.enabled", self.currentIdx - 1)
        end,
    }

    enableArchipelagoTooltip = 
    {
        header = "Enable Archipelago",
        description = "If Disabled, this allows you to load the base campaign without the mod interfering. The mod will NOT work properly (or save) if disabled, and the campaign will NOT work properly if enabled ."
    }

    GameLanguage = {}

    gameLanguageText = "loc@LANGUAGE"
    GameLanguage.dropDownData = UiCreateDropDownState()
    GameLanguage.dropDownData.values = 
    { 
        "loc@UI_ENGLISH", 
        "loc@UI_FRENCH", 
        "loc@UI_SPANISH", 
        "loc@UI_ITALIAN",
        "loc@UI_GERMAN",
        "loc@UI_SCHINESE",
        "loc@UI_JAPANESE",
        "loc@UI_RUSSIAN",
        "loc@UI_POLISH"
    }

    GameLanguage.dropDownData.selectedIdx = GetInt("options.language") + 1

    GameLanguage.dropDownData.onSelectionChanged = function(self, idx)
        SetInt("options.language", self.selectedIdx - 1)
        LoadLanguageTable(self.selectedIdx - 1)
    end

    GameLanguage.update = function(self)
        self.dropDownData.selectedIdx = GetInt("options.language") + 1
    end


    touchLayoutVariantText = "Touch Layout Variant"
    stepperTouchLayoutVariantParams =
    {
        currentIdx = UiGetTouchLayoutVariant(),
        allValues = { "0", "1", "2" },
        configValues = { 0, 1, 2 },
        isCyclic = false,

        getCurrentValue = function(self)
            return self.allValues[self.currentIdx]
        end,

        onNext = function(self)
            self.currentIdx = self.currentIdx + 1
            if self.currentIdx > #self.allValues then
                self.currentIdx = 1
            end
            UiSetTouchLayoutVariant(self.configValues[self.currentIdx])
        end,

        onPrev = function(self)
            self.currentIdx = self.currentIdx - 1
            if self.currentIdx < 1 then
                self.currentIdx = #self.allValues
            end
            UiSetTouchLayoutVariant(self.configValues[self.currentIdx])
        end
    }
    for i=1,#stepperTouchLayoutVariantParams.configValues do
        if UiGetTouchLayoutVariant() == stepperTouchLayoutVariantParams.configValues[i] then
            stepperTouchLayoutVariantParams.currentIdx = i
            break
        end
    end


    alarmTimeText = "loc@UI_TEXT_ADJUST_ALARM"
    stepperAlarmTimeParams = 
    {
        currentIdx = 3,
        allValues = { "loc@N_SECONDS_HARD, -20", "loc@N_SECONDS_HARD, -10", "loc@UI_BUTTON_DISABLED", "loc@N_SECONDS, +15", "loc@N_SECONDS, +30", "loc@N_SECONDS, +60"},
        configValues = { -20, -10, 0, 15, 30, 60 },
        isCyclic = false,

        getCurrentValue = function(self)
            return self.allValues[self.currentIdx]
        end,

        onNext = function(self)
            self.currentIdx = self.currentIdx + 1
            if self.currentIdx > #self.allValues then
                self.currentIdx = 1
            end
            SetInt("options.game.campaign.time", self.configValues[self.currentIdx])
        end,

        onPrev = function(self)
            self.currentIdx = self.currentIdx - 1
            if self.currentIdx < 1 then
                self.currentIdx = #self.allValues
            end
            SetInt("options.game.campaign.time", self.configValues[self.currentIdx])
        end,
    }
    for i=1,#stepperAlarmTimeParams.configValues do
        if GetInt("options.game.campaign.time") == stepperAlarmTimeParams.configValues[i] then
            stepperAlarmTimeParams.currentIdx = i
            break
        end
    end

    alarmTooltip =
    { 
        header = "loc@UI_TEXT_ADJUST_ALARM", 
        description = "loc@UI_TOOLTIP_TIME"
    }


    campaignLabelText = "loc@CAMPAIGN"

    ammoValueText = "loc@UI_TEXT_ADJUST_AMMO"
    stepperAmmoValueParams = 
    {
        currentIdx = 1,
        allValues = { "loc@UI_BUTTON_NO_AMMO", "loc@UI_BUTTON_DISABLED", "+50%" ,"+100%" },
        configValues = { -1, 0, 50, 100},
        isCyclic = false,

        getCurrentValue = function(self)
            return self.allValues[self.currentIdx]
        end,

        onNext = function(self)
            self.currentIdx = self.currentIdx + 1
            if self.currentIdx > #self.allValues then
                self.currentIdx = 1
            end
            SetInt("options.game.campaign.ammo", self.configValues[self.currentIdx])
        end,

        onPrev = function(self)
            self.currentIdx = self.currentIdx - 1
            if self.currentIdx < 1 then
                self.currentIdx = #self.allValues
            end
            SetInt("options.game.campaign.ammo", self.configValues[self.currentIdx])
        end
    }
    for i=1,#stepperAmmoValueParams.configValues do
        if GetInt("options.game.campaign.ammo") == stepperAmmoValueParams.configValues[i] then
            stepperAmmoValueParams.currentIdx = i
            break
        end
    end

    adjustAmmoTooltip =
    { 
        header = "loc@UI_TEXT_ADJUST_AMMO", 
        description = "loc@UI_TOOLTIP_ADJUST_THE_AMMO"
    }


    healthValueText = "loc@UI_TEXT_ADJUST_HEALTH"
    stepperHealthValueParams = 
    {
        currentIdx = GetInt("options.game.campaign.health") / 50 + 2,
        allValues = {"-50%", "loc@UI_BUTTON_DISABLED", "+50%", "+100%"},
        isCyclic = false,

        getCurrentValue = function(self)
            return self.allValues[self.currentIdx]
        end,

        onNext = function(self)
            self.currentIdx = self.currentIdx + 1
            if self.currentIdx > #self.allValues then
                self.currentIdx = 1
            end
            SetInt("options.game.campaign.health", (self.currentIdx - 2) * 50)
        end,

        onPrev = function(self)
            self.currentIdx = self.currentIdx - 1
            if self.currentIdx < 1 then
                self.currentIdx = #self.allValues
            end
            SetInt("options.game.campaign.health", (self.currentIdx - 2) * 50)
        end,
    }

    adjustHealthTooltip = 
    {
        header = "loc@UI_TEXT_ADJUST_HEALTH",
        description = "loc@UI_TOOLTIP_ADJUST_THE_HEALTH"
    }


    missionSkippingText = "loc@UI_TEXT_MISSION_SKIPPING"
    stepperMissionSkippingParams = 
    {
        currentIdx = GetInt("options.game.missionskipping") + 1,
        allValues = {"loc@UI_BUTTON_DISABLED", "loc@UI_BUTTON_ENABLED"},
        isCyclic = false,

        getCurrentValue = function(self)
            return self.allValues[self.currentIdx]
        end,

        onNext = function(self)
            self.currentIdx = self.currentIdx + 1
            if self.currentIdx > #self.allValues then
                self.currentIdx = 1
            end
            SetInt("options.game.missionskipping", self.currentIdx - 1)
        end,

        onPrev = function(self)
            self.currentIdx = self.currentIdx - 1
            if self.currentIdx < 1 then
                self.currentIdx = #self.allValues
            end
            SetInt("options.game.missionskipping", self.currentIdx - 1)
        end,
    }

    missionSkippingTooltip = 
    {
        header = "loc@UI_TEXT_MISSION_SKIPPING",
        description = "loc@UI_TOOLTIP_SKIP_MISSION"
    }


    allowSpawnText = "loc@UI_TEXT_ALLOW_SPAWN_CREATIVE"
    stepperAllowSpawnParams = 
    {
        currentIdx = GetInt("options.game.spawn") + 1,
        allValues = {"loc@UI_BUTTON_DISABLED", "loc@UI_BUTTON_ENABLED"},
        isCyclic = false,

        getCurrentValue = function(self)
            return self.allValues[self.currentIdx]
        end,

        onNext = function(self)
            self.currentIdx = self.currentIdx + 1
            if self.currentIdx > #self.allValues then
                self.currentIdx = 1
            end
            SetInt("options.game.spawn", self.currentIdx - 1)
        end,

        onPrev = function(self)
            self.currentIdx = self.currentIdx - 1
            if self.currentIdx < 1 then
                self.currentIdx = #self.allValues
            end
            SetInt("options.game.spawn", self.currentIdx - 1)
        end,
    }

    allowSpawnTooltip = 
    {   
        header = "loc@UI_TEXT_ALLOW_SPAWN_CREATIVE",
        description = "loc@DESCRIPTION_ALLOW_SPAWN_CREATIVE"
    }

    unlockLevelsText = "loc@UI_TEXT_UNLOCK_ALL_LEVELS"
    stepperUnlockLevelsParams = 
    {
        currentIdx = GetInt("options.game.sandbox.unlocklevels") + 1,
        allValues = {"loc@UI_BUTTON_DISABLED", "loc@UI_BUTTON_ENABLED"},
        isCyclic = false,

        getCurrentValue = function(self)
            return self.allValues[self.currentIdx]
        end,

        onNext = function(self)
            self.currentIdx = self.currentIdx + 1
            if self.currentIdx > #self.allValues then
                self.currentIdx = 1
            end
            SetInt("options.game.sandbox.unlocklevels", self.currentIdx - 1)
        end,

        onPrev = function(self)
            self.currentIdx = self.currentIdx - 1
            if self.currentIdx < 1 then
                self.currentIdx = #self.allValues
            end
            SetInt("options.game.sandbox.unlocklevels", self.currentIdx - 1)
        end,
    }

    unlockLevelsTooltip = 
    {
        header = "loc@UI_TEXT_UNLOCK_ALL_LEVELS",
        description = "loc@UI_TOOLTIP_UNLOCK_ALL_LEVELS"
    }

    sandboxLabelText = "loc@SANDBOX"

    unlockToolsText = "loc@UI_BUTTON_UNLOCK_ALL_TOOLS"
    stepperUnlockToolsParams = 
    {
        currentIdx = GetInt("options.game.sandbox.unlocktools") + 1,
        allValues = {"loc@UI_BUTTON_DISABLED", "loc@UI_BUTTON_ENABLED"},
        isCyclic = false,

        getCurrentValue = function(self)
            return self.allValues[self.currentIdx]
        end,

        onNext = function(self)
            self.currentIdx = self.currentIdx + 1
            if self.currentIdx > #self.allValues then
                self.currentIdx = 1
            end
            SetInt("options.game.sandbox.unlocktools", self.currentIdx - 1)
        end,

        onPrev = function(self)
            self.currentIdx = self.currentIdx - 1
            if self.currentIdx < 1 then
                self.currentIdx = #self.allValues
            end
            SetInt("options.game.sandbox.unlocktools", self.currentIdx - 1)
        end,
    }

    unlockToolsTooltip = 
    {
        header = "loc@UI_BUTTON_UNLOCK_ALL_TOOLS",
        description = "loc@UI_TOOLTIP_UNLOCK_ALL_TOOLS"
    }

    miscLabelText = "loc@UI_SETTINGS_MISC"
    disableCharText = "loc@UI_SETTINGS_DISABLE_CHAR"
    stepperDisableCharParams = 
    {
        currentIdx = GetInt("options.game.disable_character_in_vehicle") == 0 and 2 or 1,
        allValues = {"loc@UI_BUTTON_DISABLED", "loc@UI_BUTTON_ENABLED"},
        isCyclic = false,

        getCurrentValue = function(self)
            return self.allValues[self.currentIdx]
        end,

        onNext = function(self)
            self.currentIdx = self.currentIdx + 1
            if self.currentIdx > #self.allValues then
                self.currentIdx = 1
            end
            SetInt("options.game.disable_character_in_vehicle", 0)
        end,

        onPrev = function(self)
            self.currentIdx = self.currentIdx - 1
            if self.currentIdx < 1 then
                self.currentIdx = #self.allValues
            end
            SetInt("options.game.disable_character_in_vehicle", 1)
        end,
    }

    multiplayerLabelText = "loc@UI_SETTINGS_MULTIPLAYER"
    multiplayerSubscriptionsText = "loc@UI_SETTINGS_MULTIPLAYER_SUBSCRIPTIONS"
    stepperMultiplayerSubscriptionsParams = 
    {
        currentIdx = GetInt("options.multiplayer.keepsubscriptions") + 1,
        allValues = {"loc@UI_BUTTON_DISABLED", "loc@UI_BUTTON_ENABLED"},
        isCyclic = false,

        getCurrentValue = function(self)
            return self.allValues[self.currentIdx]
        end,

        onNext = function(self)
            self.currentIdx = self.currentIdx + 1
            if self.currentIdx > #self.allValues then
                self.currentIdx = 1
            end
            SetInt("options.multiplayer.keepsubscriptions", self.currentIdx - 1)
        end,

        onPrev = function(self)
            self.currentIdx = self.currentIdx - 1
            if self.currentIdx < 1 then
                self.currentIdx = #self.allValues
            end
            SetInt("options.multiplayer.keepsubscriptions", self.currentIdx - 1)
        end,
    }

    multiplayerSubscriptionsTooltip = 
    {
        header = "loc@UI_SETTINGS_MULTIPLAYER_SUBSCRIPTIONS",
        description = "loc@UI_SETTINGS_MULTIPLAYER_SUBSCRIPTIONS_TOOLTIP"
    }

    local resetProgressDialog = Teardown.WarningDialog
    {
        warningNote = { text = "loc@UI_TEXT_ARE_YOU_UPPERCASE" },
        warningDetails = { text = "loc@UI_TEXT_IF_YOU_0" },

        onAccept = function(self)
            self:hide()

            local keys = ListKeys("savegame")
            for i=1, #keys do
                    if keys[i] ~= "waseulav2shown" then
                    ClearKey("savegame."..keys[i])
                end
            end

            resetActivities()

            if not GetBool("game.menu.active") then
                Menu()
            end
        end,

        onCancel = function(self)
            self:hide()
        end
    }

    resetProgressButtonParams = 
    {
        text = "loc@UI_BUTTON_RESET_PROGRESS",

        onPressed = function(self)
            resetProgressDialog:show()
        end,
    }
end

game_options_logic_init()