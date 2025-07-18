import 'package:equatable/equatable.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wishlist/app/config/environment.dart';
import 'package:wishlist/gen/assets.gen.dart';

class Config extends Equatable {
  const Config({
    required this.supabaseConfig,
  });

  final SupabaseConfig supabaseConfig;

  // Load all environment variables from .env.{environment} file
  static Future<void> _loadEnvironment(
    Environment environment, {
    required DotEnv dotEnvConfig,
  }) async {
    await dotEnvConfig.load(
      fileName: Assets.env.values.map((e) => e).firstWhere(
            (element) =>
                element.contains(environment.toString().split('.').last),
          ),
    );
  }

  static Future<Config> load({
    required Environment environment,
    DotEnv? dotEnvOverride,
  }) async {
    // Well since we need this line to test the others methods
    // we can not cover this line in the tests
    final dotEnvConfig = dotEnvOverride ?? dotenv; // coverage:ignore-line

    await _loadEnvironment(environment, dotEnvConfig: dotEnvConfig);

    return Config(
      supabaseConfig: SupabaseConfig(
        url: dotEnvConfig.get('SUPABASE_URL'),
        anonKey: dotEnvConfig.get('SUPABASE_ANON_KEY'),
      ),
    );
  }

  @override
  List<Object?> get props => [
        supabaseConfig,
      ];
}

class SupabaseConfig extends Equatable {
  const SupabaseConfig({
    required this.url,
    required this.anonKey,
  });

  final String url;
  final String anonKey;

  @override
  List<Object?> get props => [
        url,
        anonKey,
      ];
}
