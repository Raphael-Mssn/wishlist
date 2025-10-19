import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/shared/navigation/routes.dart';
import 'package:wishlist/shared/widgets/page_layout.dart';

class BookedWishesScreen extends ConsumerWidget {
  const BookedWishesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;

    return PageLayout(
      title: l10n.bookedWishesScreenTitle,
      actions: [
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () => SettingsRoute().push(context),
        ),
      ],
      child: const Center(
        child: Text('Liste des wishes réservés - à implémenter'),
      ),
    );
  }
}
