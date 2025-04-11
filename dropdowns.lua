-- dropdowns.lua

local M = {}

local Const = TrueRP.PortraitSelector.Constants
local State = TrueRP.PortraitSelector.State
local Gallery = TrueRP.PortraitSelector.Gallery

-- ===================== 🔧 UTILS ====================== --

local function IsPet()
    return State.gender == "Familier"
end

local function GetAvailableRaces()
    return IsPet() and Const.CREATURE_TYPES or Const.RACES
end

local function GetAvailableClasses()
    if IsPet() then
        return State.race == "Démon" and Const.DEMON_TYPES
            or State.race == "Bête" and Const.BEAST_TYPES
            or {}
    end
    return Const.CLASSES_BY_RACE[State.race] or {}
end

local function AddDropdownEntry(text, onClick)
    local info = UIDropDownMenu_CreateInfo()
    info.text = text
    info.func = onClick
    UIDropDownMenu_AddButton(info)
end

-- ===================== 🧠 STATE LOGIC ====================== --

local function ApplyStateKey(key, value)
    State[key] = value
end

local function ResetStateKeys(resetKeys)
    if not resetKeys then return end
    for _, key in ipairs(resetKeys) do
        State[key] = nil
    end
end

local function UpdateDropdownTexts(dropdown, value, resetFrames)
    UIDropDownMenu_SetText(dropdown, value)
    if resetFrames then
        for key, frame in pairs(resetFrames) do
            UIDropDownMenu_SetText(frame, "")
        end
    end
end

local function RefreshUI(opts)
    if opts.refreshGallery then
        Gallery.UpdateGallery()
    end
    if opts.after then
        opts.after()
    end
end

local function ApplyStateChange(opts)
    ApplyStateKey(opts.key, opts.value)
    ResetStateKeys(opts.reset)
    UpdateDropdownTexts(opts.dropdown, opts.value, opts.resetFrames)
    RefreshUI(opts)
end

-- ===================== 🎛 CONFIG + DROPDOWNS ====================== --

local DropdownConfigs = {
    target = {
        getSource = function()
            local entries = {}
            local playerName = UnitName("player")
            local currentPet = UnitName("pet")
            local pets = CustomPortraitDB[playerName] and CustomPortraitDB[playerName].pets or {}

            table.insert(entries, {
                label = playerName .. " (Joueur)",
                value = "Joueur"
            })

            local added = {}
            for petName in pairs(pets) do
                table.insert(entries, {
                    label = (currentPet and petName == currentPet) and "|cff00ff00" .. petName .. "|r" or petName,
                    value = petName
                })
                added[petName] = true
            end

            if currentPet and not added[currentPet] then
                table.insert(entries, {
                    label = "|cff00ff00" .. currentPet .. "|r",
                    value = currentPet
                })
            end

            return entries
        end,
        stateKey = "target",
        refreshGallery = false
    },
    gender = {
        getSource = function() return Const.GENDERS end,
        stateKey = "gender",
        reset = { "race", "class" },
        resetFrames = {
            race = RaceDropDown,
            class = ClassDropDown
        },
        refreshGallery = true
    },
    race = {
        getSource = GetAvailableRaces,
        stateKey = "race",
        reset = { "class" },
        resetFrames = { class = ClassDropDown },
        refreshGallery = true,
        after = function()
            UIDropDownMenu_Initialize(ClassDropDown, function(frame)
                M.InitDropdown("class", frame)
            end)
        end
    },
    class = {
        getSource = GetAvailableClasses,
        stateKey = "class",
        refreshGallery = true
    }
}

local function CreateDropdownHandler(entry, opts)
    local value = type(entry) == "table" and entry.value or entry
    return function()
        ApplyStateChange({
            key = opts.stateKey,
            value = value,
            dropdown = opts.dropdown,
            reset = opts.reset,
            resetFrames = opts.resetFrames,
            refreshGallery = opts.refreshGallery,
            after = opts.after
        })
    end
end

local function PopulateDropdown(entries, opts)
    UIDropDownMenu_ClearAll(opts.dropdown)
    for _, entry in ipairs(entries) do
        local label = type(entry) == "table" and entry.label or entry
        AddDropdownEntry(label, CreateDropdownHandler(entry, opts))
    end
end

local function PrepareConfig(key, dropdownFrame)
    local base = DropdownConfigs[key]
    if not base then return nil end
    local config = CopyTable(base)
    config.dropdown = dropdownFrame
    config.entries = config.getSource()
    return config
end

function M.InitDropdown(key, dropdownFrame)
    local config = PrepareConfig(key, dropdownFrame)
    if not config then return end
    PopulateDropdown(config.entries, config)
end

-- ===================== 🔗 EXPORT ====================== --

TrueRP = TrueRP or {}
TrueRP.PortraitSelector = TrueRP.PortraitSelector or {}
TrueRP.PortraitSelector.Dropdowns = M
