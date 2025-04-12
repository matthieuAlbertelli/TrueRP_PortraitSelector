CustomPortraitDB = CustomPortraitDB or {}

-- Aliases de modules
local Dropdowns = TrueRP.PortraitSelector.Dropdowns
local Gallery = TrueRP.PortraitSelector.Gallery
local State = TrueRP.PortraitSelector.State

SLASH_PORTRAITSELECT1 = "/portrait"
SlashCmdList["PORTRAITSELECT"] = function()
    UIDropDownMenu_Initialize(TargetTypeDropDown, function(self)
        Dropdowns.InitDropdown("playerControlled", self)
    end)
    PortraitSelectorFrame:Show()
end

function PortraitSelector_OnLoad(self)
    UIDropDownMenu_Initialize(TargetTypeDropDown, function(self)
        Dropdowns.InitDropdown("playerControlled", self)
    end)
    UIDropDownMenu_Initialize(GenderDropDown, function(self)
        Dropdowns.InitDropdown("gender", self)
    end)
    UIDropDownMenu_Initialize(RaceDropDown, function(self)
        Dropdowns.InitDropdown("race", self)
    end)
    UIDropDownMenu_Initialize(ClassDropDown, function(self)
        Dropdowns.InitDropdown("class", self)
    end)

    SaveButton:SetText("Sauvegarder")

    PortraitSelectorScrollFrame:SetScrollChild(PortraitSelectorGallery)
    PortraitSelectorGallery:SetSize(360, 1000)
    PortraitSelectorScrollFrame:SetVerticalScroll(0)

    Gallery.InitSelector()

    local race, classe = UnitRace("player"), UnitClass("player")
    local sex = UnitSex("player") == 2 and "Homme" or "Femme"

    local raceMap = {
        ["Blood Elf"] = "Elfe de sang",
        ["Orc"] = "Orc",
        ["Human"] = "Humain",
        ["Draenei"] = "Draeneï",
        ["Night Elf"] = "Elfe de la nuit",
        ["Tauren"] = "Tauren",
        ["Gnome"] = "Gnome",
        ["Troll"] = "Troll",
        ["Undead"] = "Réprouvé",
        ["Dwarf"] = "Nain"
    }

    local classMap = {
        ["Paladin"] = "Paladin",
        ["Hunter"] = "Chasseur",
        ["Warrior"] = "Guerrier",
        ["Shaman"] = "Chaman",
        ["Mage"] = "Mage",
        ["Warlock"] = "Démoniste",
        ["Rogue"] = "Voleur",
        ["Priest"] = "Prêtre",
        ["Druid"] = "Druide"
    }

    State.gender = sex
    State.race = raceMap[race]
    State.class = classMap[classe]

    UIDropDownMenu_SetText(GenderDropDown, State.gender)
    UIDropDownMenu_SetText(RaceDropDown, State.race)
    UIDropDownMenu_SetText(ClassDropDown, State.class)

    Gallery.UpdateGallery()
end
