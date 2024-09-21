import 'dart:async';

import 'package:collection/collection.dart';
import 'package:fladder/jellyfin/jellyfin_open_api.enums.swagger.dart';
import 'package:fladder/jellyfin/jellyfin_open_api.swagger.dart';
import 'package:fladder/models/library_search/library_search_options.dart';
import 'package:fladder/models/settings/home_settings_model.dart';
import 'package:fladder/providers/dashboard_provider.dart';
import 'package:fladder/providers/settings/client_settings_provider.dart';
import 'package:fladder/providers/settings/home_settings_provider.dart';
import 'package:fladder/providers/user_provider.dart';
import 'package:fladder/providers/views_provider.dart';
import 'package:fladder/routes/build_routes/home_routes.dart';
import 'package:fladder/routes/build_routes/route_builder.dart';
import 'package:fladder/screens/shared/media/carousel_banner.dart';
import 'package:fladder/screens/shared/media/poster_row.dart';
import 'package:fladder/screens/shared/nested_scaffold.dart';
import 'package:fladder/screens/shared/nested_sliver_appbar.dart';
import 'package:fladder/util/adaptive_layout.dart';
import 'package:fladder/util/list_padding.dart';
import 'package:fladder/util/localization_helper.dart';
import 'package:fladder/util/sliver_list_padding.dart';
import 'package:fladder/widgets/shared/pinch_poster_zoom.dart';
import 'package:fladder/widgets/shared/poster_size_slider.dart';
import 'package:fladder/widgets/shared/pull_to_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  final ScrollController navigationScrollController;
  const DashboardScreen({
    required this.navigationScrollController,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  late final Timer _timer;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 120), (timer) {
      _refreshIndicatorKey.currentState?.show();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> _refreshHome() async {
    if (mounted) {
      await ref.read(userProvider.notifier).updateInformation();
      await ref.read(viewsProvider.notifier).fetchViews();
      await ref.read(dashboardProvider.notifier).fetchNextUpAndResume();
    }
  }

  @override
  Widget build(BuildContext context) {
    final dashboardData = ref.watch(dashboardProvider);
    final views = ref.watch(viewsProvider);
    final homeSettings = ref.watch(homeSettingsProvider);
    final resumeVideo = dashboardData.resumeVideo;
    final resumeAudio = dashboardData.resumeAudio;
    final resumeBooks = dashboardData.resumeBooks;

    final allResume = [...resumeVideo, ...resumeAudio, ...resumeBooks].toList();

    final homeCarouselItems = switch (homeSettings.carouselSettings) {
      HomeCarouselSettings.nextUp => dashboardData.nextUp,
      HomeCarouselSettings.combined => [...allResume, ...dashboardData.nextUp],
      HomeCarouselSettings.cont => allResume,
      _ => [...allResume, ...dashboardData.nextUp],
    };

    return MediaQuery.removeViewInsets(
      context: context,
      child: NestedScaffold(
        body: PullToRefresh(
          refreshKey: _refreshIndicatorKey,
          displacement: 80 + MediaQuery.of(context).viewPadding.top,
          onRefresh: () async => await _refreshHome(),
          child: PinchPosterZoom(
            scaleDifference: (difference) => ref.read(clientSettingsProvider.notifier).addPosterSize(difference),
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: widget.navigationScrollController,
              slivers: [
                if (AdaptiveLayout.of(context).layout == LayoutState.phone)
                  NestedSliverAppBar(
                    route: LibrarySearchRoute(),
                    parent: context,
                  ),
                if (homeSettings.carouselSettings != HomeCarouselSettings.off && homeCarouselItems.isNotEmpty) ...{
                  SliverToBoxAdapter(
                    child: Transform.translate(
                      offset: Offset(0, AdaptiveLayout.layoutOf(context) == LayoutState.phone ? -14 : 0),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                            minHeight: AdaptiveLayout.of(context).isDesktop ? 350 : 275,
                            maxHeight: (MediaQuery.sizeOf(context).height * 0.25).clamp(400, double.infinity)),
                        child: AspectRatio(
                          aspectRatio: 1.6,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: CarouselBanner(
                              items: homeCarouselItems,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                } else if (AdaptiveLayout.of(context).isDesktop)
                  const DefaultSliverTopBadding(),
                if (AdaptiveLayout.of(context).isDesktop)
                  const SliverToBoxAdapter(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        PosterSizeWidget(),
                      ],
                    ),
                  ),
                ...[
                  if (resumeVideo.isNotEmpty &&
                      (homeSettings.nextUp == HomeNextUp.cont || homeSettings.nextUp == HomeNextUp.separate))
                    SliverToBoxAdapter(
                      child: PosterRow(
                        label: context.localized.dashboardContinueWatching,
                        posters: resumeVideo,
                      ),
                    ),
                  if (resumeAudio.isNotEmpty &&
                      (homeSettings.nextUp == HomeNextUp.cont || homeSettings.nextUp == HomeNextUp.separate))
                    SliverToBoxAdapter(
                      child: PosterRow(
                        label: context.localized.dashboardContinueListening,
                        posters: resumeAudio,
                      ),
                    ),
                  if (resumeBooks.isNotEmpty &&
                      (homeSettings.nextUp == HomeNextUp.cont || homeSettings.nextUp == HomeNextUp.separate))
                    SliverToBoxAdapter(
                      child: PosterRow(
                        label: context.localized.dashboardContinueReading,
                        posters: resumeBooks,
                      ),
                    ),
                  if (dashboardData.nextUp.isNotEmpty &&
                      (homeSettings.nextUp == HomeNextUp.nextUp || homeSettings.nextUp == HomeNextUp.separate))
                    SliverToBoxAdapter(
                      child: PosterRow(
                        label: context.localized.dashboardNextUp,
                        posters: dashboardData.nextUp,
                      ),
                    ),
                  if ([...allResume, ...dashboardData.nextUp].isNotEmpty && homeSettings.nextUp == HomeNextUp.combined)
                    SliverToBoxAdapter(
                      child: PosterRow(
                        label: context.localized.dashboardContinue,
                        posters: [...allResume, ...dashboardData.nextUp],
                      ),
                    ),
                  ...views.dashboardViews
                      .where((element) => element.recentlyAdded.isNotEmpty)
                      .map((view) => SliverToBoxAdapter(
                            child: PosterRow(
                              label: context.localized.dashboardRecentlyAdded(view.name),
                              onLabelClick: () => context.routePushOrGo(LibrarySearchRoute(
                                id: view.id,
                                sortOptions: switch (view.collectionType) {
                                  CollectionType.tvshows ||
                                  CollectionType.books ||
                                  CollectionType.boxsets ||
                                  CollectionType.folders ||
                                  CollectionType.music =>
                                    SortingOptions.dateLastContentAdded,
                                  _ => SortingOptions.dateAdded,
                                },
                                sortOrder: SortOrder.descending,
                              )),
                              posters: view.recentlyAdded,
                            ),
                          )),
                ].whereNotNull().toList().addInBetween(const SliverToBoxAdapter(child: SizedBox(height: 16))),
                const DefautlSliverBottomPadding(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
