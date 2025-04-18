-- gallery.lua

local M = {}

local State = TrueRP.PortraitSelector.State

local numPortraits = 100
local portraitsPerRow = 4
local rowHeight = 110
local maxRow = math.ceil(numPortraits / portraitsPerRow)
local portraitButtonSize = 100

function M.InitSelector()
    for i = 1, numPortraits do
        local btn = CreateFrame("Button", "PortraitButton" .. i, PortraitSelectorGallery)
        btn.texture = btn:CreateTexture(nil, "BACKGROUND")
        btn:SetSize(portraitButtonSize, portraitButtonSize)

        local row = math.floor((i - 1) / portraitsPerRow)
        local col = (i - 1) % portraitsPerRow
        btn:SetPoint("TOPLEFT", PortraitSelectorGallery, "TOPLEFT", 10 + col * 110, -10 - row * rowHeight)

        btn.texture:SetAllPoints()
        btn:EnableMouse(true)
        btn:RegisterForClicks("AnyUp")
        btn:Hide()
    end
end

function M.Clear(startIndex, endIndex)
    for i = startIndex, endIndex do
        local btn = _G["PortraitButton" .. i]
        btn:Hide()
    end
end

function M.UpdateGallery()
    if not State.gender or not State.race or not State.class then
        M.Clear(1, numPortraits)
        return
    end

    local basePath = "Interface\\AddOns\\TrueRP_DB\\portraits\\" ..
        State.gender:lower():gsub(" ", "_") .. "\\" ..
        State.race:lower():gsub(" ", "_") .. "\\" ..
        State.class:lower():gsub(" ", "_")

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
            State.portrait = texturePath
            PortraitPreviewTexture:SetTexture(texturePath)
        end)
        btn:Show()
    end
end

TrueRP = TrueRP or {}
TrueRP.PortraitSelector = TrueRP.PortraitSelector or {}
TrueRP.PortraitSelector.Gallery = M
