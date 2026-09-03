import 'package:flutter/material.dart';
import '../models/iof_symbols_v3.dart';
import 'iof_symbol_preview_v3.dart';

/// Variante V3 — bibliothèque générée directement depuis le fichier .omap
/// officiel, geometrie multi-elements fidele. Coexiste avec la visionneuse
/// historique (iof_symbols_viewer.dart, v1/v2) pour comparaison.
///
/// Fenêtre de consultation de tous les symboles IOF (ISOM 2017-2) connus
/// d'OWildZimut : utile pour vérifier qu'un code/nom/couleur est bien celui
/// de la norme officielle. Utilise le même rendu ([IOFSymbolPreviewV3]) que le
/// sélecteur de symboles, pour que ce qu'on voit ici corresponde à ce qui
/// sera proposé lors de l'ajout d'un symbole sur la carte.
class IOFSymbolsViewerV3 extends StatefulWidget {
  const IOFSymbolsViewerV3({super.key});

  @override
  State<IOFSymbolsViewerV3> createState() => _IOFSymbolsViewerV3State();
}

class _IOFSymbolsViewerV3State extends State<IOFSymbolsViewerV3> {
  String _selectedCategory = 'Toutes';
  String _searchQuery = '';
  IOFSymbolV3? _selectedSymbol;

  @override
  Widget build(BuildContext context) {
    final allCategories = ['Toutes', ...IOFSymbolsV3.visibleSymbols.map((s) => s.categoryFr).toSet().toList()..sort()];

    List<IOFSymbolV3> filteredSymbols = _searchQuery.isNotEmpty
        ? IOFSymbolsV3.search(_searchQuery)
        : IOFSymbolsV3.visibleSymbols;

    if (_selectedCategory != 'Toutes') {
      filteredSymbols = filteredSymbols.where((s) => s.categoryFr == _selectedCategory).toList();
    }

    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 900,
          maxHeight: 700,
        ),
        child: Column(
          children: [
            _buildHeader(filteredSymbols.length),
            _buildSearchBar(),
            _buildCategoryFilter(allCategories),
            Expanded(
              child: _buildSymbolsList(filteredSymbols),
            ),
            if (_selectedSymbol != null) _buildSymbolDetails(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(int filteredCount) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Icon(Icons.map, size: 24, color: Colors.blue),
          const SizedBox(width: 12),
          const Text(
            'Symboles IOF — V3 (ISOM 2017-2 fidèle)',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          Text(
            '$filteredCount / ${IOFSymbolsV3.visibleSymbols.length} symboles',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search, size: 20),
          hintText: 'Rechercher par code ou nom...',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
        onChanged: (value) => setState(() => _searchQuery = value),
      ),
    );
  }

  Widget _buildCategoryFilter(List<String> categories) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SizedBox(
        height: 40,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            final isSelected = category == _selectedCategory;

            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(category),
                selected: isSelected,
                onSelected: (selected) => setState(() => _selectedCategory = category),
                backgroundColor: Colors.grey[200],
                selectedColor: Colors.blue,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontSize: 12,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSymbolsList(List<IOFSymbolV3> symbols) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: symbols.length,
      itemBuilder: (context, index) {
        final symbol = symbols[index];
        final isSelected = _selectedSymbol == symbol;

        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          elevation: isSelected ? 4 : 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: isSelected ? Colors.blue : Colors.transparent,
              width: 2,
            ),
          ),
          child: ListTile(
            leading: IOFSymbolPreviewV3(symbol: symbol, size: 40),
            title: Text(
              symbol.name,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                children: [
                  Text(
                    'Code : ${symbol.code}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    symbol.categoryFr,
                    style: TextStyle(fontSize: 11, color: Colors.blue.shade800),
                  ),
                ],
              ),
            ),
            trailing: Text(
              _getTypeLabel(symbol.type),
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
            ),
            onTap: () => setState(() => _selectedSymbol = symbol),
          ),
        );
      },
    );
  }

  Widget _buildSymbolDetails() {
    final symbol = _selectedSymbol;
    if (symbol == null) return const SizedBox();

    return Column(
      children: [
        const Divider(height: 1, thickness: 1),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IOFSymbolPreviewV3(symbol: symbol, size: 40),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          symbol.name,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Code : ${symbol.code} • Type : ${_getTypeLabel(symbol.type)} • ${symbol.categoryFr}',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildColorDetails(symbol),
              const SizedBox(height: 12),
              const Text(
                'Description :',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(symbol.description, style: const TextStyle(fontSize: 13)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildColorDetails(IOFSymbolV3 symbol) {
    final colorRef = symbol.geometry?.colorReference;

    if (colorRef == null || colorRef == '-1') {
      return const Text(
        'Couleur : transparente / héritée des sous-éléments du symbole',
        style: TextStyle(fontSize: 13, color: Colors.grey),
      );
    }

    final priority = int.tryParse(colorRef);
    final iofColor = priority != null ? IOFColorsV3.getByPriority(priority) : null;

    if (iofColor == null) {
      return Text('Référence de couleur : $colorRef', style: const TextStyle(fontSize: 13));
    }

    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(color: iofColor.color, border: Border.all(color: Colors.grey)),
        ),
        const SizedBox(width: 8),
        Text(
          '${iofColor.name} (priorité ${iofColor.priority})',
          style: const TextStyle(fontSize: 13),
        ),
      ],
    );
  }

  String _getTypeLabel(int type) {
    switch (type) {
      case 1:
        return 'Point';
      case 2:
        return 'Ligne';
      case 4:
        return 'Surface';
      case 8:
        return 'Texte';
      default:
        return 'Inconnu';
    }
  }
}

/// Ouvre la fenêtre de consultation des symboles IOF
void showIOFSymbolsViewerV3(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => const IOFSymbolsViewerV3(),
  );
}
