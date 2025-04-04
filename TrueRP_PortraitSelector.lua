CustomPortraitDB = CustomPortraitDB or {}

local races = {
    "Humain", "Nain", "Elfe de la nuit", "Gnome", "Draeneï",
    "Orc", "Troll", "Tauren", "Elfe de sang", "Mort-vivant"
}

local classesByRace = {
    ["Humain"] = { "Guerrier", "Paladin", "Voleur", "Prêtre", "Mage", "Démoniste" },
    ["Nain"] = { "Guerrier", "Paladin", "Chasseur", "Prêtre" },
    ["Elfe de la nuit"] = { "Guerrier", "Voleur", "Prêtre", "Druide", "Chasseur" },
    ["Gnome"] = { "Guerrier", "Voleur", "Mage", "Démoniste" },
    ["Draeneï"] = { "Guerrier", "Paladin", "Prêtre", "Chaman" },
    ["Orc"] = { "Guerrier", "Chasseur", "Voleur", "Chaman", "Démoniste" },
    ["Troll"] = { "Guerrier", "Chasseur", "Voleur", "Prêtre", "Mage" },
    ["Tauren"] = { "Guerrier", "Chasseur", "Chaman", "Druide" },
    ["Elfe de sang"] = { "Guerrier", "Paladin", "Chasseur", "Voleur", "Prêtre", "Mage" },
    ["Mort-vivant"] = { "Guerrier", "Voleur", "Prêtre", "Mage", "Démoniste" },
}

local selectedRace = nil
local selectedClass = nil
local selectedPortrait = nil

SLASH_PORTRAITSELECT1 = "/portrait"
SlashCmdList["PORTRAITSELECT"] = function()
    if PortraitSelectorFrame then
        PortraitSelectorFrame:Show()
    end
end
local test = CreateFrame("Button", nil, PortraitSelectorFrame)
test:SetSize(64, 64)
test:SetPoint("BOTTOMLEFT", 20, 20)
test:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8x8" })
test:SetBackdropColor(0, 1, 0, 0.5)

function PortraitSelector_OnLoad(self)
    UIDropDownMenu_Initialize(RaceDropDown, PortraitSelector_InitRace)
    UIDropDownMenu_Initialize(ClassDropDown, PortraitSelector_InitClass)

    if PortraitSelectorFrameScroll and PortraitSelectorFrameScrollChild then
        PortraitSelectorFrameScroll:SetScrollChild(PortraitSelectorFrameScrollChild)
        -- local btn = CreateFrame("Button", "TestChildButton", PortraitSelectorFrameScrollChild)
        -- btn:SetSize(64, 64)
        -- btn:SetPoint("TOPLEFT", 10, -10)
        -- btn:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8x8" })
        -- btn:SetBackdropColor(0, 1, 0, 0.5)
        -- btn:EnableMouse(true)
        -- btn:RegisterForClicks("AnyUp")
        -- btn:SetFrameStrata("TOOLTIP")
        -- btn:SetFrameLevel(100)
        -- btn:SetScript("OnClick", function()
        --     print("✅ Bouton ScrollChild cliqué")
        -- end)

        PortraitSelectorFrameScrollChild:SetParent(PortraitSelectorFrameScroll)
        PortraitSelectorFrameScrollChild:Show()
    end
end

function PortraitSelector_InitRace()
    for _, race in ipairs(races) do
        local info = UIDropDownMenu_CreateInfo()
        info.text = race
        info.func = function()
            UIDropDownMenu_SetSelectedName(RaceDropDown, race)
            selectedRace = race
            selectedClass = nil
            UIDropDownMenu_SetText(ClassDropDown, "")
            PortraitSelector_UpdateGallery()
        end
        UIDropDownMenu_AddButton(info)
    end
end

function PortraitSelector_InitClass()
    if not selectedRace then return end
    for _, class in ipairs(classesByRace[selectedRace]) do
        local info = UIDropDownMenu_CreateInfo()
        info.text = class
        info.func = function()
            UIDropDownMenu_SetSelectedName(ClassDropDown, class)
            selectedClass = class
            PortraitSelector_UpdateGallery()
        end
        UIDropDownMenu_AddButton(info)
    end
end

function PortraitSelector_UpdateGallery()
    if not PortraitSelectorFrameScrollChild then
        print("❌ ScrollChild introuvable !")
    else
        print("✅ ScrollChild existe")
    end
    for i = 1, 100 do
        local b = _G["PortraitButton" .. i]
        if b then b:Hide() end
    end

    if not selectedRace or not selectedClass then return end
    -- print(selectedRace .. " " .. selectedClass .. "sélectionnés")

    local basePath = "Interface\\AddOns\\TrueRP_PortraitSelector\\portraits\\" ..
        selectedRace:lower():gsub(" ", "_") .. "\\" ..
        selectedClass:lower():gsub(" ", "_")
    -- print("Recherche d'image dans le dossier: " .. basePath)

    local index = 1
    for row = 0, 3 do
        for col = 0, 4 do
            local texturePath = basePath .. "\\portrait_" .. index .. ".tga"

            local btn = _G["PortraitButton" .. index]
            if not btn then
                btn = CreateFrame("Button", "PortraitButton" .. index, PortraitSelectorFrameScrollChild)
                btn:SetSize(64, 64)
                btn:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8x8" })
                btn:SetBackdropColor(0, 0.5, 1, 0) -- turquoise clair
                btn:EnableMouse(true)
                btn:RegisterForClicks("AnyUp")
                btn:SetFrameStrata("TOOLTIP")
                btn:SetFrameLevel(100)
            end
            btn:SetPoint("TOPLEFT", col * 70 + 10, -row * 70 - 10)

            local texturePath = basePath .. "\\portrait_" .. index .. ".tga"
            btn.texture = btn.texture or btn:CreateTexture(nil, "BACKGROUND")
            btn.texture:SetAllPoints()
            btn.texture:SetTexture(texturePath)
            print("Tentative de chargement :", texturePath, "->", btn.texture:GetTexture())


            btn:SetScript("OnClick", function()
                print("Click détecté sur :", texturePath)
                selectedPortrait = texturePath
                PortraitSelector_Highlight(btn)
            end)

            btn:Show()

            index = index + 1
        end
    end
end

function PortraitSelector_Highlight(selectedButton)
    -- Supprimer les cadres verts précédents
    for i = 1, 100 do
        local b = _G["PortraitButton" .. i]
        if b and b.selectionBorder then
            b.selectionBorder:Hide()
        end
    end

    -- Ajouter un cadre vert propre autour du bouton sélectionné
    if not selectedButton.selectionBorder then
        local border = CreateFrame("Frame", nil, selectedButton)
        border:SetAllPoints()
        border:SetBackdrop({
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            edgeSize = 12,
            insets = { left = 2, right = 2, top = 2, bottom = 2 }
        })
        border:SetBackdropBorderColor(0, 1, 0, 1) -- vert vif
        selectedButton.selectionBorder = border
    end

    selectedButton.selectionBorder:Show()
end

function PortraitSelector_Save()
    print("Sauvegarde : race =", selectedRace, "classe =", selectedClass, "portrait =", selectedPortrait)

    if selectedPortrait then
        CustomPortraitDB[UnitGUID("player")] = {
            race = selectedRace,
            classe = selectedClass,
            portrait = selectedPortrait
        }
        print("✅ Portrait sauvegardé :", selectedPortrait)
    else
        print("❌ Aucun portrait sélectionné.")
    end
end

-- local btn = CreateFrame("Button", "TestButtonAbsolute", UIParent)
-- btn:SetSize(64, 64)
-- btn:SetPoint("CENTER", 200, 0)
-- btn:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8x8" })
-- btn:SetBackdropColor(1, 0, 1, 0.5)
-- btn:EnableMouse(true)
-- btn:RegisterForClicks("AnyUp")
-- btn:SetFrameStrata("TOOLTIP")
-- btn:SetFrameLevel(100)

-- btn:SetScript("OnClick", function()
--     print("✅ TestButtonAbsolute cliqué")
-- end)
