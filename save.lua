-- save.lua

local M = {}

local State = TrueRP.PortraitSelector.State
local DB = TrueRP_DBModule

function M.Save()
    if not State.portrait then return end

    local playerKey = UnitName("player")

    print("State:" .. State.target)
    if State.target == "Joueur" then
        DB.SetPortraitInDB(playerKey, State.portrait)
    else -- C'est le portrait du familier qui est modifié
        DB.SetPetPortraitInDB(playerKey, State.target, State.portrait)
    end

    -- Optionnel : broadcast addon message (à réactiver si nécessaire)
    -- local message = "UPDATE:" .. playerKey
    -- if GetNumRaidMembers() > 0 then
    --     SendAddonMessage("TRUERP_PORTRAIT", message, "RAID")
    -- elseif GetNumPartyMembers() > 0 then
    --     SendAddonMessage("TRUERP_PORTRAIT", message, "PARTY")
    -- else
    --     SendAddonMessage("TRUERP_PORTRAIT", message, "WHISPER", UnitName("player"))
    -- end
end

TrueRP = TrueRP or {}
TrueRP.PortraitSelector = TrueRP.PortraitSelector or {}
TrueRP.PortraitSelector.Saver = M
