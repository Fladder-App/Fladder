import 'package:fladder/providers/user_provider.dart';
import 'package:fladder/routes/build_routes/route_builder.dart';
import 'package:fladder/routes/build_routes/settings_routes.dart';
import 'package:fladder/screens/shared/user_icon.dart';
import 'package:fladder/util/adaptive_layout.dart';
import 'package:fladder/util/localization_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsUserIcon extends ConsumerWidget {
  const SettingsUserIcon({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = ref.watch(userProvider);
    return Tooltip(
      message: context.localized.settings,
      waitDuration: const Duration(seconds: 1),
      child: UserIcon(
        user: users,
        cornerRadius: 200,
        onLongPress: () => context.routePush(LockScreenRoute()),
        onTap: () => switch (AdaptiveLayout.of(context).size) {
          ScreenLayout.single => context.routePush(SettingsRoute()),
          ScreenLayout.dual => context.routePush(ClientSettingsRoute()),
        },
      ),
    );
  }
}
