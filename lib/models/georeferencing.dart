import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Point de contrôle au sol pour le géoréférencement
///
/// Un point de contrôle au sol est un point dont on connaît à la fois
/// les coordonnées dans le repère de la carte (en mm) et les coordonnées
/// géographiques réelles (latitude, longitude, altitude).
class GroundControlPoint {
  /// Identifiant unique du point
  final String id;
  
  /// Nom du point
  final String name;
  
  /// Position dans le repère de la carte (en mm)
  final Offset mapPosition;
  
  /// Coordonnées géographiques (latitude, longitude en degrés décimaux)
  final LatLng geoPosition;
  
  /// Altitude (en mètres, optionnelle)
  final double? altitude;
  
  /// Précision estimée (en mètres)
  final double accuracy;

  /// Crée un nouveau point de contrôle au sol
  GroundControlPoint({
    required this.id,
    required this.name,
    required this.mapPosition,
    required this.geoPosition,
    this.altitude,
    this.accuracy = 0.0,
  });

  /// Crée une copie avec modifications
  GroundControlPoint copyWith({
    String? id,
    String? name,
    Offset? mapPosition,
    LatLng? geoPosition,
    double? altitude,
    double? accuracy,
  }) {
    return GroundControlPoint(
      id: id ?? this.id,
      name: name ?? this.name,
      mapPosition: mapPosition ?? this.mapPosition,
      geoPosition: geoPosition ?? this.geoPosition,
      altitude: altitude ?? this.altitude,
      accuracy: accuracy ?? this.accuracy,
    );
  }

  /// Exporte en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'map_position': {'x': mapPosition.dx, 'y': mapPosition.dy},
      'geo_position': {'lat': geoPosition.latitude, 'lng': geoPosition.longitude},
      if (altitude != null) 'altitude': altitude,
      'accuracy': accuracy,
    };
  }

  /// Charge depuis JSON
  factory GroundControlPoint.fromJson(Map<String, dynamic> json) {
    return GroundControlPoint(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      mapPosition: Offset(
        (json['map_position']?['x'] as num?)?.toDouble() ?? 0.0,
        (json['map_position']?['y'] as num?)?.toDouble() ?? 0.0,
      ),
      geoPosition: LatLng(
        (json['geo_position']?['lat'] as num?)?.toDouble() ?? 0.0,
        (json['geo_position']?['lng'] as num?)?.toDouble() ?? 0.0,
      ),
      altitude: (json['altitude'] as num?)?.toDouble(),
      accuracy: (json['accuracy'] as num?)?.toDouble() ?? 0.0,
    );
  }

  @override
  String toString() {
    return 'GroundControlPoint(id: $id, name: $name, map: $mapPosition, geo: $geoPosition)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GroundControlPoint &&
        other.id == id &&
        other.name == name &&
        other.mapPosition == mapPosition &&
        other.geoPosition == geoPosition &&
        other.altitude == altitude &&
        other.accuracy == accuracy;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        mapPosition.hashCode ^
        geoPosition.hashCode ^
        altitude.hashCode ^
        accuracy.hashCode;
  }
}

/// Coordonnées géographiques (latitude, longitude)
class LatLng {
  /// Latitude en degrés décimaux
  final double latitude;
  
  /// Longitude en degrés décimaux
  final double longitude;

  /// Crée de nouvelles coordonnées géographiques
  const LatLng(this.latitude, this.longitude);

  /// Exporte en JSON
  Map<String, dynamic> toJson() {
    return {
      'lat': latitude,
      'lng': longitude,
    };
  }

  /// Charge depuis JSON
  factory LatLng.fromJson(Map<String, dynamic> json) {
    return LatLng(
      (json['lat'] as num?)?.toDouble() ?? 0.0,
      (json['lng'] as num?)?.toDouble() ?? 0.0,
    );
  }

  /// Distance entre deux points géographiques (formule de Haversine)
  ///
  /// [other] : L'autre point
  /// Retourne la distance en mètres
  double distanceTo(LatLng other) {
    const earthRadius = 6371000.0; // Rayon de la Terre en mètres
    
    final lat1 = latitude * 0.017453292519943295; // deg to rad
    final lon1 = longitude * 0.017453292519943295;
    final lat2 = other.latitude * 0.017453292519943295;
    final lon2 = other.longitude * 0.017453292519943295;
    
    final dLat = lat2 - lat1;
    final dLon = lon2 - lon1;
    
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1) * math.cos(lat2) *
        math.sin(dLon / 2) * math.sin(dLon / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    
    return earthRadius * c;
  }

  /// Cap entre deux points (en degrés)
  ///
  /// [other] : L'autre point
  /// Retourne le cap en degrés (0 = Nord, 90 = Est, etc.)
  double bearingTo(LatLng other) {
    final lat1 = latitude * 0.017453292519943295;
    final lon1 = longitude * 0.017453292519943295;
    final lat2 = other.latitude * 0.017453292519943295;
    final lon2 = other.longitude * 0.017453292519943295;
    
    final y = math.sin(lon2 - lon1) * math.cos(lat2);
    final x = math.cos(lat1) * math.sin(lat2) - math.sin(lat1) * math.cos(lat2) * math.cos(lon2 - lon1);
    
    final bearing = math.atan2(y, x);
    return bearing * 57.29577951308232; // rad to deg
  }

  @override
  String toString() {
    return 'LatLng($latitude, $longitude)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LatLng &&
        other.latitude == latitude &&
        other.longitude == longitude;
  }

  @override
  int get hashCode => latitude.hashCode ^ longitude.hashCode;
}

/// Transformation affine pour la conversion de coordonnées
///
/// Cette classe représente une transformation affine 2D qui peut être utilisée
/// pour convertir entre le repère de la carte et le repère géographique.
class AffineTransformation {
  /// Matrice de transformation [a, b, c, d, e, f]
  /// où : x' = a * x + b * y + c
  ///       y' = d * x + e * y + f
  final List<double> matrix;

  /// Crée une nouvelle transformation affine
  AffineTransformation(this.matrix);

  /// Transformation identité
  factory AffineTransformation.identity() {
    return AffineTransformation([1, 0, 0, 0, 1, 0]);
  }

  /// Crée une transformation à partir de points de contrôle
  ///
  /// [mapPoints] : Liste de points dans le repère de la carte
  /// [geoPoints] : Liste de points géographiques correspondants
  /// Nécessite au moins 3 points non alignés pour une transformation complète
  factory AffineTransformation.fromControlPoints(
    List<Offset> mapPoints,
    List<LatLng> geoPoints,
  ) {
    if (mapPoints.length < 3 || geoPoints.length < 3) {
      return AffineTransformation.identity();
    }
    
    // Pour l'instant, on retourne une transformation identité
    // TODO: Implémenter le calcul de la transformation affine
    return AffineTransformation.identity();
  }

  /// Applique la transformation à un point
  Offset transform(Offset point) {
    final x = matrix[0] * point.dx + matrix[1] * point.dy + matrix[2];
    final y = matrix[3] * point.dx + matrix[4] * point.dy + matrix[5];
    return Offset(x, y);
  }

  /// Applique l'inverse de la transformation à un point
  Offset inverseTransform(Offset point) {
    // Pour l'instant, on retourne le point inchangé
    // TODO: Implémenter l'inverse de la transformation
    return point;
  }

  /// Exporte en JSON
  Map<String, dynamic> toJson() {
    return {
      'matrix': matrix,
    };
  }

  /// Charge depuis JSON
  factory AffineTransformation.fromJson(Map<String, dynamic> json) {
    final matrixData = json['matrix'] as List<dynamic>? ?? [];
    return AffineTransformation(
      matrixData.map((v) => (v as num?)?.toDouble() ?? 0.0).toList(),
    );
  }
}

/// Gestion du géoréférencement de la carte
///
/// Cette classe gère la conversion entre les coordonnées de la carte
/// (en mm) et les coordonnées géographiques réelles.
class Georeferencing {
  /// Échelle de la carte (1:scale = scale mètres pour 1 mm sur la carte)
  final double scale;
  
  /// Rotation 
