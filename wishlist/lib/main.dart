import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:wishlist/app/app.dart';
import 'package:wishlist/app/config/config.dart';
import 'package:wishlist/app/config/config_provider.dart';
import 'package:wishlist/app/config/environment.dart';
import 'package:wishlist/app/config/environment_provider.dart';
import 'package:wishlist/app/config/environment_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final environment = Environment.values.byName(EnvironmentService.appEnv);

  final config = await Config.load(environment: environment);

  await Supabase.initialize(
    url: config.supabaseConfig.url,
    anonKey: config.supabaseConfig.anonKey,
  );

  runApp(
    ProviderScope(
      overrides: [
        configProvider.overrideWithValue(config),
        environmentProvider.overrideWithValue(environment),
      ],
      child: const MyApp(),
    ),
  );
}

final supabase = Supabase.instance.client;
