import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:implicitly_animated_list/implicitly_animated_list.dart';

/// Widget générique qui gère la transition entre une animation staggered
/// au chargement initial et une ImplicitlyAnimatedList pour les changements
/// ultérieurs.
class AnimatedListView<T> extends StatefulWidget {
  const AnimatedListView({
    super.key,
    required this.items,
    required this.itemBuilder,
    required this.itemEquality,
    this.padding,
    this.itemSpacing = 0,
    this.animationDuration = const Duration(milliseconds: 375),
    this.animationDelay = 20,
    this.animationMargin = 200,
    this.estimatedMaxItems,
    this.separatorBuilder,
    this.verticalOffset,
  });

  /// Liste des items à afficher
  final List<T> items;

  /// Builder pour créer un widget à partir d'un item
  final Widget Function(BuildContext context, T item, int index) itemBuilder;

  /// Fonction pour comparer deux items (utilisée par ImplicitlyAnimatedList)
  final bool Function(T oldItem, T newItem) itemEquality;

  /// Padding de la liste
  final EdgeInsets? padding;

  /// Espacement entre les items (utilisé uniquement si separatorBuilder est
  /// null)
  final double itemSpacing;

  /// Durée de l'animation staggered
  final Duration animationDuration;

  /// Délai entre chaque animation staggered (en millisecondes)
  final int animationDelay;

  /// Marge supplémentaire pour le calcul de la durée totale (en millisecondes)
  final int animationMargin;

  /// Nombre maximum estimé d'items (utilisé si items.length est trop grand)
  /// Si null, utilise items.length
  final int? estimatedMaxItems;

  /// Builder optionnel pour créer un séparateur entre les items
  /// Si fourni, utilise ListView.separated au lieu de ListView.builder
  final Widget Function(BuildContext context, int index)? separatorBuilder;

  /// Offset vertical pour l'animation staggered (par défaut: animationDelay)
  final double? verticalOffset;

  @override
  State<AnimatedListView<T>> createState() => _AnimatedListViewState<T>();
}

class _AnimatedListViewState<T> extends State<AnimatedListView<T>> {
  bool _isInitialLoad = true;

  @override
  void initState() {
    super.initState();
    _scheduleInitialLoadCompletion();
  }

  void _scheduleInitialLoadCompletion() {
    final estimatedMaxItems = widget.estimatedMaxItems;

    final itemCount = estimatedMaxItems != null
        ? estimatedMaxItems.clamp(0, widget.items.length)
        : widget.items.length;

    final totalDuration = widget.animationDuration.inMilliseconds +
        (itemCount * widget.animationDelay) +
        widget.animationMargin;

    Future.delayed(Duration(milliseconds: totalDuration), () {
      if (mounted) {
        setState(() => _isInitialLoad = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isInitialLoad
        ? _buildStaggeredListView()
        : _buildImplicitlyAnimatedList();
  }

  Widget _buildStaggeredListView() {
    final verticalOffset =
        widget.verticalOffset ?? widget.animationDelay.toDouble();
    final separatorBuilder = widget.separatorBuilder;

    if (separatorBuilder != null) {
      return AnimationLimiter(
        child: ListView.separated(
          padding: widget.padding,
          itemCount: widget.items.length,
          separatorBuilder: separatorBuilder,
          itemBuilder: (context, index) {
            final item = widget.items[index];
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: widget.animationDuration,
              child: SlideAnimation(
                verticalOffset: verticalOffset,
                child: FadeInAnimation(
                  child: widget.itemBuilder(context, item, index),
                ),
              ),
            );
          },
        ),
      );
    }

    return AnimationLimiter(
      child: ListView.builder(
        padding: widget.padding,
        itemCount: widget.items.length,
        itemBuilder: (context, index) {
          final item = widget.items[index];
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: widget.animationDuration,
            child: SlideAnimation(
              verticalOffset: verticalOffset,
              child: FadeInAnimation(
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: index < widget.items.length - 1
                        ? widget.itemSpacing
                        : 0,
                  ),
                  child: widget.itemBuilder(context, item, index),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildImplicitlyAnimatedList() {
    return ImplicitlyAnimatedList<T>(
      padding: widget.padding,
      itemData: widget.items,
      itemEquality: widget.itemEquality,
      initialAnimation: false,
      itemBuilder: (context, item) {
        final index = widget.items.indexOf(item);
        final hasSeparator = widget.separatorBuilder != null;

        // Si on a un separatorBuilder, on ajoute le spacing après chaque item
        // (sauf le dernier) pour simuler le séparateur dans
        // ImplicitlyAnimatedList
        if (hasSeparator && index < widget.items.length - 1) {
          return Padding(
            padding: EdgeInsets.only(bottom: widget.itemSpacing),
            child: widget.itemBuilder(context, item, index),
          );
        }

        // Sinon, on utilise le spacing normal ou pas de spacing
        if (!hasSeparator && widget.itemSpacing > 0) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: index < widget.items.length - 1 ? widget.itemSpacing : 0,
            ),
            child: widget.itemBuilder(context, item, index),
          );
        }

        return widget.itemBuilder(context, item, index);
      },
    );
  }
}
