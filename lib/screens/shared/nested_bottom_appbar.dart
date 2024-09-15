import 'package:fladder/util/adaptive_layout.dart';
import 'package:fladder/widgets/shared/shapes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NestedBottomAppBar extends ConsumerWidget {
  final Widget child;
  const NestedBottomAppBar({required this.child, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double bottomPadding =
        (AdaptiveLayout.of(context).isDesktop || kIsWeb) ? 12 : MediaQuery.of(context).padding.bottom;
    return Card(
      color: Theme.of(context).colorScheme.surface,
      shape: BottomBarShape(),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: SizedBox(
          height: kBottomNavigationBarHeight + 12 + bottomPadding,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12)
                .copyWith(
                  bottom: bottomPadding,
                )
                .add(EdgeInsets.only(
                  left: MediaQuery.of(context).padding.left,
                  right: MediaQuery.of(context).padding.right,
                )),
            child: child,
          ),
        ),
      ),
    );
  }
}
