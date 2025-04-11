-- dropdowns.lua

function PortraitSelector_InitGender()
    for _, gender in ipairs(GENDERS) do
        local info = UIDropDownMenu_CreateInfo()
        info.text = gender
        info.func = function()
            SelectedState.gender = gender
            UIDropDownMenu_SetText(GenderDropDown, gender)
            SelectedState.race = nil
            SelectedState.class = nil
            UIDropDownMenu_SetText(RaceDropDown, "")
            UIDropDownMenu_SetText(ClassDropDown, "")
            PortraitSelector_UpdateGallery()
        end
        UIDropDownMenu_AddButton(info)
    end
end

function PortraitSelector_InitRace()
    UIDropDownMenu_ClearAll(RaceDropDown)
    if SelectedState.gender == "Familier" then
        for _, creatureType in ipairs(CREATURE_TYPES) do
            local info = UIDropDownMenu_CreateInfo()
            info.text = creatureType
            info.func = function()
                SelectedState.race = creatureType
                UIDropDownMenu_SetText(RaceDropDown, creatureType)
                UIDropDownMenu_Initialize(ClassDropDown, PortraitSelector_InitClass)

                SelectedState.class = nil
                UIDropDownMenu_SetText(ClassDropDown, "")
                PortraitSelector_UpdateGallery()
            end
            UIDropDownMenu_AddButton(info)
        end
        return
    end
    for _, race in ipairs(RACES) do
        local info = UIDropDownMenu_CreateInfo()
        info.text = race
        info.func = function()
            SelectedState.race = race
            UIDropDownMenu_SetText(RaceDropDown, race)
            SelectedState.class = nil
            UIDropDownMenu_SetText(ClassDropDown, "")
            PortraitSelector_UpdateGallery()
        end
        UIDropDownMenu_AddButton(info)
    end
end

function PortraitSelector_InitClass()
    UIDropDownMenu_ClearAll(ClassDropDown)
    if SelectedState.gender == "Familier" then
        if SelectedState.race == "Démon" then
            for _, demon in ipairs(DEMON_TYPES) do
                local info = UIDropDownMenu_CreateInfo()
                info.text = demon
                info.func = function()
                    SelectedState.class = demon
                    UIDropDownMenu_SetText(ClassDropDown, demon)
                    PortraitSelector_UpdateGallery()
                end
                UIDropDownMenu_AddButton(info)
            end
        elseif SelectedState.race == "Bête" then
            for _, beast in ipairs(BEAST_TYPES) do
                local info = UIDropDownMenu_CreateInfo()
                info.text = beast
                info.func = function()
                    SelectedState.class = beast
                    UIDropDownMenu_SetText(ClassDropDown, beast)
                    PortraitSelector_UpdateGallery()
                end
                UIDropDownMenu_AddButton(info)
            end
        end
        return
    end

    if not SelectedState.race then return end
    for _, class in ipairs(CLASSES_BY_RACE[SelectedState.race]) do
        local info = UIDropDownMenu_CreateInfo()
        info.text = class
        info.func = function()
            SelectedState.class = class
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
        SelectedState.target = "Joueur"
        UIDropDownMenu_SetText(TargetTypeDropDown, playerName .. " (Joueur)")
    end
    UIDropDownMenu_AddButton(info)

    local added = {}
    for petName in pairs(pets) do
        local info = UIDropDownMenu_CreateInfo()
        info.text = (currentPet and petName == currentPet) and "|cff00ff00" .. petName .. "|r" or petName
        info.func = function()
            SelectedState.target = petName
            UIDropDownMenu_SetText(TargetTypeDropDown, petName)
        end
        UIDropDownMenu_AddButton(info)
        added[petName] = true
    end

    if currentPet and not added[currentPet] then
        local info = UIDropDownMenu_CreateInfo()
        info.text = "|cff00ff00" .. currentPet .. "|r"
        info.func = function()
            SelectedState.target = currentPet
            UIDropDownMenu_SetText(TargetTypeDropDown, currentPet)
        end
        UIDropDownMenu_AddButton(info)
    end

    if SelectedState.target == "Joueur" then
        UIDropDownMenu_SetText(TargetTypeDropDown, playerName .. " (Joueur)")
    elseif currentPet then
        UIDropDownMenu_SetText(TargetTypeDropDown, currentPet)
    end
end
