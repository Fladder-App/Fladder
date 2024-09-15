import 'package:animations/animations.dart';
import 'package:collection/collection.dart';
import 'package:fladder/jellyfin/jellyfin_open_api.enums.swagger.dart';
import 'package:fladder/models/item_base_model.dart';
import 'package:fladder/models/library_search/library_search_options.dart';
import 'package:fladder/routes/app_routes.dart';
import 'package:fladder/routes/build_routes/route_builder.dart';
import 'package:fladder/screens/dashboard/dashboard_screen.dart';
import 'package:fladder/screens/syncing/synced_screen.dart';
import 'package:fladder/screens/favourites/favourites_screen.dart';
import 'package:fladder/screens/library_search/library_search_screen.dart';
import 'package:fladder/screens/shared/detail_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DashboardRoute extends CustomRoute {
  DashboardRoute() : super(name: 'Dashboard', basePath: '/dashboard');

  @override
  GoRoute get go => GoRoute(
        path: basePath,
        parentNavigatorKey: AppRoutes.homeShellKey,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
              key: state.pageKey,
              child: DashboardScreen(
                key: Key(basePath),
                navigationScrollController: AppRoutes.scrollController,
              ),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
                  child: child,
                );
              });
        },
      );
}

class FavouritesRoute extends CustomRoute {
  FavouritesRoute() : super(name: 'Favorites', basePath: '/favorites');

  @override
  GoRoute get go => GoRoute(
        path: basePath,
        parentNavigatorKey: AppRoutes.homeShellKey,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
              key: state.pageKey,
              child: FavouritesScreen(
                key: Key(basePath),
                navigationScrollController: AppRoutes.scrollController,
              ),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
                  child: child,
                );
              });
        },
      );
}

class SyncRoute extends CustomRoute {
  SyncRoute() : super(name: 'Sync', basePath: '/sync');

  @override
  GoRoute get go => GoRoute(
        path: basePath,
        parentNavigatorKey: AppRoutes.homeShellKey,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
              key: state.pageKey,
              child: SyncedScreen(
                key: Key(basePath),
                navigationScrollController: AppRoutes.scrollController,
              ),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
                  child: child,
                );
              });
        },
      );
}

class DetailsRoute extends CustomRoute {
  final String? id;
  final GlobalKey<NavigatorState>? navKey;
  DetailsRoute({this.id, this.navKey}) : super(name: 'Details', basePath: '/details', arguments: ':itemId');

  @override
  String get route => "$basePath/$id";

  @override
  GoRoute get go => GoRoute(
        path: path,
        parentNavigatorKey: navKey,
        pageBuilder: (context, state) {
          final String id = state.pathParameters['itemId'] ?? "nothing";
          ItemBaseModel? item = state.extra as ItemBaseModel?;
          return CustomTransitionPage(
            key: state.pageKey,
            child: DetailScreen(
              key: Key(id),
              id: id,
              item: item,
            ),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeThroughTransition(
                animation: animation,
                secondaryAnimation: secondaryAnimation,
                child: child,
              );
            },
          );
        },
      );
}

const _libraryKey = "libraryId";
const _sortOptionsKey = "sortOptions";
const _sortOrderKey = "sortOrder";
const _favoriteKey = "favorite";
const _folderKey = "folder";

class LibrarySearchRoute extends CustomRoute {
  final String? id;
  final bool? favorites;
  final SortingOptions? sortOptions;
  final SortOrder? sortOrder;
  final String? folderId;
  final GlobalKey<NavigatorState>? navKey;
  LibrarySearchRoute({this.id, this.favorites, this.sortOptions, this.sortOrder, this.folderId, this.navKey})
      : super(
          name: 'LibrarySearch',
          basePath: '/library',
          queryParameters: {
            _libraryKey: id,
            _sortOptionsKey: sortOptions?.name,
            _sortOrderKey: sortOrder?.name,
            _favoriteKey: favorites,
            _folderKey: folderId,
          },
        );

  @override
  String get route => "$basePath${parseUrlParameters(queryParameters)}";

  @override
  GoRoute get go => GoRoute(
        path: basePath,
        parentNavigatorKey: navKey,
        pageBuilder: (context, state) {
          final String? id = state.uri.queryParameters[_libraryKey];
          final bool? favourites = bool.tryParse(state.uri.queryParameters[_favoriteKey] ?? "");
          final String? folderId = state.uri.queryParameters[_folderKey];
          final SortingOptions? sortingOptions = SortingOptions.values
              .firstWhereOrNull((element) => element.name == state.uri.queryParameters[_sortOptionsKey]);
          final SortingOrder? sortOrder = SortingOrder.values
              .firstWhereOrNull((element) => element.name == state.uri.queryParameters[_sortOrderKey]);
          return CustomTransitionPage(
            key: state.pageKey,
            child: LibrarySearchScreen(
              key: Key(id ?? "librarySearch"),
              viewModelId: id,
              folderId: folderId?.split(','),
              sortingOptions: sortingOptions,
              sortOrder: sortOrder,
              favourites: favourites,
            ),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
                child: child,
              );
            },
          );
        },
      );
}
