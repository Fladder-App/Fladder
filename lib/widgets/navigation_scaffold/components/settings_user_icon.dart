import 'package:auto_route/auto_route.dart';
import 'package:fladder/providers/user_provider.dart';
import 'package:fladder/routes/auto_router.gr.dart';
import 'package:fladder/screens/shared/user_icon.dart';
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
        onLongPress: () => context.router.push(const LockRoute()),
        onTap: () => context.router.navigate(const SettingsRoute()),
      ),
    );
  }
}
