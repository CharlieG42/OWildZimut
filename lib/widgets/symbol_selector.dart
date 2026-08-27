import 'package:flutter/material.dart';
import '../models/iof_symbols.dart';
import '../models/symbol.dart' as symbol_model;

/// Widget pour sélectionner un symbole IOF
class SymbolSelector extends StatefulWidget {
  final ValueChanged<symbol_model.MapSymbol> onSymbolSelected;
  final Color? selectedColor;
  final double? selectedSize;
  final symbol_model.SymbolDetailLevel detailLevel;
  final bool showSearch;
  final bool showCategories;

  const SymbolSelector({
    super.key,
    required this.onSymbolSelected,
    this.selectedColor,
    this.selectedSize,
    this.detailLevel = symbol_model.SymbolDetailLevel.standard,
    this.showSearch = true,
    this.showCategories = true,
  });

  @override
  State<SymbolSelector> createState() => _SymbolSelectorState();
}

class _SymbolSelectorState extends State<SymbolSelector> {
  IOFSymbolCategory? _selectedCategory;
  String _searchQuery = '';
  IOFSymbolDefinition? _selectedSymbolDef;
  Color _selectedColor = Colors.black;
  double _selectedSize = 1.0;

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.selectedColor ?? Colors.black;
    _selectedSize = widget.selectedSize ?? 1.0;
  }

  List<IOFSymbolDefinition> _getFilteredSymbols() {
    var symbols = iofSymbolLibrary.getSymbolsByDetailLevel(widget.detailLevel);
    
    if (_selectedCategory != null) {
      symbols = symbols.where((s) => s.category == _selectedCategory).toList();
    }
    
    if (_searchQuery.isNotEmpty) {
      symbols = symbols.where((s) => 
        s.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        s.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        s.code.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }
    
    return symbols;
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
        return 'Mur de terre';
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
        return 'Groupe rochers';
      case IOFSymbolCategory.stonyGround:
        return 'Terrain rocheux';
      case IOFSymbolCategory.controlPoint:
        return 'Point de contrôle';
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
        return 'Terre cultivée';
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

  Widget _buildCategoryChip(IOFSymbolCategory? category, String label) {
    final isSelected = _selectedCategory == category;
    
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedCategory = selected ? category : null;
        });
      },
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _buildSymbolPreview(IOFSymbolDefinition symbolDef) {
    final color = symbolDef.defaultColor;
    final size = symbolDef.defaultSize * 2;
    
    switch (symbolDef.type) {
      case symbol_model.MapSymbolType.point:
        return Container(
          width: size * 2,
          height: size * 2,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black, width: 0.5),
          ),
        );
      case symbol_model.MapSymbolType.line:
        return Container(
          width: double.infinity,
          height: size,
          decoration: BoxDecoration(
            color: color,
            border: Border.all(color: Colors.black, width: 0.5),
          ),
        );
      case symbol_model.MapSymbolType.area:
        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.5),
            border: Border.all(color: color, width: 0.5),
          ),
        );
      case symbol_model.MapSymbolType.text:
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
              Expanded(
                child: Center(
                  child: _buildSymbolPreview(symbolDef),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                symbolDef.code,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                symbolDef.name,
                style: const TextStyle(fontSize: 8),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final symbols = _getFilteredSymbols();
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
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
                        ...IOFSymbolCategory.values.map((category) => 
                          _buildCategoryChip(category, _getCategoryLabel(category))
                        ).toList(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ],
            ),
          ),
        ),
        if (_selectedSymbolDef != null) ...[
          Card(
            elevation: 2,
            margin: const EdgeInsets.all(4),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Sélectionné: ${_selectedSymbolDef!.code} (${_selectedSymbolDef!.name})',
                      style: const TextStyle(fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: _createAndSelectMapSymbol,
                    child: const Text('Ajouter'),
                  ),
                ],
              ),
            ),
          ),
        ],
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(4),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 80,
              childAspectRatio: 1.0,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ),
            itemCount: symbols.length,
            itemBuilder: (context, index) {
              final symbolDef = symbols[index];
              return _buildSymbolItem(symbolDef);
            },
          ),
        ),
      ],
    );
  }

  void _createAndSelectMapSymbol() {
    if (_selectedSymbolDef == null) return;
    
    final symbol = _selectedSymbolDef!.createMapSymbol(
      color: _selectedColor,
      size: _selectedSize,
    );
    
    widget.onSymbolSelected(symbol);
    
    setState(() {
      _selectedSymbolDef = null;
    });
  }
}

/// Dialogue pour sélectionner un symbole
class SymbolSelectorDialog extends StatelessWidget {
  final symbol_model.SymbolDetailLevel detailLevel;

  const SymbolSelectorDialog({
    super.key,
    this.detailLevel = symbol_model.SymbolDetailLevel.standard,
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
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Sélectionner un symbole IOF',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: SymbolSelector(
                onSymbolSelected: (symbol) {
                  Navigator.of(context).pop(symbol);
                },
                detailLevel: detailLevel,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(null),
                child: const Text('Annuler'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
