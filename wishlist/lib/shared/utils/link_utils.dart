/// Transforme un lien saisi par l'utilisateur en [Uri] web ouvrable, ou
/// renvoie `null` si le lien n'est pas exploitable.
///
/// - Ajoute `https://` quand le schéma est absent (ex. "amazon.fr/produit").
/// - N'accepte que les schémas http et https.
/// - Exige un nom de domaine avec au moins un point (ex. "amazon.fr").
///
/// Exemples:
/// - "https://amazon.fr/produit" -> https://amazon.fr/produit
/// - "www.amazon.fr" -> https://www.amazon.fr
/// - "pas un lien" -> null
Uri? parseWebLink(String? raw) {
  final trimmed = raw?.trim() ?? '';
  if (trimmed.isEmpty || trimmed.contains(RegExp(r'\s'))) {
    return null;
  }

  final hasScheme = RegExp('^[a-zA-Z][a-zA-Z0-9+.-]*://').hasMatch(trimmed);
  final uri = Uri.tryParse(hasScheme ? trimmed : 'https://$trimmed');
  if (uri == null) {
    return null;
  }

  final isWebScheme = uri.scheme == 'http' || uri.scheme == 'https';
  final host = uri.host;
  final hasValidHost = host.contains('.') &&
      !host.startsWith('.') &&
      !host.endsWith('.') &&
      !host.contains('..');

  return isWebScheme && hasValidHost ? uri : null;
}
