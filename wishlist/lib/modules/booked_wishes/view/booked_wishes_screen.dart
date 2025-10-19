import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wishlist/gen/assets.gen.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/modules/booked_wishes/view/widgets/booked_wish_card.dart';
import 'package:wishlist/modules/wishs/view/widgets/consult_wish_bottom_sheet.dart';
import 'package:wishlist/shared/infra/booked_wishes_provider.dart';
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
      data: (bookedWishes) => bookedWishes.isEmpty
          ? PageLayoutEmpty(
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
            )
          : PageLayout(
              title: l10n.bookedWishesScreenTitle,
              onRefresh: refreshBookedWishes,
              padding: EdgeInsets.zero,
              actions: [
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () => SettingsRoute().push(context),
                ),
              ],
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: AppColors.gainsboro,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: ListView.separated(
                  padding: const EdgeInsets.only(bottom: 96),
                  itemCount: bookedWishes.length,
                  separatorBuilder: (context, index) => const Gap(8),
                  itemBuilder: (context, index) {
                    final bookedWish = bookedWishes[index];
                    return BookedWishCard(
                      bookedWish: bookedWish,
                      onTap: () {
                        showConsultWishBottomSheet(
                          context,
                          bookedWish.wish,
                        );
                      },
                    );
                  },
                ),
              ),
            ),
    );
  }
}
