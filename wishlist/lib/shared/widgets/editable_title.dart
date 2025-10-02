import 'package:flutter/material.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/theme/text_styles.dart';

class EditableTitle extends StatefulWidget {
  const EditableTitle({
    super.key,
    required this.initialTitle,
    this.onTitleChanged,
    this.validator,
  });

  final String initialTitle;
  final Function(String)? onTitleChanged;
  final String? Function(String?)? validator;

  @override
  State<EditableTitle> createState() => _EditableTitleState();
}

class _EditableTitleState extends State<EditableTitle> {
  late TextEditingController _titleController;
  bool _hasBeenModified = false;
  late String _initialTitle;

  @override
  void initState() {
    super.initState();
    _initialTitle = widget.initialTitle;
    _titleController = TextEditingController(text: widget.initialTitle);
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: AppColors.gainsboro,
          selectionColor: AppColors.gainsboro.withOpacity(0.3),
          selectionHandleColor: AppColors.gainsboro,
        ),
      ),
      child: Stack(
        children: [
          TextFormField(
            controller: _titleController,
            validator: widget.validator,
            style: AppTextStyles.medium.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.background,
            ),
            textAlign: TextAlign.center,
            cursorColor: AppColors.gainsboro,
            cursorErrorColor: AppColors.gainsboro,
            decoration: const InputDecoration(
              //errorText: '',
              errorStyle: TextStyle(color: Colors.transparent, fontSize: 0),
              border: InputBorder.none,
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.gainsboro),
              ),
              errorBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.gainsboro),
              ),
              focusedErrorBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.gainsboro),
              ),
              contentPadding: EdgeInsets.zero,
            ),
            onChanged: (value) {
              setState(() {
                _hasBeenModified = value != _initialTitle;
              });
              widget.onTitleChanged?.call(value);
            },
            onTapOutside: (event) {
              FocusScope.of(context).unfocus();
            },
          ),
          Positioned(
            top: 0,
            right: 0,
            child: _hasBeenModified
                ? const Icon(
                    Icons.circle,
                    size: 8,
                    color: AppColors.background,
                  )
                : const Icon(
                    Icons.edit,
                    size: 16,
                    color: AppColors.background,
                  ),
          ),
        ],
      ),
    );
  }
}
