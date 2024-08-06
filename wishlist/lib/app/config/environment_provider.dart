import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/app/config/environment.dart';

final environmentProvider =
    Provider.autoDispose<Environment>((ref) => throw UnimplementedError());
