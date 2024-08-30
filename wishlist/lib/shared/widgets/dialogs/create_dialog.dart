import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/gen/fonts.gen.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/shared/infra/non_null_extensions/go_true_client_non_null_getter_user_extension.dart';
import 'package:wishlist/shared/infra/supabase_client_provider.dart';
import 'package:wishlist/shared/infra/wishlist_service.dart';
import 'package:wishlist/shared/models/wishlist/wishlist.dart';
import 'package:wishlist/shared/theme/colors.dart';
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
    const labelFontSize = 20.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListBody(
          children: <Widget>[
            TextField(
              controller: widget.nameController,
              style: const TextStyle(
                fontFamily: FontFamily.truculenta,
                fontSize: labelFontSize,
              ),
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
          ],
        ),
      ],
    );
  }
}

Future<void> showCreateDialog(BuildContext context, WidgetRef ref) async {
  final l10n = context.l10n;
  final nameController = TextEditingController();

  return showAppDialog(
    context,
    title: l10n.createWishlist,
    content: _CreateDialogContent(nameController: nameController),
    confirmButtonLabel: l10n.createButton,
    onConfirm: () async {
      await ref.read(wishlistServiceProvider).createWishlist(
            Wishlist(
              name: nameController.text,
              idOwner:
                  ref.read(supabaseClientProvider).auth.currentUserNonNull.id,
              color: AppColors.getHexValue(AppColors.getRandomColor()),
              updatedBy:
                  ref.read(supabaseClientProvider).auth.currentUserNonNull.id,
            ),
          );
    },
    onCancel: () {},
  );
}
