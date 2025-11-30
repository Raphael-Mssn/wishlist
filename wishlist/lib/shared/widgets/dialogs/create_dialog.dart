import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wishlist/gen/fonts.gen.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/modules/wishlists/view/widgets/wishlist_toggle_switch.dart';
import 'package:wishlist/shared/infra/non_null_extensions/go_true_client_non_null_getter_user_extension.dart';
import 'package:wishlist/shared/infra/supabase_client_provider.dart';
import 'package:wishlist/shared/infra/wishlist_mutations_provider.dart';
import 'package:wishlist/shared/infra/wishlist_service.dart';
import 'package:wishlist/shared/models/wishlist/create_request/wishlist_create_request.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/widgets/dialogs/app_dialog.dart';

class _CreateDialogContent extends StatefulWidget {
  const _CreateDialogContent({
    required this.nameController,
    required this.visibilityNotifier,
  });
  final TextEditingController nameController;
  final ValueNotifier<bool> visibilityNotifier;

  @override
  State<_CreateDialogContent> createState() => _CreateDialogContentState();
}

class _CreateDialogContentState extends State<_CreateDialogContent> {
  @override
  void initState() {
    super.initState();
    widget.visibilityNotifier.value = false;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    const labelFontSize = 20.0;

    return SizedBox(
      width: double.maxFinite,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: widget.nameController,
            style: const TextStyle(
              fontFamily: FontFamily.truculenta,
              fontSize: labelFontSize,
            ),
            textCapitalization: TextCapitalization.sentences,
            cursorColor: AppColors.primary,
            autofocus: true,
            decoration: InputDecoration(
              hintText: l10n.name,
              hintStyle: const TextStyle(
                fontFamily: FontFamily.truculenta,
                fontSize: labelFontSize,
                fontStyle: FontStyle.italic,
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.primary),
              ),
            ),
          ),
          const Gap(16),
          ValueListenableBuilder<bool>(
            valueListenable: widget.visibilityNotifier,
            builder: (context, isPublic, child) {
              return Center(
                child: WishlistToggleSwitch(
                  current: isPublic,
                  onChanged: (value) => widget.visibilityNotifier.value = value,
                  trueLabel: l10n.public,
                  falseLabel: l10n.private,
                  trueIcon: const Icon(
                    Icons.lock_open,
                    color: AppColors.makara,
                  ),
                  falseIcon: const Icon(
                    Icons.lock,
                    color: AppColors.makara,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

Future<void> showCreateDialog(BuildContext context, WidgetRef ref) async {
  final l10n = context.l10n;
  final nameController = TextEditingController();
  final visibilityNotifier = ValueNotifier<bool>(false);
  final userId = ref.read(supabaseClientProvider).auth.currentUserNonNull.id;

  return showAppDialog(
    context,
    title: l10n.createWishlist,
    content: _CreateDialogContent(
      nameController: nameController,
      visibilityNotifier: visibilityNotifier,
    ),
    confirmButtonLabel: l10n.createButton,
    onConfirm: () async {
      final visibility = visibilityNotifier.value
          ? WishlistVisibility.public
          : WishlistVisibility.private;

      await ref.read(wishlistMutationsProvider.notifier).create(
            WishlistCreateRequest(
              name: nameController.text,
              idOwner: userId,
              color: AppColors.getHexValue(AppColors.getRandomColor()),
              order: await ref
                  .read(wishlistServiceProvider)
                  .getNextWishlistOrderByUser(userId),
              updatedBy: userId,
              visibility: visibility,
            ),
          );
    },
    onCancel: () {},
  );
}
