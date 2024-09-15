import 'package:fladder/util/adaptive_layout.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DefautlSliverBottomPadding extends StatelessWidget {
  const DefautlSliverBottomPadding({super.key});

  @override
  Widget build(BuildContext context) {
    return (AdaptiveLayout.of(context).isDesktop || kIsWeb)
        ? const SliverToBoxAdapter()
        : SliverPadding(padding: EdgeInsets.only(bottom: 85 + MediaQuery.of(context).padding.bottom));
  }
}

class DefaultSliverTopBadding extends StatelessWidget {
  const DefaultSliverTopBadding({super.key});

  @override
  Widget build(BuildContext context) {
    return (AdaptiveLayout.of(context).isDesktop || kIsWeb)
        ? const SliverPadding(padding: EdgeInsets.only(top: 35))
        : SliverPadding(padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top));
  }
}
