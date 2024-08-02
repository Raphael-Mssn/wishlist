enum Environment {
  dev,
  staging,
  prod,
}

extension MappableEnvironment on Environment {
  T map<T>({
    required T Function() dev,
    required T Function() staging,
    required T Function() prod,
  }) {
    switch (this) {
      case Environment.dev:
        return dev();
      case Environment.staging:
        return staging();
      case Environment.prod:
        return prod();
    }
  }

  T maybeMap<T>({
    T Function()? dev,
    T Function()? staging,
    T Function()? prod,
    required T Function() orElse,
  }) {
    return map(
      dev: dev is T Function() ? dev : orElse,
      staging: staging is T Function() ? staging : orElse,
      prod: prod is T Function() ? prod : orElse,
    );
  }
}
