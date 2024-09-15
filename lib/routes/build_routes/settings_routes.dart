import 'package:fladder/routes/build_routes/route_builder.dart';
import 'package:fladder/screens/settings/client_settings_page.dart';
import 'package:fladder/screens/settings/player_settings_page.dart';
import 'package:fladder/screens/settings/settings_screen.dart';
import 'package:fladder/screens/settings/security_settings_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsRoute extends CustomRoute {
  final String? id;
  final GlobalKey<NavigatorState>? navKey;
  SettingsRoute({this.id, this.navKey}) : super(name: 'Settings', basePath: '/settings');

  @override
  GoRoute get go => GoRoute(
        path: basePath,
        parentNavigatorKey: navKey,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const SettingsScreen(),
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

class ClientSettingsRoute extends CustomRoute {
  final String? id;
  final GlobalKey<NavigatorState>? navKey;
  ClientSettingsRoute({this.id, this.navKey}) : super(name: 'ClientSettings', basePath: '/settings/client');

  @override
  GoRoute get go => GoRoute(
        path: basePath,
        parentNavigatorKey: navKey,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const ClientSettingsPage(),
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

class SecuritySettingsRoute extends CustomRoute {
  final String? id;
  final GlobalKey<NavigatorState>? navKey;
  SecuritySettingsRoute({this.id, this.navKey}) : super(name: 'SecuritySettings', basePath: '/settings/security');

  @override
  GoRoute get go => GoRoute(
        path: basePath,
        parentNavigatorKey: navKey,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const SecuritySettingsPage(),
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

class PlayerSettingsRoute extends CustomRoute {
  final String? id;
  final GlobalKey<NavigatorState>? navKey;
  PlayerSettingsRoute({this.id, this.navKey}) : super(name: 'PlayerSettings', basePath: '/settings/player');

  @override
  GoRoute get go => GoRoute(
        path: basePath,
        parentNavigatorKey: navKey,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const PlayerSettingsPage(),
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
