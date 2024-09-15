import 'package:fladder/providers/shared_provider.dart';
import 'package:fladder/providers/user_provider.dart';
import 'package:fladder/routes/build_routes/home_routes.dart';
import 'package:fladder/routes/build_routes/route_builder.dart';
import 'package:fladder/routes/build_routes/settings_routes.dart';
import 'package:fladder/screens/home.dart';
import 'package:fladder/screens/settings/settings_screen.dart';
import 'package:fladder/util/adaptive_layout.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AppRoutes {
  static final parentKey = GlobalKey<NavigatorState>();
  static final homeShellKey = GlobalKey<NavigatorState>();
  static final settingsKey = GlobalKey<NavigatorState>();
  static final loginRoute = LoginRoute();
  static final splashRoute = SplashRoute();

  static final scrollController = ScrollController();

  static GoRouter routes({required WidgetRef ref, required ScreenLayout screenLayout}) {
    return GoRouter(
      navigatorKey: parentKey,
      initialLocation: splashRoute.route,
      //Only useful for web if the user is not in an active session yet
      redirect: kIsWeb
          ? (context, state) async {
              if (state.uri.toString() == loginRoute.route || state.uri.toString() == splashRoute.route) return null;
              await Future.microtask(() {
                final lastUsedAccount = ref.read(sharedUtilityProvider).getActiveAccount();
                if (lastUsedAccount == null) return loginRoute.route;
                if (ref.read(userProvider) == null) ref.read(userProvider.notifier).loginUser(lastUsedAccount);
              });
              if (ref.read(userProvider) == null) {
                return loginRoute.route;
              } else {
                return state.uri.toString();
              }
            }
          : null,
      routes: AppRoutes().getRoutes(screenLayout),
    );
  }

  List<RouteBase> getRoutes(ScreenLayout screenLayout) {
    switch (screenLayout) {
      case ScreenLayout.single:
        return linearRoutes;
      case ScreenLayout.dual:
        return nestedRoutes;
    }
  }

  static List<RouteBase> linearRoutes = [
    loginRoute.go,
    splashRoute.go,
    LockScreenRoute().go,
    ShellRoute(
      navigatorKey: homeShellKey,
      pageBuilder: (context, state, child) {
        return NoTransitionPage(
          child: Home(
            key: state.pageKey,
            location: state.uri.toString(),
            nestedChild: child,
          ),
        );
      },
      routes: [
        DashboardRoute().go,
        FavouritesRoute().go,
        SyncRoute().go,
      ],
    ),
    DetailsRoute(navKey: parentKey).go,
    LibrarySearchRoute(navKey: parentKey).go,

    // Settings routes
    SettingsRoute(navKey: parentKey).go,
    ClientSettingsRoute(navKey: parentKey).go,
    SecuritySettingsRoute(navKey: parentKey).go,
    PlayerSettingsRoute(navKey: parentKey).go,
  ];

  static List<RouteBase> nestedRoutes = [
    loginRoute.go,
    splashRoute.go,
    LockScreenRoute().go,
    ShellRoute(
      navigatorKey: homeShellKey,
      pageBuilder: (context, state, child) => NoTransitionPage(
        child: Home(
          key: state.pageKey,
          location: state.uri.toString(),
          nestedChild: child,
        ),
      ),
      routes: [
        ShellRoute(
          navigatorKey: settingsKey,
          pageBuilder: (context, state, child) => NoTransitionPage(
            key: state.pageKey,
            child: SettingsScreen(location: state.uri.toString(), child: child),
          ),
          routes: [
            ClientSettingsRoute(navKey: settingsKey).go,
            SecuritySettingsRoute(navKey: settingsKey).go,
            PlayerSettingsRoute(navKey: settingsKey).go,
          ],
        ),
        DashboardRoute().go,
        FavouritesRoute().go,
        SyncRoute().go,
        DetailsRoute(navKey: homeShellKey).go,
        LibrarySearchRoute(navKey: homeShellKey).go,
      ],
    ),
  ];
}
