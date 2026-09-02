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
          maxWidth: 900,
          maxHeight: 700,
        ),
        child: Column(
          children: [
            // Header
            _buildHeader(filteredSymbols.length),
            
            // Search bar
            _buildSearchBar(),
            
            // Category filter
            _buildCategoryFilter(allCategories),
            
            // Symbols list
            Expanded(
              child: _buildSymbolsList(filteredSymbols),
            ),
            
            // Symbol details (if selected)
            if (_selectedSymbol != null) ...[
              _buildSymbolDetails(),
            ],
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
            'IOF Symbols - ISOM 2017-2',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Text(
            '$filteredCount / ${IOFSymbolsV2.symbols.length} symbols',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
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
          hintText: 'Search by code or name...',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
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

  Widget _buildSymbolsList(List<IOFSymbol> symbols) {
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
            leading: _buildSymbolPreview(symbol),
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
                Row(
                  children: [
                    Text(
                      'Code: ${symbol.code}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      symbol.category,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.blue.shade800,
                      ),
                    ),
                  ],
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
    );
  }

  Widget _buildSymbolPreview(IOFSymbol symbol) {
    final size = 40.0;
    
    // Use the symbol's display color
    final color = symbol.displayColor;
    
    // Build preview based on geometry
    if (symbol.isPoint) {
      final radius = symbol.geometry.pointRadius ?? size / 2;
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.2),
          shape: BoxShape.circle,
          border: Border.all(color: color, width: 1.5),
        ),
        child: Center(
          child: Container(
            width: radius * 2,
            height: radius * 2,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
        ),
      );
    } else if (symbol.isLine) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: Container(
            height: 2,
            width: size * 0.8,
            color: color,
          ),
        ),
      );
    } else if (symbol.isArea) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: color, width: 1),
        ),
      );
    } else if (symbol.isText) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Center(
          child: Icon(Icons.text_fields, size: 16, color: Colors.blue),
        ),
      );
    }
    
    // Default
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Icon(Icons.help_outline, size: 16),
    );
  }

  Widget _buildSymbolDetails() {
    if (_selectedSymbol == null) return const SizedBox();
    
    final symbol = _selectedSymbol!;
    final geom = symbol.geometry;
    
    return Column(
      children: [
        const Divider(height: 1, thickness: 1),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Symbol header
              Row(
                children: [
                  _buildSymbolPreview(symbol),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          symbol.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Code: ${symbol.code} | Type: ${_getTypeLabel(symbol.type)} | Category: ${symbol.category}',
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
              
              // Geometry details
              _buildGeometryDetails(symbol),
              
              const SizedBox(height: 12),
              
              // Color information
              _buildColorDetails(symbol),
              
              const SizedBox(height: 12),
              
              // Description
              const Text(
                'Description:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                symbol.description,
                style: const TextStyle(fontSize: 13),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGeometryDetails(IOFSymbol symbol) {
    final geom = symbol.geometry;
    final geomType = geom.symbolType;
    
    if (geomType == null) return const SizedBox();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Geometry:',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        if (geomType == 'point') ...[
          Text('Inner Radius: ${geom.properties['inner_radius']} (${((int.tryParse(geom.properties['inner_radius']?.toString() ?? '0') ?? 0) / 1000.0).toStringAsFixed(2)}mm)'),
          Text('Inner Color: ${geom.properties['inner_color']}'),
          Text('Outer Color: ${geom.properties['outer_color']}'),
          Text('Rotatable: ${geom.properties['rotatable']}'),
        ],
        if (geomType == 'line') ...[
          Text('Color: ${geom.properties['color']}'),
          Text('Line Width: ${geom.properties['line_width']} (${((int.tryParse(geom.properties['line_width']?.toString() ?? '0') ?? 0) / 1000.0).toStringAsFixed(2)}mm)'),
          Text('Dashed: ${geom.properties['dashed']}'),
          if (geom.properties['dash_length'] != null) Text('Dash Length: ${geom.properties['dash_length']}'),
          if (geom.properties['break_length'] != null) Text('Break Length: ${geom.properties['break_length']}'),
          if (geom.properties['join_style'] != null) Text('Join Style: ${geom.properties['join_style']}'),
          if (geom.properties['cap_style'] != null) Text('Cap Style: ${geom.properties['cap_style']}'),
        ],
        if (geomType == 'area') ...[
          Text('Inner Color: ${geom.properties['inner_color']}'),
          Text('Rotatable: ${geom.properties['rotatable']}'),
        ],
        if (geomType == 'text') ...[
          Text('Color: ${geom.properties['color']}'),
          Text('Font Size: ${geom.properties['font_size']}'),
          Text('Rotatable: ${geom.properties['rotatable']}'),
        ],
      ],
    );
  }

  Widget _buildColorDetails(IOFSymbol symbol) {
    final colorRef = symbol.geometry.colorReference;
    
    if (colorRef == null || colorRef == '-1') {
      return const Text(
        'Color: Transparent / No fill',
        style: TextStyle(fontSize: 13, color: Colors.grey),
      );
    }
    
    final priority = int.tryParse(colorRef);
    final iofColor = priority != null ? IOFColors.getByPriority(priority) : null;
    
    if (iofColor != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Color Information:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: iofColor.color,
                  border: Border.all(color: Colors.grey),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${iofColor.name} (Priority: ${iofColor.priority})',
                style: const TextStyle(fontSize: 13),
              ),
            ],
          ),
          Text(
            'CMYK: (${iofColor.c.toStringAsFixed(2)}, ${iofColor.m.toStringAsFixed(2)}, ${iofColor.y.toStringAsFixed(2)}, ${iofColor.k.toStringAsFixed(2)})',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      );
    }
    
    return Text(
      'Color Reference: $colorRef',
      style: const TextStyle(fontSize: 13),
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
