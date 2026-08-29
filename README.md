# OWildZimut

**Outil de création de cartes de Course d'Orientation avec gestion avancée de calques**

[![Flutter](https://img.shields.io/badge/Flutter-3.12.2+-blue.svg)](https://flutter.dev/)
[![License: MIT](https://img.shields.org/badge/license-MIT-purple.svg)](https://opensource.org/licenses/MIT)

## 📁 À propos

**OWildZimut** est une application mobile développée en **Flutter** pour la création et l'édition de cartes de **Course d'Orientation**. Elle permet aux utilisateurs de concevoir des cartes professionnelles avec une gestion avancée des calques, des symboles IOF (International Orienteering Federation), et des outils de dessin spécialisés.

### ✅ Fonctionnalités principales

#### Version actuelle (0.0.002)
- ✅ **Gestion des calques** : Ajout, suppression, réorganisation, visibilité et opacité
- ✅ **Outils de dessin** : Sélection, points, lignes, polygones, texte
- ✅ **Navigation avancée** : Zoom, défilement, réinitialisation de la vue
- ✅ **Symboles IOF** : Bibliothèque complète des symboles standard IOF avec sélection interactive
- ✅ **Sauvegarde/Chargement** : Export et import de projets au format JSON
- ✅ **Interface intuitive** : Conçue pour les cartographes et organisateurs de courses
- ✅ **Panneaux repliables** : Barre d'outils et panneau des calques peuvent être réduits pour plus d'espace

#### Fonctionnalités en développement
- 🔄 **Chargement OCAD/OOMAP** : Import de fichiers OMAP existants (architecture prête, parsing à compléter)
- 🔄 **Gestion des symboles personnalisés** : Création et modification de symboles personnalisés
- 🔄 **Calibrage de la carte** : Alignement avec des images satellite ou des cartes existantes

## 🚀 Roadmap détaillée

### Phase 1: Fondations (Version 0.0.001 - 0.0.002) ✅ COMPLETÉ
- [x] Structure de base de l'application Flutter
- [x] Modèle de données pour les calques
- [x] Modèle de données pour les symboles
- [x] Vue de la carte avec zoom et panoramique
- [x] Barre d'outils de dessin
- [x] Panneau de gestion des calques

### Phase 2: Import/Export (Version 0.0.003 - 0.0.004)
- [ ] **Chargement OMAP** (Priorité Haute)
  - [ ] Sélection et placement de symboles IOF
  - [ ] Modèle de données pour les fichiers OMAP
  - [ ] Implémentation complète du parseur binaire
  - [ ] Support du format OMAP
  - [ ] Interface utilisateur pour le chargement
- [ ] **Export OMAP** (Priorité Moyenne)
  - [ ] Génération de fichiers OMAP
  - [ ] Export des calques et symboles
  - [ ] Options d'export (version, échelle, etc.)
- [ ] **Sauvegarde/Chargement JSON** (Priorité Moyenne)
  - [ ] Export JSON de base
  - [ ] Import JSON avec validation
  - [ ] Gestion des versions de fichiers
  - [ ] Compression des fichiers volumineux

### Phase 3: Outils avancés (Version 0.0.005 - 0.0.006)
- [ ] **Outils de dessin améliorés**
  - [ ] Outils de sélection multiple
  - [ ] Déplacement, rotation, mise à l'échelle
  - [ ] Copier/coller des éléments
  - [ ] Annuler/Rétablir (Historique)
- [ ] **Gestion des symboles**
  - [ ] Création de symboles personnalisés
  - [ ] Bibliothèque de symboles utilisateur
  - [ ] Import de symboles depuis des fichiers
  - [ ] Éditeur de symboles visuel
- [ ] **Calibrage et géoréférencement**
  - [ ] Alignement avec des images de fond
  - [ ] Support des images géoréférencées
  - [ ] Transformation affine (rotation, échelle, translation)
  - [ ] Calage sur points de contrôle

### Phase 4: Fonctionnalités professionnelles (Version 0.0.007+)
- [ ] **Gestion de projet**
  - [ ] Création et gestion de projets
  - [ ] Multi-cartes dans un projet
  - [ ] Métadonnées du projet
- [ ] **Collaboration**
  - [ ] Partage de projets
  - [ ] Travail collaboratif en temps réel
  - [ ] Commentaires et annotations
- [ ] **Export avancé**
  - [ ] Export PDF avec légende
  - [ ] Export image (PNG, JPEG)
  - [ ] Export vectoriel (SVG, DXF)
  - [ ] Export pour impression professionnelle

### Phase 5: Optimisation et déploiement (Version 0.1.0+)
- [ ] **Performances**
  - [ ] Rendu optimisé pour les grandes cartes
  - [ ] Chargement progressif
  - [ ] Gestion mémoire améliorée
- [ ] **Multiplateforme**
  - [ ] Version mobile (Android/iOS)
  - [ ] Version desktop (Windows, macOS, Linux)
  - [ ] Version web
- [ ] **Tests et qualité**
  - [ ] Suite de tests complète
  - [ ] Documentation utilisateur
  - [ ] Tutoriels interactifs

## 📋 Structure du projet

```
o_wild_zimut/
├── lib/
│   ├── main.dart                 # Point d'entrée de l'application
│   ├── models/
│   │   ├── layer.dart            # Modèle de calque
│   │   ├── map_state.dart        # État global de la carte
│   │   ├── symbol.dart           # Modèle de symbole
│   │   ├── iof_symbols.dart      # Bibliothèque des symboles IOF
│   │   └── ocad_file.dart        # Modèle pour les fichiers OCAD/OOMAP
│   ├── screens/
│   │   └── about_dialog.dart     # Dialogue "À propos"
│   └── widgets/
│       ├── layer_item.dart       # Élément de calque dans la liste
│       ├── layer_panel.dart      # Panneau de gestion des calques
│       ├── map_view.dart         # Vue de la carte
│       ├── tool_bar.dart         # Barre d'outils
│       ├── symbol_selector.dart  # Sélecteur de symboles IOF
│       └── file_loader.dart      # Chargeur de fichiers OCAD/OOMAP
├── pubspec.yaml                 # Configuration des dépendances
└── README.md                    # Ce fichier
```

## 📊 Architecture technique

### Gestion d'état
L'application utilise une approche simple avec StateNotifier pour la gestion d'état. À l'avenir, une migration vers Riverpod ou Bloc pourrait être envisagée pour les fonctionnalités plus complexes.

### Modèle de données
- **Layer**: Représente un calque avec ses propriétés (visibilité, opacité, ordre, etc.)
- **Symbol**: Représente un symbole sur la carte avec sa position, type, couleur, etc.
- **MapState**: État global de l'application (calques, vue, sélection, etc.)
- **IOFSymbolDefinition**: Définition complète d'un symbole IOF
- **OCADFile**: Représentation d'un fichier OCAD/OOMAP

### Rendu graphique
- **CustomPaint**: Utilisé pour dessiner la carte et les symboles
- **InteractiveViewer**: Pour le zoom et le panoramique
- **Gestures**: Gestion des interactions tactiles et souris

## 🎨 Symboles IOF supportés

L'application supporte les catégories de symboles IOF suivantes :

### Forêt et végétation
- Forêt blanche, jaune, verte (niveaux de passabilité)
- Terrain ouvert
- Marais (passable et impraticable)
- Fourré, clairière
- Terre cultivée, vignoble, verger

### Relief
- Talus de terre
- Mur de terre / falaise
- Fosse
- Butte
- Dépression

### Eau
- Lac
- Rivière
- Ruisseau
- Marais bleu (impraticable)

### Chemins et routes
- Chemin public/privé
- Chemin forestier
- Sentier
- Route goudronnée

### Bâtiments et constructions
- Bâtiment
- Ruine
- Clôture
- Mur

### Rochers
- Rocher isolé
- Groupe de rochers
- Terrain rocheux

### Points remarquables
- Point de contrôle
- Départ
- Arrivée
- Point de passage obligatoire

### Symboles techniques
- Limite de carte
- Zone hors limites
- Passage obligatoire
- Zone interdite

## 📥 Installation

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

# Sur desktop (après activation)
flutter run -d windows
flutter run -d macos
flutter run -d linux
```

## 🛠️ Activation du support desktop

Pour activer le support desktop :

```bash
# Activer le support Windows
flutter create --platforms windows .

# Activer le support macOS
flutter create --platforms macos .

# Activer le support Linux
flutter create --platforms linux .
```

## 📦 Dépendances

### Dépendances principales
- **flutter** : SDK Flutter
- **cupertino_icons** : Icônes iOS
- **flutter_lints** : Recommandations de linting
- **file_picker** : Sélection de fichiers (pour le chargement OCAD/OOMAP)

### Ajout des dépendances pour le chargement de fichiers

Ajoutez à votre `pubspec.yaml` :

```yaml
dependencies:
  file_picker: ^8.0.0
```

Puis exécutez :

```bash
flutter pub get
```

## 🎯 Utilisation

### Structure de l'interface

L'application est organisée en trois zones principales :

1. **Barre d'outils (gauche)** : Contient les outils de dessin et les commandes de zoom
   - Peut être réduite pour gagner de la place
   - Outils disponibles : Sélection, Point, Ligne, Polygone, Texte
   - Commandes de vue : Zoom avant/arrière, Réinitialiser

2. **Zone de carte (centre)** : Espace de travail principal pour dessiner et éditer
   - Navigation par zoom (molette ou gestes) et panoramique (clic droit + glisser)
   - Grille d'aide au dessin
   - Affichage des calques et symboles

3. **Panneau des calques (droite)** : Gestion des calques de la carte
   - Peut être réduit pour gagner de la place
   - Contrôle de visibilité et opacité
   - Réorganisation des calques (monter/descendre)
   - Ajout/suppression de calques

### Créer une nouvelle carte

1. L'application démarre avec 3 calques par défaut :
   - Carte de base
   - Végétation
   - Chemins
2. Sélectionnez un calque dans le panneau de droite
3. Choisissez un outil dans la barre d'outils de gauche
4. Dessinez sur la carte :
   - **Point** : Cliquez pour placer un point
   - **Ligne** : Cliquez pour démarrer, continuez à cliquer pour ajouter des points, double-cliquez pour terminer
   - **Polygone** : Comme la ligne, mais se ferme automatiquement
   - **Texte** : Cliquez pour placer un texte
5. Utilisez le bouton "+" dans la barre d'outils pour ajouter des symboles IOF

### Gérer les calques

- **Visibilité** : Cliquez sur l'icône d'œil pour afficher/masquer un calque
- **Opacité** : Utilisez le curseur pour ajuster l'opacité
- **Réorganisation** : Utilisez les flèches haut/bas pour changer l'ordre des calques
- **Suppression** : Cliquez sur l'icône de corbeille pour supprimer un calque
- **Sélection** : Cliquez sur un calque pour le sélectionner et dessiner dessus

### Ajouter des symboles IOF

1. Cliquez sur le bouton "+" dans la barre d'app bar (en haut à droite)
2. Une fenêtre de sélection de symboles s'ouvre
3. Utilisez la recherche ou les filtres par catégorie pour trouver un symbole
4. Sélectionnez un symbole
5. Personnalisez la couleur et la taille si nécessaire
6. Cliquez sur "Ajouter" pour placer le symbole au centre de la vue
7. Le symbole est ajouté au calque actuellement sélectionné

### Charger un fichier OCAD/OOMAP

1. Cliquez sur le bouton "Charger OCAD/OOMAP" dans la barre d'app bar
2. Sélectionnez un fichier .ocd ou .oomap
3. L'application affiche un aperçu du fichier
4. Cliquez sur "Importer" pour charger les calques et symboles
5. Les calques du fichier sont ajoutés à votre projet actuel

## 📊 Format des fichiers OCAD/OOMAP

### Structure générale

Les fichiers OCAD et OOMAP sont des formats binaires avec la structure suivante :

1. **En-tête** (Header) : Métadonnées du fichier
   - Version du format
   - Système de coordonnées
   - Échelle
   - Nom de la carte, auteur, organisation
   - Étendue géographique (minX, maxX, minY, maxY)

2. **Palettes de couleurs** (Color Table)
   - Définition des couleurs utilisées
   - Numéro, nom, valeurs RVB/CMYK

3. **Définitions des symboles** (Symbol Table)
   - Symbole par symbole avec :
     - Numéro
     - Nom et description
     - Type (point, ligne, surface, texte)
     - Couleur par défaut
     - Définition graphique

4. **Calques** (Layers)
   - Numéro, nom, visibilité, verrouillage
   - Liste des éléments (symboles placés)

5. **Données géométriques**
   - Position, rotation, mise à l'échelle des éléments
   - Points des lignes et polygones

### Versions supportées

| Version | Description | Support |
|---------|-------------|---------|
| OCAD 6  | Ancien format | ⚠️ Partiel |
| OCAD 7  | Format classique | ✅ Prévu |
| OCAD 8  | Format moderne | ✅ Prévu |
| OCAD 9  | Ajout des calques | ✅ Prévu |
| OCAD 10 | Support Unicode | ✅ Prévu |
| OCAD 11 | Symbole 3D | ✅ Prévu |
| OCAD 12 | Dernière version | ✅ Prévu |
| OOMAP   | Format ouvert | ✅ Prévu |

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

## 📝 Contribution

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

### Priorités de développement

1. **Chargement OCAD/OOMAP** - Priorité maximale
2. **Export OCAD** - Priorité haute
3. **Historique (Undo/Redo)** - Priorité moyenne
4. **Outils de sélection avancés** - Priorité moyenne
5. **Gestion des projets** - Priorité basse

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
- Aux créateurs de OCAD pour leur format ouvert

---

© 2024 Charlie Gentil - WildZimut
