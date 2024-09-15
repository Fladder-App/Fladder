import 'package:ficonsax/ficonsax.dart';
import 'package:fladder/providers/user_provider.dart';
import 'package:fladder/util/localization_helper.dart';
import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fladder/routes/build_routes/home_routes.dart';
import 'package:fladder/routes/build_routes/route_builder.dart';
import 'package:fladder/util/string_extensions.dart';
import 'package:fladder/widgets/navigation_scaffold/components/adaptive_fab.dart';
import 'package:fladder/widgets/navigation_scaffold/components/destination_model.dart';
import 'package:fladder/widgets/navigation_scaffold/navigation_scaffold.dart';

enum HomeTabs {
  dashboard,
  favorites,
  sync;
}

class Home extends ConsumerWidget {
  final HomeTabs? currentTab;
  final Widget? nestedChild;
  final String? location;
  const Home({this.currentTab, this.nestedChild, this.location, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canDownload = ref.watch(showSyncButtonProviderProvider);
    final destinations = HomeTabs.values.map((e) {
      switch (e) {
        case HomeTabs.dashboard:
          return DestinationModel(
            label: context.localized.navigationDashboard,
            icon: const Icon(IconsaxOutline.home),
            selectedIcon: const Icon(IconsaxBold.home),
            route: DashboardRoute(),
            action: () => context.routeGo(DashboardRoute()),
            floatingActionButton: AdaptiveFab(
              context: context,
              title: context.localized.search,
              key: Key(e.name.capitalize()),
              onPressed: () => context.routePushOrGo(LibrarySearchRoute()),
              child: const Icon(IconsaxOutline.search_normal_1),
            ),
          );
        case HomeTabs.favorites:
          return DestinationModel(
            label: context.localized.navigationFavorites,
            icon: const Icon(IconsaxOutline.heart),
            selectedIcon: const Icon(IconsaxBold.heart),
            route: FavouritesRoute(),
            floatingActionButton: AdaptiveFab(
              context: context,
              title: context.localized.filter(0),
              key: Key(e.name.capitalize()),
              onPressed: () => context.routePushOrGo(LibrarySearchRoute(favorites: true)),
              child: const Icon(IconsaxOutline.heart_search),
            ),
            action: () => context.routeGo(FavouritesRoute()),
          );
        case HomeTabs.sync:
          if (canDownload) {
            return DestinationModel(
              label: context.localized.navigationSync,
              icon: const Icon(IconsaxOutline.cloud),
              selectedIcon: const Icon(IconsaxBold.cloud),
              route: SyncRoute(),
              action: () => context.routeGo(SyncRoute()),
            );
          }
          return null;
        default:
          return null;
      }
    });

    return NavigationScaffold(
      currentIndex: currentTab?.index ?? 0,
      location: location,
      nestedChild: nestedChild,
      destinations: destinations.whereNotNull().toList(),
    );
  }
}
