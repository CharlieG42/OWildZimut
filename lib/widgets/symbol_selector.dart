import 'package:flutter/material.dart';
import '../models/iof_symbols.dart';
import '../models/symbol.dart' as symbol_model;

/// Widget pour sélectionner un symbole IOF
class SymbolSelector extends StatefulWidget {
  final ValueChanged<symbol_model.MapSymbol> onSymbolSelected;
  final Color? selectedColor;
  final double? selectedSize;
  final SymbolDetailLevel detailLevel;
  final bool showSearch;
  final bool showCategories;

  const SymbolSelector({
    super.key,
    required this.onSymbolSelected,
    this.selectedColor,
    this.selectedSize,
    this.detailLevel = SymbolDetailLevel.standard,
    this.showSearch = true,
    this.showCategories = true,
  });

  @override
  State<SymbolSelector> createState() => _SymbolSelectorState();
}

class _SymbolSelectorState extends State<SymbolSelector> {
  IOFSymbolCategory? _selectedCategory;
  String _searchQuery = '';
  symbol_model.MapSymbol? _selectedSymbolDef;
  Color _selectedColor = Colors.black;
  double _selectedSize = 1.0;

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.selectedColor ?? Colors.black;
    _selectedSize = widget.selectedSize ?? 1.0;
  }

  @override
  Widget build(BuildContext context) {
    final symbols = _getFilteredSymbols();
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // En-tête avec recherche et filtres
        Card(
          elevation: 2,
          margin: const EdgeInsets.all(4),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.showSearch) ...[
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Rechercher un symbole',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      isDense: true,
                    ),
                    onChanged: (value) => setState(() => _searchQuery = value),
                  ),
                  const SizedBox(height: 8),
                ],
                if (widget.showCategories) ...[
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildCategoryChip(null, 'Tous'),
                        const SizedBox(width: 4),
                        IOFSymbolCategory.values.map((category) => 
                          _buildCategoryChip(category, _getCategoryLabel(category))
                        ).toList(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
                // Options de personnalisation
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Couleur',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          SizedBox(
                            height: 30,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                _buildColorOption(Colors.black),
                                _buildColorOption(Colors.red),
                                _buildColorOption(Colors.green),
                                _buildColorOption(Colors.blue),
                                _buildColorOption(Colors.yellow),
                                _buildColorOption(Colors.orange),
                                _buildColorOption(Colors.purple),
                                _buildColorOption(Colors.brown),
                                _buildColorOption(Colors.grey),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Taille',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Slider(
                            value: _selectedSize,
                            min: 0.5,
                            max: 10.0,
                            onChanged: (value) => setState(() => _selectedSize = value),
                            label: '${_selectedSize.toStringAsFixed(1)}',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        // Liste des symboles
        Expanded(
          child: Card(
            elevation: 2,
            margin: const EdgeInsets.all(4),
            child: symbols.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('Aucun symbole trouvé'),
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(4),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: symbols.length,
                    itemBuilder: (context, index) {
                      final symbolDef = symbols[index];
                      return _buildSymbolItem(symbolDef);
                    },
                  ),
          ),
        ),
        // Bouton de sélection
        if (_selectedSymbolDef != null)
          Card(
            elevation: 2,
            margin: const EdgeInsets.all(4),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Sélectionné: ${_selectedSymbolDef!.name} (${_selectedSymbolDef!.code})',
                      style: const TextStyle(fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: _createAndSelectSymbol,
                    child: const Text('Ajouter'),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  List<IOFSymbolDefinition> _getFilteredSymbols() {
    var symbols = iofSymbolLibrary.getSymbolsByDetailLevel(widget.detailLevel);
    
    // Filtrer par catégorie
    if (_selectedCategory != null) {
      symbols = symbols.where((s) => s.category == _selectedCategory).toList();
    }
    
    // Filtrer par recherche
    if (_searchQuery.isNotEmpty) {
      symbols = iofSymbolLibrary.searchSymbols(_searchQuery);
      // Re-filtrer par catégorie si nécessaire
      if (_selectedCategory != null) {
        symbols = symbols.where((s) => s.category == _selectedCategory).toList();
      }
    }
    
    return symbols;
  }

  Widget _buildCategoryChip(IOFSymbolCategory? category, String label) {
    final isSelected = _selectedCategory == category;
    
    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          color: isSelected ? Colors.white : null,
        ),
      ),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedCategory = selected ? category : null;
        });
      },
      backgroundColor: Theme.of(context).colorScheme.surface,
      selectedColor: Theme.of(context).colorScheme.primary,
      checkmarkColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  Widget _buildColorOption(Color color) {
    final isSelected = _selectedColor.toARGB32() == color.toARGB32();
    
    return GestureDetector(
      onTap: () => setState(() => _selectedColor = color),
      child: Container(
        width: 24,
        height: 24,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.white : Colors.transparent,
            width: 2,
          ),
          boxShadow: isSelected 
              ? [BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                )]
              : null,
        ),
      ),
    );
  }

  Widget _buildSymbolItem(IOFSymbolDefinition symbolDef) {
    final isSelected = _selectedSymbolDef == symbolDef;
    
    return Card(
      elevation: isSelected ? 4 : 1,
      margin: EdgeInsets.zero,
      color: isSelected 
          ? Theme.of(context).colorScheme.primaryContainer
          : null,
      child: InkWell(
        onTap: () => setState(() => _selectedSymbolDef = symbolDef),
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icône du symbole
              Expanded(
                child: Center(
                  child: _buildSymbolPreview(symbolDef),
                ),
              ),
              const SizedBox(height: 2),
              // Code du symbole
              Text(
                symbolDef.code,
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              // Nom du symbole (abbrévié)
              Text(
                _truncateName(symbolDef.name, 10),
                style: TextStyle(
                  fontSize: 7,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSymbolPreview(IOFSymbolDefinition symbolDef) {
    final color = symbolDef.defaultColor;
    final size = symbolDef.defaultSize * 2;
    
    switch (symbolDef.type) {
      case MapSymbolType.point:
        return Container(
          width: size * 2,
          height: size * 2,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black, width: 0.5),
          ),
        );
      case MapSymbolType.line:
        return Container(
          width: double.infinity,
          height: size,
          decoration: BoxDecoration(
            color: color,
            border: Border.all(color: Colors.black, width: 0.5),
          ),
        );
      case MapSymbolType.area:
        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.5),
            border: Border.all(color: color, width: 0.5),
          ),
        );
      case MapSymbolType.text:
        return Center(
          child: Text(
            'T',
            style: TextStyle(
              color: color,
              fontSize: size * 2,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
    }
  }

  String _truncateName(String name, int maxLength) {
    if (name.length <= maxLength) return name;
    return '${name.substring(0, maxLength - 1)}.';
  }

  String _getCategoryLabel(IOFSymbolCategory category) {
    switch (category) {
      case IOFSymbolCategory.forest:
        return 'Forêt';
      case IOFSymbolCategory.openLand:
        return 'Terrain ouvert';
      case IOFSymbolCategory.marsh:
        return 'Marais';
      case IOFSymbolCategory.earthBank:
        return 'Talus';
      case IOFSymbolCategory.earthWall:
        return 'Mur terre';
      case IOFSymbolCategory.pit:
        return 'Fosse';
      case IOFSymbolCategory.knoll:
        return 'Butte';
      case IOFSymbolCategory.depression:
        return 'Dépression';
      case IOFSymbolCategory.water:
        return 'Eau';
      case IOFSymbolCategory.lake:
        return 'Lac';
      case IOFSymbolCategory.river:
        return 'Rivière';
      case IOFSymbolCategory.stream:
        return 'Ruisseau';
      case IOFSymbolCategory.marshWater:
        return 'Marais eau';
      case IOFSymbolCategory.path:
        return 'Chemin';
      case IOFSymbolCategory.track:
        return 'Piste';
      case IOFSymbolCategory.road:
        return 'Route';
      case IOFSymbolCategory.trail:
        return 'Sentier';
      case IOFSymbolCategory.building:
        return 'Bâtiment';
      case IOFSymbolCategory.ruin:
        return 'Ruine';
      case IOFSymbolCategory.fence:
        return 'Clôture';
      case IOFSymbolCategory.wall:
        return 'Mur';
      case IOFSymbolCategory.boulder:
        return 'Rocher';
      case IOFSymbolCategory.boulderCluster:
        return 'Rochers';
      case IOFSymbolCategory.stonyGround:
        return 'Terrain rocheux';
      case IOFSymbolCategory.controlPoint:
        return 'Contrôle';
      case IOFSymbolCategory.start:
        return 'Départ';
      case IOFSymbolCategory.finish:
        return 'Arrivée';
      case IOFSymbolCategory.crossingPoint:
        return 'Passage';
      case IOFSymbolCategory.thicket:
        return 'Fourré';
      case IOFSymbolCategory.clearing:
        return 'Clairière';
      case IOFSymbolCategory.cultivatedLand:
        return 'Culture';
      case IOFSymbolCategory.vineyard:
        return 'Vignoble';
      case IOFSymbolCategory.orchard:
        return 'Verger';
      case IOFSymbolCategory.boundary:
        return 'Limite';
      case IOFSymbolCategory.outOfBounds:
        return 'Hors limites';
      case IOFSymbolCategory.mandatoryPassage:
        return 'Passage obligatoire';
      case IOFSymbolCategory.forbidden:
        return 'Interdit';
    }
  }

  void _createAndSelectMapSymbol() {
    if (_selectedSymbolDef == null) return;
    
    final symbol = _selectedSymbolDef!.createMapSymbol(
      color: _selectedColor,
      size: _selectedSize,
    );
    
    widget.onSymbolSelected(symbol);
    
    // Réinitialiser la sélection
    setState(() {
      _selectedSymbolDef = null;
    });
  }
}

/// Dialogue pour sélectionner un symbole
class SymbolSelectorDialog extends StatelessWidget {
  final SymbolDetailLevel detailLevel;

  const SymbolSelectorDialog({
    super.key,
    this.detailLevel = SymbolDetailLevel.standard,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 600,
          maxHeight: 800,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(
              title: const Text('Sélectionner un symbole IOF'),
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            Expanded(
              child: SymbolSelector(
                onSymbolSelected: (symbol) => Navigator.of(context).pop(symbol),
                detailLevel: detailLevel,
                showSearch: true,
                showCategories: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
