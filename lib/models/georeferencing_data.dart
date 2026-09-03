/// Modèle pour stocker les données de géoréférencement extraites d'un GeoPDF.
/// Ces données permettent de transformer les coordonnées du PDF (en points)
/// en coordonnées géographiques (latitude/longitude ou projetées).
class GeoreferencingData {
  /// Système de coordonnées (ex: "EPSG:3857", "EPSG:4326")
  final String crs;

  /// Coordonnées géographiques des coins du PDF (dans l'ordre :
  /// [minLon, minLat, maxLon, minLat, maxLon, maxLat, minLon, maxLat])
  /// Correspond aux GPTS (Geo Points) du Viewport GEO.
  final List<double> geographicPoints;

  /// Coordonnées locales dans le PDF (en points, normalisées entre 0 et 1)
  /// Correspond aux LPTS (Local Points) du Viewport GEO.
  final List<double> localPoints;

  /// Bounds géographiques calculés (minLon, minLat, maxLon, maxLat)
  final List<double> bounds;

  /// Largeur du PDF en points
  final double width;

  /// Hauteur du PDF en points
  final double height;

  /// Résolution en DPI (points par pouce)
  final double dpi;

  const GeoreferencingData({
    required this.crs,
    required this.geographicPoints,
    required this.localPoints,
    required this.bounds,
    required this.width,
    required this.height,
    this.dpi = 300.0,
  });

  /// Crée un GeoreferencingData à partir des données brutes du Viewport GEO
  factory GeoreferencingData.fromViewport({
    required String crs,
    required List<double> gpts,
    required List<double> lpts,
    required double width,
    required double height,
    double dpi = 300.0,
  }) {
    // Calculer les bounds à partir des GPTS
    final lons = [gpts[0], gpts[2], gpts[4], gpts[6]];
    final lats = [gpts[1], gpts[3], gpts[5], gpts[7]];
    final minLon = lons.reduce((a, b) => a < b ? a : b);
    final maxLon = lons.reduce((a, b) => a > b ? a : b);
    final minLat = lats.reduce((a, b) => a < b ? a : b);
    final maxLat = lats.reduce((a, b) => a > b ? a : b);

    return GeoreferencingData(
      crs: crs,
      geographicPoints: gpts,
      localPoints: lpts,
      bounds: [minLon, minLat, maxLon, maxLat],
      width: width,
      height: height,
      dpi: dpi,
    );
  }

  /// Convertit des coordonnées locales (en points dans le PDF) en coordonnées géographiques
  /// [x, y] en points → [longitude, latitude]
  List<double> localToGeo(List<double> localCoords) {
    final x = localCoords[0];
    final y = localCoords[1];

    // Normaliser les coordonnées locales entre 0 et 1
    final normX = x / width;
    final normY = y / height;

    // Interpolation linéaire entre les bounds
    final lon = bounds[0] + (bounds[2] - bounds[0]) * normX;
    final lat = bounds[1] + (bounds[3] - bounds[1]) * (1 - normY); // Inversé car Y va de haut en bas

    return [lon, lat];
  }

  /// Convertit des coordonnées géographiques en coordonnées locales (en points)
  /// [longitude, latitude] → [x, y] en points
  List<double> geoToLocal(List<double> geoCoords) {
    final lon = geoCoords[0];
    final lat = geoCoords[1];

    // Normaliser entre 0 et 1
    final normX = (lon - bounds[0]) / (bounds[2] - bounds[0]);
    final normY = 1 - ((lat - bounds[1]) / (bounds[3] - bounds[1])); // Inversé

    final x = normX * width;
    final y = normY * height;

    return [x, y];
  }

  /// Génère la chaîne de grid pour un fichier OMAP
  /// Format OMAP : "minLon,minLat maxLon,minLat maxLon,maxLat minLon,maxLat"
  String toOmapGrid() {
    return '${bounds[0]},${bounds[1]} ${bounds[2]},${bounds[1]} '
        '${bounds[2]},${bounds[3]} ${bounds[0]},${bounds[3]}';
  }

  /// Copie avec modification
  GeoreferencingData copyWith({
    String? crs,
    List<double>? geographicPoints,
    List<double>? localPoints,
    List<double>? bounds,
    double? width,
    double? height,
    double? dpi,
  }) {
    return GeoreferencingData(
      crs: crs ?? this.crs,
      geographicPoints: geographicPoints ?? this.geographicPoints,
      localPoints: localPoints ?? this.localPoints,
      bounds: bounds ?? this.bounds,
      width: width ?? this.width,
      height: height ?? this.height,
      dpi: dpi ?? this.dpi,
    );
  }

  @override
  String toString() {
    return 'GeoreferencingData('
        'crs: $crs, '
        'bounds: $bounds, '
        'size: ${width}x$height, '
        'dpi: $dpi)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GeoreferencingData &&
        other.crs == crs &&
        other.geographicPoints == geographicPoints &&
        other.localPoints == localPoints &&
        other.bounds == bounds &&
        other.width == width &&
        other.height == height &&
        other.dpi == dpi;
  }

  @override
  int get hashCode {
    return Object.hash(
      crs,
      geographicPoints,
      localPoints,
      bounds,
      width,
      height,
      dpi,
    );
  }
}
