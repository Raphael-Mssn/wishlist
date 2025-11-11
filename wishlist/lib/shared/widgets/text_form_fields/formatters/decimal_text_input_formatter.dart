import 'package:flutter/services.dart';

/// Formatter qui permet la saisie avec virgule ou point
/// pour les nombres décimaux
class DecimalTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Permet uniquement les chiffres, point et virgule
    final text = newValue.text;
    if (text.isEmpty) {
      return newValue;
    }

    // Vérifie que le texte ne contient que des chiffres, point ou virgule
    if (!RegExp(r'^[0-9.,]*$').hasMatch(text)) {
      return oldValue;
    }

    // Permet un seul séparateur décimal (point ou virgule)
    final commaCount = ','.allMatches(text).length;
    final dotCount = '.'.allMatches(text).length;
    if (commaCount + dotCount > 1) {
      return oldValue;
    }

    return newValue;
  }
}
