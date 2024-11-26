import 'package:flutter/material.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/theme/text_styles.dart';

class UserSearchBar extends StatefulWidget {
  const UserSearchBar({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  State<UserSearchBar> createState() => _UserSearchBarState();
}

class _UserSearchBarState extends State<UserSearchBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
        border: Border.fromBorderSide(
          BorderSide(
            color: AppColors.makara,
            width: 2,
          ),
        ),
      ),
      child: TextField(
        controller: widget.controller,
        autofocus: true,
        style: AppTextStyles.smaller.copyWith(
          color: AppColors.darkGrey,
        ),
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          focusedBorder: InputBorder.none,
          hintText: context.l10n.emailOrPseudoHint,
          hintStyle: AppTextStyles.smaller.copyWith(
            color: AppColors.darkGrey,
            fontStyle: FontStyle.italic,
          ),
          border: InputBorder.none,
          icon: const Icon(
            Icons.search,
            color: AppColors.makara,
          ),
        ),
      ),
    );
  }
}
