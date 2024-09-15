import 'package:flutter/material.dart';

class DisableFocus extends StatelessWidget {
  final Widget child;
  final bool canRequestFocus;
  final bool skipTraversal;
  final bool descendantsAreFocusable;
  final bool descendantsAreTraversable;
  const DisableFocus({
    required this.child,
    super.key,
    this.canRequestFocus = false,
    this.skipTraversal = true,
    this.descendantsAreFocusable = false,
    this.descendantsAreTraversable = false,
  });

  @override
  Widget build(BuildContext context) {
    return Focus(
      canRequestFocus: canRequestFocus,
      skipTraversal: skipTraversal,
      descendantsAreFocusable: descendantsAreFocusable,
      descendantsAreTraversable: descendantsAreTraversable,
      child: child,
    );
  }
}
