class EnvironmentService {
  static const appEnv = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'prod',
  );
}
