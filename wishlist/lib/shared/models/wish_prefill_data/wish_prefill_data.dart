import 'package:freezed_annotation/freezed_annotation.dart';

part 'wish_prefill_data.freezed.dart';

/// Données optionnelles pour préremplir le formulaire de création de Wish.
/// Utilisé pour le partage (share intent), deep link et futur scan code-barres.
@freezed
class WishPrefillData with _$WishPrefillData {
  const factory WishPrefillData({
    String? name,
    String? linkUrl,
    String? description,
    double? price,
  }) = _WishPrefillData;

  /// Construit à partir des query params d'une URL (deep link, navigation).
  factory WishPrefillData.fromQueryParams(Map<String, String> params) {
    if (params.isEmpty) {
      return const WishPrefillData();
    }
    final priceStr = params[_queryKeyPrice];
    return WishPrefillData(
      name: params[_queryKeyName]?.isNotEmpty ?? false
          ? params[_queryKeyName]
          : null,
      linkUrl: params[_queryKeyLink]?.isNotEmpty ?? false
          ? params[_queryKeyLink]
          : null,
      description: params[_queryKeyDescription]?.isNotEmpty ?? false
          ? params[_queryKeyDescription]
          : null,
      price: priceStr != null && priceStr.isNotEmpty
          ? double.tryParse(priceStr)
          : null,
    );
  }

  /// Construit à partir du texte/URL reçu par le share intent.
  /// - Si [text] est une seule URL → [linkUrl], [name] vide.
  /// - Si [text] contient du texte + une URL (ex. "Titre produit https://...")
  ///   → [name] = texte, [linkUrl] = URL.
  /// - Sinon → [name] = text (ex. titre partagé).
  ///
  /// Note : prix, image, description ne sont pas fournis par le partage
  /// (Amazon et la plupart des apps n'envoient que du texte brut : titre +
  /// lien). Les récupérer demanderait de charger la page (scraping / API),
  /// ce qui est fragile et souvent interdit par les CGU.
  factory WishPrefillData.fromSharedText(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) {
      return const WishPrefillData();
    }
    // Cas : tout le texte est une seule URL
    final uri = Uri.tryParse(trimmed);
    final isOnlyUrl = uri != null &&
        uri.hasScheme &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        !trimmed.contains(' ');
    if (isOnlyUrl) {
      return WishPrefillData(linkUrl: trimmed);
    }
    // Cas : texte + URL (ex. "Titre produit https://amzn.eu/...")
    final urlMatch = RegExp(r'https?://[^\s]+').firstMatch(trimmed);
    if (urlMatch != null) {
      final linkUrl = urlMatch.group(0);
      final beforeUrl = trimmed.substring(0, urlMatch.start).trim();
      final name = beforeUrl.isNotEmpty ? beforeUrl : null;
      return WishPrefillData(
        name: name,
        linkUrl: linkUrl,
      );
    }
    return WishPrefillData(name: trimmed);
  }

  const WishPrefillData._();

  static const _queryKeyName = 'name';
  static const _queryKeyLink = 'link';
  static const _queryKeyDescription = 'description';
  static const _queryKeyPrice = 'price';

  /// Construit à partir des paramètres de route
  /// (CreateWishRoute, AddWishRoute).
  static WishPrefillData? fromRouteParams({
    String? name,
    String? link,
    String? description,
    String? price,
  }) {
    final p = WishPrefillData(
      name: name,
      linkUrl: link,
      description: description,
      price: price != null && price.isNotEmpty ? double.tryParse(price) : null,
    );
    return p.hasData ? p : null;
  }

  /// Construit les query params pour une URL (navigation avec prefill).
  Map<String, String> toQueryParams() {
    final map = <String, String>{};
    final name = this.name;
    final linkUrl = this.linkUrl;
    final description = this.description;
    final price = this.price;

    if (name != null && name.isNotEmpty) {
      map[_queryKeyName] = name;
    }
    if (linkUrl != null && linkUrl.isNotEmpty) {
      map[_queryKeyLink] = linkUrl;
    }
    if (description != null && description.isNotEmpty) {
      map[_queryKeyDescription] = description;
    }
    if (price != null) {
      map[_queryKeyPrice] = price.toString();
    }
    return map;
  }

  /// True si au moins un champ est renseigné.
  bool get hasData {
    final name = this.name;
    final linkUrl = this.linkUrl;
    final description = this.description;
    final price = this.price;

    return (name != null && name.isNotEmpty) ||
        (linkUrl != null && linkUrl.isNotEmpty) ||
        (description != null && description.isNotEmpty) ||
        price != null;
  }
}
