import 'package:fladder/models/media_playback_model.dart';
import 'package:fladder/providers/video_player_provider.dart';
import 'package:fladder/providers/views_provider.dart';
import 'package:fladder/routes/app_routes.dart';
import 'package:fladder/screens/shared/nested_bottom_appbar.dart';
import 'package:fladder/util/adaptive_layout.dart';
import 'package:fladder/widgets/navigation_scaffold/components/floating_player_bar.dart';
import 'package:fladder/widgets/navigation_scaffold/components/destination_model.dart';
import 'package:fladder/widgets/navigation_scaffold/components/fladder_appbar.dart';
import 'package:fladder/widgets/navigation_scaffold/components/navigation_body.dart';
import 'package:fladder/widgets/navigation_scaffold/components/navigation_drawer.dart';
import 'package:fladder/widgets/shared/hide_on_scroll.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NavigationScaffold extends ConsumerStatefulWidget {
  final int? currentIndex;
  final String? location;
  final Widget? nestedChild;
  final List<DestinationModel> destinations;
  final GlobalKey<NavigatorState>? nestedNavigatorKey;
  const NavigationScaffold({
    this.currentIndex,
    this.location,
    this.nestedChild,
    required this.destinations,
    this.nestedNavigatorKey,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NavigationScaffoldState();
}

class _NavigationScaffoldState extends ConsumerState<NavigationScaffold> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  int get currentIndex => widget.destinations.indexWhere((element) => element.route?.route == widget.location);
  String get currentLocation => widget.location ?? "Nothing";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((value) {
      ref.read(viewsProvider.notifier).fetchViews();
    });
  }

  @override
  Widget build(BuildContext context) {
    final playerState = ref.watch(mediaPlaybackProvider.select((value) => value.state));
    final views = ref.watch(viewsProvider.select((value) => value.views));
    return PopScope(
      canPop: currentIndex == 0,
      onPopInvoked: (didPop) {
        if (currentIndex != 0) {
          widget.destinations.first.action!();
        }
      },
      child: Scaffold(
        key: _key,
        appBar: const FladderAppbar(),
        extendBodyBehindAppBar: true,
        extendBody: true,
        floatingActionButtonLocation:
            playerState == VideoPlayerState.minimized ? FloatingActionButtonLocation.centerFloat : null,
        floatingActionButton: AdaptiveLayout.of(context).layout == LayoutState.phone
            ? switch (playerState) {
                VideoPlayerState.minimized => const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: FloatingPlayerBar(),
                  ),
                _ => widget.destinations.elementAtOrNull(currentIndex)?.floatingActionButton?.normal,
              }
            : null,
        drawer: NestedNavigationDrawer(
          actionButton: null,
          toggleExpanded: (value) {
            _key.currentState?.closeDrawer();
          },
          views: views,
          destinations: widget.destinations,
          currentLocation: currentLocation,
        ),
        bottomNavigationBar: AdaptiveLayout.of(context).layout == LayoutState.phone
            ? HideOnScroll(
                controller: AppRoutes.scrollController,
                child: NestedBottomAppBar(
                  child: Transform.translate(
                    offset: const Offset(0, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: widget.destinations
                          .map(
                            (destination) =>
                                destination.toNavigationButton(widget.location == destination.route?.route, false),
                          )
                          .toList(),
                    ),
                  ),
                ),
              )
            : null,
        body: widget.nestedChild != null
            ? NavigationBody(
                child: widget.nestedChild!,
                parentContext: context,
                currentIndex: currentIndex,
                destinations: widget.destinations,
                currentLocation: currentLocation,
                drawerKey: _key,
              )
            : null,
      ),
    );
  }
}
