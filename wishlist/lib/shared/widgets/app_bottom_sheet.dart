import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/theme/text_styles.dart';

Future<void> showAppBottomSheet(
  BuildContext context, {
  required Widget body,
}) async {
  const radius = Radius.circular(25);
  // Ensure the theme is the same as the one from the context passed,
  // not the one from the builder of showBarModalBottomSheet
  final theme = Theme.of(context);

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
      return Scaffold(
        body: AnimatedTheme(
          data: theme,
          child: body,
        ),
      );
    },
  );
}

class AppBottomSheetWithThemeAndAppBarLayout extends StatefulWidget {
  const AppBottomSheetWithThemeAndAppBarLayout({
    super.key,
    required this.theme,
    required this.title,
    required this.actionIcon,
    required this.onActionTapped,
    required this.body,
    this.isEditable = false,
    this.onTitleChanged,
  });

  final ThemeData theme;
  final String title;
  final IconData actionIcon;
  final Function() onActionTapped;
  final Widget body;
  final bool isEditable;
  final Function(String)? onTitleChanged;

  @override
  State<AppBottomSheetWithThemeAndAppBarLayout> createState() =>
      _AppBottomSheetWithThemeAndAppBarLayoutState();
}

class _AppBottomSheetWithThemeAndAppBarLayoutState
    extends State<AppBottomSheetWithThemeAndAppBarLayout> {
  bool _isEditing = false;
  late TextEditingController _titleController;
  late FocusNode _focusNode;
  bool _hasBeenModified = false;
  late String _initialTitle;

  @override
  void initState() {
    super.initState();
    _initialTitle = widget.title;
    _titleController = TextEditingController(text: widget.title);
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _startEditing() {
    if (!widget.isEditable) {
      return;
    }
    setState(() {
      _isEditing = true;
    });
    _focusNode.requestFocus();
  }

  void _finishEditing() {
    setState(() {
      _isEditing = false;
      _hasBeenModified = _titleController.text != _initialTitle;
    });
    widget.onTitleChanged?.call(_titleController.text);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedTheme(
      data: widget.theme,
      child: Column(
        children: [
          AppBar(
            centerTitle: true,
            toolbarHeight: 80,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: IconButton(
                  icon: Icon(
                    widget.actionIcon,
                    size: 32,
                  ),
                  onPressed: widget.onActionTapped,
                ),
              ),
            ],
            foregroundColor: AppColors.background,
            title: widget.isEditable
                ? _isEditing
                    ? Theme(
                        data: Theme.of(context).copyWith(
                          textSelectionTheme: TextSelectionThemeData(
                            cursorColor: AppColors.gainsboro,
                            selectionColor:
                                AppColors.gainsboro.withOpacity(0.3),
                            selectionHandleColor: AppColors.gainsboro,
                          ),
                        ),
                        child: TextField(
                          controller: _titleController,
                          focusNode: _focusNode,
                          style: AppTextStyles.medium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.background,
                          ),
                          textAlign: TextAlign.center,
                          cursorColor: AppColors.gainsboro,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: AppColors.gainsboro),
                            ),
                            contentPadding: EdgeInsets.zero,
                          ),
                          onSubmitted: (_) => _finishEditing(),
                          onTapOutside: (_) => _finishEditing(),
                        ),
                      )
                    : GestureDetector(
                        onTap: _startEditing,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              child: Tooltip(
                                message: _titleController.text,
                                child: Text(
                                  _titleController.text,
                                  style: AppTextStyles.medium.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Transform.translate(
                              offset: const Offset(0, -1),
                              child: Icon(
                                _hasBeenModified ? Icons.circle : Icons.edit,
                                size: _hasBeenModified ? 8 : 16,
                                color: AppColors.background,
                              ),
                            ),
                          ],
                        ),
                      )
                : Text(
                    widget.title,
                    style: AppTextStyles.medium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
            backgroundColor: widget.theme.primaryColor,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: widget.body,
            ),
          ),
        ],
      ),
    );
  }
}
