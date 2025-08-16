import 'package:flutter/material.dart';
import 'package:pattern_box/pattern_box.dart';

/// Une surcouche sur PatternBox qui permet de faire tourner le motif
class RotatablePatternBox extends PatternBox {
  // en radians

  RotatablePatternBox({
    required this.originalPattern,
    this.rotationAngle = 0.0,
    bool? repaint,
  }) : super(
          color: originalPattern.color,
          thickness: originalPattern.thickness,
          type: originalPattern.type,
          gap: originalPattern.gap,
          repaint: repaint ?? originalPattern.repaint,
        );
  final PatternBox originalPattern;
  final double rotationAngle;

  @override
  void paint(Canvas canvas, Size size) {
    // Sauvegarde l'état actuel du canvas
    canvas.save();

    // Calcule le centre de rotation
    final center = Offset(size.width / 2, size.height / 2);

    // Agrandit la zone de dessin pour couvrir tout le widget après rotation
    final maxDimension = size.width > size.height ? size.width : size.height;
    final expandedSize = Size(maxDimension * 1.5, maxDimension * 1.5);
    final expandedOffset = Offset(
      (expandedSize.width - size.width) / 2,
      (expandedSize.height - size.height) / 2,
    );

    // Applique la rotation autour du centre
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotationAngle);
    canvas.translate(-center.dx, -center.dy);

    // Dessine le motif original sur une zone agrandie
    canvas.translate(-expandedOffset.dx, -expandedOffset.dy);
    originalPattern.paint(canvas, expandedSize);

    // Restaure l'état du canvas
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is RotatablePatternBox) {
      return oldDelegate.rotationAngle != rotationAngle ||
          oldDelegate.originalPattern != originalPattern;
    }
    return true;
  }
}

/// Extension pour faciliter l'utilisation
extension PatternBoxRotation on PatternBox {
  /// Retourne une version rotatable du PatternBox
  RotatablePatternBox rotated(double angleInRadians) {
    return RotatablePatternBox(
      originalPattern: this,
      rotationAngle: angleInRadians,
    );
  }

  /// Retourne une version rotatable du PatternBox avec un angle en degrés
  RotatablePatternBox rotatedDegrees(double angleInDegrees) {
    return RotatablePatternBox(
      originalPattern: this,
      rotationAngle:
          angleInDegrees * (3.14159 / 180), // Conversion degrés -> radians
    );
  }
}
