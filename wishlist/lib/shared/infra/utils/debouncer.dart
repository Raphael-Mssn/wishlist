import 'dart:async';

import 'package:flutter/material.dart';

class Debouncer {
  Debouncer({required this.milliseconds});
  final int milliseconds;
  VoidCallback? action;
  Timer? _timer;

  void run(VoidCallback action) {
    final timer = _timer;
    if (timer != null) {
      timer.cancel();
    }

    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
