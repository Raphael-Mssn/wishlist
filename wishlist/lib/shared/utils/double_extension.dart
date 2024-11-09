extension DoubleExtension on double {
  /// Returns the integer part of the double as a string
  /// if the decimal part is 0.
  ///
  /// Basic toString() returns 22 as 22.0
  String toStringWithout0() {
    return this % 1 == 0 ? toInt().toString() : toString();
  }
}

extension DoubleOrNullExtension on double? {
  /// Returns the integer part of the double as a string
  /// if the decimal part is 0.
  /// If the value is null, returns an empty string.
  ///
  /// Basic toString() returns:
  /// - 22 as 22.0
  /// - null as 'null'
  String toStringWithout0OrEmpty() {
    final value = this;
    return value == null ? '' : value.toStringWithout0();
  }
}
