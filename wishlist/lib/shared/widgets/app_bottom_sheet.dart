import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:wishlist/shared/theme/colors.dart';

Future<void> showAppBottomSheet(
  BuildContext context, {
  required Widget body,
}) async {
  const radius = Radius.circular(25);

  await showBarModalBottomSheet<void>(
    context: context,
    backgroundColor: AppColors.background,
    expand: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: radius,
        topRight: radius,
      ),
    ),
    builder: (context) {
      return Scaffold(body: body);
    },
  );
}
