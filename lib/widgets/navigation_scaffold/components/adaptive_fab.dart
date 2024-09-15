import 'package:flutter/material.dart';

class AdaptiveFab {
  final BuildContext context;
  final String title;
  final Widget child;
  final Function() onPressed;
  final Key? key;
  AdaptiveFab({
    required this.context,
    this.title = '',
    required this.child,
    required this.onPressed,
    this.key,
  });

  FloatingActionButton get normal {
    return FloatingActionButton(
      key: key,
      onPressed: onPressed,
      tooltip: title,
      child: child,
    );
  }

  Widget get extended {
    return AnimatedContainer(
      key: key,
      duration: const Duration(milliseconds: 250),
      height: 60,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: ElevatedButton(
          onPressed: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                child,
                const Spacer(),
                Flexible(child: Text(title)),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
