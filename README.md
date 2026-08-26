# OWildZimut

**Outil de création de cartes de Course d'Orientation avec gestion avancée de calques**

[![Flutter](https://img.shields.io/badge/Flutter-3.12.2+-blue.svg)](https://flutter.dev/)
[![License: MIT](https://img.shields.io/badge/license-MIT-purple.svg)](https://opensource.org/licenses/MIT)

## 📌 À propos

**OWildZimut** est une application mobile développée en **Flutter** pour la création et l'édition de cartes de **Course d'Orientation**. Elle permet aux utilisateurs de concevoir des cartes professionnelles avec une gestion avancée des calques, des symboles IOF (International Orienteering Federation), et des outils de dessin spécialisés.

### ⚡ Fonctionnalités principales

- ✅ **Gestion des calques** : Ajout, suppression, réorganisation, visibilité et opacité
- ✅ **Outils de dessin** : Sélection, points, lignes, polygones, texte
- ✅ **Navigation avancée** : Zoom, défilement, réinitialisation de la vue
- ✅ **Symboles IOF** : Support des symboles standard pour la Course d'Orientation
- ✅ **Sauvegarde/Chargement** : Export et import de projets au format JSON
- ✅ **Interface intuitive** : Conçue pour les cartographes et organisateurs de courses

## 🚀 Installation

### Prérequis

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (version 3.12.2 ou supérieure)
- [Git](https://git-scm.com/)
- Un éditeur de code (VS Code, Android Studio, etc.)

### Cloner le projet

```bash
git clone https://github.com/CharlieG42/OWildZimut.git
cd OWildZimut
```

### Installer les dépendances

```bash
flutter pub get
```

### Lancer l'application

```bash
# Sur Android
flutter run -d android

# Sur iOS
flutter run -d ios

# Sur le web
flutter run -d chrome
```

## 📱 Utilisation

### Structure de l'interface

L'application est organisée en trois zones principales :

1. **Barre d'outils (gauche)** : Contient les outils de dessin et les commandes de zoom
2. **Zone de carte (centre)** : Espace de travail principal pour dessiner et éditer
3. **Panneau des calques (droite)** : Gestion des calques de la carte

### Créer une nouvelle carte

1. Cliquez sur le bouton **+** dans le panneau des calques pour ajouter un nouveau calque
2. Sélectionnez un calque pour le modifier
3. Utilisez les outils de la barre d'outils pour dessiner des éléments

### Gérer les calques

- **Visibilité** : Cliquez sur l'icône d'œil pour afficher/masquer un calque
- **Opacité** : Utilisez le curseur pour ajuster l'opacité
- **Réorganisation** : Utilisez les flèches haut/bas pour changer l'ordre des calques
- **Suppression** : Cliquez sur l'icône de corbeille pour supprimer un calque

### Outils disponibles

| Outil | Description |
|-------|-------------|
| 🔍 Sélection | Sélectionner et déplacer des éléments |
| ⭕ Point | Dessiner des points (symboles) |
| ═ Ligne | Dessiner des lignes |
| ▢ Polygone | Dessiner des polygones |
| 📝 Texte | Ajouter du texte |

### Commandes de vue

- **Zoom avant** : Bouton + ou molette de la souris
- **Zoom arrière** : Bouton - ou molette de la souris
- **Déplacement** : Clic droit + glisser ou deux doigts (mobile)
- **Réinitialiser** : Bouton de réinitialisation

## 🏗️ Architecture technique

### Structure du projet

```
o_wild_zimut/
├── lib/
│   ├── main.dart                 # Point d'entrée de l'application
│   ├── models/
│   │   ├── layer.dart            # Modèle de calque
│   │   ├── map_state.dart        # État global de la carte
│   │   └── symbol.dart           # Modèle de symbole
│   ├── screens/
│   │   └── about_dialog.dart     # Dialogue "À propos"
│   └── widgets/
│       ├── layer_item.dart       # Élément de calque dans la liste
│       ├── layer_panel.dart      # Panneau de gestion des calques
│       ├── map_view.dart         # Vue de la carte
│       └── tool_bar.dart         # Barre d'outils
├── pubspec.yaml                 # Configuration des dépendances
└── README.md                    # Ce fichier
```

### Modèles de données

#### Layer (Calque)
```dart
class Layer {
  final String id;           // Identifiant unique
  String name;              // Nom du calque
  LayerType type;           // Type : vector ou raster
  bool visible;             // Visibilité
  double opacity;           // Opacité (0.0 - 1.0)
  int zIndex;               // Ordre d'affichage
  bool locked;              // Verrouillé
  List<Symbol> symbols;     // Symboles du calque
  Color color;              // Couleur du calque
}
```

#### Symbol (Symbole)
```dart
class Symbol {
  final String id;           // Identifiant unique
  final SymbolType type;    // Type : point, line, area, text
  String code;              // Code IOF
  Offset position;          // Position
  String description;       // Description
  Color color;              // Couleur
  double size;              // Taille
  double rotation;          // Rotation
  List<Offset> points;      // Points (pour lignes/polygones)
}
```

## 🎨 Personnalisation

### Thème

Le thème de l'application peut être modifié dans `main.dart` :

```dart
ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.green,  // Couleur principale
    brightness: Brightness.light,
  ),
  useMaterial3: true,
)
```

### Version de l'application

La version est définie dans deux endroits :
- `pubspec.yaml` : Version de publication
- `lib/models/map_state.dart` : Version affichée dans l'application

## 📦 Dépendances

- **flutter** : SDK Flutter
- **cupertino_icons** : Icônes iOS
- **flutter_lints** : Recommandations de linting

## 🤝 Contribution

Les contributions sont les bienvenues ! Voici comment contribuer :

1. Forker le projet
2. Créer une branche pour votre fonctionnalité (`git checkout -b feature/nouvelle-fonctionnalité`)
3. Commiter vos changements (`git commit -m 'Ajout de la nouvelle fonctionnalité'`)
4. Pousser vers la branche (`git push origin feature/nouvelle-fonctionnalité`)
5. Ouvrir une Pull Request

### Bonnes pratiques

- Respecter le style de code existant
- Ajouter des commentaires pour le code complexe
- Écrire des tests pour les nouvelles fonctionnalités
- Mettre à jour la documentation

## 📄 Licence

Ce projet est sous licence **MIT**. Voir le fichier [LICENSE](LICENSE) pour plus de détails.

## 👤 Auteur

**Charlie Gentil**
- GitHub : [@CharlieG42](https://github.com/CharlieG42)
- Organisation : [WildZimut](https://github.com/CharlieG42)

## 🙏 Remerciements

- À la communauté Flutter pour son excellent travail
- Aux développeurs de la **International Orienteering Federation** pour leurs standards
- À tous les contributeurs et testeurs

---

*© 2024 Charlie Gentil - WildZimut*
