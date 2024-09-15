import 'package:flutter/material.dart';

class Throttler {
  final Duration duration;
  int? lastActionTime;

  Throttler({required this.duration});

  void run(VoidCallback action) {
    if (lastActionTime == null) {
      lastActionTime = DateTime.now().millisecondsSinceEpoch;
      action();
    } else {
      if (DateTime.now().millisecondsSinceEpoch - lastActionTime! > (duration.inMilliseconds)) {
        lastActionTime = DateTime.now().millisecondsSinceEpoch;
        action();
      }
    }
  }
}
