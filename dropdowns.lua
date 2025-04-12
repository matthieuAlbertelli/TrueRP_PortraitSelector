-- dropdowns.lua
-- Module responsable de l'initialisation des dropdowns dynamiques :
-- genre, race, classe et entité contrôlée par le joueur (joueur ou familier).
-- Utilise une configuration déclarative pour gérer les comportements de sélection.

local M = {}

local Configs = TrueRP.PortraitSelector.DropdownConfig
local StateAccess = TrueRP.PortraitSelector.StateAccess
local Gallery = TrueRP.PortraitSelector.Gallery

--- Définit le texte d'un dropdown s'il existe
-- @param frame table - Le dropdown à modifier
-- @param text string - Le texte à afficher
local function SetDropdownText(frame, text)
    if frame and text then
        UIDropDownMenu_SetText(frame, text)
    end
end

--- Ajoute une entrée à un dropdown Blizz.
-- @param text string - Le label à afficher
-- @param onClick function - La fonction à appeler lors du clic
local function AddDropdownEntry(text, onClick)
    local info = UIDropDownMenu_CreateInfo()
    info.text = text
    info.func = onClick
    UIDropDownMenu_AddButton(info)
end

--- Applique un changement de sélection dans un dropdown.
-- Met à jour l'état, réinitialise d'autres champs si besoin,
-- met à jour les textes des dropdowns, et appelle les callbacks associés.
-- @param opts table - Paramètres : key, value, dropdown, reset, resetFrames, refreshGallery, after
local function ApplyDropdownChange(opts)
    StateAccess.Set(opts.key, opts.value)
    SetDropdownText(opts.dropdown, opts.value)

    if opts.reset then
        for _, key in ipairs(opts.reset) do
            StateAccess.Set(key, nil)
            if opts.resetFrames and opts.resetFrames[key] then
                SetDropdownText(opts.resetFrames[key], "")
            end
        end
    end

    if opts.refreshGallery then Gallery.UpdateGallery() end
    if opts.after then opts.after() end
end

--- Génère un handler `onClick` pour une entrée de dropdown.
-- Gère automatiquement les objets {label, value} ou des strings simples.
-- @param entry string|table - L'entrée (ou sa structure)
-- @param opts table - Les options de configuration liées à ce dropdown
-- @return function - Fonction à appeler lors du clic
local function CreateDropdownHandler(entry, opts)
    local value = type(entry) == "table" and entry.value or entry
    return function()
        ApplyDropdownChange {
            key = opts.stateKey,
            value = value,
            dropdown = opts.dropdown,
            reset = opts.reset,
            resetFrames = opts.resetFrames,
            refreshGallery = opts.refreshGallery,
            after = opts.after
        }
    end
end

--- Remplit un dropdown avec une liste d'entrées (strings ou objets {label, value}).
-- @param entries table - La liste d'options à afficher
-- @param opts table - La configuration étendue du dropdown
local function PopulateDropdown(entries, opts)
    UIDropDownMenu_ClearAll(opts.dropdown)
    for _, entry in ipairs(entries) do
        local label = type(entry) == "table" and entry.label or entry
        AddDropdownEntry(label, CreateDropdownHandler(entry, opts))
    end
end

--- Prépare une configuration complète de dropdown à partir de sa clé.
-- Inclut la récupération des entrées dynamiques via getSource(State)
-- @param key string - Clé du dropdown (ex: "gender", "race", etc.)
-- @param dropdownFrame Frame - Frame UI du dropdown
-- @return table|nil - Configuration enrichie
local function PrepareConfig(key, dropdownFrame)
    local base = Configs[key]
    if not base then return nil end
    local config = CopyTable(base)
    config.dropdown = dropdownFrame
    config.entries = config.getSource(TrueRP.PortraitSelector.State)
    return config
end

--- Initialise un dropdown donné selon sa configuration.
-- À appeler depuis `UIDropDownMenu_Initialize`.
-- @param key string - Clé du dropdown ("gender", "race", "class", "playerControlled")
-- @param dropdownFrame Frame - Le frame correspondant
function M.InitDropdown(key, dropdownFrame)
    local config = PrepareConfig(key, dropdownFrame)
    if config then
        PopulateDropdown(config.entries, config)
    end
end

-- 🔗 Exporte le module dans l'espace global TrueRP
TrueRP = TrueRP or {}
TrueRP.PortraitSelector = TrueRP.PortraitSelector or {}
TrueRP.PortraitSelector.Dropdowns = M
