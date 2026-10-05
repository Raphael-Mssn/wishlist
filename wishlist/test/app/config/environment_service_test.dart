import 'package:flutter_test/flutter_test.dart';
import 'package:wishlist/app/config/environment.dart';
import 'package:wishlist/app/config/environment_service.dart';

void main() {
  test('defaults to dev when APP_ENV is not defined', () {
    expect(EnvironmentService.appEnv, 'dev');
    expect(
      Environment.values.byName(EnvironmentService.appEnv),
      Environment.dev,
    );
  });
}
