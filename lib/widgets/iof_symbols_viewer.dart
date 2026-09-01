import 'package:flutter/material.dart';
import '../models/iof_symbols_v2.dart';

/// Widget to display and browse IOF symbols from ISOM 2017-2
class IOFSymbolsViewer extends StatefulWidget {
  const IOFSymbolsViewer({super.key});

  @override
  State<IOFSymbolsViewer> createState() => _IOFSymbolsViewerState();
}

class _IOFSymbolsViewerState extends State<IOFSymbolsViewer> {
  String _selectedCategory = 'All';
  String _searchQuery = '';
  IOFSymbol? _selectedSymbol;

  @override
  Widget build(BuildContext context) {
    final allCategories = ['All', ...IOFSymbolsV2.getCategories()];
    
    // Filter symbols based on category and search
    List<IOFSymbol> filteredSymbols = IOFSymbolsV2.symbols;
    
    if (_selectedCategory != 'All') {
      filteredSymbols = filteredSymbols.where((s) => s.category == _selectedCategory).toList();
    }
    
    if (_searchQuery.isNotEmpty) {
      filteredSymbols = IOFSymbolsV2.search(_searchQuery);
      if (_selectedCategory != 'All') {
        filteredSymbols = filteredSymbols.where((s) => s.category == _selectedCategory).toList();
      }
    }

    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 800,
          maxHeight: 600,
        ),
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.map, size: 24),
                  const SizedBox(width: 12),
                  const Text(
                    'IOF Symbols - ISOM 2017-2',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${filteredSymbols.length} / ${IOFSymbolsV2.symbols.length} symbols',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            
            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search, size: 20),
                  hintText: 'Search by code or name...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onChanged: (value) => setState(() => _searchQuery = value),
              ),
            ),
            
            // Category filter
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: allCategories.length,
                  itemBuilder: (context, index) {
                    final category = allCategories[index];
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
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            
            // Symbols list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: filteredSymbols.length,
                itemBuilder: (context, index) {
                  final symbol = filteredSymbols[index];
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
                      leading: _buildSymbolIcon(symbol),
                      title: Text(
                        symbol.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(
                            'Code: ${symbol.code}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            symbol.category,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.blue.shade800,
                            ),
                          ),
                        ],
                      ),
                      trailing: Text(
                        _getTypeLabel(symbol.type),
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onTap: () => setState(() => _selectedSymbol = symbol),
                    ),
                  );
                },
              ),
            ),
            
            // Symbol details (if selected)
            if (_selectedSymbol != null) ...[
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _buildSymbolIcon(_selectedSymbol!),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _selectedSymbol!.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Code: ${_selectedSymbol!.code} | Type: ${_getTypeLabel(_selectedSymbol!.type)}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Description:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _selectedSymbol!.description,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSymbolIcon(IOFSymbol symbol) {
    Color iconColor;
    IconData iconData;
    
    // Choose icon based on symbol type
    switch (symbol.type) {
      case 1: // Point
        iconData = Icons.circle;
        iconColor = Colors.red;
        break;
      case 2: // Line
        iconData = Icons.horizontal_rule;
        iconColor = Colors.brown;
        break;
      case 4: // Area
        iconData = Icons.square;
        iconColor = Colors.green;
        break;
      case 8: // Text
        iconData = Icons.text_fields;
        iconColor = Colors.blue;
        break;
      default:
        iconData = Icons.help_outline;
        iconColor = Colors.grey;
    }
    
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(iconData, color: iconColor, size: 20),
    );
  }

  String _getTypeLabel(int type) {
    switch (type) {
      case 1: return 'Point';
      case 2: return 'Line';
      case 4: return 'Area';
      case 8: return 'Text';
      default: return 'Unknown';
    }
  }
}

/// Function to show the IOF symbols viewer dialog
void showIOFSymbolsViewer(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => const IOFSymbolsViewer(),
  );
}
