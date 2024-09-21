import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StatusCard extends ConsumerWidget {
  final Color? color;
  final Widget child;

  const StatusCard({this.color, required this.child, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: SizedBox(
        width: 33,
        height: 33,
        child: Card(
          elevation: 10,
          surfaceTintColor: color,
          shadowColor: color != null ? Colors.transparent : null,
          child: IconTheme(
            data: IconThemeData(
              color: color,
            ),
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}
