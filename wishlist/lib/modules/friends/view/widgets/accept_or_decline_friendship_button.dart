import 'package:flutter/material.dart';
import 'package:wishlist/shared/theme/colors.dart';

class AcceptOrDeclineFriendshipButton extends StatelessWidget {
  const AcceptOrDeclineFriendshipButton({
    super.key,
    required this.onAccept,
    required this.onDecline,
  });

  final VoidCallback onAccept;
  final VoidCallback onDecline;

  @override
  Widget build(BuildContext context) {
    const radius = Radius.circular(50);

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets
            .zero, // Retire le padding pour laisser l'enfant le définir
      ),
      onPressed: null, // Désactive l'onPressed par défaut
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSideButton(
            onTap: onDecline,
            color: AppColors.pastelGray,
            icon: Icons.delete,
            borderRadius: const BorderRadius.only(
              topLeft: radius,
              bottomLeft: radius,
            ),
          ),
          _buildSideButton(
            onTap: onAccept,
            color: AppColors.primary,
            icon: Icons.person_add_alt_1,
            borderRadius: const BorderRadius.only(
              topRight: radius,
              bottomRight: radius,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSideButton({
    required VoidCallback onTap,
    required Color color,
    required IconData icon,
    required BorderRadius borderRadius,
  }) {
    return InkWell(
      splashColor: AppColors.darkGrey.withOpacity(0.1),
      borderRadius: borderRadius,
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          color: color,
          borderRadius: borderRadius,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        child: Icon(
          icon,
          size: 28,
        ),
      ),
    );
  }
}
