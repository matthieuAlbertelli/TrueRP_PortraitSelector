-- gallery.lua

local numPortraits = 100
local portraitsPerRow = 5
local rowHeight = 70
local maxRow = math.ceil(numPortraits / portraitsPerRow)

function PortraitSelector_InitSelector()
    for i = 1, numPortraits do
        local btn = CreateFrame("Button", "PortraitButton" .. i, PortraitSelectorGallery)
        btn.texture = btn:CreateTexture(nil, "BACKGROUND")
        btn:SetSize(64, 64)

        local row = math.floor((i - 1) / portraitsPerRow)
        local col = (i - 1) % portraitsPerRow
        btn:SetPoint("TOPLEFT", PortraitSelectorGallery, "TOPLEFT", 10 + col * 70, -10 - row * rowHeight)

        btn.texture:SetAllPoints()
        btn:EnableMouse(true)
        btn:RegisterForClicks("AnyUp")
        btn:Hide()
    end
end

function PortraitSelector_Empty(startIndex, endIndex)
    for i = startIndex, endIndex do
        local btn = _G["PortraitButton" .. i]
        btn:Hide()
    end
end

function PortraitSelector_UpdateGallery()
    if not SelectedState.gender or not SelectedState.race or not SelectedState.class then
        PortraitSelector_Empty(1, numPortraits)
        return
    end

    local basePath = "Interface\\AddOns\\TrueRP_PortraitSelector\\portraits\\" ..
        SelectedState.gender:lower():gsub(" ", "_") .. "\\" ..
        SelectedState.race:lower():gsub(" ", "_") .. "\\" ..
        SelectedState.class:lower():gsub(" ", "_")

    PortraitSelectorGallery:SetHeight(maxRow * rowHeight)

    for i = 1, numPortraits do
        local btn = _G["PortraitButton" .. i]
        local texturePath = basePath .. "\\portrait_" .. i .. ".tga"

        btn.texture:SetTexture(nil)
        btn.texture:SetTexture(texturePath)
        btn.texture:SetAllPoints()

        if not btn.texture:GetTexture() then
            while i <= numPortraits do
                _G["PortraitButton" .. i]:Hide()
                i = i + 1
            end
            return
        end

        btn:SetScript("OnClick", function()
            SelectedState.portrait = texturePath
            PortraitPreviewTexture:SetTexture(texturePath)
        end)
        btn:Show()
    end
end
