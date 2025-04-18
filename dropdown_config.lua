-- dropdown_config.lua
-- Contient la configuration déclarative des dropdowns utilisés dans TrueRP_PortraitSelector.
-- Chaque entrée correspond à un menu déroulant (dropdown) et définit :
--  - la clé de l'état qu'elle modifie
--  - la source des valeurs à afficher
--  - les resets éventuels sur d'autres champs
--  - les frames à vider si réinitialisation
--  - si la galerie doit être mise à jour
--  - une action "après sélection" optionnelle

local Logic = TrueRP.PortraitSelector.Logic

--- Crée une entrée de dropdown avec mise en surbrillance optionnelle.
-- @param label string - Texte à afficher
-- @param value string - Valeur associée
-- @param isHighlighted boolean? - Si true, applique une couleur verte
-- @return table - Objet { label = "...", value = "..." }
local function MakeEntry(label, value, isHighlighted)
    return {
        label = isHighlighted and ("|cff00ff00" .. label .. "|r") or label,
        value = value
    }
end

TrueRP = TrueRP or {}
TrueRP.PortraitSelector = TrueRP.PortraitSelector or {}

--- Configuration des dropdowns
TrueRP.PortraitSelector.DropdownConfig = {

    --- Dropdown : Entité contrôlée par le joueur (joueur ou familier)
    playerControlled = {
        stateKey = "target",
        getSource = function(state)
            local entries = {}
            local playerName = UnitName("player")
            local currentPet = UnitName("pet")
            local pets = TrueRP_DB[playerName] and TrueRP_DB[playerName].pets or {}

            table.insert(entries, MakeEntry(playerName .. " (Joueur)", "Joueur"))

            local added = {}
            for petName in pairs(pets) do
                table.insert(entries, MakeEntry(petName, petName, petName == currentPet))
                added[petName] = true
            end

            if currentPet and not added[currentPet] then
                table.insert(entries, MakeEntry(currentPet, currentPet, true))
            end

            return entries
        end,
        refreshGallery = false
    },

    --- Dropdown : Genre
    gender = {
        stateKey = "gender",
        getSource = function(state)
            return TrueRP.PortraitSelector.Constants.GENDERS
        end,
        reset = { "race", "class" },
        resetFrames = {
            race = RaceDropDown,
            class = ClassDropDown
        },
        refreshGallery = true
    },

    --- Dropdown : Race
    race = {
        stateKey = "race",
        getSource = function(state)
            return Logic.GetAvailableRaces(state.gender)
        end,
        reset = { "class" },
        resetFrames = { class = ClassDropDown },
        refreshGallery = true,
        after = function()
            UIDropDownMenu_Initialize(ClassDropDown, function(frame)
                TrueRP.PortraitSelector.Dropdowns.InitDropdown("class", frame)
            end)
        end
    },

    --- Dropdown : Classe
    class = {
        stateKey = "class",
        getSource = function(state)
            return Logic.GetAvailableClasses(state.gender, state.race)
        end,
        refreshGallery = true
    }
}
