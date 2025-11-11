import 'package:flutter/material.dart';
import 'package:wishlist/shared/theme/colors.dart';

class ScrollableContentWithIndicator extends StatefulWidget {
  const ScrollableContentWithIndicator({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<ScrollableContentWithIndicator> createState() =>
      _ScrollableContentWithIndicatorState();
}

class _ScrollableContentWithIndicatorState
    extends State<ScrollableContentWithIndicator> {
  final ScrollController _scrollController = ScrollController();
  bool _showScrollIndicator = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_checkScrollability);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkScrollability();
    });
  }

  @override
  void didUpdateWidget(ScrollableContentWithIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.child != widget.child) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _checkScrollability();
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_checkScrollability);
    _scrollController.dispose();
    super.dispose();
  }

  void _checkScrollability() {
    final canScroll = _scrollController.hasClients &&
        _scrollController.position.maxScrollExtent > 0;
    final isAtBottom = _scrollController.hasClients &&
        _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 10;

    if (mounted) {
      setState(() {
        _showScrollIndicator = canScroll && !isAtBottom;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          controller: _scrollController,
          child: widget.child,
        ),
        if (_showScrollIndicator)
          const Positioned(
            bottom: 0,
            right: 0,
            child: Center(
              child: Icon(
                Icons.arrow_downward,
                color: AppColors.darkGrey,
                size: 28,
              ),
            ),
          ),
      ],
    );
  }
}
