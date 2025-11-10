import 'package:currency_formatter/currency_formatter.dart';

/// Utility helpers for formatting values across the app.
class Formatters {
  /// Format a numeric value as a currency string.
  ///
  /// - [amount]: numeric value (double/int/num) to format.
  /// - [currency]: CurrencyFormat to use (defaults to Euro).
  /// - [decimal]: number of decimal places to show (defaults to 2).
  /// - [showThousandSeparator]: whether to show thousand separators (defaults to false).
  ///
  /// This wraps `CurrencyFormatter.format` so the rest of the app can call a
  /// single helper and change formatting rules in one place.
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
