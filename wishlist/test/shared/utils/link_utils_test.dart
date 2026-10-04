import 'package:flutter_test/flutter_test.dart';
import 'package:wishlist/shared/utils/link_utils.dart';

void main() {
  group('parseWebLink', () {
    test('keeps a valid https link as is', () {
      expect(
        parseWebLink('https://www.amazon.fr/dp/B0CHX1W1XY?ref=abc'),
        Uri.parse('https://www.amazon.fr/dp/B0CHX1W1XY?ref=abc'),
      );
    });

    test('accepts http links', () {
      expect(
        parseWebLink('http://example.com'),
        Uri.parse('http://example.com'),
      );
    });

    test('adds https when the scheme is missing', () {
      expect(
        parseWebLink('amazon.fr/produit'),
        Uri.parse('https://amazon.fr/produit'),
      );
      expect(parseWebLink('www.fnac.com'), Uri.parse('https://www.fnac.com'));
    });

    test('trims surrounding whitespace', () {
      expect(
        parseWebLink('  https://apple.com  '),
        Uri.parse('https://apple.com'),
      );
    });

    test('rejects empty or null input', () {
      expect(parseWebLink(null), isNull);
      expect(parseWebLink(''), isNull);
      expect(parseWebLink('   '), isNull);
    });

    test('rejects plain text', () {
      expect(parseWebLink('pas un lien'), isNull);
      expect(parseWebLink('cadeau'), isNull);
      expect(parseWebLink('https://cadeau'), isNull);
    });

    test('rejects malformed hosts', () {
      expect(parseWebLink('https://.com'), isNull);
      expect(parseWebLink('https://amazon.'), isNull);
      expect(parseWebLink('https://amazon..fr'), isNull);
      expect(parseWebLink('https://'), isNull);
    });

    test('rejects non web schemes', () {
      expect(parseWebLink('ftp://example.com'), isNull);
      expect(parseWebLink('javascript://example.com'), isNull);
    });
  });
}
