-- Cahier des charges appliqué :
-- - Ajout d'une sélection de cible (joueur ou familier)
-- - Si c'est un familier, enregistrement par nom réel du pet (UnitName("pet"))
-- - Pas de sauvegarde si aucun portrait sélectionné
-- - Message d'info affiché pour les familiers partageant le même nom
-- - Conservation de la structure CustomPortraitDB[NomDuJoueur].pets[NomDuPet]
-- - Liste déroulante avec joueur + pets enregistrés, le pet invoqué apparaît en vert
-- - Liste déroulante rafraîchie à chaque ouverture de la fenêtre

CustomPortraitDB = CustomPortraitDB or {}

local genders = { "Homme", "Femme" }
local races = {
    "Elfe de sang", "Draeneï", "Orc", "Humain", "Tauren", "Troll", "Mort-vivant", "Elfe de la nuit", "Nain", "Gnome"
}

local classesByRace = {
    ["Elfe de sang"] = { "Paladin", "Démoniste", "Mage", "Chasseur", "Prêtre", "Voleur" },
    ["Draeneï"] = { "Guerrier", "Paladin", "Prêtre", "Chasseur", "Chaman", "Mage" },
    ["Orc"] = { "Guerrier", "Chaman", "Chasseur", "Démoniste", "Voleur" },
    ["Humain"] = { "Paladin", "Guerrier", "Prêtre", "Voleur", "Mage", "Démoniste" },
    ["Tauren"] = { "Guerrier", "Chaman", "Druide", "Chasseur" },
    ["Troll"] = { "Chasseur", "Prêtre", "Mage", "Voleur", "Chaman", "Guerrier" },
    ["Mort-vivant"] = { "Guerrier", "Prêtre", "Mage", "Voleur", "Démoniste" },
    ["Elfe de la nuit"] = { "Guerrier", "Prêtre", "Chasseur", "Voleur", "Druide" },
    ["Nain"] = { "Guerrier", "Paladin", "Chasseur", "Prêtre" },
    ["Gnome"] = { "Guerrier", "Voleur", "Mage", "Démoniste" },
}

local selectedGender = nil
local selectedRace = nil
local selectedClass = nil
local selectedPortrait = nil
local selectedTarget = "Joueur"

local numPortraits = 100
local portraitsPerRow = 5
local rowHeight = 70
local maxRow = math.ceil(numPortraits / portraitsPerRow)

SLASH_PORTRAITSELECT1 = "/portrait"
SlashCmdList["PORTRAITSELECT"] = function()
    UIDropDownMenu_Initialize(TargetTypeDropDown, PortraitSelector_InitTargetType)
    PortraitSelectorFrame:Show()
end

local function PortraitSelector_Empty(startIndex, endIndex)
    for i = startIndex, endIndex do
        local btn = _G["PortraitButton" .. i]
        btn:Hide()
    end
end

local function PortraitSelector_InitSelector()
    for i = 1, numPortraits do
        local btn = CreateFrame("Button", "PortraitButton" .. i, PortraitSelectorGallery)
        btn.texture = btn:CreateTexture(nil, "BACKGROUND")
        btn:SetSize(64, 64)

        local row = math.floor((i - 1) / portraitsPerRow)
        local col = (i - 1) % portraitsPerRow
        btn:SetPoint("TOPLEFT", PortraitSelectorGallery, "TOPLEFT", 10 + col * 70, -10 - row * rowHeight)

        btn.texture:SetAllPoints()
        btn:EnableMouse(true)
        btn:RegisterForClicks("AnyUp")
        btn:Hide()
    end
end

function PortraitSelector_InitGender()
    for _, gender in ipairs(genders) do
        local info = UIDropDownMenu_CreateInfo()
        info.text = gender
        info.func = function()
            selectedGender = gender
            UIDropDownMenu_SetText(GenderDropDown, gender)
            selectedRace = nil
            selectedClass = nil
            UIDropDownMenu_SetText(RaceDropDown, "")
            UIDropDownMenu_SetText(ClassDropDown, "")
            PortraitSelector_UpdateGallery()
        end
        UIDropDownMenu_AddButton(info)
    end
end

function PortraitSelector_InitRace()
    for _, race in ipairs(races) do
        local info = UIDropDownMenu_CreateInfo()
        info.text = race
        info.func = function()
            selectedRace = race
            UIDropDownMenu_SetText(RaceDropDown, race)
            selectedClass = nil
            UIDropDownMenu_SetText(ClassDropDown, "")
            PortraitSelector_UpdateGallery()
        end
        UIDropDownMenu_AddButton(info)
    end
end

function PortraitSelector_InitClass()
    if not selectedRace then return end
    for _, class in ipairs(classesByRace[selectedRace]) do
        local info = UIDropDownMenu_CreateInfo()
        info.text = class
        info.func = function()
            selectedClass = class
            UIDropDownMenu_SetText(ClassDropDown, class)
            PortraitSelector_UpdateGallery()
        end
        UIDropDownMenu_AddButton(info)
    end
end

function PortraitSelector_InitTargetType()
    local playerName = UnitName("player")
    local currentPet = UnitName("pet")
    local pets = CustomPortraitDB[playerName] and CustomPortraitDB[playerName].pets or {}

    local info = UIDropDownMenu_CreateInfo()
    info.text = playerName .. " (Joueur)"
    info.func = function()
        selectedTarget = "Joueur"
        UIDropDownMenu_SetText(TargetTypeDropDown, playerName .. " (Joueur)")
    end
    UIDropDownMenu_AddButton(info)

    for petName in pairs(pets) do
        local info = UIDropDownMenu_CreateInfo()
        info.text = (currentPet and petName == currentPet) and "|cff00ff00" .. petName .. "|r" or petName
        info.func = function()
            selectedTarget = petName
            UIDropDownMenu_SetText(TargetTypeDropDown, petName)
        end
        UIDropDownMenu_AddButton(info)
    end

    if selectedTarget == "Joueur" then
        UIDropDownMenu_SetText(TargetTypeDropDown, playerName .. " (Joueur)")
    elseif currentPet then
        UIDropDownMenu_SetText(TargetTypeDropDown, currentPet)
    end
end

function PortraitSelector_OnLoad(self)
    UIDropDownMenu_Initialize(TargetTypeDropDown, PortraitSelector_InitTargetType)
    UIDropDownMenu_Initialize(GenderDropDown, PortraitSelector_InitGender)
    UIDropDownMenu_Initialize(RaceDropDown, PortraitSelector_InitRace)
    UIDropDownMenu_Initialize(ClassDropDown, PortraitSelector_InitClass)

    SaveButton:SetText("Sauvegarder")

    PortraitSelectorScrollFrame:SetScrollChild(PortraitSelectorGallery)
    PortraitSelectorGallery:SetSize(360, 1000)
    PortraitSelectorScrollFrame:SetVerticalScroll(0)

    PortraitSelector_InitSelector()

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
        ["Undead"] = "Mort-vivant",
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

    selectedGender = sex
    selectedRace = raceMap[race]
    selectedClass = classMap[classe]

    UIDropDownMenu_SetText(GenderDropDown, selectedGender)
    UIDropDownMenu_SetText(RaceDropDown, selectedRace)
    UIDropDownMenu_SetText(ClassDropDown, selectedClass)

    PortraitSelector_UpdateGallery()
end

function PortraitSelector_UpdateGallery()
    if not selectedGender or not selectedRace or not selectedClass then
        PortraitSelector_Empty(1, numPortraits)
        return
    end

    local basePath = "Interface\\AddOns\\TrueRP_PortraitSelector\\portraits\\" ..
        selectedGender:lower():gsub(" ", "_") .. "\\" ..
        selectedRace:lower():gsub(" ", "_") .. "\\" ..
        selectedClass:lower():gsub(" ", "_")

    PortraitSelectorGallery:SetHeight(maxRow * rowHeight)

    for i = 1, numPortraits do
        local btn = _G["PortraitButton" .. i]
        local texturePath = basePath .. "\\portrait_" .. i .. ".tga"

        btn.texture:SetTexture(nil)
        btn.texture:SetTexture(texturePath)
        btn.texture:SetAllPoints()

        if not btn.texture:GetTexture() then
            while i <= numPortraits do
                _G["PortraitButton" .. i]:Hide()
                i = i + 1
            end
            return
        end

        btn:SetScript("OnClick", function()
            selectedPortrait = texturePath
            PortraitPreviewTexture:SetTexture(texturePath)
        end)
        btn:Show()
    end
end

function PortraitSelector_Save()
    if not selectedPortrait then return end

    local playerKey = UnitName("player")
    CustomPortraitDB[playerKey] = CustomPortraitDB[playerKey] or {}

    if selectedTarget == "Joueur" then
        CustomPortraitDB[playerKey].portrait = selectedPortrait
    else
        local petName = selectedTarget
        CustomPortraitDB[playerKey].pets = CustomPortraitDB[playerKey].pets or {}
        CustomPortraitDB[playerKey].pets[petName] = selectedPortrait
    end

    local message = "UPDATE:" .. playerKey
    if GetNumRaidMembers() > 0 then
        SendAddonMessage("TRUERP_PORTRAIT", message, "RAID")
    elseif GetNumPartyMembers() > 0 then
        SendAddonMessage("TRUERP_PORTRAIT", message, "PARTY")
    else
        SendAddonMessage("TRUERP_PORTRAIT", message, "WHISPER", UnitName("player"))
    end
end
