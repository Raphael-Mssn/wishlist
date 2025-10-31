import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/app/navigation/router.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/shared/infra/presence_initializer.dart';
import 'package:wishlist/shared/theme/theme.dart';

/// The Widget that configures your application.
class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    // Initialiser le service de présence après le premier frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(presenceInitializerProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      restorationScopeId: 'app',
      onGenerateTitle: (context) => 'Wishlist',
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fr'),
        Locale('en'),
      ],
      routerConfig: router,
      theme: theme,
    );
  }
}
