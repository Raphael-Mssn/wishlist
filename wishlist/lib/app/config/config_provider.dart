import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/app/config/config.dart';

final configProvider = Provider.autoDispose<Config>(
  (ref) => throw UnimplementedError(),
);
