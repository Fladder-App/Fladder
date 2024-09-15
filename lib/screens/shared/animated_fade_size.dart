import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnimatedFadeSize extends ConsumerWidget {
  final Duration duration;
  final Widget child;
  const AnimatedFadeSize({
    this.duration = const Duration(milliseconds: 125),
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnimatedSize(
      duration: duration,
      curve: Curves.easeInOutCubic,
      child: AnimatedSwitcher(
        duration: duration,
        switchInCurve: Curves.easeInOutCubic,
        switchOutCurve: Curves.easeInOutCubic,
        child: child,
      ),
    );
  }
}
