import 'package:fladder/util/adaptive_layout.dart';
import 'package:flutter/material.dart';

Future<void> showDialogAdaptive(
    {required BuildContext context, bool useSafeArea = true, required Widget Function(BuildContext context) builder}) {
  if (AdaptiveLayout.of(context).inputDevice == InputDevice.pointer) {
    return showDialog(
      context: context,
      useSafeArea: useSafeArea,
      builder: (context) => Dialog(
        child: builder(context),
      ),
    );
  } else {
    return showDialog(
      context: context,
      useSafeArea: useSafeArea,
      builder: (context) => Dialog.fullscreen(
        child: builder(context),
      ),
    );
  }
}
