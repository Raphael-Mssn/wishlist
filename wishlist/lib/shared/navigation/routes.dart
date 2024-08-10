import 'package:equatable/equatable.dart';

class AppRoute extends Equatable {
  const AppRoute(this.name);

  /// Name for this [AppRoute]
  final String name;

  @override
  List<Object?> get props => [name];
}

class AppRoutes {
  static AppRoute get home => const AppRoute('home');

  static AppRoute get settings => const AppRoute('settings');

  static AppRoute get auth => const AppRoute('auth');

  static AppRoute get changePassword => const AppRoute('changePassword');
}
