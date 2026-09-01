import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Classe pour gérer le géoréférencement des cartes
/// 
/// Le géoréférencement permet de relier les coordonnées de la carte (en pixels)
/// à des coordonnées réelles (en mètres ou en degrés).
class Georeferencing {
  /// Dénominateur de l'échelle (ex: 10000 pour 1:10000)
  final int scaleDenominator;
  
  /// Facteur d'échelle de la grille
  final double? gridScaleFactor;
  
  /// Facteur d'échelle auxiliaire
  final double? auxiliaryScaleFactor;
  
  /// Grivation (rotation de la grille)
  final double? grivation;
  
  /// ID du système de coordonnées projetées (ex: "UTM")
  final String? crsId;
  
  /// Spécification PROJ.4 pour le système de coordonnées projetées
  final String? proj4Spec;
  
  /// Paramètre du système de coordonnées projetées
  final String? crsParameter;
  
  /// Point de référence dans la carte (en mm)
  final Offset? refPoint;
  
  /// Point de référence dans le monde réel (en mètres ou coordonnées projetées)
  final Offset? refPointReal;
  
  /// ID du système de coordonnées géographiques
  final String? geographicCrsId;
  
  /// Spécification PROJ.4 pour le système de coordonnées géographiques
  final String? geographicProj4Spec;
  
  /// Point de référence en degrés (latitude, longitude)
  final GeographicRefPoint? refPointDeg;

  const Georeferencing({
    this.scaleDenominator = 10000,
    this.gridScaleFactor,
    this.auxiliaryScaleFactor,
    this.grivation,
    this.crsId,
    this.proj4Spec,
    this.crsParameter,
    this.refPoint,
    this.refPointReal,
    this.geographicCrsId,
    this.geographicProj4Spec,
    this.refPointDeg,
  });

  /// Crée un géoréférencement basique avec une échelle
  factory Georeferencing.basic({
    int scaleDenominator = 10000,
    String? crsId,
    Offset? refPoint,
  }) {
    return Georeferencing(
      scaleDenominator: scaleDenominator,
      crsId: crsId,
      refPoint: refPoint,
    );
  }

  /// Crée un géoréférencement à partir de points de contrôle
  /// 
  /// [controlPoints] : Liste de points de contrôle (au moins 2 requis)
  /// [crsId] : ID du système de coordonnées
  factory Georeferencing.fromControlPoints(
    List<GroundControlPoint> controlPoints, {
    String? crsId,
  }) {
    if (controlPoints.length < 2) {
      throw ArgumentError('Au moins 2 points de contrôle sont requis');
    }

    // Calculer la transformation affine
    final transformation = AffineTransformation.fromPoints(controlPoints);
    
    // Calculer l'échelle moyenne
    final scale = transformation.scale;
    
    return Georeferencing(
      scaleDenominator: (1 / scale).round(),
      crsId: crsId,
      refPoint: controlPoints.first.mapPoint,
      refPointReal: controlPoints.first.realPoint,
    );
  }

  /// Convertit des coordonnées de la carte (mm) en coordonnées réelles (m)
  Offset? toRealCoordinates(Offset mapPoint) {
    if (refPoint == null || refPointReal == null) return null;
    
    // Calculer le décalage par rapport au point de référence
    final delta = mapPoint - refPoint!;
    
    // Convertir en mètres (1 mm sur la carte = scaleDenominator / 1000 mètres)
    // 1:10000 signifie 1 cm = 100 m, donc 1 mm = 1 m
    // Donc échelle = scaleDenominator / 1000
    final scaleFactor = scaleDenominator / 1000.0;
    
    return refPointReal! + Offset(
      delta.dx * scaleFactor,
      delta.dy * scaleFactor,
    );
  }

  /// Convertit des coordonnées réelles (m) en coordonnées de la carte (mm)
  Offset? toMapCoordinates(Offset realPoint) {
    if (refPoint == null || refPointReal == null) return null;
    
    // Calculer le décalage par rapport au point de référence réel
    final delta = realPoint - refPointReal!;
    
    // Convertir en mm sur la carte
    final scaleFactor = 1000.0 / scaleDenominator;
    
    return refPoint! + Offset(
      delta.dx * scaleFactor,
      delta.dy * scaleFactor,
    );
  }

  /// Exporte en JSON
  Map<String, dynamic> toJson() {
    return {
      'scale_denominator': scaleDenominator,
      if (gridScaleFactor != null) 'grid_scale_factor': gridScaleFactor,
      if (auxiliaryScaleFactor != null) 'auxiliary_scale_factor': auxiliaryScaleFactor,
      if (grivation != null) 'grivation': grivation,
      if (crsId != null) 'crs_id': crsId,
      if (proj4Spec != null) 'proj4_spec': proj4Spec,
      if (crsParameter != null) 'crs_parameter': crsParameter,
      if (refPoint != null) 'ref_point': {'x': refPoint!.dx, 'y': refPoint!.dy},
      if (refPointReal != null) 'ref_point_real': {'x': refPointReal!.dx, 'y': refPointReal!.dy},
      if (geographicCrsId != null) 'geographic_crs_id': geographicCrsId,
      if (geographicProj4Spec != null) 'geographic_proj4_spec': geographicProj4Spec,
      if (refPointDeg != null) 'ref_point_deg': {
        'lat': refPointDeg!.latitude,
        'lon': refPointDeg!.longitude,
      },
    };
  }

  /// Charge depuis JSON
  factory Georeferencing.fromJson(Map<String, dynamic> json) {
    return Georeferencing(
      scaleDenominator: json['scale_denominator'] as int? ?? 10000,
      gridScaleFactor: json['grid_scale_factor'] as double?,
      auxiliaryScaleFactor: json['auxiliary_scale_factor'] as double?,
      grivation: json['grivation'] as double?,
      crsId: json['crs_id'] as String?,
      proj4Spec: json['proj4_spec'] as String?,
      crsParameter: json['crs_parameter'] as String?,
      refPoint: json['ref_point'] != null
          ? Offset(
              (json['ref_point']['x'] as num?)?.toDouble() ?? 0.0,
              (json['ref_point']['y'] as num?)?.toDouble() ?? 0.0,
            )
          : null,
      refPointReal: json['ref_point_real'] != null
          ? Offset(
              (json['ref_point_real']['x'] as num?)?.toDouble() ?? 0.0,
              (json['ref_point_real']['y'] as num?)?.toDouble() ?? 0.0,
            )
          : null,
      geographicCrsId: json['geographic_crs_id'] as String?,
      geographicProj4Spec: json['geographic_proj4_spec'] as String?,
      refPointDeg: json['ref_point_deg'] != null
          ? GeographicRefPoint(
              (json['ref_point_deg']['lat'] as num?)?.toDouble() ?? 0.0,
              (json['ref_point_deg']['lon'] as num?)?.toDouble() ?? 0.0,
            )
          : null,
    );
  }
}

/// Point de contrôle pour le géoréférencement
/// 
/// Un point de contrôle relie un point sur la carte (en mm) à un point réel
/// (en mètres ou en coordonnées géographiques).
class GroundControlPoint {
  /// Position sur la carte (en mm)
  final Offset mapPoint;
  
  /// Position réelle (en mètres ou coordonnées projetées)
  final Offset realPoint;

  const GroundControlPoint({
    required this.mapPoint,
    required this.realPoint,
  });

  /// Crée un point de contrôle à partir de coordonnées latitude/longitude
  factory GroundControlPoint.fromLatLng({
    required Offset mapPoint,
    required double latitude,
    required double longitude,
  }) {
    // Conversion simplifiée : on suppose que lat/lon sont en degrés
    // et on les convertit en mètres (approximation)
    // Note: Une conversion précise nécessiterait une projection cartographique
    return GroundControlPoint(
      mapPoint: mapPoint,
      realPoint: Offset(longitude, latitude), // Simplifié
    );
  }
}

/// Point de référence géographique (latitude/longitude en degrés)
class GeographicRefPoint {
  final double latitude;
  final double longitude;

  const GeographicRefPoint(this.latitude, this.longitude);

  /// Convertit en Offset (pour compatibilité)
  Offset toOffset() => Offset(longitude, latitude);
}

/// Transformation affine pour le géoréférencement
/// 
/// Une transformation affine permet de convertir des coordonnées entre deux
/// systèmes de coordonnées à l'aide d'une matrice 2x3.
class AffineTransformation {
  /// Coefficients de la transformation :
  /// x' = a * x + b * y + c
  /// y' = d * x + e * y + f
  final double a, b, c;
  final double d, e, f;

  const AffineTransformation(this.a, this.b, this.c, this.d, this.e, this.f);

  /// Transformation identité
  static const AffineTransformation identity = AffineTransformation(1, 0, 0, 0, 1, 0);

  /// Crée une transformation affine à partir de points de contrôle
  /// 
  /// [controlPoints] : Liste de points de contrôle (au moins 3 requis pour une
  /// transformation affine complète, mais 2 points suffisent pour une
  /// transformation de similarité)
  factory AffineTransformation.fromPoints(List<GroundControlPoint> controlPoints) {
    if (controlPoints.length < 2) {
      throw ArgumentError('Au moins 2 points de contrôle sont requis');
    }

    if (controlPoints.length >= 3) {
      // Transformation affine complète (6 paramètres)
      return _calculateAffineTransformation(controlPoints);
    } else {
      // Transformation de similarité (4 paramètres : translation, rotation, échelle)
      return _calculateSimilarityTransformation(controlPoints);
    }
  }

  /// Calcule une transformation affine complète à partir de 3+ points
  static AffineTransformation _calculateAffineTransformation(List<GroundControlPoint> points) {
    // On utilise les 3 premiers points pour calculer la transformation
    final p1 = points[0];
    final p2 = points[1];
    final p3 = points[2];

    // Matrice des coordonnées sources (map)
    final x1 = p1.mapPoint.dx;
    final y1 = p1.mapPoint.dy;
    final x2 = p2.mapPoint.dx;
    final y2 = p2.mapPoint.dy;
    final x3 = p3.mapPoint.dx;
    final y3 = p3.mapPoint.dy;

    // Matrice des coordonnées destinations (real)
    final x1p = p1.realPoint.dx;
    final y1p = p1.realPoint.dy;
    final x2p = p2.realPoint.dx;
    final y2p = p2.realPoint.dy;
    final x3p = p3.realPoint.dx;
    final y3p = p3.realPoint.dy;

    // Résoudre le système d'équations pour a, b, c, d, e, f
    // x' = a*x + b*y + c
    // y' = d*x + e*y + f
    
    // Pour 3 points, on a 6 équations :
    // x1p = a*x1 + b*y1 + c
    // x2p = a*x2 + b*y2 + c
    // x3p = a*x3 + b*y3 + c
    // y1p = d*x1 + e*y1 + f
    // y2p = d*x2 + e*y2 + f
    // y3p = d*x3 + e*y3 + f
    
    // Résoudre pour a, b, c
    final denom = (y2 - y3) * (x1 - x2) - (x2 - x3) * (y1 - y2);
    
    if (denom == 0) {
      // Les points sont colinéaires, utiliser une transformation de similarité
      return _calculateSimilarityTransformation(points);
    }
    
    final a = ((y2 - y3) * (x1p - x2p) - (x2 - x3) * (y1p - y2p)) / denom;
    final b = ((x3 - x2) * (x1p - x2p) - (x1 - x2) * (x3p - x2p)) / denom;
    final c = x1p - a * x1 - b * y1;
    
    final d = ((y2 - y3) * (y1p - y2p) - (x2 - x3) * (x1p - x2p)) / denom;
    final e = ((x3 - x2) * (y1p - y2p) - (x1 - x2) * (y3p - y2p)) / denom;
    final f = y1p - d * x1 - e * y1;

    return AffineTransformation(a, b, c, d, e, f);
  }

  /// Calcule une transformation de similarité à partir de 2 points
  static AffineTransformation _calculateSimilarityTransformation(List<GroundControlPoint> points) {
    final p1 = points[0];
    final p2 = points[1];

    // Vecteurs
    final dx = p2.mapPoint.dx - p1.mapPoint.dx;
    final dy = p2.mapPoint.dy - p1.mapPoint.dy;
    final dxp = p2.realPoint.dx - p1.realPoint.dx;
    final dyp = p2.realPoint.dy - p1.realPoint.dy;

    // Calculer l'échelle et la rotation
    final scale = math.sqrt(dxp * dxp + dyp * dyp) / math.sqrt(dx * dx + dy * dy);
    final cosTheta = (dx * dxp + dy * dyp) / (math.sqrt(dx * dx + dy * dy) * math.sqrt(dxp * dxp + dyp * dyp));
    final sinTheta = (dx * dyp - dy * dxp) / (math.sqrt(dx * dx + dy * dy) * math.sqrt(dxp * dxp + dyp * dyp));

    // Coefficients de la transformation
    final a = scale * cosTheta;
    final b = -scale * sinTheta;
    final d = scale * sinTheta;
    final e = scale * cosTheta;
    final c = p2.realPoint.dx - a * p2.mapPoint.dx - b * p2.mapPoint.dy;
    final f = p2.realPoint.dy - d * p2.mapPoint.dx - e * p2.mapPoint.dy;

    return AffineTransformation(a, b, c, d, e, f);
  }

  /// Applique la transformation à un point
  Offset transform(Offset point) {
    return Offset(
      a * point.dx + b * point.dy + c,
      d * point.dx + e * point.dy + f,
    );
  }

  /// Applique l'inverse de la transformation à un point
  Offset inverseTransform(Offset point) {
    // Calculer le déterminant
    final det = a * e - b * d;
    
    if (det == 0) {
      // La transformation n'est pas inversible
      return point;
    }
    
    final invDet = 1 / det;
    
    return Offset(
      (e * (point.dx - c) - b * (point.dy - f)) * invDet,
      (-d * (point.dx - c) + a * (point.dy - f)) * invDet,
    );
  }

  /// Échelle moyenne de la transformation
  double get scale {
    // Échelle dans la direction x
    final scaleX = math.sqrt(a * a + d * d);
    // Échelle dans la direction y
    final scaleY = math.sqrt(b * b + e * e);
    // Échelle moyenne
    return (scaleX + scaleY) / 2;
  }

  /// Rotation moyenne de la transformation (en radians)
  double get rotation {
    // Utiliser l'atan2 de la matrice de rotation
    return math.atan2(d, a);
  }
}
