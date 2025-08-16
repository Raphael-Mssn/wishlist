import 'package:flutter/material.dart';
import 'package:pattern_box/pattern_box.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/theme/widgets/angled_wave_painter.dart';
import 'package:wishlist/shared/theme/widgets/rotatable_pattern_box.dart';

/// Types de rotation prédéfinis
enum WaveRotationType {
  none, // Pas de rotation
  fixed, // Rotation fixe
  deterministic, // Rotation déterminée basée sur un ID (north, east, south, west)
}

/// Presets prédéfinis pour différents contextes
enum WavePreset {
  standard, // Preset standard
  appBar, // Preset pour AppBar
  card, // Preset pour les cartes
  pill, // Preset pour les pills
}

/// Paramètres personnalisés pour override les presets
class WaveCustomParams {
  const WaveCustomParams({
    this.frequency,
    this.thickness,
    this.gap,
    this.amplitude,
    this.angleVariation,
  });

  final double? frequency;
  final double? thickness;
  final double? gap;
  final double? amplitude;
  final double? angleVariation;
}

/// Widget custom qui factorise l'utilisation des patterns d'onde
/// dans toute l'application avec des paramètres prédéfinis
class AppWavePattern extends StatelessWidget {
  const AppWavePattern({
    super.key,
    required this.backgroundColor,
    this.patternColor,
    this.child,
    this.borderRadius,
    this.height,
    this.width,
    this.rotationType = WaveRotationType.none,
    this.rotationAngle = 0.0,
    this.preset = WavePreset.standard,
    this.customParams,
    this.deterministicId, // Nouveau paramètre pour l'ID
  });

  final Color backgroundColor;
  final Color? patternColor;
  final Widget? child;
  final BorderRadiusGeometry? borderRadius;
  final double? height;
  final double? width;
  final WaveRotationType rotationType;
  final double rotationAngle;
  final WavePreset preset;
  final WaveCustomParams? customParams;
  final int? deterministicId; // ID pour la rotation déterminée

  @override
  Widget build(BuildContext context) {
    final params = _getPresetParams();
    final finalParams = _mergeWithCustomParams(params);
    final finalRotation = _getFinalRotation();
    final finalPatternColor =
        patternColor ?? AppColors.lighten(backgroundColor);

    return PatternBoxWidget(
      height: height,
      width: width,
      pattern: WavePainter(
        frequency: finalParams.frequency,
        thickness: finalParams.thickness,
        gap: finalParams.gap,
        color: finalPatternColor,
        amplitude: finalParams.amplitude,
      )
          .withAngleVariation(
            angleVariation: finalParams.angleVariation,
          )
          .rotatedDegrees(finalRotation),
      borderRadius: borderRadius,
      backgroundColor: backgroundColor,
      child: child,
    );
  }

  /// Retourne les paramètres selon le preset choisi
  _WaveParams _getPresetParams() {
    switch (preset) {
      case WavePreset.standard:
        return const _WaveParams(
          frequency: 0.8,
          thickness: 12,
          gap: 42,
          amplitude: 20,
          angleVariation: 0.2,
        );
      case WavePreset.appBar:
        return const _WaveParams(
          frequency: 1,
          thickness: 16,
          gap: 48,
          amplitude: 40,
          angleVariation: 0.4,
        );
      case WavePreset.card:
        return const _WaveParams(
          frequency: 0.8,
          thickness: 16,
          gap: 48,
          amplitude: 20,
          angleVariation: 0.2,
        );
      case WavePreset.pill:
        return const _WaveParams(
          frequency: 0.8,
          thickness: 12,
          gap: 42,
          amplitude: 80,
          angleVariation: 0.2,
        );
    }
  }

  /// Fusionne les paramètres du preset avec les paramètres personnalisés
  _WaveParams _mergeWithCustomParams(_WaveParams presetParams) {
    if (customParams == null) return presetParams;

    return _WaveParams(
      frequency: customParams!.frequency ?? presetParams.frequency,
      thickness: customParams!.thickness ?? presetParams.thickness,
      gap: customParams!.gap ?? presetParams.gap,
      amplitude: customParams!.amplitude ?? presetParams.amplitude,
      angleVariation:
          customParams!.angleVariation ?? presetParams.angleVariation,
    );
  }

  /// Calcule la rotation finale selon le type choisi
  double _getFinalRotation() {
    switch (rotationType) {
      case WaveRotationType.none:
        return 0;
      case WaveRotationType.fixed:
        return rotationAngle;
      case WaveRotationType.deterministic:
        // Rotation déterminée basée sur l'ID (north, east, south, west)
        if (deterministicId != null) {
          return (deterministicId! % 4) * 90.0;
        }
        return 0; // Fallback si pas d'ID
    }
  }
}

/// Classe interne pour les paramètres des vagues
class _WaveParams {
  const _WaveParams({
    required this.frequency,
    required this.thickness,
    required this.gap,
    required this.amplitude,
    required this.angleVariation,
  });

  final double frequency;
  final double thickness;
  final double gap;
  final double amplitude;
  final double angleVariation;
}
