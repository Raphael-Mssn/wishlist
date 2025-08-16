import 'dart:math';
import 'package:flutter/material.dart';
import 'package:pattern_box/pattern_box.dart';

/// Une surcouche sur WavePainter qui ajoute une variation d'angle progressive à chaque vague
class AngledWavePainter extends PatternBox {
  AngledWavePainter({
    Color? color,
    double? gap,
    double? thickness,
    this.frequency = 3,
    this.amplitude = 10,
    this.angleVariation = 0.1, // Variation d'angle en radians
    bool? repaint,
  }) : super(
          color: color ?? Colors.grey,
          thickness: thickness ?? 2,
          type: PatternType.wave,
          gap: gap ?? 20,
          repaint: repaint ?? false,
        );
  final double frequency;
  final double amplitude;
  final double angleVariation; // Variation d'angle en radians

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke;

    var waveIndex = 0;
    for (double y = 0; y <= size.height; y += gap) {
      final path = Path();

      // Calcule l'angle de variation progressif
      final progress = y / size.height;
      final variationAngle = (progress - 0.5) * 2 * angleVariation;

      // Sauvegarde l'état du canvas
      canvas.save();

      // Applique la rotation au centre de cette vague
      final waveCenter = Offset(size.width / 2, y);
      canvas.translate(waveCenter.dx, waveCenter.dy);
      canvas.rotate(variationAngle);
      canvas.translate(-waveCenter.dx, -waveCenter.dy);

      // Dessine la vague normale
      path.moveTo(0, y);
      for (double x = 0; x <= size.width; x++) {
        path.lineTo(
          x,
          y + sin((x / size.width) * frequency * 2 * pi) * amplitude,
        );
      }

      canvas.drawPath(path, paint);

      // Restaure l'état du canvas
      canvas.restore();

      waveIndex++;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is AngledWavePainter) {
      return oldDelegate.frequency != frequency ||
          oldDelegate.amplitude != amplitude ||
          oldDelegate.angleVariation != angleVariation ||
          oldDelegate.color != color ||
          oldDelegate.thickness != thickness ||
          oldDelegate.gap != gap;
    }
    return true;
  }
}

/// Extension pour faciliter l'utilisation
extension WavePainterAngle on WavePainter {
  /// Retourne une version avec variations d'angle progressives du WavePainter
  AngledWavePainter withAngleVariation({
    double angleVariation = 0.1,
  }) {
    return AngledWavePainter(
      color: color,
      gap: gap,
      thickness: thickness,
      frequency: frequency,
      amplitude: amplitude,
      angleVariation: angleVariation,
      repaint: repaint,
    );
  }
}
