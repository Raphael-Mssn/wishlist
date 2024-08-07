enum Environment {
  dev,
  prod,
}

extension MappableEnvironment on Environment {
  T map<T>({
    required T Function() dev,
    required T Function() prod,
  }) {
    switch (this) {
      case Environment.dev:
        return dev();
      case Environment.prod:
        return prod();
    }
  }

  T maybeMap<T>({
    T Function()? dev,
    T Function()? prod,
    required T Function() orElse,
  }) {
    return map(
      dev: dev is T Function() ? dev : orElse,
      prod: prod is T Function() ? prod : orElse,
    );
  }
}
