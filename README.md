# OWildZimut

**Outil de création de cartes de Course d'Orientation avec gestion avancée de calques**

[![Flutter](https://img.shields.io/badge/Flutter-3.12.2+-blue.svg)](https://flutter.dev/)
[![License: MIT](https://img.shields.io/badge/license-MIT-purple.svg)](https://opensource.org/licenses/MIT)

## À propos

**OWildZimut** est une application mobile développée en **Flutter** pour la création et l'édition de cartes de **Course d'Orientation**. Elle permet de concevoir des cartes avec une **gestion avancée des calques**, des **symboles IOF** (International Orienteering Federation), et des **outils de dessin spécialisés**.

OWildZimut ne travaille qu'avec des **formats ouverts** : le format propriétaire **OCAD n'est pas et ne sera pas supporté**. L'import/export de cartes se fait via le format ouvert **OMAP** (OpenOrienteering Mapper).

### Fonctionnalités principales

#### Version actuelle (0.0.007)

✅ **Interface adaptée mobile** : bascule automatique entre une mise en page bureau (trois colonnes) et une mise en page téléphone (carte plein écran, outils et calques dans des tiroirs défilants), pensée pour les écrans type Galaxy S23+

✅ **Gestion des calques** : 
- Ajout, suppression, réorganisation
- Visibilité et opacité ajustables
- Déplacement des calques (monter/descendre)

✅ **Import/Export complet** :
- **Import OMAP** : lecture des calques, couleurs, symboles, géométrie des objets (points, lignes, surfaces)
- **Export OMAP v9** : génération de fichiers compatibles avec OpenOrienteering Mapper
- Import d'un fond de carte (jpg, jpeg, png)

✅ **Outils de dessin** :
- Sélection (simple et multiple)
- Points, lignes, polygones, texte
- **Drag & Drop** pour déplacer les symboles
- **Sélection par rectangle** (maintenez enfoncé)

✅ **Expérience utilisateur améliorée** :
- **Undo/Redo** complet (50 niveaux d'historique)
- **Copier/Coller** des symboles
- **Raccourcis clavier** (Ctrl+Z, Ctrl+Y, Ctrl+C, Ctrl+V, Del, etc.)
- **Feedback visuel** : animations, survol, sélection
- **Barre d'outils contextuelle** avec icônes
- **Mode avancé** pour les fonctionnalités professionnelles

✅ **Navigation avancée** :
- Zoom (molette, pincement, boutons)
- Défilement (glisser, clic droit)
- Réinitialisation de la vue

✅ **Symboles IOF** :
- Bibliothèque complète des symboles standard IOF
- Sélection interactive avec recherche et filtres par catégorie
- **Support des lignes et surfaces** (pas seulement les points)
- **Gestion des codes IOF** pour l'interopérabilité

✅ **Sauvegarde/Chargement** :
- Export et import de projets au format JSON
- Export OMAP pour compatibilité avec d'autres logiciels
- Gestion des versions de fichiers

### Fonctionnalités en développement

- **Calibrage du fond de carte** : interface tactile de déplacement/mise à l'échelle par glisser-déposer
- **Géoréférencement avancé** : support des systèmes de coordonnées (UTM, WGS84, etc.)
- **Export PDF** : génération de fichiers PDF avec légende
- **Export image** : export en PNG/JPEG haute résolution
- **Gestion des projets** : création et gestion de projets multi-cartes

## Roadmap détaillée

### Phase 1: Fondations (Version 0.0.001 - 0.0.002) ✅ COMPLÈTE
- [x] Structure de base de l'application Flutter
- [x] Modèle de données pour les calques
- [x] Modèle de données pour les symboles
- [x] Vue de la carte avec zoom et panoramique
- [x] Barre d'outils de dessin
- [x] Panneau de gestion des calques

### Phase 2: Import/Export et mobile (Version 0.0.003 - 0.0.007) ✅ EN COURS
- [x] Interface adaptée aux téléphones (mise en page responsive, tiroirs)
- [x] Import d'un fond de carte au format jpg/jpeg/png
- [x] **Parseur OMAP complet** (couleurs, symboles, géométrie des objets : points, lignes, surfaces)
- [x] **Export OMAP v9** (compatible avec OpenOrienteering Mapper)
- [x] Interface utilisateur pour le chargement OMAP
- [x] Sauvegarde/Chargement JSON

### Phase 3: Outils avancés (Version 0.0.008+) 🎯 PROCHAINE
- [ ] **Géoréférencement complet**
  - [x] Structure de base (Georeferencing class)
  - [ ] Interface tactile de calage
  - [ ] Support des points de contrôle
  - [ ] Transformation affine
- [ ] **Outils de dessin améliorés**
  - [x] Sélection multiple
  - [x] Déplacement par drag & drop
  - [ ] Rotation des symboles
  - [ ] Mise à l'échelle des symboles
  - [ ] Copier/coller avec décalage
  - [ ] Annuler/Retablir (✅ Implémenté)
- [ ] **Gestion des symboles**
  - [ ] Création de symboles personnalisés
  - [ ] Bibliothèque de symboles utilisateur
  - [ ] Editeur de symboles visuel

### Phase 4: Fonctionnalités professionnelles (Version 0.1.0+)
- [ ] **Gestion de projet** : création et gestion de projets, multi-cartes, métadonnées
- [ ] **Collaboration** : partage de projets, travail collaboratif, commentaires
- [ ] **Export avancé** : PDF avec légende, image (PNG/JPEG), vectoriel (SVG/DXF)
- [ ] **Impression professionnelle**

### Phase 5: Optimisation et déploiement (Version 0.2.0+)
- [ ] **Performances** : rendu optimisé pour les grandes cartes, chargement progressif
- [ ] **Multiplateforme** : desktop (Windows, macOS, Linux), web
- [ ] **Tests complets** : suite de tests unitaires et d'intégration
- [ ] **Documentation utilisateur** : tutoriels interactifs

## Structure du projet

```
o_wild_zimut/
├── lib/
│   ├── main.dart                       # Point d'entrée, mise en page responsive
│   ├── models/
│   │   ├── layer.dart                  # Modèle de calque (vectoriel ou image de fond)
│   │   ├── map_state.dart              # État global de la carte avec gestion de la sélection
│   │   ├── symbol.dart                 # Modèle de symbole (point, ligne, surface, texte)
│   │   ├── iof_symbols.dart            # Bibliothèque des symboles IOF
│   │   ├── omap_file.dart              # Parseur/Export OMAP complet
│   │   └── georeferencing.dart          # Gestion du géoréférencement
│   ├── formatters/
│   │   └── omap_exporter.dart          # Export OMAP v9
│   ├── services/
│   │   └── undo_manager.dart           # Gestion de l'historique (Undo/Redo)
│   ├── widgets/
│   │   ├── map_view.dart               # Vue de la carte avec gestion des gestes
│   │   ├── layer_panel.dart            # Panneau de gestion des calques
│   │   ├── tool_bar.dart                # Barre d'outils avec raccourcis clavier
│   │   ├── symbol_selector.dart        # Sélecteur de symboles IOF
│   │   ├── file_loader.dart            # Chargeur de fichiers
│   │   ├── background_image_picker.dart # Sélecteur d'image de fond
│   │   └── feedback_animations.dart     # Animations de feedback visuel
│   └── screens/
│       └── about_dialog.dart           # Dialogue "À propos"
├── pubspec.yaml                        # Configuration des dépendances
└── README.md                           # Ce fichier
```

## Architecture technique

### Gestion d'état
L'application utilise une approche **immutable** basée sur `MapState` avec un système d'**Undo/Redo** complet. Chaque modification de la carte est stockée dans l'historique, permettant à l'utilisateur d'annuler ou de rétablir ses actions.

### Modèle de données
- **Layer** : un calque, vectoriel (symboles) ou raster (image de fond avec décalage/échelle)
- **MapSymbol** : un symbole placé sur la carte (position, type, couleur, points, etc.)
- **MapState** : état global de l'application (calques, vue, sélection, historique)
- **IOFSymbolDefinition** : définition complète d'un symbole IOF
- **OmapDocument** : représentation d'un fichier OMAP analysé (couleurs, symboles, calques/objets)
- **Georeferencing** : gestion du géoréférencement et des transformations

### Interface adaptée aux téléphones
À partir d'une largeur d'écran de **700dp**, l'application bascule automatiquement vers une mise en page mobile :
- La carte occupe tout l'écran
- La barre d'outils et le panneau des calques sont accessibles via des tiroirs
- Une barre d'outils compacte reste visible en bas pour un accès rapide

### Rendu graphique
- **CustomPaint** : dessine la grille, le marqueur d'origine et les symboles
- **Image.file** : affiche les calques image de fond
- **InteractiveViewer** / **Gestures** : zoom, panoramique et interactions tactiles

## Symboles IOF supportés

L'application supporte toutes les catégories de symboles IOF standard :

### Forêt et végétation
- Forêt blanche, jaune, verte (niveaux de passabilité)
- Terrain ouvert, marais (passable et impraticable)
- Fourré, clairière, terre cultivée, vignoble, verger

### Relief
- Talus de terre, mur de terre / falaise
- Fosse, butte, dépression

### Eau
- Lac, rivière, ruisseau
- Marais bleu (impraticable)

### Chemins et routes
- Chemin public/privé, chemin forestier
- Sentier, route goudronnée

### Bâtiments et constructions
- Bâtiment, ruine, clôture, mur

### Rochers
- Rocher isolé, groupe de rochers
- Terrain rocheux

### Points remarquables
- Point de contrôle, départ, arrivée
- Point de passage obligatoire

### Symboles techniques
- Limite de carte, zone hors limites
- Passage obligatoire, zone interdite

## Installation

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
# Sur Android (plateforme cible principale)
flutter run -d android

# Sur iOS
flutter run -d ios

# Sur le web
flutter run -d chrome
```

## Dépendances

- **flutter** : SDK Flutter
- **cupertino_icons** : icônes iOS
- **flutter_lints** : recommandations de linting
- **file_picker** : sélection de fichiers (import OMAP, import d'image de fond)
- **path_provider** : accès à des répertoires standards
- **path** : manipulation de chemins de fichiers
- **xml** : analyse des fichiers OMAP (format XML)

## Utilisation

### Structure de l'interface

**Sur ordinateur / grand écran**, l'application est organisée en trois zones :
1. **Barre d'outils (gauche)** : outils de dessin et commandes de zoom
2. **Zone de carte (centre)** : espace de travail principal
3. **Panneau des calques (droite)** : gestion des calques

**Sur téléphone**, la carte occupe tout l'écran :
- Le bouton ☰ (menu) ouvre le tiroir des outils
- Le bouton "calques" ouvre le tiroir de gestion des calques
- Une barre compacte en bas donne un accès direct aux outils

### Raccourcis clavier

| Raccourci | Action |
|-----------|--------|
| **Ctrl+Z** | Annuler |
| **Ctrl+Y** | Rétablir |
| **Ctrl+C** | Copier les symboles sélectionnés |
| **Ctrl+V** | Coller les symboles |
| **Ctrl+A** | Tout sélectionner |
| **Del/Backspace** | Supprimer les symboles sélectionnés |
| **Échap** | Effacer la sélection |
| **S** | Outil Sélection |
| **P** | Outil Point |
| **L** | Outil Ligne |
| **G** | Outil Polygone |
| **T** | Outil Texte |
| **+/-** | Zoom avant/arrière |
| **0** | Réinitialiser la vue |

### Créer une nouvelle carte

1. L'application démarre avec 3 calques par défaut : Carte de base, Végétation, Chemins
2. Sélectionnez un calque (panneau des calques)
3. Choisissez un outil (barre d'outils)
4. Dessinez sur la carte :
   - **Point** : cliquez pour placer un point
   - **Ligne** : cliquez pour démarrer, continuez à cliquer pour ajouter des points, double-cliquez ou appuyez sur Entrée pour terminer
   - **Polygone** : comme la ligne, mais se ferme automatiquement quand vous cliquez près du premier point
   - **Texte** : cliquez pour placer un texte

### Importer un fond de carte

1. Cliquez sur le bouton image dans la barre d'application
2. Choisissez un fichier .jpg, .jpeg ou .png
3. Un nouveau calque image est ajouté au bas de la pile

### Importer un fichier OMAP

1. Cliquez sur le bouton dossier dans la barre d'application
2. Sélectionnez un fichier .omap
3. Les calques et objets lus dans le fichier sont ajoutés à votre projet

### Exporter une carte

1. Cliquez sur le bouton Exporter dans la barre d'application
2. Choisissez un emplacement pour enregistrer le fichier
3. La carte est exportée au format OMAP v9

### Gérer les calques

- **Visibilité** : icône d'œil pour afficher/masquer un calque
- **Opacité** : curseur pour ajuster l'opacité
- **Réorganisation** : flèches haut/bas pour changer l'ordre des calques
- **Suppression** : icône de corbeille
- **Sélection** : cliquez sur un calque pour le sélectionner et dessiner dessus

### Sélection et édition

- **Sélection simple** : cliquez sur un symbole
- **Sélection multiple** : maintenez la touche Ctrl (ou Shift) enfoncée et cliquez sur plusieurs symboles
- **Sélection par rectangle** : maintenez le bouton de la souris enfoncé et déplacez pour dessiner un rectangle
- **Déplacement** : sélectionnez un ou plusieurs symboles, puis faites glisser
- **Suppression** : sélectionnez des symboles et appuyez sur Del
- **Copier/Coller** : utilisez Ctrl+C / Ctrl+V ou les boutons de la barre d'outils

## Personnalisation

### Thème

Le thème de l'application peut être modifié dans `main.dart` :

```dart
ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.green,
    brightness: Brightness.light,
  ),
  useMaterial3: true,
)
```

### Point de bascule mobile / bureau

Le seuil de largeur déclenchant la mise en page mobile est défini dans `main.dart` (`kMobileBreakpoint`, 700dp par défaut).

### Version de l'application

La version est définie dans :
- `pubspec.yaml` : version de publication
- `lib/models/map_state.dart` : version affichée dans l'application

## Contribution

1. Forker le projet
2. Créer une branche pour votre fonctionnalité (`git checkout -b feature/nouvelle-fonctionnalité`)
3. Commiter vos changements
4. Pousser vers la branche
5. Ouvrir une Pull Request

### Bonnes pratiques
- Respecter le style de code existant
- Ajouter des commentaires pour le code complexe
- Écrire des tests pour les nouvelles fonctionnalités
- Mettre à jour la documentation

### Priorités de développement
1. **Géoréférencement avancé** - priorité haute
2. **Export PDF** - priorité haute
3. **Editeur de symboles** - priorité moyenne
4. **Gestion des projets** - priorité moyenne

## Licence

Ce projet est sous licence **MIT**. Voir le fichier LICENSE pour plus de détails.

## Remerciements

- À la communauté Flutter pour son excellent travail
- Aux développeurs de la **International Orienteering Federation** pour leurs standards
- Au projet **OpenOrienteering Mapper** pour le format ouvert OMAP
- À tous les contributeurs et testeurs

## Changelog

### Version 0.0.007 (Actuelle)
- ✅ **Export OMAP v9** : Export complet des cartes au format OpenOrienteering Mapper
- ✅ **Parseur OMAP amélioré** : Support des lignes, surfaces, calques et géoréférencement
- ✅ **Sélection multiple** : Sélection de plusieurs symboles avec Ctrl/Cmd ou par rectangle
- ✅ **Undo/Redo** : Historique complet (50 niveaux) avec Ctrl+Z / Ctrl+Y
- ✅ **Copier/Coller** : Copie et collage des symboles avec décalage automatique
- ✅ **Drag & Drop** : Déplacement des symboles sélectionnés par glisser-déposer
- ✅ **Raccourcis clavier** : Support complet des raccourcis (sélection, édition, vue)
- ✅ **Feedback visuel** : Animations et survol pour une meilleure UX
- ✅ **Barre d'outils améliorée** : Icônes, infobulles et mode avancé
- ✅ **Mode mobile optimisé** : Barre d'outils compacte pour les petits écrans

### Version 0.0.006
- ✅ Interface adaptée mobile (tiroirs, barre compacte)
- ✅ Import d'un fond de carte (jpg/jpeg/png)
- ✅ Parseur OMAP basique (points uniquement)
- ✅ Interface utilisateur pour le chargement OMAP
- ✅ Sauvegarde/Chargement JSON

### Versions précédentes
- 0.0.001-0.0.005 : Fondations de l'application
