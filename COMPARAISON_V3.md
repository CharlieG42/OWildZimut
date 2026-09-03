# Intégration IOF — v3 en comparaison avec l'existant

## Base de ce paquet
Ce zip part de **ton dépôt GitHub actuel** (`CharlieG42/OWildZimut`, branche `main`,
récupéré au moment de cette réponse) : toutes tes modifications récentes sont
conservées telles quelles — `constants.dart` (version centralisée), le centrage
automatique de la vue sur la taille d'écran après import OMAP
(`MapState.centerOnSymbols`), `undo_manager.dart`, `background_image_picker.dart`,
`recenter_controls.dart`, `offset_extensions.dart`, les évolutions de
`layer_item.dart` / `layer_panel.dart` / `map_view.dart` / `about_dialog.dart` /
`georeferencing.dart`. **Rien de tout ça n'a été touché.**

## Ce qui a été ajouté (v3), rien retiré
Comme demandé, `iof_symbols.dart` (v1) et `iof_symbols_v2.dart` restent en place
à l'identique, avec leur sélecteur et leur visionneuse historiques — pour que tu
puisses comparer. En parallèle :

- **`lib/models/iof_symbols_v3.dart`** (nouveau) : la bibliothèque que j'avais
  construite lors de notre précédent échange, régénérée depuis le fichier
  `ISOM_2017-2_15000.omap` que tu m'avais fourni. 191 symboles ISOM 2017-2,
  couleurs officielles, et surtout la **géométrie multi-éléments** des
  symboles ponctuels composites (les tirets du symbole "marais", les cercles
  concentriques d'un point de contrôle...) — absente des v1 et v2.
  Toutes les classes sont suffixées `V3` (`IOFSymbolV3`, `IOFSymbolsV3`,
  `IOFColorV3`, `IOFColorsV3`, `IOFSymbolGeometryV3`, `IOFSymbolElementV3`)
  pour ne jamais entrer en collision avec les classes `IOFSymbol`/`IOFColors`
  déjà utilisées par v1/v2 ailleurs dans le projet.

- **`lib/widgets/iof_symbol_preview_v3.dart`** (nouveau) : rendu qui dessine
  chaque symbole à partir de sa vraie géométrie (pas un rond générique).

- **`lib/widgets/iof_symbols_viewer_v3.dart`** (nouveau) : visionneuse dédiée
  à la bibliothèque v3, même structure que ta visionneuse actuelle (recherche,
  filtre par catégorie, détail au clic) mais alimentée par les vraies données.

- **`lib/main.dart`** : une seule vraie modification — le menu « ⋮ » propose
  désormais deux entrées distinctes :
  - *Voir les symboles IOF (v1/v2)* → ta visionneuse actuelle, inchangée
  - *Voir les symboles IOF (v3 — ISOM fidèle)* → la nouvelle

  Compare-les côte à côte, notamment sur des codes comme `308.1` (marais),
  `301` (plan d'eau) ou `701`/`702` (postes de contrôle) : c'est là que l'écart
  entre les trois approches est le plus visible.

- **`tools/generate_iof_symbols.py`** (nouveau, unique) : le générateur qui
  produit `iof_symbols_v3.dart` depuis n'importe quel `.omap` officiel.
  Accepte maintenant une option `--suffix` pour générer une bibliothèque avec
  des classes renommées (c'est ce qui a servi à produire la v3 sans collision) :
  ```
  python3 tools/generate_iof_symbols.py tools/ISOM_2017-2_15000.omap lib/models/iof_symbols_v3.dart --suffix V3
  ```

## Ce que je n'ai délibérément pas touché
- `lib/models/map_file.dart` (mort, orienté OCAD) et `lib/models/iof_symbols_v2.dart`
  sont toujours là — je ne les ai pas supprimés cette fois puisque tu veux
  comparer. Si tu confirmes garder la v3, ce sera le moment de les enlever.
- `lib/models/layer.dart.tmp` et `lib/widgets/feedback_animations.dart.bak`
  sont présents dans le dépôt (probablement des artefacts d'éditeur) — je ne
  les ai ni supprimés ni modifiés, ce n'est pas à moi d'en décider, mais ce
  sont a priori des fichiers à ignorer/supprimer côté Git.
- L'import OMAP (`omap_file.dart`) et le sélecteur de pose de symboles
  (`symbol_selector.dart`) utilisent toujours la bibliothèque v1 — je ne les
  ai pas rebranchés sur v3 cette fois-ci, volontairement, pour ne montrer que
  la comparaison de rendu demandée sans rien changer au comportement actuel
  de l'appli. Si tu adoptes v3, la suite logique est de rebrancher ces deux-là
  dessus (je peux le faire dans un prochain tour).

## Limite connue (inchangée depuis la dernière fois)
Le rendu sur le canvas principal (`map_view.dart`) reste générique quelle que
soit la bibliothèque : seules les deux visionneuses et l'aperçu du sélecteur
profitent d'un rendu fidèle à la géométrie réelle.
