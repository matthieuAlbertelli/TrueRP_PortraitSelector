-- state_access.lua
-- Encapsulation des accès en lecture/écriture à l'état global partagé (State)
-- Permet de centraliser les opérations sur l'état de sélection et de les rendre plus maintenables.

local State = TrueRP.PortraitSelector.State
local M = {}

--- Met à jour une clé dans l'état
-- @param key string - Nom du champ à modifier
-- @param value any - Valeur à assigner (ou nil pour réinitialiser)
function M.Set(key, value)
    State[key] = value
end

--- Récupère la valeur d'une clé dans l'état
-- @param key string - Clé à lire
-- @return any - Valeur de la clé, ou nil si absente
function M.Get(key)
    return State[key]
end

--- Réinitialise un ou plusieurs champs de l'état
-- @param keys string[]? - Liste de noms de champs à effacer (mise à nil)
function M.Clear(keys)
    if not keys then return end
    for _, key in ipairs(keys) do
        State[key] = nil
    end
end

-- 🔗 Export du module dans l'espace global TrueRP
TrueRP = TrueRP or {}
TrueRP.PortraitSelector = TrueRP.PortraitSelector or {}
TrueRP.PortraitSelector.StateAccess = M
