import 'dart:math';
import 'package:flutter/material.dart';
import 'package:pattern_box/pattern_box.dart';

/// Un WavePainter amélioré qui combine rotation et variation d'angle en une seule classe
class EnhancedWavePainter extends PatternBox {
  EnhancedWavePainter({
    Color? color,
    double? gap,
    double? thickness,
    this.frequency = 3,
    this.amplitude = 10,
    this.angleVariation = 0.0, // Variation d'angle en radians
    double rotationAngleDegrees = 0.0, // Rotation globale en degrés
    this.useExpansion =
        false, // Active l'expansion de la zone de dessin avec la rotation
    bool? repaint,
  })  : rotationAngle = rotationAngleDegrees * (pi / 180),
        super(
          color: color ?? Colors.grey,
          thickness: thickness ?? 2,
          type: PatternType.wave,
          gap: gap ?? 20,
          repaint: repaint ?? false,
        );

  final double frequency;
  final double amplitude;
  final double angleVariation; // Variation d'angle en radians
  final double rotationAngle;
  final bool useExpansion;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke;

    canvas.save();

    // Applique la rotation avec ou sans expansion
    if (rotationAngle != 0 || useExpansion) {
      // Rotation avec expansion : agrandit la zone de dessin
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

      // Dessine les vagues sur une zone agrandie
      canvas.translate(-expandedOffset.dx, -expandedOffset.dy);
      _drawWaves(canvas, paint, expandedSize);
      canvas.translate(expandedOffset.dx, expandedOffset.dy);
    } else {
      // Pas de rotation globale, dessine normalement
      _drawWaves(canvas, paint, size);
    }

    // Restaure l'état global du canvas
    canvas.restore();
  }

  /// Dessine les vagues avec variation d'angle
  void _drawWaves(Canvas canvas, Paint paint, Size size) {
    for (double y = 0; y <= size.height; y += gap) {
      final path = Path();

      // Calcule l'angle de variation progressif si nécessaire
      if (angleVariation != 0) {
        final progress = y / size.height;
        final variationAngle = (progress - 0.5) * 2 * angleVariation;

        // Sauvegarde l'état pour cette vague
        canvas.save();

        // Applique la rotation à cette vague
        final waveCenter = Offset(size.width / 2, y);
        canvas.translate(waveCenter.dx, waveCenter.dy);
        canvas.rotate(variationAngle);
        canvas.translate(-waveCenter.dx, -waveCenter.dy);
      }

      // Dessine la vague
      path.moveTo(0, y);
      for (double x = 0; x <= size.width; x++) {
        path.lineTo(
          x,
          y + sin((x / size.width) * frequency * 2 * pi) * amplitude,
        );
      }

      canvas.drawPath(path, paint);

      // Restaure l'état pour cette vague si nécessaire
      if (angleVariation != 0) {
        canvas.restore();
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is EnhancedWavePainter) {
      return oldDelegate.frequency != frequency ||
          oldDelegate.amplitude != amplitude ||
          oldDelegate.angleVariation != angleVariation ||
          oldDelegate.rotationAngle != rotationAngle ||
          oldDelegate.useExpansion != useExpansion ||
          oldDelegate.color != color ||
          oldDelegate.thickness != thickness ||
          oldDelegate.gap != gap;
    }
    return true;
  }
}
