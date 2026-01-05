abstract final class AppSpacing {
  /// Hauteur de la nav bar flottante (bouton add)
  static const double navBarHeight = 70;

  /// Espace entre le safe area et la nav bar
  static const double navBarBottomOffset = 8;

  /// Fallback pour le padding du contenu (utilisé si pas dans un AppScaffold)
  static const double navBarContentPadding =
      navBarHeight + navBarBottomOffset * 2;
}
