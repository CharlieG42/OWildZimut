import 'package:flutter/material.dart';

/// Extension pour ajouter la méthode dot à Offset
extension OffsetExtensions on Offset {
  double dot(Offset other) {
    return dx * other.dx + dy * other.dy;
  }
}
