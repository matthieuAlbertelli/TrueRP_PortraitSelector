CustomPortraitDB = CustomPortraitDB or {}

local races = {
    "Elfe de sang", "Draeneï"
}

local classesByRace = {
    ["Elfe de sang"] = { "Paladin" },
    ["Draeneï"] = { "Guerrier" }
    -- ["Orc"] = { "Guerrier", "Chaman" },
    -- ["Humain"] = { "Paladin", "Mage" },
}

local selectedRace = nil
local selectedClass = nil
local selectedPortrait = nil

local numPortraits = 100
local portraitsPerRow = 5
local rowHeight = 70
local maxRow = math.ceil(numPortraits / portraitsPerRow)

SLASH_PORTRAITSELECT1 = "/portrait"
SlashCmdList["PORTRAITSELECT"] = function()
    PortraitSelectorFrame:Show()
end

local function PortraitSelector_Empty(startIndex, endIndex)
    for i = startIndex, endIndex do
        local btn = _G["PortraitButton" .. i]
        btn:Hide()
    end
end


local function PortraitSelector_InitSelector()
    for i = 1, numPortraits do
        local btn = _G["PortraitButton" .. i]
        -- local texturePath = basePath .. "\\portrait_" .. i .. ".tga"
        local row = math.floor((i - 1) / portraitsPerRow)
        local col = (i - 1) % portraitsPerRow

        btn = CreateFrame("Button", "PortraitButton" .. i, PortraitSelectorGallery)
        btn.texture = btn:CreateTexture(nil, "BACKGROUND")
        btn:SetSize(64, 64)
        btn.texture:SetAllPoints()
        btn:SetPoint("TOPLEFT", PortraitSelectorGallery, "TOPLEFT", 10 + col * 70, -10 - row * rowHeight)
        btn:EnableMouse(true)
        btn:RegisterForClicks("AnyUp")
        -- btn:SetScript("OnClick", function()
        --     selectedPortrait = texturePath
        --    -- print("✅ Sélection :", texturePath)
        -- end)
        btn:Hide()
    end
end

function PortraitSelector_OnLoad(self)
    UIDropDownMenu_Initialize(RaceDropDown, PortraitSelector_InitRace)
    UIDropDownMenu_Initialize(ClassDropDown, PortraitSelector_InitClass)
    SaveButton:SetText("Sauvegarder")

    PortraitSelectorScrollFrame:SetScrollChild(PortraitSelectorGallery)
    PortraitSelectorGallery:SetSize(360, 1000) -- hauteur > hauteur scroll visible
    PortraitSelectorScrollFrame:SetVerticalScroll(0)
    -- TESTS TMP
    -- PortraitSelectorGallery:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8x8" })
    -- PortraitSelectorGallery:SetBackdropColor(1, 0, 0, 0.2)

    -- local test = CreateFrame("Button", nil, PortraitSelectorGallery)
    -- test:SetSize(64, 64)
    -- test:SetPoint("TOPLEFT", 10, -700)
    -- test:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8x8" })
    -- test:SetBackdropColor(0, 1, 0, 0.6)
    -- test:EnableMouse(true)
    -- test:RegisterForClicks("AnyUp")
    -- test:SetScript("OnClick", function() print("✅ Clic test") end)

    -- FIN TESTS TMP

    local race, classe = UnitRace("player"), UnitClass("player")
    local raceMap = {
        ["Blood Elf"] = "Elfe de sang", ["Orc"] = "Orc", ["Human"] = "Humain"
    }
    local classMap = {
        ["Paladin"] = "Paladin",
        ["Hunter"] = "Chasseur",
        ["Warrior"] = "Guerrier",
        ["Shaman"] = "Chaman",
        ["Mage"] = "Mage"
    }

    PortraitSelector_InitSelector(40, 5)

    selectedRace = raceMap[race]
    selectedClass = classMap[classe]

    UIDropDownMenu_SetText(RaceDropDown, selectedRace)
    UIDropDownMenu_SetText(ClassDropDown, selectedClass)
    PortraitSelector_UpdateGallery()
end

function PortraitSelector_InitRace()
    for _, race in ipairs(races) do
        local info = UIDropDownMenu_CreateInfo()
        info.text = race
        info.func = function()
            selectedRace = race
            UIDropDownMenu_SetText(RaceDropDown, race)
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
            selectedClass = class
            UIDropDownMenu_SetText(ClassDropDown, class)
            PortraitSelector_UpdateGallery()
        end
        UIDropDownMenu_AddButton(info)
    end
end

function PortraitSelector_UpdateGallery()
    -- for i = 1, 100 do
    --     local b = _G["PortraitButton" .. i]
    --     if b then b:Hide() end
    -- end

    if not selectedRace or not selectedClass then
        PortraitSelector_Empty(1, numPortraits)
        return
    end

    local basePath = "Interface\\AddOns\\TrueRP_PortraitSelector\\portraits\\" ..
        selectedRace:lower():gsub(" ", "_") .. "\\" ..
        selectedClass:lower():gsub(" ", "_")



    PortraitSelectorGallery:SetHeight(maxRow * rowHeight)

    for i = 1, numPortraits do
        local btn = _G["PortraitButton" .. i]
        -- local textureIndex = i
        local texturePath = basePath .. "\\portrait_" .. i .. ".tga"

        -- Création d'un bouton de portrait
        -- btn = CreateFrame("Button", "PortraitButton" .. i, PortraitSelectorGallery)
        -- btn.texture = btn:CreateTexture(nil, "BACKGROUND")


        btn.texture:SetTexture(nil)
        btn.texture:SetTexture(texturePath)
        -- print("path:" .. texturePath)
        -- print("texture:" .. (btn.texture:GetTexture() or "introuvable"))
        -- Stoppe la recherche quand l'image suivante n'existe pas
        if not btn.texture:GetTexture(btn.texture) then
            -- print(texturePath .. ' introuvable. Hide des suivants.')
            -- btn:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8x8" })
            -- btn:SetBackdropColor(0, 1, 0, 0.3)
            while i <= numPortraits do
                btn:Hide()
                i = i + 1
            end
            return
        end
        -- if btn.texture then
        -- local row = math.floor((i - 1) / portraitsPerRow)
        -- local col = (i - 1) % portraitsPerRow
        -- btn:SetSize(64, 64)
        btn.texture:SetAllPoints()
        -- btn:SetPoint("TOPLEFT", PortraitSelectorGallery, "TOPLEFT", 10 + col * 70, -10 - row * rowHeight)
        -- btn:EnableMouse(true)
        -- btn:RegisterForClicks("AnyUp")
        btn:SetScript("OnClick", function()
            selectedPortrait = texturePath
            -- print("✅ Sélection :", texturePath)
            PortraitPreviewTexture:SetTexture(texturePath)
        end)
        -- end
        btn:Show()
    end
end

function PortraitSelector_Save()
    local playerKey = UnitName("player")
    if selectedPortrait then
        CustomPortraitDB[playerKey] = {
            portrait = selectedPortrait
        }
        -- print("✅ Portrait sauvegardé :", selectedPortrait)
    else
        -- print("❌ Aucun portrait sélectionné.")
    end
end
