import 'package:flutter/material.dart';
import 'package:wishlist/l10n/l10n.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/theme/text_styles.dart';

class UserSearchBar extends StatefulWidget {
  const UserSearchBar({
    super.key,
    required this.controller,
    this.isFocusedOnStart = false,
  });

  final TextEditingController controller;
  final bool isFocusedOnStart;

  @override
  State<UserSearchBar> createState() => _UserSearchBarState();
}

class _UserSearchBarState extends State<UserSearchBar> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();

    // Demander le focus une seule fois lors de la première construction
    if (widget.isFocusedOnStart) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNode.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

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
        focusNode: _focusNode,
        style: AppTextStyles.smaller.copyWith(
          color: AppColors.darkGrey,
        ),
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
