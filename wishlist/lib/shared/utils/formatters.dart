import 'package:currency_formatter/currency_formatter.dart';

/// Helpers utilitaires pour formater les valeurs dans l'application.
class Formatters {
  /// Formate une valeur numérique en chaîne monétaire.
  ///
  /// - [amount] : valeur numérique (double/int/num) à formater.
  /// - [currency] : `CurrencyFormat` à utiliser (par défaut Euro).
  /// - [decimal] : nombre de décimales à afficher (par défaut 2).
  /// - [showThousandSeparator] : afficher les séparateurs de milliers
  /// (par défaut false).
  ///
  /// Enveloppe `CurrencyFormatter.format` afin que le reste de l'application
  /// puisse appeler un helper unique et modifier les règles de formatage en
  /// un seul endroit.
  static String currency(
    num amount, {
    CurrencyFormat currency = CurrencyFormat.eur,
    int decimal = 2,
    bool showThousandSeparator = false,
  }) {
    return CurrencyFormatter.format(
      amount,
      currency,
      decimal: decimal,
      showThousandSeparator: showThousandSeparator,
    );
  }
}
