import 'package:flutter/widgets.dart';
import 'package:wishlist/l10n/arb/app_localizations.dart';

export 'package:wishlist/l10n/arb/app_localizations.dart';

extension BuildContextWithLocalizations on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
