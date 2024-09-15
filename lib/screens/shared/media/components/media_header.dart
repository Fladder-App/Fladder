import 'package:fladder/models/items/images_models.dart';
import 'package:fladder/util/adaptive_layout.dart';
import 'package:fladder/util/fladder_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MediaHeader extends ConsumerWidget {
  final String name;
  final ImageData? logo;
  const MediaHeader({
    required this.name,
    required this.logo,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final maxWidth =
        switch (AdaptiveLayout.layoutOf(context)) { LayoutState.desktop || LayoutState.tablet => 0.55, _ => 1 };
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Material(
          elevation: 30,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(150)),
          shadowColor: Colors.black.withOpacity(0.35),
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.sizeOf(context).height * 0.2,
                maxWidth: MediaQuery.sizeOf(context).width * maxWidth,
              ),
              child: FladderImage(
                image: logo,
                enableBlur: true,
                frameBuilder: (context, child, frame, wasSynchronouslyLoaded) => Container(
                  color: Colors.red,
                  width: 512,
                  height: 512,
                  child: child,
                ),
                placeHolder: const SizedBox(height: 0),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
