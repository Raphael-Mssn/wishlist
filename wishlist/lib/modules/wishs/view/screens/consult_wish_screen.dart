import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/modules/wishs/view/widgets/consult_wish_back_button.dart';
import 'package:wishlist/modules/wishs/view/widgets/consult_wish_image.dart';
import 'package:wishlist/modules/wishs/view/widgets/consult_wish_info_container.dart';
import 'package:wishlist/shared/infra/repositories/wish/wish_streams_providers.dart';
import 'package:wishlist/shared/theme/colors.dart';

class ConsultWishScreen extends ConsumerWidget {
  const ConsultWishScreen({
    super.key,
    required this.wishId,
  });

  final int wishId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final wish = ref.watch(watchWishByIdProvider(wishId));

    return Scaffold(
      backgroundColor: AppColors.gainsboro,
      body: wish.when(
        data: (wish) {
          final descriptionText = wish.description.isNotEmpty
              ? wish.description
              : l10n.noDescription;

          return Stack(
            children: [
              SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    const Gap(64),
                    const ConsultWishBackButton(),
                    const Gap(16),
                    ConsultWishImage(wish: wish),
                    const Gap(32),
                    ConsultWishInfoContainer(
                      wish: wish,
                      descriptionText: descriptionText,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
        error: (error, stackTrace) => const SizedBox.shrink(),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
