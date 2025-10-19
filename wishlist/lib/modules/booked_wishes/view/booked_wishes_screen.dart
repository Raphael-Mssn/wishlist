import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gap/gap.dart';
import 'package:wishlist/gen/assets.gen.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/modules/booked_wishes/view/widgets/booked_wish_card.dart';
import 'package:wishlist/modules/booked_wishes/view/widgets/user_group_header.dart';
import 'package:wishlist/modules/wishs/view/widgets/consult_wish_bottom_sheet.dart';
import 'package:wishlist/shared/infra/booked_wishes_provider.dart';
import 'package:wishlist/shared/models/booked_wish_with_details/booked_wish_with_details.dart';
import 'package:wishlist/shared/navigation/routes.dart';
import 'package:wishlist/shared/page_layout_empty/page_layout_empty.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/utils/scaffold_messenger_extension.dart';
import 'package:wishlist/shared/widgets/page_layout.dart';

class BookedWishesScreen extends ConsumerWidget {
  const BookedWishesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final bookedWishesAsync = ref.watch(bookedWishesProvider);
    const gap = 16.0;

    Future<void> refreshBookedWishes() async {
      await ref.read(bookedWishesProvider.notifier).loadBookedWishes();
    }

    return bookedWishesAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stackTrace) {
        ScaffoldMessenger.of(context).showGenericError(isTopSnackBar: true);
        return const SizedBox.shrink();
      },
      data: (bookedWishes) {
        if (bookedWishes.isEmpty) {
          return PageLayoutEmpty(
            illustrationUrl: Assets.svg.noWishlist,
            title: l10n.bookedWishesEmptyTitle,
            onRefresh: refreshBookedWishes,
            appBarTitle: l10n.bookedWishesScreenTitle,
            actions: [
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () => SettingsRoute().push(context),
              ),
            ],
          );
        }

        final groupedWishes = <String, List<BookedWishWithDetails>>{};
        for (final bookedWish in bookedWishes) {
          groupedWishes
              .putIfAbsent(bookedWish.ownerId, () => [])
              .add(bookedWish);
        }

        final containers = <Widget>[];
        var position = 0;

        for (final entry in groupedWishes.entries) {
          final ownerWishes = entry.value;
          final firstWish = ownerWishes.first;

          containers.add(
            AnimationConfiguration.staggeredList(
              position: position++,
              duration: const Duration(milliseconds: 375),
              child: SlideAnimation(
                verticalOffset: 50,
                child: FadeInAnimation(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.gainsboro,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // User header
                        UserGroupHeader(
                          avatarUrl: firstWish.ownerAvatarUrl,
                          pseudo: firstWish.ownerPseudo,
                          wishCount: ownerWishes.length,
                        ),
                        const Gap(gap),
                        ...ownerWishes.map((bookedWish) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: BookedWishCard(
                              bookedWish: bookedWish,
                              onTap: () {
                                showConsultWishBottomSheet(
                                  context,
                                  bookedWish.wish,
                                );
                              },
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }

        return PageLayout(
          title: l10n.bookedWishesScreenTitle,
          onRefresh: refreshBookedWishes,
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => SettingsRoute().push(context),
            ),
          ],
          child: AnimationLimiter(
            child: ListView.separated(
              itemCount: containers.length,
              separatorBuilder: (context, index) => const Gap(gap),
              itemBuilder: (context, index) => containers[index],
            ),
          ),
        );
      },
    );
  }
}
