import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirstLaunchService {
  FirstLaunchService(this._prefs);
  final SharedPreferences _prefs;

  static const String _hasLaunchedKey = 'has_launched_app';

  bool isFirstLaunch() {
    return _prefs.getBool(_hasLaunchedKey) != true;
  }

  Future<void> markAsLaunched() async {
    await _prefs.setBool(_hasLaunchedKey, true);
  }
}

final sharedPreferencesProvider =
    FutureProvider<SharedPreferences>((ref) async {
  return SharedPreferences.getInstance();
});

final firstLaunchServiceProvider =
    FutureProvider<FirstLaunchService>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return FirstLaunchService(prefs);
});
