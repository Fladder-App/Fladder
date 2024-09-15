import 'package:fladder/screens/login/login_screen.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:fladder/routes/app_routes.dart';
import 'package:fladder/screens/login/lock_screen.dart';
import 'package:fladder/screens/splash_screen.dart';
import 'package:fladder/util/adaptive_layout.dart';

extension RouteContextBuilder on BuildContext {
  /// Push a location onto the page stack.
  Future<T?> routePush<T>(CustomRoute route, {Object? extra}) async {
    return push(route.route, extra: extra);
  }

  /// Replaces the top-most page of the page stack with the given URL location
  void routeReplace(CustomRoute route, {Object? extra}) {
    replace(route.route, extra: extra);
  }

  /// Navigate to a location.
  void routeGo(CustomRoute route, {Object? extra}) {
    go(route.route, extra: extra);
  }

  /// [Pushed] if nested(single) else [Go]
  void routePushOrGo(CustomRoute route, {Object? extra}) {
    switch (AdaptiveLayout.of(this).size) {
      case ScreenLayout.single:
        routePush(route, extra: extra);
        break;
      case ScreenLayout.dual:
        routeGo(route, extra: extra);
        break;
    }
  }

  /// [Push] if nested(single) else [Replace]
  void routeReplaceOrPush(CustomRoute route, {Object? extra}) {
    switch (AdaptiveLayout.of(this).size) {
      case ScreenLayout.single:
        routePush(route, extra: extra);
        break;
      case ScreenLayout.dual:
        routeReplace(route, extra: extra);
        break;
    }
  }
}

abstract class CustomRoute {
  final String name;
  final String basePath;
  final String? arguments;
  final Map<String, dynamic>? queryParameters;

  CustomRoute({required this.name, required this.basePath, this.arguments, this.queryParameters})
      : assert(basePath.isNotEmpty, 'GoRoute path cannot be empty');

  String get route => basePath;

  String get path => "$basePath/${arguments ?? queryParameters}";

  void navigate() {
    AppRoutes.parentKey.currentContext?.routeGo(this);
  }

  void replaceRoot() {
    AppRoutes.parentKey.currentContext?.routeReplace(this);
  }

  RouteBase get go;
}

class LoginRoute extends CustomRoute {
  LoginRoute() : super(name: 'Login', basePath: '/login');

  @override
  GoRoute get go => GoRoute(
        path: basePath,
        builder: (context, state) {
          return const LoginScreen();
        },
      );
}

class SplashRoute extends CustomRoute {
  SplashRoute() : super(name: 'Splash', basePath: '/splash');

  @override
  GoRoute get go => GoRoute(
        path: basePath,
        builder: (context, state) {
          return const SplashScreen();
        },
      );
}

class LockScreenRoute extends CustomRoute {
  final bool selfLock;
  LockScreenRoute({this.selfLock = false}) : super(name: 'Lock', basePath: '/lock');

  @override
  GoRoute get go => GoRoute(
        parentNavigatorKey: AppRoutes.parentKey,
        path: basePath,
        builder: (context, state) {
          return LockScreen(
            selfLock: selfLock,
          );
        },
      );
}

String parseUrlParameters(Map<String, dynamic>? parameters) {
  if (parameters == null) return '';
  String parameterString = '?';
  for (String key in parameters.keys) {
    if (parameters[key] != null) parameterString += '$key=${parameters[key]}&';
  }

  return parameterString.substring(0, parameterString.length - 1);
}
