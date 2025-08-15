import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/shared/infra/current_user_avatar_provider.dart';
import 'package:wishlist/shared/theme/colors.dart';
import 'package:wishlist/shared/widgets/avatar/app_avatar.dart';
import 'package:wishlist/shared/widgets/avatar/avatar_options_bottom_sheet.dart';

class EditableAvatarWidget extends ConsumerWidget {
  const EditableAvatarWidget({
    super.key,
    this.showEditIcon = true,
  });

  final bool showEditIcon;

  static const double _size = 120;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final avatarAsync = ref.watch(currentUserAvatarProvider);

    ref.listen<AsyncValue<String?>>(currentUserAvatarProvider,
        (previous, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error uploading avatar: ${next.error}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    });

    return SizedBox(
      width: _size,
      height: _size,
      child: Stack(
        children: [
          avatarAsync.when(
            data: (avatarUrl) => AppAvatar(
              avatarUrl: avatarUrl,
              size: _size,
            ),
            loading: () => Container(
              width: _size,
              height: _size,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.makara,
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  color: AppColors.background,
                ),
              ),
            ),
            error: (error, stack) => Container(
              width: _size,
              height: _size,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.makara,
              ),
              child: const Center(
                child: Icon(
                  Icons.error,
                  color: AppColors.background,
                  size: _size * 0.3,
                ),
              ),
            ),
          ),
          if (showEditIcon)
            Positioned(
              bottom: 0,
              right: 0,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.background,
                  border: Border.all(
                    color: AppColors.primary,
                    width: 2.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.darkGrey.withOpacity(0.12),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: () {
                    final avatarAsync = ref.read(currentUserAvatarProvider);
                    final avatarUrl = avatarAsync.valueOrNull;
                    final hasAvatar = avatarUrl != null && avatarUrl.isNotEmpty;
                    showAvatarOptionsBottomSheet(
                      context,
                      hasAvatar: hasAvatar,
                    );
                  },
                  icon: const Icon(
                    Icons.edit,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 36,
                    minHeight: 36,
                  ),
                  padding: EdgeInsets.zero,
                  splashRadius: 22,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
