import 'package:flutter_test/flutter_test.dart';
import 'package:wishlist/shared/models/wish_prefill_data/wish_prefill_data.dart';

void main() {
  group('WishPrefillData.fromSharedText', () {
    test('returns empty when text is empty or whitespace', () {
      expect(
        WishPrefillData.fromSharedText(''),
        const WishPrefillData(),
      );
      expect(
        WishPrefillData.fromSharedText('   '),
        const WishPrefillData(),
      );
    });

    test('returns linkUrl only when text is a single URL', () {
      const url = 'https://example.com/product/123';
      final result = WishPrefillData.fromSharedText(url);
      expect(result.linkUrl, url);
      expect(result.name, isNull);
      expect(result.description, isNull);
      expect(result.price, isNull);
    });

    test('returns linkUrl only for http URL without spaces', () {
      const url = 'http://site.fr/page';
      final result = WishPrefillData.fromSharedText(url);
      expect(result.linkUrl, url);
      expect(result.name, isNull);
    });

    test('returns name and linkUrl when text contains title then URL', () {
      const text = 'Mon super produit https://amzn.eu/abc123';
      final result = WishPrefillData.fromSharedText(text);
      expect(result.name, 'Mon super produit');
      expect(result.linkUrl, 'https://amzn.eu/abc123');
    });

    test('returns name and linkUrl when text has multiple words before URL',
        () {
      const text = 'Titre avec plusieurs mots https://example.com/item';
      final result = WishPrefillData.fromSharedText(text);
      expect(result.name, 'Titre avec plusieurs mots');
      expect(result.linkUrl, 'https://example.com/item');
    });

    test('returns name only when text has no URL', () {
      const text = 'Juste un titre de wish';
      final result = WishPrefillData.fromSharedText(text);
      expect(result.name, text);
      expect(result.linkUrl, isNull);
    });

    test('trims leading and trailing whitespace', () {
      final result = WishPrefillData.fromSharedText('  https://x.com  ');
      expect(result.linkUrl, 'https://x.com');
    });
  });

  group('WishPrefillData.fromQueryParams', () {
    test('returns empty when map is empty', () {
      expect(
        WishPrefillData.fromQueryParams({}),
        const WishPrefillData(),
      );
    });

    test('parses name, link, description, price', () {
      final result = WishPrefillData.fromQueryParams({
        'name': 'Mon wish',
        'link': 'https://example.com',
        'description': 'Une description',
        'price': '29.99',
      });
      expect(result.name, 'Mon wish');
      expect(result.linkUrl, 'https://example.com');
      expect(result.description, 'Une description');
      expect(result.price, 29.99);
    });

    test('ignores empty string values for name and link', () {
      final result = WishPrefillData.fromQueryParams({
        'name': '',
        'link': '',
        'description': 'ok',
        'price': '10',
      });
      expect(result.name, isNull);
      expect(result.linkUrl, isNull);
      expect(result.description, 'ok');
      expect(result.price, 10.0);
    });

    test('parses price as null when missing or invalid', () {
      expect(
        WishPrefillData.fromQueryParams({'price': ''}).price,
        isNull,
      );
      expect(
        WishPrefillData.fromQueryParams({'price': 'abc'}).price,
        isNull,
      );
      expect(
        WishPrefillData.fromQueryParams({}).price,
        isNull,
      );
    });

    test('parses partial params', () {
      final result = WishPrefillData.fromQueryParams({
        'link': 'https://only-link.com',
      });
      expect(result.name, isNull);
      expect(result.linkUrl, 'https://only-link.com');
      expect(result.description, isNull);
      expect(result.price, isNull);
    });
  });
}
