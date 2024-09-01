import 'dart:math';
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

  static final List<Color> colorPalette = [blue, purple, yellow, green];

  static Color getRandomColor() {
    final random = Random();
    final index = random.nextInt(colorPalette.length);
    return colorPalette[index];
  }

  static String getHexValue(Color color) {
    return '#${color.value.toRadixString(16).substring(2)}';
  }
}
