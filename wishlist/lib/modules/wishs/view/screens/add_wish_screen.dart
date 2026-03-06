import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/shared/infra/share_intent_payload_provider.dart';
import 'package:wishlist/shared/infra/wishlists_realtime_provider.dart';
import 'package:wishlist/shared/models/wish_prefill_data/wish_prefill_data.dart';
import 'package:wishlist/shared/models/wishlist/wishlist.dart';
import 'package:wishlist/shared/navigation/routes.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/theme/text_styles.dart';
import 'package:wishlist/shared/widgets/wishlist_list_tile.dart';

/// Écran affiché quand on arrive via partage (add-wish) sans wishlist connue.
/// Redirige vers le formulaire de création dans la bonne wishlist
/// (choix si plusieurs).
class AddWishScreen extends ConsumerStatefulWidget {
  const AddWishScreen({
    super.key,
    this.prefill,
  });

  final WishPrefillData? prefill;

  @override
  ConsumerState<AddWishScreen> createState() => _AddWishScreenState();
}

class _AddWishScreenState extends ConsumerState<AddWishScreen> {
  /// Prefill venant du partage (provider) ou de la route (URL).
  /// Rempli dans addPostFrameCallback : getAndClearPrefill() modifie le
  /// provider, interdit pendant initState/build (Riverpod).
  WishPrefillData? _prefill;

  /// Évite les navigations en double : un seul des deux déclencheurs
  /// (post-frame ou listen) exécute la navigation.
  bool _navigationHandled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      _prefill = ref
              .read(shareIntentPayloadNotifierProvider.notifier)
              .getAndClearPrefill() ??
          widget.prefill;
      _resolveNavigation();
    });
  }

  /// Applique la navigation si 0 ou 1 wishlist.
  void _tryNavigateFromWishlists(List<Wishlist> wishlists) {
    if (!mounted || _navigationHandled) {
      return;
    }
    if (wishlists.isEmpty) {
      _navigationHandled = true;
      context.pop();
      return;
    }
    if (wishlists.length == 1) {
      _navigationHandled = true;
      _goToCreateWish(wishlists.first.id);
    }
  }

  /// Données déjà dispo au premier frame (ex. cache) : on navigue sans
  /// attendre le listen.
  void _resolveNavigation() {
    if (!mounted) {
      return;
    }
    ref.read(wishlistsRealtimeProvider).whenData(_tryNavigateFromWishlists);
  }

  void _goToCreateWish(int wishlistId) {
    CreateWishRoute(
      wishlistId: wishlistId,
      name: _prefill?.name,
      link: _prefill?.linkUrl,
      description: _prefill?.description,
      price: _prefill?.price?.toString(),
    ).go(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    // Quand le provider passe en data après un loading, naviguer si 0 ou 1
    // wishlist (WidgetRef.listen n'a pas fireImmediately).
    ref.listen(wishlistsRealtimeProvider, (prev, next) {
      next.whenData(_tryNavigateFromWishlists);
    });
    final wishlistsAsync = ref.watch(wishlistsRealtimeProvider);

    return wishlistsAsync.when(
      data: (wishlists) {
        if (wishlists.isEmpty) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              backgroundColor: AppColors.background,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.pop(),
              ),
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  l10n.noWishlist,
                  style: AppTextStyles.medium.copyWith(color: AppColors.makara),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }
        if (wishlists.length == 1) {
          return const Scaffold(
            backgroundColor: AppColors.background,
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return _WishlistSelectionContent(
          wishlists: wishlists,
          onSelectWishlist: _goToCreateWish,
        );
      },
      loading: () => const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
        ),
        body: Center(
          child: Text(
            l10n.errorLoadingWishlists,
            style: AppTextStyles.small.copyWith(color: AppColors.makara),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class _WishlistSelectionContent extends StatelessWidget {
  const _WishlistSelectionContent({
    required this.wishlists,
    required this.onSelectWishlist,
  });

  final List<Wishlist> wishlists;
  final void Function(int wishlistId) onSelectWishlist;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final sorted = List<Wishlist>.from(wishlists)
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          l10n.selectWishlist,
          style: AppTextStyles.medium.copyWith(color: AppColors.darkGrey),
        ),
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        itemCount: sorted.length,
        itemBuilder: (context, index) {
          final wishlist = sorted[index];
          return WishlistListTile(
            wishlist: wishlist,
            onTap: () => onSelectWishlist(wishlist.id),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          );
        },
      ),
    );
  }
}
