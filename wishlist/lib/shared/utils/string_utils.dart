/// Normalise une chaîne en retirant les accents et en la convertissant en
/// minuscules
///
/// Exemples:
/// - "Éléphant" -> "elephant"
/// - "Café" -> "cafe"
/// - "Naïve" -> "naive"
String normalizeString(String input) {
  const withAccents = 'ÀÁÂÃÄÅàáâãäåÒÓÔÕÖØòóôõöøÈÉÊËèéêëÇçÌÍÎÏìíîïÙÚÛÜùúûüÿÑñ';
  const withoutAccents =
      'AAAAAAaaaaaaOOOOOOooooooEEEEeeeeCcIIIIiiiiUUUUuuuuyNn';

  var result = input.toLowerCase();

  for (var i = 0; i < withAccents.length; i++) {
    result = result.replaceAll(withAccents[i], withoutAccents[i]);
  }

  return result;
}
