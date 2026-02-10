import 'package:wishlist/shared/models/app_user.dart';

/// Sorts a list of [AppUser] alphabetically by pseudo (case-insensitive).
List<AppUser> sortAppUsersByPseudo(Iterable<AppUser> users) {
  return users.toList()
    ..sort(
      (a, b) => a.profile.pseudo.toLowerCase().compareTo(
            b.profile.pseudo.toLowerCase(),
          ),
    );
}
