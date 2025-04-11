-- constants.lua

local M = {}

M.GENDERS = { "Homme", "Femme", "Familier" }

M.RACES = {
    "Elfe de sang", "Draeneï", "Orc", "Humain", "Tauren",
    "Troll", "Mort-vivant", "Elfe de la nuit", "Nain", "Gnome"
}

M.CLASSES_BY_RACE = {
    ["Elfe de sang"] = { "Paladin", "Démoniste", "Mage", "Chasseur", "Prêtre", "Voleur" },
    ["Draeneï"] = { "Guerrier", "Paladin", "Prêtre", "Chasseur", "Chaman", "Mage" },
    ["Orc"] = { "Guerrier", "Chaman", "Chasseur", "Démoniste", "Voleur" },
    ["Humain"] = { "Paladin", "Guerrier", "Prêtre", "Voleur", "Mage", "Démoniste" },
    ["Tauren"] = { "Guerrier", "Chaman", "Druide", "Chasseur" },
    ["Troll"] = { "Chasseur", "Prêtre", "Mage", "Voleur", "Chaman", "Guerrier" },
    ["Mort-vivant"] = { "Guerrier", "Prêtre", "Mage", "Voleur", "Démoniste" },
    ["Elfe de la nuit"] = { "Guerrier", "Prêtre", "Chasseur", "Voleur", "Druide" },
    ["Nain"] = { "Guerrier", "Paladin", "Chasseur", "Prêtre" },
    ["Gnome"] = { "Guerrier", "Voleur", "Mage", "Démoniste" },
}

M.DEMON_TYPES = {
    "Diablotin", "Marcheur du vide", "Succube", "Chasseur corrompu", "Gangregarde"
}

M.BEAST_TYPES = {
    "Dracodard"
}

M.CREATURE_TYPES = {
    "Démon", "Bête"
}

-- Injection dans l’espace TrueRP.PortraitSelector
TrueRP = TrueRP or {}
TrueRP.PortraitSelector = TrueRP.PortraitSelector or {}
TrueRP.PortraitSelector.Constants = M
