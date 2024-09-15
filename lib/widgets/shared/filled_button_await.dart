import 'dart:async';
import 'dart:developer';

import 'package:fladder/screens/shared/animated_fade_size.dart';
import 'package:flutter/material.dart';

class FilledButtonAwait extends StatefulWidget {
  final FutureOr<dynamic> Function() onPressed;
  final ButtonStyle? style;
  final Widget child;

  const FilledButtonAwait({
    required this.onPressed,
    this.style,
    required this.child,
    super.key,
  });

  @override
  State<FilledButtonAwait> createState() => FilledButtonAwaitState();
}

class FilledButtonAwaitState extends State<FilledButtonAwait> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    const duration = Duration(milliseconds: 250);
    const iconSize = 24.0;
    return FilledButton(
        style: widget.style,
        onPressed: loading
            ? null
            : () async {
                setState(() => loading = true);
                try {
                  await widget.onPressed();
                } catch (e) {
                  log(e.toString());
                } finally {
                  setState(() => loading = false);
                }
              },
        child: AnimatedFadeSize(
          duration: duration,
          child: loading
              ? Opacity(
                  opacity: 0.75,
                  child: SizedBox(
                    width: iconSize,
                    height: iconSize,
                    child: CircularProgressIndicator(
                      strokeCap: StrokeCap.round,
                      color: widget.style?.foregroundColor?.resolve({WidgetState.hovered}),
                    ),
                  ),
                )
              : widget.child,
        ));
  }
}
