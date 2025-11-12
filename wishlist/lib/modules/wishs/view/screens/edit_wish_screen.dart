import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/modules/wishs/view/wish_form_screen.dart';
import 'package:wishlist/shared/infra/repositories/wish/wish_streams_providers.dart';
import 'package:wishlist/shared/theme/colors.dart';

class EditWishScreen extends ConsumerWidget {
  const EditWishScreen({
    super.key,
    required this.wishId,
  });

  final int wishId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishAsync = ref.watch(watchWishByIdProvider(wishId));

    return wishAsync.when(
      data: (wish) => WishFormScreen(
        wishlistId: wish.wishlistId,
        wish: wish,
      ),
      loading: () => const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) => const Scaffold(
        backgroundColor: AppColors.background,
        body: SizedBox.shrink(),
      ),
    );
  }
}
