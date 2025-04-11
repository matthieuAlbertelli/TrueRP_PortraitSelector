-- dropdowns.lua

local M = {}

local Const = TrueRP.PortraitSelector.Constants
local State = TrueRP.PortraitSelector.State
local Gallery = TrueRP.PortraitSelector.Gallery

-- Utilitaire : ajoute une entrée à un menu déroulant
local function AddDropdownEntry(text, onClick)
    local info = UIDropDownMenu_CreateInfo()
    info.text = text
    info.func = onClick
    UIDropDownMenu_AddButton(info)
end

-- Utilitaire : met à jour l’état, réinitialise d’autres valeurs, rafraîchit
local function SetDropdownAndReset(opts)
    State[opts.key] = opts.value
    UIDropDownMenu_SetText(opts.dropdown, opts.value)

    if opts.reset then
        for _, key in ipairs(opts.reset) do
            State[key] = nil
            if opts.resetFrames and opts.resetFrames[key] then
                UIDropDownMenu_SetText(opts.resetFrames[key], "")
            end
        end
    end

    if opts.refreshGallery then
        Gallery.UpdateGallery()
    end

    if opts.after then
        opts.after()
    end
end

-- Utilitaire : génère une liste déroulante dynamique
local function GenerateDropdown(sourceList, opts)
    UIDropDownMenu_ClearAll(opts.dropdown)
    for _, entry in ipairs(sourceList) do
        AddDropdownEntry(entry, function()
            SetDropdownAndReset({
                key = opts.stateKey,
                value = entry,
                dropdown = opts.dropdown,
                reset = opts.reset,
                resetFrames = opts.resetFrames,
                refreshGallery = opts.refreshGallery,
                after = opts.after
            })
        end)
    end
end

-- 🎚 Genre
function M.InitGender()
    GenerateDropdown(Const.GENDERS, {
        stateKey = "gender",
        dropdown = GenderDropDown,
        reset = { "race", "class" },
        resetFrames = {
            race = RaceDropDown,
            class = ClassDropDown
        },
        refreshGallery = true
    })
end

-- 🧬 Race
function M.InitRace()
    if State.gender == "Familier" then
        return GenerateDropdown(Const.CREATURE_TYPES, {
            stateKey = "race",
            dropdown = RaceDropDown,
            reset = { "class" },
            resetFrames = { class = ClassDropDown },
            refreshGallery = true,
            after = function()
                UIDropDownMenu_Initialize(ClassDropDown, M.InitClass)
            end
        })
    end

    GenerateDropdown(Const.RACES, {
        stateKey = "race",
        dropdown = RaceDropDown,
        reset = { "class" },
        resetFrames = { class = ClassDropDown },
        refreshGallery = true
    })
end

-- 🛡 Classe
function M.InitClass()
    UIDropDownMenu_ClearAll(ClassDropDown)
    if not State.race then return end

    if State.gender == "Familier" then
        local source = State.race == "Démon" and Const.DEMON_TYPES
            or State.race == "Bête" and Const.BEAST_TYPES
            or {}
        return GenerateDropdown(source, {
            stateKey = "class",
            dropdown = ClassDropDown,
            refreshGallery = true
        })
    end

    local classList = Const.CLASSES_BY_RACE[State.race]
    if classList then
        GenerateDropdown(classList, {
            stateKey = "class",
            dropdown = ClassDropDown,
            refreshGallery = true
        })
    end
end

-- 🎯 Cible (Joueur / familiers)
function M.InitTargetType()
    local playerName = UnitName("player")
    local currentPet = UnitName("pet")
    local pets = CustomPortraitDB[playerName] and CustomPortraitDB[playerName].pets or {}

    -- Joueur
    AddDropdownEntry(playerName .. " (Joueur)", function()
        State.target = "Joueur"
        UIDropDownMenu_SetText(TargetTypeDropDown, playerName .. " (Joueur)")
    end)

    local added = {}

    -- Familiers enregistrés
    for petName in pairs(pets) do
        local isCurrent = (currentPet and petName == currentPet)
        local label = isCurrent and "|cff00ff00" .. petName .. "|r" or petName
        AddDropdownEntry(label, function()
            State.target = petName
            UIDropDownMenu_SetText(TargetTypeDropDown, petName)
        end)
        added[petName] = true
    end

    -- Pet actuel non enregistré
    if currentPet and not added[currentPet] then
        AddDropdownEntry("|cff00ff00" .. currentPet .. "|r", function()
            State.target = currentPet
            UIDropDownMenu_SetText(TargetTypeDropDown, currentPet)
        end)
    end

    -- Affichage sélectionné
    if State.target == "Joueur" then
        UIDropDownMenu_SetText(TargetTypeDropDown, playerName .. " (Joueur)")
    elseif currentPet then
        UIDropDownMenu_SetText(TargetTypeDropDown, currentPet)
    end
end

-- 🔗 Export
TrueRP = TrueRP or {}
TrueRP.PortraitSelector = TrueRP.PortraitSelector or {}
TrueRP.PortraitSelector.Dropdowns = M
