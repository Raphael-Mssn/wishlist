import 'package:flutter/material.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/theme/text_styles.dart';

class EditableTitle extends StatefulWidget {
  const EditableTitle({
    super.key,
    required this.initialTitle,
    this.onTitleChanged,
  });

  final String initialTitle;
  final Function(String)? onTitleChanged;

  @override
  State<EditableTitle> createState() => _EditableTitleState();
}

class _EditableTitleState extends State<EditableTitle> {
  bool _isEditing = false;
  late TextEditingController _titleController;
  late FocusNode _focusNode;
  bool _hasBeenModified = false;
  late String _initialTitle;

  @override
  void initState() {
    super.initState();
    _initialTitle = widget.initialTitle;
    _titleController = TextEditingController(text: widget.initialTitle);
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _startEditing() {
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
    return _isEditing
        ? Theme(
            data: Theme.of(context).copyWith(
              textSelectionTheme: TextSelectionThemeData(
                cursorColor: AppColors.gainsboro,
                selectionColor: AppColors.gainsboro.withOpacity(0.3),
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
                  borderSide: BorderSide(color: AppColors.gainsboro),
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
          );
  }
}
