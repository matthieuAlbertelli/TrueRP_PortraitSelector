-- dropdowns.lua

local M = {}

local Const = TrueRP.PortraitSelector.Constants
local State = TrueRP.PortraitSelector.State
local Gallery = TrueRP.PortraitSelector.Gallery

function M.InitGender()
    for _, gender in ipairs(Const.GENDERS) do
        local info = UIDropDownMenu_CreateInfo()
        info.text = gender
        info.func = function()
            State.gender = gender
            UIDropDownMenu_SetText(GenderDropDown, gender)
            State.race = nil
            State.class = nil
            UIDropDownMenu_SetText(RaceDropDown, "")
            UIDropDownMenu_SetText(ClassDropDown, "")
            Gallery.UpdateGallery()
        end
        UIDropDownMenu_AddButton(info)
    end
end

function M.InitRace()
    UIDropDownMenu_ClearAll(RaceDropDown)
    if State.gender == "Familier" then
        for _, creatureType in ipairs(Const.CREATURE_TYPES) do
            local info = UIDropDownMenu_CreateInfo()
            info.text = creatureType
            info.func = function()
                State.race = creatureType
                UIDropDownMenu_SetText(RaceDropDown, creatureType)
                UIDropDownMenu_Initialize(ClassDropDown, M.InitClass)

                State.class = nil
                UIDropDownMenu_SetText(ClassDropDown, "")
                Gallery.UpdateGallery()
            end
            UIDropDownMenu_AddButton(info)
        end
        return
    end
    for _, race in ipairs(Const.RACES) do
        local info = UIDropDownMenu_CreateInfo()
        info.text = race
        info.func = function()
            State.race = race
            UIDropDownMenu_SetText(RaceDropDown, race)
            State.class = nil
            UIDropDownMenu_SetText(ClassDropDown, "")
            Gallery.UpdateGallery()
        end
        UIDropDownMenu_AddButton(info)
    end
end

function M.InitClass()
    UIDropDownMenu_ClearAll(ClassDropDown)
    if State.gender == "Familier" then
        if State.race == "Démon" then
            for _, demon in ipairs(Const.DEMON_TYPES) do
                local info = UIDropDownMenu_CreateInfo()
                info.text = demon
                info.func = function()
                    State.class = demon
                    UIDropDownMenu_SetText(ClassDropDown, demon)
                    Gallery.UpdateGallery()
                end
                UIDropDownMenu_AddButton(info)
            end
        elseif State.race == "Bête" then
            for _, beast in ipairs(Const.BEAST_TYPES) do
                local info = UIDropDownMenu_CreateInfo()
                info.text = beast
                info.func = function()
                    State.class = beast
                    UIDropDownMenu_SetText(ClassDropDown, beast)
                    Gallery.UpdateGallery()
                end
                UIDropDownMenu_AddButton(info)
            end
        end
        return
    end

    if not State.race then return end
    for _, class in ipairs(Const.CLASSES_BY_RACE[State.race]) do
        local info = UIDropDownMenu_CreateInfo()
        info.text = class
        info.func = function()
            State.class = class
            UIDropDownMenu_SetText(ClassDropDown, class)
            Gallery.UpdateGallery()
        end
        UIDropDownMenu_AddButton(info)
    end
end

function M.InitTargetType()
    local playerName = UnitName("player")
    local currentPet = UnitName("pet")
    local pets = CustomPortraitDB[playerName] and CustomPortraitDB[playerName].pets or {}

    local info = UIDropDownMenu_CreateInfo()
    info.text = playerName .. " (Joueur)"
    info.func = function()
        State.target = "Joueur"
        UIDropDownMenu_SetText(TargetTypeDropDown, playerName .. " (Joueur)")
    end
    UIDropDownMenu_AddButton(info)

    local added = {}
    for petName in pairs(pets) do
        local info = UIDropDownMenu_CreateInfo()
        info.text = (currentPet and petName == currentPet) and "|cff00ff00" .. petName .. "|r" or petName
        info.func = function()
            State.target = petName
            UIDropDownMenu_SetText(TargetTypeDropDown, petName)
        end
        UIDropDownMenu_AddButton(info)
        added[petName] = true
    end

    if currentPet and not added[currentPet] then
        local info = UIDropDownMenu_CreateInfo()
        info.text = "|cff00ff00" .. currentPet .. "|r"
        info.func = function()
            State.target = currentPet
            UIDropDownMenu_SetText(TargetTypeDropDown, currentPet)
        end
        UIDropDownMenu_AddButton(info)
    end

    if State.target == "Joueur" then
        UIDropDownMenu_SetText(TargetTypeDropDown, playerName .. " (Joueur)")
    elseif currentPet then
        UIDropDownMenu_SetText(TargetTypeDropDown, currentPet)
    end
end

TrueRP = TrueRP or {}
TrueRP.PortraitSelector = TrueRP.PortraitSelector or {}
TrueRP.PortraitSelector.Dropdowns = M
