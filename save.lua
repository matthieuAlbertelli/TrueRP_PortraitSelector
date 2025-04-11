-- save.lua

local M = {}

local State = TrueRP.PortraitSelector.State

function M.Save()
    if not State.portrait then return end

    local playerKey = UnitName("player")
    CustomPortraitDB[playerKey] = CustomPortraitDB[playerKey] or {}

    if State.target == "Joueur" then
        CustomPortraitDB[playerKey].portrait = State.portrait
    else
        local petName = State.target
        CustomPortraitDB[playerKey].pets = CustomPortraitDB[playerKey].pets or {}
        CustomPortraitDB[playerKey].pets[petName] = State.portrait
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

TrueRP = TrueRP or {}
TrueRP.PortraitSelector = TrueRP.PortraitSelector or {}
TrueRP.PortraitSelector.Saver = M
