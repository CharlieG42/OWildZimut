#!/usr/bin/env python3
"""
Génère lib/models/iof_symbols.dart à partir d'un fichier .omap
(OpenOrienteering Mapper) contenant un jeu de symboles officiel
(ex. ISOM 2017-2, ISSprOM 2019). C'est la SEULE source de vérité :
ne jamais retoucher iof_symbols.dart à la main, relancer ce script
si le fichier .omap modèle change.

Usage:
    python3 generate_iof_symbols.py <fichier.omap> <sortie.dart>

Variante avec suffixe (pour faire coexister plusieurs bibliothèques
sans collision de noms de classe, ex. iof_symbols_v3.dart à côté de
iof_symbols.dart) :
    python3 generate_iof_symbols.py <fichier.omap> <sortie.dart> --suffix V3
Renomme IOFColor(s)/IOFSymbol(s)/IOFSymbolGeometry/IOFSymbolElement en
leur ajoutant le suffixe donné (ex. IOFSymbols -> IOFSymbolsV3).
"""
import sys
import re
import xml.etree.ElementTree as ET


def strip_ns(tag: str) -> str:
    return tag.split('}')[-1]


def apply_suffix(dart_source: str, suffix: str) -> str:
    """Renomme les classes publiques (IOFColor, IOFColors, IOFSymbol,
    IOFSymbols, IOFSymbolGeometry, IOFSymbolElement) en leur ajoutant
    [suffix], du nom le plus specifique au plus general pour ne jamais
    re-suffixer un identifiant deja renomme."""
    renames = [
        ('IOFSymbolElement', f'IOFSymbolElement{suffix}'),
        ('IOFSymbolGeometry', f'IOFSymbolGeometry{suffix}'),
        ('IOFSymbols', f'IOFSymbols{suffix}'),
        ('IOFSymbol', f'IOFSymbol{suffix}'),
        ('IOFColors', f'IOFColors{suffix}'),
        ('IOFColor', f'IOFColor{suffix}'),
    ]
    for old, new in renames:
        pattern = re.compile(r'\b' + old + r'\b(?!' + re.escape(suffix) + r')')
        dart_source = pattern.sub(new, dart_source)
    return dart_source


def dart_string(s: str) -> str:
    """Échappe une chaîne pour un literal Dart raw r'...' (on bascule sur
    un literal normal si la chaîne contient une apostrophe, ce qui arrive
    dans certaines descriptions IOF)."""
    s = s or ''
    s = re.sub(r'\s+', ' ', s).strip()
    if "'" not in s and '$' not in s:
        return "r'" + s + "'"
    escaped = s.replace('\\', '\\\\').replace("'", "\\'").replace('$', '\\$')
    return "'" + escaped + "'"


def parse_colors(root):
    colors = []
    colors_el = next(e for e in root.iter() if strip_ns(e.tag) == 'colors')
    for c in colors_el:
        if strip_ns(c.tag) != 'color':
            continue
        rgb_el = next((ch for ch in c if strip_ns(ch.tag) == 'rgb'), None)
        r = float(rgb_el.get('r')) if rgb_el is not None and rgb_el.get('r') else None
        g = float(rgb_el.get('g')) if rgb_el is not None and rgb_el.get('g') else None
        b = float(rgb_el.get('b')) if rgb_el is not None and rgb_el.get('b') else None
        colors.append({
            'priority': int(c.get('priority', '0')),
            'name': c.get('name', ''),
            'c': float(c.get('c', '0')),
            'm': float(c.get('m', '0')),
            'y': float(c.get('y', '0')),
            'k': float(c.get('k', '0')),
            'opacity': float(c.get('opacity', '1')),
            'r': r, 'g': g, 'b': b,
        })
    colors.sort(key=lambda x: x['priority'])
    return colors


def parse_coords(coords_el):
    if coords_el is None or coords_el.text is None:
        return []
    pts = []
    for chunk in coords_el.text.strip().split(';'):
        chunk = chunk.strip()
        if not chunk:
            continue
        parts = chunk.split()
        if len(parts) >= 2:
            x = float(parts[0]) / 1000.0
            y = float(parts[1]) / 1000.0
            pts.append((x, y))
    return pts


def parse_line_symbol_attrs(el):
    if el is None:
        return None
    def gi(name, default=None):
        v = el.get(name)
        return int(v) if v is not None else default
    return {
        'color': el.get('color'),
        'line_width': gi('line_width', 0),
        'dashed': el.get('dashed') == 'true',
        'dash_length': gi('dash_length'),
        'break_length': gi('break_length'),
        'join_style': el.get('join_style'),
        'cap_style': el.get('cap_style'),
        'minimum_length': gi('minimum_length'),
        'segment_length': gi('segment_length'),
        'end_length': gi('end_length'),
        'mid_symbols_per_spot': gi('mid_symbols_per_spot'),
    }


def parse_point_symbol_attrs(el):
    if el is None:
        return None
    def gi(name, default=None):
        v = el.get(name)
        return int(v) if v is not None else default
    return {
        'inner_radius': gi('inner_radius', 0),
        'inner_color': el.get('inner_color'),
        'outer_width': gi('outer_width', 0),
        'outer_color': el.get('outer_color'),
        'rotatable': el.get('rotatable') == 'true',
    }


def parse_area_symbol_attrs(el):
    if el is None:
        return None
    return {
        'inner_color': el.get('inner_color'),
        'rotatable': el.get('rotatable') == 'true',
    }


def parse_text_symbol_attrs(el):
    if el is None:
        return None
    font_el = next((c for c in el if strip_ns(c.tag) == 'font'), None)
    text_el = next((c for c in el if strip_ns(c.tag) == 'text'), None)
    return {
        'font_family': font_el.get('family') if font_el is not None else None,
        'font_size': int(font_el.get('size')) if font_el is not None and font_el.get('size') else None,
        'color': text_el.get('color') if text_el is not None else None,
    }


def parse_element(el):
    """Parse un <element> d'un point_symbol : sa mini-définition de style
    (<symbol> imbriqué, jetable, pas de code) et sa géométrie (<object>)."""
    sub_symbol_el = next((c for c in el if strip_ns(c.tag) == 'symbol'), None)
    object_el = next((c for c in el if strip_ns(c.tag) == 'object'), None)
    if sub_symbol_el is None or object_el is None:
        return None

    sub_type = int(sub_symbol_el.get('type', '1'))
    sub_geom = None
    if sub_type == 1:
        ps = next((c for c in sub_symbol_el if strip_ns(c.tag) == 'point_symbol'), None)
        sub_geom = ('point', parse_point_symbol_attrs(ps))
    elif sub_type == 2:
        ls = next((c for c in sub_symbol_el if strip_ns(c.tag) == 'line_symbol'), None)
        sub_geom = ('line', parse_line_symbol_attrs(ls))
    elif sub_type == 4:
        ars = next((c for c in sub_symbol_el if strip_ns(c.tag) == 'area_symbol'), None)
        sub_geom = ('area', parse_area_symbol_attrs(ars))
    else:
        return None

    coords_el = next((c for c in object_el if strip_ns(c.tag) == 'coords'), None)
    coords = parse_coords(coords_el)

    pattern_el = next((c for c in object_el if strip_ns(c.tag) == 'pattern'), None)
    pattern_coords = []
    if pattern_el is not None:
        for coord in pattern_el:
            if strip_ns(coord.tag) != 'coord':
                continue
            x = float(coord.get('x', '0')) / 1000.0
            y = float(coord.get('y', '0')) / 1000.0
            pattern_coords.append((x, y))
    if not pattern_coords:
        pattern_coords = [(0.0, 0.0)]

    return {'subType': sub_geom[0], 'attrs': sub_geom[1], 'coords': coords, 'pattern': pattern_coords}


def parse_symbol(sym_el):
    code = sym_el.get('code')
    sid = sym_el.get('id')
    name = sym_el.get('name', '')
    is_hidden = sym_el.get('is_hidden') == 'true'
    type_code = int(sym_el.get('type', '1'))

    desc_el = next((c for c in sym_el if strip_ns(c.tag) == 'description'), None)
    description = ''.join(desc_el.itertext()) if desc_el is not None else ''

    data = {
        'id': sid, 'code': code, 'name': name, 'description': description,
        'type': type_code, 'isHidden': is_hidden,
        'point': None, 'line': None, 'area': None, 'text': None,
        'elements': [], 'combinedParts': None,
    }

    if type_code == 1:
        ps = next((c for c in sym_el if strip_ns(c.tag) == 'point_symbol'), None)
        data['point'] = parse_point_symbol_attrs(ps)
        if ps is not None:
            for el in ps:
                if strip_ns(el.tag) != 'element':
                    continue
                parsed = parse_element(el)
                if parsed:
                    data['elements'].append(parsed)
    elif type_code == 2:
        ls = next((c for c in sym_el if strip_ns(c.tag) == 'line_symbol'), None)
        data['line'] = parse_line_symbol_attrs(ls)
    elif type_code == 4:
        ars = next((c for c in sym_el if strip_ns(c.tag) == 'area_symbol'), None)
        data['area'] = parse_area_symbol_attrs(ars)
    elif type_code == 8:
        ts = next((c for c in sym_el if strip_ns(c.tag) == 'text_symbol'), None)
        data['text'] = parse_text_symbol_attrs(ts)
    elif type_code == 16:
        comb = next((c for c in sym_el if strip_ns(c.tag) == 'combined_symbol'), None)
        parts = []
        if comb is not None:
            for p in comb:
                if strip_ns(p.tag) == 'part':
                    parts.append(p.get('symbol'))
        data['combinedParts'] = parts

    return data


def resolve_combined(symbols_by_id):
    """Pour un symbole combiné (type 16), calcule une géométrie effective
    utilisable pour l'aperçu/le rendu : la partie surface si elle existe,
    sinon la partie ligne la plus large. Reproduit la logique déjà en place
    côté import (`omap_file.dart`) pour rester cohérent."""
    for data in symbols_by_id.values():
        if data['type'] != 16:
            continue
        area_part = None
        widest_line = None
        widest_width = -1
        for part_id in data['combinedParts'] or []:
            part = symbols_by_id.get(part_id)
            if part is None:
                continue
            if part['type'] == 4 and area_part is None:
                area_part = part
            if part['type'] == 2 and part['line']:
                w = part['line']['line_width'] or 0
                if w > widest_width:
                    widest_width = w
                    widest_line = part
        if area_part is not None:
            data['area'] = area_part['area']
            data['effectiveType'] = 4
        elif widest_line is not None:
            data['line'] = widest_line['line']
            data['effectiveType'] = 2
        else:
            data['effectiveType'] = data['type']


CATEGORY_RANGES = [
    (100, 199, 'Landforms', 'Formes de terrain'),
    (200, 299, 'Rock and boulders', 'Rochers et blocs'),
    (300, 399, 'Water and marsh', 'Eau et marais'),
    (400, 499, 'Vegetation', 'Végétation'),
    (500, 599, 'Man-made features', 'Aménagements'),
    (600, 699, 'Technical symbols', 'Symboles techniques'),
    (700, 799, 'Course symbols', 'Symboles de parcours'),
    (800, 899, 'Course symbols', 'Symboles de parcours'),
    (900, 999, 'Other', 'Autres'),
]


def category_for(code: str):
    try:
        base = int(code.split('.')[0])
    except ValueError:
        return ('Other', 'Autres')
    for lo, hi, en, fr in CATEGORY_RANGES:
        if lo <= base <= hi:
            return (en, fr)
    return ('Other', 'Autres')


def fmt_color_dart(c):
    if c['r'] is not None:
        r, g, b = c['r'], c['g'], c['b']
    else:
        r = (1 - c['c']) * (1 - c['k'])
        g = (1 - c['m']) * (1 - c['k'])
        b = (1 - c['y']) * (1 - c['k'])
    ri = max(0, min(255, round(r * 255)))
    gi = max(0, min(255, round(g * 255)))
    bi = max(0, min(255, round(b * 255)))
    return f'Color(0xFF{ri:02X}{gi:02X}{bi:02X})'


def fmt_optional_int(v):
    return 'null' if v is None else str(v)


def fmt_optional_str(v):
    return 'null' if v is None else dart_string(v)


def fmt_optional_bool(v):
    return 'null' if v is None else ('true' if v else 'false')


def gen_line_geometry(attrs, indent):
    if attrs is None:
        return 'null'
    return (
        f"IOFSymbolGeometry.line(\n"
        f"{indent}  color: {fmt_optional_str(attrs['color'])},\n"
        f"{indent}  lineWidth: {fmt_optional_int(attrs['line_width'])},\n"
        f"{indent}  dashed: {str(attrs['dashed']).lower()},\n"
        f"{indent}  dashLength: {fmt_optional_int(attrs['dash_length'])},\n"
        f"{indent}  breakLength: {fmt_optional_int(attrs['break_length'])},\n"
        f"{indent}  joinStyle: {fmt_optional_str(attrs['join_style'])},\n"
        f"{indent}  capStyle: {fmt_optional_str(attrs['cap_style'])},\n"
        f"{indent})"
    )


def gen_point_geometry(attrs, elements, indent):
    if attrs is None:
        return 'null'
    elements_dart = 'null'
    if elements:
        items = []
        for el in elements:
            items.append(gen_element(el, indent + '  '))
        elements_dart = '[\n' + ',\n'.join(items) + f'\n{indent}]'
    return (
        f"IOFSymbolGeometry.point(\n"
        f"{indent}  innerRadius: {fmt_optional_int(attrs['inner_radius'])},\n"
        f"{indent}  innerColor: {fmt_optional_str(attrs['inner_color'])},\n"
        f"{indent}  outerColor: {fmt_optional_str(attrs['outer_color'])},\n"
        f"{indent}  rotatable: {str(attrs['rotatable']).lower()},\n"
        f"{indent}  elements: {elements_dart},\n"
        f"{indent})"
    )


def gen_area_geometry(attrs, indent):
    if attrs is None:
        return 'null'
    return (
        f"IOFSymbolGeometry.area(\n"
        f"{indent}  innerColor: {fmt_optional_str(attrs['inner_color'])},\n"
        f"{indent}  rotatable: {str(attrs['rotatable']).lower()},\n"
        f"{indent})"
    )


def gen_text_geometry(attrs, indent):
    if attrs is None:
        return 'null'
    return (
        f"IOFSymbolGeometry.text(\n"
        f"{indent}  color: {fmt_optional_str(attrs['color'])},\n"
        f"{indent}  fontSize: {fmt_optional_int(attrs['font_size'])},\n"
        f"{indent}  rotatable: true,\n"
        f"{indent})"
    )


def gen_offsets(pts, indent):
    if not pts:
        return 'const []'
    items = ', '.join(f'Offset({x:.4f}, {y:.4f})' for x, y in pts)
    return f'[{items}]'


def gen_element(el, indent):
    sub_type = el['subType']
    if sub_type == 'point':
        sub_geom = gen_point_geometry(el['attrs'], None, indent + '  ')
    elif sub_type == 'line':
        sub_geom = gen_line_geometry(el['attrs'], indent + '  ')
    else:
        sub_geom = gen_area_geometry(el['attrs'], indent + '  ')
    coords = gen_offsets(el['coords'], indent)
    pattern = gen_offsets(el['pattern'], indent)
    return (
        f"{indent}IOFSymbolElement(\n"
        f"{indent}  symbol: {sub_geom},\n"
        f"{indent}  coords: {coords},\n"
        f"{indent}  pattern: {pattern},\n"
        f"{indent})"
    )


def gen_symbol(data):
    indent = '      '
    type_code = data.get('effectiveType', data['type'])
    if type_code == 1:
        geometry = gen_point_geometry(data['point'], data['elements'], indent)
    elif type_code == 2:
        geometry = gen_line_geometry(data['line'], indent)
    elif type_code == 4:
        geometry = gen_area_geometry(data['area'], indent)
    elif type_code == 8:
        geometry = gen_text_geometry(data['text'], indent)
    else:
        geometry = 'null'

    render_type = {1: 1, 2: 2, 4: 4, 8: 8}.get(type_code, 1)

    return (
        "    IOFSymbol(\n"
        f"      code: {dart_string(data['code'])},\n"
        f"      name: {dart_string(data['name'])},\n"
        f"      description: {dart_string(data['description'])},\n"
        f"      type: {render_type},\n"
        f"      id: {dart_string(data['id'])},\n"
        f"      isHidden: {str(data['isHidden']).lower()},\n"
        f"      geometry: {geometry},\n"
        "    ),"
    )


def generate(omap_path, out_path, suffix=None):
    tree = ET.parse(omap_path)
    root = tree.getroot()

    symbol_set_name = None
    symbols_el = next(e for e in root.iter() if strip_ns(e.tag) == 'symbols')
    symbol_set_name = symbols_el.get('id') or ''

    colors = parse_colors(root)

    symbols_by_id = {}
    order = []
    for sym_el in symbols_el:
        if strip_ns(sym_el.tag) != 'symbol':
            continue
        data = parse_symbol(sym_el)
        symbols_by_id[data['id']] = data
        order.append(data['id'])

    resolve_combined(symbols_by_id)

    lines = []
    lines.append('// ============================================')
    lines.append('// IOF Symbols - genere automatiquement, NE PAS EDITER A LA MAIN.')
    lines.append(f'// Source : {symbol_set_name}')
    lines.append('// Regenerer avec generate_iof_symbols.py si le fichier .omap modele change.')
    lines.append(f'// Contient {len(order)} symboles et {len(colors)} couleurs IOF.')
    lines.append('// ============================================')
    lines.append('')
    lines.append("import 'package:flutter/material.dart';")
    lines.append("import 'symbol.dart' as symbol_model;")
    lines.append('')

    # --- Colors ---
    lines.append('/// Une couleur du jeu de symboles IOF (valeurs CMJN + RVB precalcule).')
    lines.append('class IOFColor {')
    lines.append('  final int priority;')
    lines.append('  final String name;')
    lines.append('  final Color color;')
    lines.append('  final double c;')
    lines.append('  final double m;')
    lines.append('  final double y;')
    lines.append('  final double k;')
    lines.append('  final double opacity;')
    lines.append('')
    lines.append('  const IOFColor(this.priority, this.name, this.color, this.c, this.m, this.y, this.k, this.opacity);')
    lines.append('')
    lines.append('  @override')
    lines.append("  String toString() => 'IOFColor(priority: $" + "{priority}, name: $" + "{name})';")
    lines.append('}')
    lines.append('')
    lines.append('/// Palette des couleurs du jeu de symboles IOF (index = priorite 0..N-1).')
    lines.append('class IOFColors {')
    lines.append('  static const List<IOFColor> colors = [')
    for c in colors:
        color_dart = fmt_color_dart(c)
        name_dart = dart_string(c['name'])
        lines.append(
            f"    IOFColor({c['priority']}, {name_dart}, {color_dart}, "
            f"{c['c']}, {c['m']}, {c['y']}, {c['k']}, {c['opacity']}),"
        )
    lines.append('  ];')
    lines.append('')
    lines.append('  static IOFColor? getByPriority(int priority) {')
    lines.append('    if (priority >= 0 && priority < colors.length) return colors[priority];')
    lines.append('    return null;')
    lines.append('  }')
    lines.append('')
    lines.append('  static Color getColorByPriority(int priority) => getByPriority(priority)?.color ?? Colors.black;')
    lines.append('}')
    lines.append('')

    # --- Geometry / Element classes ---
    lines.append('/// Geometrie (style graphique) d\'un symbole IOF ou d\'un sous-element.')
    lines.append('class IOFSymbolGeometry {')
    lines.append("  final String symbolType; // 'point' | 'line' | 'area' | 'text'")
    lines.append('  final Map<String, dynamic> properties;')
    lines.append('')
    lines.append('  const IOFSymbolGeometry(this.symbolType, this.properties);')
    lines.append('')
    lines.append('  factory IOFSymbolGeometry.point({')
    lines.append('    required int? innerRadius,')
    lines.append('    required String? innerColor,')
    lines.append('    required String? outerColor,')
    lines.append('    bool rotatable = false,')
    lines.append('    List<IOFSymbolElement>? elements,')
    lines.append('  }) {')
    lines.append('    return IOFSymbolGeometry(\'point\', {')
    lines.append("      'inner_radius': innerRadius,")
    lines.append("      'inner_color': innerColor,")
    lines.append("      'outer_color': outerColor,")
    lines.append("      'rotatable': rotatable,")
    lines.append("      'elements': elements ?? const <IOFSymbolElement>[],")
    lines.append('    });')
    lines.append('  }')
    lines.append('')
    lines.append('  factory IOFSymbolGeometry.line({')
    lines.append('    required String? color,')
    lines.append('    required int? lineWidth,')
    lines.append('    bool dashed = false,')
    lines.append('    int? dashLength,')
    lines.append('    int? breakLength,')
    lines.append('    String? joinStyle,')
    lines.append('    String? capStyle,')
    lines.append('  }) {')
    lines.append('    return IOFSymbolGeometry(\'line\', {')
    lines.append("      'color': color,")
    lines.append("      'line_width': lineWidth,")
    lines.append("      'dashed': dashed,")
    lines.append("      'dash_length': dashLength,")
    lines.append("      'break_length': breakLength,")
    lines.append("      'join_style': joinStyle,")
    lines.append("      'cap_style': capStyle,")
    lines.append('    });')
    lines.append('  }')
    lines.append('')
    lines.append('  factory IOFSymbolGeometry.area({required String? innerColor, bool rotatable = false}) {')
    lines.append("    return IOFSymbolGeometry('area', {'inner_color': innerColor, 'rotatable': rotatable});")
    lines.append('  }')
    lines.append('')
    lines.append('  factory IOFSymbolGeometry.text({required String? color, required int? fontSize, bool rotatable = false}) {')
    lines.append("    return IOFSymbolGeometry('text', {'color': color, 'font_size': fontSize, 'rotatable': rotatable});")
    lines.append('  }')
    lines.append('')
    lines.append("  String? get colorReference {")
    lines.append("    if (symbolType == 'line' || symbolType == 'text') return properties['color']?.toString();")
    lines.append("    if (symbolType == 'point' || symbolType == 'area') return properties['inner_color']?.toString();")
    lines.append('    return null;')
    lines.append('  }')
    lines.append('')
    lines.append('  /// Couleur resolue (transparente si non definie, ex. "-1").')
    lines.append('  Color getColor() {')
    lines.append('    final colorRef = colorReference;')
    lines.append("    if (colorRef == null || colorRef == '-1') return Colors.transparent;")
    lines.append('    return IOFColors.getColorByPriority(int.tryParse(colorRef) ?? 0);')
    lines.append('  }')
    lines.append('')
    lines.append('  /// Epaisseur de ligne en mm (les unites OMAP sont en 0.001 mm).')
    lines.append('  double? get lineWidthMm {')
    lines.append("    if (symbolType != 'line') return null;")
    lines.append("    final w = properties['line_width'];")
    lines.append('    return w == null ? null : (w as int) / 1000.0;')
    lines.append('  }')
    lines.append('')
    lines.append('  /// Rayon du point central en mm.')
    lines.append('  double? get pointRadiusMm {')
    lines.append("    if (symbolType != 'point') return null;")
    lines.append("    final r = properties['inner_radius'];")
    lines.append('    return r == null ? null : (r as int) / 1000.0;')
    lines.append('  }')
    lines.append('')
    lines.append('  bool get isDashed => properties[\'dashed\'] == true;')
    lines.append('  double? get dashLengthMm {')
    lines.append("    final v = properties['dash_length'];")
    lines.append('    return v == null ? null : (v as int) / 1000.0;')
    lines.append('  }')
    lines.append('  double? get breakLengthMm {')
    lines.append("    final v = properties['break_length'];")
    lines.append('    return v == null ? null : (v as int) / 1000.0;')
    lines.append('  }')
    lines.append('')
    lines.append('  /// Sous-elements graphiques (uniquement pour un point_symbol composite).')
    lines.append('  List<IOFSymbolElement> get elements =>')
    lines.append("      (properties['elements'] as List<IOFSymbolElement>?) ?? const [];")
    lines.append('')
    lines.append('  @override')
    lines.append("  String toString() => 'IOFSymbolGeometry(type: $" + "{symbolType})';")
    lines.append('}')
    lines.append('')
    lines.append('/// Un sous-element d\'un symbole ponctuel composite (ex. les deux tirets')
    lines.append('/// du symbole "marais", ou les cercles concentriques d\'un point de')
    lines.append('/// controle). [coords] est le trace local (en mm, relatif au centre du')
    lines.append('/// symbole) dessine avec le style [symbol] ; [pattern] est la liste des')
    lines.append('/// positions ou ce trace est repete (le plus souvent une seule, (0,0)).')
    lines.append('class IOFSymbolElement {')
    lines.append('  final IOFSymbolGeometry symbol;')
    lines.append('  final List<Offset> coords;')
    lines.append('  final List<Offset> pattern;')
    lines.append('')
    lines.append('  const IOFSymbolElement({required this.symbol, this.coords = const [], this.pattern = const [Offset.zero]});')
    lines.append('}')
    lines.append('')

    # --- IOFSymbol class ---
    lines.append('/// Un symbole IOF complet (issu de la specification ISOM/ISSprOM).')
    lines.append('class IOFSymbol {')
    lines.append('  final String code;')
    lines.append('  final String name;')
    lines.append('  final String description;')
    lines.append('  final int type; // 1=point, 2=ligne, 4=surface, 8=texte')
    lines.append('  final String? id;')
    lines.append('  final bool isHidden;')
    lines.append('  final IOFSymbolGeometry? geometry;')
    lines.append('')
    lines.append('  const IOFSymbol({')
    lines.append('    required this.code,')
    lines.append('    required this.name,')
    lines.append('    required this.description,')
    lines.append('    required this.type,')
    lines.append('    this.id,')
    lines.append('    this.isHidden = false,')
    lines.append('    this.geometry,')
    lines.append('  });')
    lines.append('')
    lines.append('  bool get isPoint => type == 1;')
    lines.append('  bool get isLine => type == 2;')
    lines.append('  bool get isArea => type == 4;')
    lines.append('  bool get isText => type == 8;')
    lines.append('')
    lines.append('  /// Groupe ISOM (base sur la plage numerique du code), en anglais.')
    lines.append('  String get category {')
    for lo, hi, en, _ in CATEGORY_RANGES:
        lines.append(f"    if (_baseCode >= {lo} && _baseCode <= {hi}) return '{en}';")
    lines.append("    return 'Other';")
    lines.append('  }')
    lines.append('')
    lines.append('  /// Groupe ISOM, libelle en francais (pour l\'UI).')
    lines.append('  String get categoryFr {')
    for lo, hi, _, fr in CATEGORY_RANGES:
        lines.append(f"    if (_baseCode >= {lo} && _baseCode <= {hi}) return '{fr}';")
    lines.append("    return 'Autres';")
    lines.append('  }')
    lines.append('')
    lines.append('  int get _baseCode => int.tryParse(code.split(\'.\').first) ?? -1;')
    lines.append('')
    lines.append('  /// Couleur declaree par le symbole (peut etre transparente : de')
    lines.append('  /// nombreux symboles ponctuels composites n\'ont pas de couleur au')
    lines.append('  /// niveau racine, leur rendu vient uniquement de [geometry.elements]).')
    lines.append('  Color get color => geometry?.getColor() ?? Colors.black;')
    lines.append('')
    lines.append('  /// Couleur utilisable pour un apercu/UI : ne renvoie jamais transparent')
    lines.append('  /// (retombe sur une teinte par categorie), pour eviter un symbole')
    lines.append('  /// invisible dans le selecteur ou sur la carte.')
    lines.append('  Color get displayColor {')
    lines.append('    final c = color;')
    lines.append('    if (c != Colors.transparent) return c;')
    lines.append("    switch (category) {")
    lines.append("      case 'Landforms': return const Color(0xFFD15C00);")
    lines.append("      case 'Rock and boulders': return Colors.black;")
    lines.append("      case 'Water and marsh': return const Color(0xFF00B0FF);")
    lines.append("      case 'Vegetation': return const Color(0xFF3DAA17);")
    lines.append("      case 'Man-made features': return Colors.black;")
    lines.append('      default: return Colors.black87;')
    lines.append('    }')
    lines.append('  }')
    lines.append('')
    lines.append('  /// Construit un [symbol_model.MapSymbol] pret a etre place sur la')
    lines.append('  /// carte a partir de cette definition IOF.')
    lines.append('  symbol_model.MapSymbol createMapSymbol({')
    lines.append('    required String id,')
    lines.append('    Offset position = Offset.zero,')
    lines.append('    List<Offset>? points,')
    lines.append('    double rotation = 0.0,')
    lines.append('  }) {')
    lines.append('    switch (type) {')
    lines.append('      case 1:')
    lines.append('        final diameter = (geometry?.pointRadiusMm ?? 0.5) * 2;')
    lines.append('        return symbol_model.MapSymbol(')
    lines.append('          id: id,')
    lines.append('          type: symbol_model.MapSymbolType.point,')
    lines.append('          iofCode: code,')
    lines.append('          code: code,')
    lines.append('          name: name,')
    lines.append('          description: description,')
    lines.append('          position: position,')
    lines.append('          points: [position],')
    lines.append('          color: displayColor,')
    lines.append('          size: diameter > 0 ? diameter : 1.0,')
    lines.append('          rotation: rotation,')
    lines.append('        );')
    lines.append('      case 2:')
    lines.append('        final pts = points ?? [position, position + const Offset(10, 0)];')
    lines.append('        return symbol_model.MapSymbol(')
    lines.append('          id: id,')
    lines.append('          type: symbol_model.MapSymbolType.line,')
    lines.append('          iofCode: code,')
    lines.append('          code: code,')
    lines.append('          name: name,')
    lines.append('          description: description,')
    lines.append('          position: pts.first,')
    lines.append('          points: pts,')
    lines.append('          color: displayColor,')
    lines.append('          strokeColor: displayColor,')
    lines.append('          strokeWidth: geometry?.lineWidthMm ?? 0.15,')
    lines.append('          isDashed: geometry?.isDashed ?? false,')
    lines.append('          dashLength: geometry?.dashLengthMm,')
    lines.append('          gapLength: geometry?.breakLengthMm,')
    lines.append('        );')
    lines.append('      case 4:')
    lines.append('        final pts = points ??')
    lines.append('            [')
    lines.append('              position,')
    lines.append('              position + const Offset(10, 0),')
    lines.append('              position + const Offset(10, 10),')
    lines.append('              position + const Offset(0, 10),')
    lines.append('              position,')
    lines.append('            ];')
    lines.append('        return symbol_model.MapSymbol(')
    lines.append('          id: id,')
    lines.append('          type: symbol_model.MapSymbolType.area,')
    lines.append('          iofCode: code,')
    lines.append('          code: code,')
    lines.append('          name: name,')
    lines.append('          description: description,')
    lines.append('          position: pts.first,')
    lines.append('          points: pts,')
    lines.append('          color: displayColor,')
    lines.append('          fillColor: displayColor,')
    lines.append('          strokeColor: displayColor,')
    lines.append('          strokeWidth: 0.0,')
    lines.append('          isClosed: true,')
    lines.append('        );')
    lines.append('      default:')
    lines.append('        return symbol_model.MapSymbol(')
    lines.append('          id: id,')
    lines.append('          type: symbol_model.MapSymbolType.text,')
    lines.append('          iofCode: code,')
    lines.append('          code: code,')
    lines.append('          name: name,')
    lines.append('          description: description,')
    lines.append('          position: position,')
    lines.append('          points: [position],')
    lines.append('          color: displayColor,')
    lines.append('          text: name,')
    lines.append('          fontSize: 3.0,')
    lines.append('        );')
    lines.append('    }')
    lines.append('  }')
    lines.append('')
    lines.append('  @override')
    lines.append("  String toString() => 'IOFSymbol(code: $" + "{code}, name: $" + "{name})';")
    lines.append('')
    lines.append('  @override')
    lines.append('  bool operator ==(Object other) => identical(this, other) || (other is IOFSymbol && other.code == code);')
    lines.append('')
    lines.append('  @override')
    lines.append('  int get hashCode => code.hashCode;')
    lines.append('}')
    lines.append('')

    # --- IOFSymbols library ---
    lines.append(f'/// Bibliotheque complete des symboles {symbol_set_name} ({len(order)} symboles).')
    lines.append('class IOFSymbols {')
    lines.append('  static final List<IOFSymbol> symbols = [')
    for sid in order:
        lines.append(gen_symbol(symbols_by_id[sid]))
    lines.append('  ];')
    lines.append('')
    lines.append('  static final Map<String, IOFSymbol> _byCode = {')
    lines.append('    for (final s in symbols) s.code: s,')
    lines.append('  };')
    lines.append('')
    lines.append('  /// Symboles visibles dans un selecteur (masque les variantes de')
    lines.append('  /// migration ISOM2000 et les parties internes des symboles combines).')
    lines.append('  static final List<IOFSymbol> visibleSymbols =')
    lines.append('      symbols.where((s) => !s.isHidden).toList(growable: false);')
    lines.append('')
    lines.append('  /// Recherche par code exact, puis par code de base (ex. "104.9" absent')
    lines.append('  /// -> repli sur "104") : utile pour les fichiers .omap externes qui')
    lines.append('  /// referencent une variante non listee ici.')
    lines.append('  static IOFSymbol? getByCode(String code) {')
    lines.append('    final exact = _byCode[code];')
    lines.append('    if (exact != null) return exact;')
    lines.append('    final base = code.split(\'.\').first;')
    lines.append('    return _byCode[base];')
    lines.append('  }')
    lines.append('')
    lines.append('  static List<IOFSymbol> getByCategory(String category, {bool visibleOnly = true}) {')
    lines.append('    final source = visibleOnly ? visibleSymbols : symbols;')
    lines.append('    return source.where((s) => s.category == category).toList();')
    lines.append('  }')
    lines.append('')
    lines.append('  static List<String> getCategories() =>')
    lines.append('      visibleSymbols.map((s) => s.category).toSet().toList()..sort();')
    lines.append('')
    lines.append('  static List<IOFSymbol> search(String query, {bool visibleOnly = true}) {')
    lines.append('    final source = visibleOnly ? visibleSymbols : symbols;')
    lines.append('    final q = query.toLowerCase();')
    lines.append('    return source')
    lines.append('        .where((s) => s.code.toLowerCase().contains(q) || s.name.toLowerCase().contains(q))')
    lines.append('        .toList();')
    lines.append('  }')
    lines.append('}')
    lines.append('')

    dart_source = '\n'.join(lines)
    if suffix:
        dart_source = apply_suffix(dart_source, suffix)

    with open(out_path, 'w', encoding='utf-8') as f:
        f.write(dart_source)

    print(f'{len(order)} symboles, {len(colors)} couleurs -> {out_path}')


if __name__ == '__main__':
    if len(sys.argv) not in (3, 5):
        print(__doc__)
        sys.exit(1)
    suffix_arg = None
    if len(sys.argv) == 5:
        if sys.argv[3] != '--suffix':
            print(__doc__)
            sys.exit(1)
        suffix_arg = sys.argv[4]
    generate(sys.argv[1], sys.argv[2], suffix=suffix_arg)
