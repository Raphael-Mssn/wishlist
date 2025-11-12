import 'dart:io';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_community_mutation/riverpod_community_mutation.dart';
import 'package:wishlist/shared/infra/wish_service.dart';
import 'package:wishlist/shared/models/wish/create_request/wish_create_request.dart';
import 'package:wishlist/shared/models/wish/wish.dart';

part 'wish_mutations_provider.g.dart';

@riverpod
class WishMutations extends _$WishMutations with Mutation<void> {
  @override
  AsyncUpdate<void> build() {
    return const AsyncUpdate.idle();
  }

  Future<void> create(WishCreateRequest request) async {
    await mutate(
      () async {
        final service = ref.read(wishServiceProvider);
        await service.createWish(request);
      },
    );
  }

  Future<void> createWithImage({
    required WishCreateRequest request,
    File? imageFile,
  }) async {
    await mutate(
      () async {
        final service = ref.read(wishServiceProvider);
        await service.createWishWithImage(
          wishCreateRequest: request,
          imageFile: imageFile,
        );
      },
    );
  }

  Future<void> update(Wish wish) async {
    await mutate(
      () async {
        final service = ref.read(wishServiceProvider);
        await service.updateWish(wish);
      },
    );
  }

  Future<void> updateWithImage({
    required Wish wish,
    File? imageFile,
    bool deleteImage = false,
  }) async {
    await mutate(
      () async {
        final service = ref.read(wishServiceProvider);
        await service.updateWishWithImage(
          wish: wish,
          imageFile: imageFile,
          deleteImage: deleteImage,
        );
      },
    );
  }

  Future<void> delete(int wishId, {String? iconUrl}) async {
    await mutate(
      () async {
        final service = ref.read(wishServiceProvider);
        await service.deleteWish(wishId, iconUrl: iconUrl);
      },
    );
  }
}
