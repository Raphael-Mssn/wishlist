/// Wrapper pour distinguer entre "non fourni" et "null explicite" dans copyWith
class Optional<T> {
  const Optional.value(T? value)
      : _value = value,
        _isPresent = true;
  const Optional.absent()
      : _value = null,
        _isPresent = false;

  final T? _value;
  final bool _isPresent;

  bool get isPresent => _isPresent;
  T? get value => _value;

  /// Retourne la valeur si présente, sinon retourne la valeur par défaut
  T? orElse(T? defaultValue) => _isPresent ? _value : defaultValue;
}

/// Extension pour simplifier l'utilisation d'Optional dans copyWith
extension OptionalCopyWith<T> on Optional<T>? {
  /// Retourne la valeur de l'Optional si présent, sinon garde la valeur
  /// par défaut.
  ///
  /// - Si this est `null` → retourne [defaultValue] (ne pas modifier)
  /// - Si this est `Optional.value(x)` → retourne `x` (même si `x` est null)
  /// - Si this est `Optional.absent()` → retourne [defaultValue]
  T? orKeep(T? defaultValue) {
    final thisValue = this;
    if (thisValue == null) {
      return defaultValue;
    }
    return thisValue.orElse(defaultValue);
  }
}
