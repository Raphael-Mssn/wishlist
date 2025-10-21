import 'dart:math';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';

abstract final class AppColors {
  static const Color background = Color(0xFFF7F6F0);

  static const Color primary = Color(0xFFF28C57);

  static const Color darkOrange = Color(0xFFDF733D);

  static const Color darkGrey = Color(0xFF2C2C2C);

  static const Color blue = Color(0xFF69ABE9);

  static const Color purple = Color(0xFF9665E5);

  static const Color yellow = Color(0xFFDBCD4D);

  static const Color green = Color(0xFF57BD87);

  static const Color gainsboro = Color(0xFFE8E4DA);

  static const Color pastelGray = Color(0xFFD3CBC1);

  static const Color makara = Color(0xFF887A6B);

  static const Color favorite = Color(0xFFFF675C);

  static final Map<Color, String> colorPalette = {
    blue: 'blue',
    purple: 'purple',
    yellow: 'yellow',
    green: 'green',
  };

  static Color getRandomColor() {
    final random = Random();
    final colors = colorPalette.keys.toList();
    final index = random.nextInt(colors.length);
    return colors[index];
  }

  static Color darken(Color color, [double factor = 0.8]) {
    final red = color.r * factor;
    final green = color.g * factor;
    final blue = color.b * factor;

    return Color.from(alpha: color.a, red: red, green: green, blue: blue);
  }

  static Color lighten(Color color, [double factor = 1.07]) {
    final red = color.r * factor;
    final green = color.g * factor;
    final blue = color.b * factor;

    return Color.from(alpha: color.a, red: red, green: green, blue: blue);
  }

  static String getHexValue(Color color) {
    return '#${color.toARGB32().toRadixString(16).substring(2)}';
  }

  static Color getColorFromHexValue(String hexColor) {
    return Color(int.parse(hexColor.substring(1, 7), radix: 16) + 0xFF000000);
  }

  static final Map<ColorSwatch<Object>, String> colorSwatches = {
    for (var entry in colorPalette.entries)
      ColorTools.createPrimarySwatch(entry.key): entry.value,
  };
}
