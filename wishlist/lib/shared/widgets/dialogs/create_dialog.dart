import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/shared/infra/non_null_extensions/go_true_client_non_null_getter_user_extension.dart';
import 'package:wishlist/shared/infra/supabase_client_provider.dart';
import 'package:wishlist/shared/infra/wishlist_mutations_provider.dart';
import 'package:wishlist/shared/infra/wishlist_service.dart';
import 'package:wishlist/shared/models/wishlist/create_request/wishlist_create_request.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/theme/text_styles.dart';
import 'package:wishlist/shared/widgets/dialogs/app_dialog.dart';

class _CreateDialogContent extends StatefulWidget {
  const _CreateDialogContent({required this.nameController});
  final TextEditingController nameController;

  @override
  State<_CreateDialogContent> createState() => _CreateDialogContentState();
}

class _CreateDialogContentState extends State<_CreateDialogContent> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: widget.nameController,
          style: AppTextStyles.large,
          textCapitalization: TextCapitalization.sentences,
          cursorColor: AppColors.primary,
          autofocus: true,
          decoration: InputDecoration(
            hintText: l10n.name,
            hintStyle: AppTextStyles.large.copyWith(
              fontStyle: FontStyle.italic,
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary),
            ),
          ),
        ),
      ],
    );
  }
}

Future<void> showCreateDialog(BuildContext context, WidgetRef ref) async {
  final l10n = context.l10n;
  final nameController = TextEditingController();
  final userId = ref.read(supabaseClientProvider).auth.currentUserNonNull.id;

  return showAppDialog(
    context,
    title: l10n.createWishlist,
    content: _CreateDialogContent(nameController: nameController),
    confirmButtonLabel: l10n.createButton,
    onConfirm: () async {
      await ref.read(wishlistMutationsProvider.notifier).create(
            WishlistCreateRequest(
              name: nameController.text,
              idOwner: userId,
              color: AppColors.getHexValue(AppColors.getRandomColor()),
              order: await ref
                  .read(wishlistServiceProvider)
                  .getNextWishlistOrderByUser(userId),
              updatedBy: userId,
            ),
          );
    },
    onCancel: () {},
  );
}
