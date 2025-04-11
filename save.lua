-- save.lua

function PortraitSelector_Save()
    if not SelectedState.portrait then return end

    local playerKey = UnitName("player")
    CustomPortraitDB[playerKey] = CustomPortraitDB[playerKey] or {}

    if SelectedState.target == "Joueur" then
        CustomPortraitDB[playerKey].portrait = SelectedState.portrait
    else
        local petName = SelectedState.target
        CustomPortraitDB[playerKey].pets = CustomPortraitDB[playerKey].pets or {}
        CustomPortraitDB[playerKey].pets[petName] = SelectedState.portrait
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
