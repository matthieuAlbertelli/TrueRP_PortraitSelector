# TrueRP_PortraitSelector

**TrueRP_PortraitSelector** est un addon pour World of Warcraft 3.3.5 (Wrath of the Lich King/TBC client) qui permet aux joueurs de choisir un portrait personnalisé à afficher dans l'interface, selon leur race, classe et sexe. Il s'intègre dans la suite d'addons TrueRP.

## 🧩 Fonctionnalités

- Interface graphique de sélection de portrait.
- Tri intelligent : Sexe > Race > Classe.
- Support des portraits pour les familiers (pets).
- Enregistrement des préférences dans une base de données locale.
- Interaction avec l’addon TrueRP_PortraitElvUI pour afficher les portraits sélectionnés dans ElvUI.
- Utilisation de la base de données partagée TrueRP_DB.

## 🔧 Installation

1. Téléchargez ce dépôt ou sa dernière release.
2. Dézippez le dossier `TrueRP_PortraitSelector/` dans `Interface/AddOns/`.
3. Assurez-vous que **TrueRP_DB** est installé également.
4. Connectez-vous en jeu, ouvrez l’interface TrueRP pour configurer votre portrait en tapant `/portrait` dans le chat.

## ⚙ Dépendances

- **TrueRP_DB** : module requis pour stocker les portraits sélectionnés.

## 🛠 Structure technique

- Code principal : `main.lua`, `logic.lua`, `dropdowns.lua`, `state.lua`, etc.
- UI : `ui.xml`
- Configuration : `dropdown_config.lua`
- Gestion d'état : `state_access.lua`

## 📄 Licence

Distribué sous la licence MIT. Voir [LICENSE](./LICENSE) pour plus de détails.

## ✨ Auteur

Développé par [Matthieu Albertelli]

---

_Fait partie des projets [TrueRP DB](https://github.com/matthieuAlbertelli/TrueRP_DB) et [TrueRP Portrait ElvUI](https://github.com/matthieuAlbertelli/TrueRP_PortraitElvUI)._
