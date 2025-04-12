-- logic.lua
-- Contient la logique métier liée à la disponibilité des races et des classes
-- en fonction du genre sélectionné (joueur ou familier).
-- Utilisé par le système de dropdowns déclaratifs pour alimenter les menus.

local Const = TrueRP.PortraitSelector.Constants
local M = {}

--- Récupère la liste des races disponibles en fonction du genre sélectionné.
-- Pour les familiers : retourne les types de créatures (ex : Démon, Bête)
-- Pour les joueurs : retourne la liste classique des races jouables
-- @param gender string - "Homme", "Femme" ou "Familier"
-- @return table - Liste des races ou types de créatures
function M.GetAvailableRaces(gender)
    return gender == "Familier" and Const.CREATURE_TYPES or Const.RACES
end

--- Récupère la liste des classes disponibles pour un couple genre/race.
-- Si le genre est "Familier", alors les classes sont les types de démons ou de bêtes.
-- Si c'est un joueur, on se base sur le mapping race → classes de Const.
-- @param gender string - "Homme", "Femme" ou "Familier"
-- @param race string - Race du personnage ou type de créature
-- @return table - Liste des classes ou sous-types
function M.GetAvailableClasses(gender, race)
    if gender == "Familier" then
        return race == "Démon" and Const.DEMON_TYPES
            or race == "Bête" and Const.BEAST_TYPES
            or {}
    end
    return Const.CLASSES_BY_RACE[race] or {}
end

-- 🔗 Export du module dans l'espace global TrueRP
TrueRP = TrueRP or {}
TrueRP.PortraitSelector = TrueRP.PortraitSelector or {}
TrueRP.PortraitSelector.Logic = M
