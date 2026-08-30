# OWildZimut

**Outil de creation de cartes de Course d'Orientation avec gestion avancee de calques**

[![Flutter](https://img.shields.io/badge/Flutter-3.12.2+-blue.svg)](https://flutter.dev/)
[![License: MIT](https://img.shields.io/badge/license-MIT-purple.svg)](https://opensource.org/licenses/MIT)

## A propos

**OWildZimut** est une application mobile developpee en **Flutter** pour la creation et l'edition de cartes de **Course d'Orientation**. Elle permet de concevoir des cartes avec une gestion avancee des calques, des symboles IOF (International Orienteering Federation), et des outils de dessin specialises.

OWildZimut ne travaille qu'avec des formats ouverts : le format proprietaire **OCAD n'est pas et ne sera pas supporte**. L'import/export de cartes se fait via le format ouvert **OMAP** (OpenOrienteering Mapper).

### Fonctionnalites principales

#### Version actuelle (0.0.006)
- **Interface adaptee mobile** : bascule automatique entre une mise en page bureau (trois colonnes) et une mise en page telephone (carte plein ecran, outils et calques dans des tiroirs defilants), pensee pour les ecrans type Galaxy S23+
- **Gestion des calques** : ajout, suppression, reorganisation, visibilite et opacite
- **Import d'un fond de carte** (jpg, jpeg, png) : un calque image est ajoute sous les calques vectoriels pour servir de support de traçage
- **Import de fichiers OMAP** : lecture des calques, de la geometrie des objets et association aux symboles IOF connus (voir limites ci-dessous)
- **Outils de dessin** : selection, points, lignes, polygones, texte
- **Navigation avancee** : zoom, defilement, reinitialisation de la vue
- **Symboles IOF** : bibliotheque des symboles standard IOF avec selection interactive, recherche et filtres par categorie
- **Sauvegarde/Chargement** : export et import de projets au format JSON (y compris la reference au fond de carte importe)
- **Panneaux repliables** : barre d'outils et panneau des calques peuvent etre reduits pour plus d'espace (bureau) ou places dans des tiroirs (mobile)

#### Limites connues de l'import OMAP
Le format OMAP complet est riche (definitions graphiques detaillees des symboles, courbes de Bezier, trous dans les surfaces, gabarits/images georeferencees, ...). Le parseur actuel lit la structure des calques et la geometrie des objets (points, lignes, surfaces) et les associe, quand c'est possible, aux symboles IOF deja connus d'OWildZimut via leur code. Il ne restitue pas encore le rendu graphique exact des symboles OMAP d'origine.

#### Fonctionnalites en developpement
- **Calibrage du fond de carte** : l'image importee peut etre deplacee/mise a l'echelle par programmation (`imageOffset`, `imageScale`) mais l'interface de calibrage tactile (glisser-deposer, calage sur points de controle) reste a construire
- **Export OMAP** : generation de fichiers OMAP a partir d'un projet OWildZimut
- **Gestion des symboles personnalises** : creation et modification de symboles personnalises

## Roadmap detaillee

### Phase 1: Fondations (Version 0.0.001 - 0.0.002) COMPLETE
- [x] Structure de base de l'application Flutter
- [x] Modele de donnees pour les calques
- [x] Modele de donnees pour les symboles
- [x] Vue de la carte avec zoom et panoramique
- [x] Barre d'outils de dessin
- [x] Panneau de gestion des calques

### Phase 2: Import/Export et mobile (Version 0.0.003 - 0.0.006) EN COURS
- [x] Interface adaptee aux telephones (mise en page responsive, tiroirs, defilement)
- [x] Import d'un fond de carte au format jpg/jpeg/png
- [x] Modele de donnees pour les fichiers OMAP
- [x] Parseur OMAP (couleurs, symboles, geometrie des objets) — version simplifiee, voir limites ci-dessus
- [x] Interface utilisateur pour le chargement OMAP
- [ ] **Export OMAP** (Priorite moyenne)
  - [ ] Generation de fichiers OMAP
  - [ ] Export des calques et symboles
  - [ ] Options d'export (version, echelle, etc.)
- [x] Sauvegarde/Chargement JSON (export, import avec valeurs par defaut robustes)
- [ ] Gestion des versions de fichiers JSON / compression des fichiers volumineux

### Phase 3: Outils avances (Version 0.0.007+)
- [ ] **Outils de dessin ameliores**
  - [ ] Outils de selection multiple
  - [ ] Deplacement, rotation, mise a l'echelle
  - [ ] Copier/coller des elements
  - [ ] Annuler/Retablir (Historique)
- [ ] **Gestion des symboles**
  - [ ] Creation de symboles personnalises
  - [ ] Bibliotheque de symboles utilisateur
  - [ ] Import de symboles depuis des fichiers
  - [ ] Editeur de symboles visuel
- [ ] **Calibrage et georeferencement**
  - [ ] Interface tactile de deplacement/mise a l'echelle du fond de carte
  - [ ] Support des images georeferencees
  - [ ] Transformation affine (rotation, echelle, translation)
  - [ ] Calage sur points de controle

### Phase 4: Fonctionnalites professionnelles (Version 0.1.0+)
- [ ] **Gestion de projet** : creation et gestion de projets, multi-cartes, metadonnees
- [ ] **Collaboration** : partage de projets, travail collaboratif, commentaires
- [ ] **Export avance** : PDF avec legende, image (PNG/JPEG), vectoriel (SVG/DXF), impression professionnelle

### Phase 5: Optimisation et deploiement (Version 0.2.0+)
- [ ] **Performances** : rendu optimise pour les grandes cartes, chargement progressif, gestion memoire
- [ ] **Multiplateforme** : desktop (Windows, macOS, Linux), web
- [ ] **Tests et qualite** : suite de tests complete, documentation utilisateur, tutoriels interactifs

## Structure du projet

```
o_wild_zimut/
├── lib/
│   ├── main.dart                       # Point d'entree, mise en page responsive
│   ├── models/
│   │   ├── layer.dart                  # Modele de calque (vectoriel ou image de fond)
│   │   ├── map_state.dart              # Etat global de la carte
│   │   ├── symbol.dart                 # Modele de symbole
│   │   ├── iof_symbols.dart            # Bibliotheque des symboles IOF
│   │   └── omap_file.dart              # Lecture des fichiers .omap (OpenOrienteering Mapper)
│   ├── screens/
│   │   └── about_dialog.dart           # Dialogue "A propos"
│   └── widgets/
│       ├── layer_item.dart             # Element de calque dans la liste
│       ├── layer_panel.dart            # Panneau de gestion des calques
│       ├── map_view.dart               # Vue de la carte (calques vectoriels + image de fond)
│       ├── tool_bar.dart                # Barre d'outils
│       ├── symbol_selector.dart        # Selecteur de symboles IOF
│       ├── file_loader.dart            # Chargeur de fichiers OMAP
│       └── background_image_picker.dart # Selecteur d'image de fond (jpg/jpeg/png)
├── pubspec.yaml                        # Configuration des dependances
└── README.md                           # Ce fichier
```

## Architecture technique

### Gestion d'etat
L'application utilise une approche simple, immuable, basee sur `MapState` (copie modifiee a chaque action via `copyWith`). Une migration vers Riverpod ou Bloc pourra etre envisagee pour des besoins plus complexes.

### Modele de donnees
- **Layer** : un calque, vectoriel (symboles) ou raster (image de fond avec decalage/echelle)
- **Symbol** : un symbole place sur la carte (position, type, couleur, ...)
- **MapState** : etat global de l'application (calques, vue, selection, ...)
- **IOFSymbolDefinition** : definition complete d'un symbole IOF
- **OmapDocument** : representation d'un fichier OMAP analyse (couleurs, symboles, calques/objets)

### Interface adaptee aux telephones
A partir d'une largeur d'ecran de 700dp, l'application bascule automatiquement vers une mise en page mobile : la carte occupe tout l'ecran, la barre d'outils et le panneau des calques sont accessibles via des tiroirs (`Drawer`/`endDrawer`) defilants, et une barre d'outils compacte reste toujours visible en bas de l'ecran pour un acces rapide aux outils de dessin et au zoom.

### Rendu graphique
- **CustomPaint** : dessine la grille, le marqueur d'origine et les symboles des calques vectoriels
- **Image.file** : affiche les calques image de fond, sous les calques vectoriels
- **InteractiveViewer** / **Gestures** : zoom, panoramique et interactions tactiles/souris

## Symboles IOF supportes

L'application supporte les categories de symboles IOF suivantes :

### Foret et vegetation
Foret blanche, jaune, verte (niveaux de passabilite), terrain ouvert, marais (passable et impraticable), fourre, clairiere, terre cultivee, vignoble, verger

### Relief
Talus de terre, mur de terre / falaise, fosse, butte, depression

### Eau
Lac, riviere, ruisseau, marais bleu (impraticable)

### Chemins et routes
Chemin public/prive, chemin forestier, sentier, route goudronnee

### Batiments et constructions
Batiment, ruine, cloture, mur

### Rochers
Rocher isole, groupe de rochers, terrain rocheux

### Points remarquables
Point de controle, depart, arrivee, point de passage obligatoire

### Symboles techniques
Limite de carte, zone hors limites, passage obligatoire, zone interdite

## Installation

### Prerequis
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (version 3.12.2 ou superieure)
- [Git](https://git-scm.com/)
- Un editeur de code (VS Code, Android Studio, etc.)

### Cloner le projet

```bash
git clone https://github.com/CharlieG42/OWildZimut.git
cd OWildZimut
```

### Installer les dependances

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

## Dependances

- **flutter** : SDK Flutter
- **cupertino_icons** : icones iOS
- **flutter_lints** : recommandations de linting
- **file_selector** : selection de fichiers (import OMAP, import d'image de fond)
- **path_provider** : acces a des repertoires standards
- **path** : manipulation de chemins de fichiers
- **xml** : analyse des fichiers OMAP (format XML)

## Utilisation

### Structure de l'interface

**Sur ordinateur / grand ecran**, l'application est organisee en trois zones :
1. **Barre d'outils (gauche)** : outils de dessin et commandes de zoom, repliable
2. **Zone de carte (centre)** : espace de travail principal
3. **Panneau des calques (droite)** : gestion des calques

**Sur telephone**, la carte occupe tout l'ecran :
- Le bouton ☰ (menu) de la barre d'application, ou de la barre d'outils compacte en bas, ouvre le tiroir des outils
- Le bouton "calques" ouvre le tiroir de gestion des calques
- Une barre compacte et defilante en bas donne un acces direct aux outils de dessin et au zoom

### Creer une nouvelle carte

1. L'application demarre avec 3 calques par defaut : Carte de base, Vegetation, Chemins
2. Selectionnez un calque (panneau ou tiroir des calques)
3. Choisissez un outil (barre d'outils ou tiroir des outils)
4. Dessinez sur la carte :
   - **Point** : cliquez pour placer un point
   - **Ligne** : cliquez pour demarrer, continuez a cliquer pour ajouter des points, double-cliquez pour terminer
   - **Polygone** : comme la ligne, mais se ferme automatiquement
   - **Texte** : cliquez pour placer un texte
5. Utilisez le bouton "+" de la barre d'application pour ajouter des symboles IOF (places au centre de la vue actuelle)

### Importer un fond de carte

1. Cliquez sur le bouton image de la barre d'application
2. Choisissez un fichier .jpg, .jpeg ou .png
3. Un nouveau calque image est ajoute au bas de la pile de calques ; les calques vectoriels restent visibles par-dessus

### Importer un fichier OMAP

1. Cliquez sur le bouton dossier de la barre d'application
2. Selectionnez un fichier .omap
3. Les calques et objets lus dans le fichier sont ajoutes a la suite de votre projet actuel

### Gerer les calques

- **Visibilite** : icone d'oeil pour afficher/masquer un calque
- **Opacite** : curseur pour ajuster l'opacite
- **Reorganisation** : fleches haut/bas pour changer l'ordre des calques
- **Suppression** : icone de corbeille
- **Selection** : appui sur un calque pour le selectionner et dessiner dessus

## Personnalisation

### Theme

Le theme de l'application peut etre modifie dans `main.dart` :

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

Le seuil de largeur declenchant la mise en page mobile est defini dans `main.dart` (`kMobileBreakpoint`, 700dp par defaut).

### Version de l'application

La version est definie dans deux endroits :
- `pubspec.yaml` : version de publication
- `lib/models/map_state.dart` : version par defaut affichee dans l'application

## Contribution

1. Forker le projet
2. Creer une branche pour votre fonctionnalite (`git checkout -b feature/nouvelle-fonctionnalite`)
3. Commiter vos changements
4. Pousser vers la branche
5. Ouvrir une Pull Request

### Bonnes pratiques
- Respecter le style de code existant
- Ajouter des commentaires pour le code complexe
- Ecrire des tests pour les nouvelles fonctionnalites
- Mettre a jour la documentation

### Priorites de developpement
1. **Export OMAP** - priorite haute
2. **Calibrage tactile du fond de carte** - priorite haute
3. **Historique (Undo/Redo)** - priorite moyenne
4. **Outils de selection avances** - priorite moyenne
5. **Gestion des projets** - priorite basse

## Licence

Ce projet est sous licence **MIT**. Voir le fichier LICENSE pour plus de details.

## Remerciements

- A la communaute Flutter pour son excellent travail
- Aux developpeurs de la **International Orienteering Federation** pour leurs standards
- Au projet **OpenOrienteering Mapper** pour le format ouvert OMAP
