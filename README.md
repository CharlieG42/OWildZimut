# OWildZimut - Flutter Version

> Outil de création de cartes de Course d'Orientation avec gestion avancée de calques
> **Réécrit en Flutter pour une compatibilité multiplateforme (Android, iOS, Windows, macOS, Linux)**

[![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.0+-green)](https://dart.dev/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

---

## 📱 Plateformes supportées

| Plateforme | Statut | Notes |
|------------|--------|-------|
| **Android** | ✅ | APK natif |
| **iOS** | ✅ | IPA natif |
| **Windows** | ✅ | EXE natif |
| **macOS** | ✅ | APP natif |
| **Linux** | ✅ | Binaire natif |
| **Web** | ⚠️ | Possible avec Flutter Web (limitations graphiques) |

---

## 🚀 Quick Start

### Prérequis
- [Flutter SDK](https://flutter.dev/docs/get-started/install) 3.0+
- Android Studio (pour Android) ou Xcode (pour iOS)
- Un éditeur de code (VS Code, Android Studio, etc.)

### Installation

```bash
# Cloner le dépôt
git clone https://github.com/CharlieG42/OWildZimut.git
cd OWildZimut

# Se placer dans le dossier Flutter (si séparé)
cd o_wild_zimut_flutter

# Récupérer les dépendances
flutter pub get

# Lancer l'application
flutter run
```

### Lancer sur une plateforme spécifique

```bash
# Android
flutter run -d android

# iOS
flutter run -d ios

# Windows
flutter run -d windows

# macOS
flutter run -d macos

# Linux
flutter run -d linux
```

---

## 📁 Structure du projet

```
o_wild_zimut_flutter/
├── lib/
│   ├── main.dart                 # Point d'entrée de l'application
│   ├── models/
│   │   ├── layer.dart            # Modèle de calque
│   │   ├── symbol.dart           # Modèle de symbole IOF
│   │   └── map_state.dart        # État global de la carte
│   ├── widgets/
│   │   ├── layer_item.dart       # Élément de liste pour un calque
│   │   ├── layer_panel.dart      # Panneau de gestion des calques
│   │   ├── map_view.dart          # Vue de la carte avec dessin
│   │   └── tool_bar.dart          # Barre d'outils
│   └── screens/
│       └── about_dialog.dart     # Boîte de dialogue "À propos"
├── pubspec.yaml                  # Dépendances Flutter
└── README.md                     # Documentation
```

---

## 🎨 Fonctionnalités

### Gestion des calques
- ✅ Ajouter/Supprimer des calques
- ✅ Réorganiser avec Monter/Descendre
- ✅ Basculer la visibilité
- ✅ Ajuster l'opacité (0-100%)
- ✅ Sélection d'un calque

### Vue de la carte
- ✅ Zoom avant/arrière (molette ou pincement)
- ✅ Déplacement (clic droit ou deux doigts)
- ✅ Réinitialisation de la vue
- ✅ Raccourcis clavier (Ctrl++/Ctrl+-/Ctrl+0)

### Outils
- Sélection
- Point (postes de contrôle)
- Ligne (chemins)
- Polygone (zones)
- Texte (légendes)

### Menu
- ✅ Menu "À propos" avec icône
- ✅ Affichage de la version (0.0.001)

---

## 🔧 Architecture

### State Management
L'application utilise un **state local** (setState) pour la simplicité.
Pour une version plus complexe, on pourrait migrer vers :
- **Riverpod** (recommandé)
- **Bloc**
- **Provider**

### Modèles de données
- `Layer` : Représente un calque avec ses propriétés
- `Symbol` : Représente un symbole IOF (point, ligne, zone, texte)
- `MapState` : État global de la carte (calques, zoom, décalage)

### Widgets personnalisés
- `MapView` : Affiche la carte avec gestion du zoom/déplacement
- `LayerPanel` : Panneau de gestion des calques
- `ToolBar` : Barre d'outils
- `AboutDialog` : Boîte de dialogue "À propos"

---

## 🎯 Roadmap

### V1.0 (Actuelle - 0.0.001)
- [x] Structure de base Flutter
- [x] Gestion des calques
- [x] Vue de la carte avec zoom/déplacement
- [x] Barre d'outils
- [x] Menu "À propos"

### V1.1
- [ ] Dessin des symboles IOF (points, lignes, polygones)
- [ ] Sauvegarde/Chargement de projets
- [ ] Export en JSON
- [ ] Personnalisation des couleurs

### V1.2
- [ ] Grille magnétique
- [ ] Alignement des symboles
- [ ] Annuler/Rétablir
- [ ] Import de fond de carte

### V2.0
- [ ] Migration vers Riverpod pour le state management
- [ ] Support des styles IOF officiels
- [ ] Export en PDF/PNG
- [ ] Collaboration en temps réel

---

## 📜 License

MIT License - voir le fichier [LICENSE](../LICENSE) pour plus de détails.

---

## 📞 Contact

- **Auteur** : Charlie Gentil
- **Organisation** : WildZimut
- **Dépôt** : [CharlieG42/OWildZimut](https://github.com/CharlieG42/OWildZimut)

---

## 🔄 Migration depuis PySide6/QML

La version Flutter remplace l'ancienne version Python/PySide6 pour :
- Une meilleure compatibilité multiplateforme (surtout Android)
- Un déploiement simplifié
- Une maintenance plus facile
- Des performances graphiques optimisées

La branche `backup/qml-version` contient l'ancienne version pour référence.
