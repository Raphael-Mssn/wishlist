import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishlist/shared/infra/user_service.dart';

abstract class Updatable {
  String get updatedBy;
  DateTime get updatedAt;

  Updatable copyWith({String? updatedBy, DateTime? updatedAt});
}

Future<void> updateEntity<T extends Updatable>(
  T entity,
  Ref ref,
  Future<void> Function(T updatedEntity) updateFunction,
) async {
  final updatedBy = ref.read(userServiceProvider).getCurrentUserId();
  final updatedAt = DateTime.now();

  final updatedEntity = entity.copyWith(
    updatedBy: updatedBy,
    updatedAt: updatedAt,
  ) as T;

  await updateFunction(updatedEntity);
}
