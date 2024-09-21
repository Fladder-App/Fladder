import 'package:ficonsax/ficonsax.dart';
import 'package:fladder/providers/user_provider.dart';
import 'package:fladder/routes/build_routes/route_builder.dart';
import 'package:fladder/routes/build_routes/settings_routes.dart';
import 'package:fladder/screens/settings/quick_connect_window.dart';
import 'package:fladder/screens/settings/settings_list_tile.dart';
import 'package:fladder/screens/settings/settings_scaffold.dart';
import 'package:fladder/screens/shared/animated_fade_size.dart';
import 'package:fladder/screens/shared/fladder_icon.dart';
import 'package:fladder/util/adaptive_layout.dart';
import 'package:fladder/util/localization_helper.dart';
import 'package:fladder/util/theme_extensions.dart';
import 'package:fladder/widgets/shared/hide_on_scroll.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fladder/providers/auth_provider.dart';
import 'package:fladder/util/application_info.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  final Widget? child;
  final String? location;
  const SettingsScreen({this.child, this.location, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final scrollController = ScrollController();
  late final singlePane = widget.child == null;
  final minVerticalPadding = 20.0;

  @override
  Widget build(BuildContext context) {
    if (singlePane) {
      return Card(
        elevation: 0,
        child: _leftPane(context),
      );
    } else {
      return Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(flex: 1, child: _leftPane(context)),
          Expanded(
            flex: 2,
            child: widget.child ?? Container(),
          ),
        ],
      );
    }
  }

  IconData get deviceIcon {
    if (AdaptiveLayout.of(context).isDesktop) {
      return IconsaxOutline.monitor;
    }
    switch (AdaptiveLayout.of(context).layout) {
      case LayoutState.phone:
        return IconsaxOutline.mobile;
      case LayoutState.tablet:
        return IconsaxOutline.monitor;
      case LayoutState.desktop:
        return IconsaxOutline.monitor;
    }
  }

  bool containsRoute(CustomRoute route) => widget.location == route.route;

  Widget _leftPane(BuildContext context) {
    final quickConnectAvailable =
        ref.watch(userProvider.select((value) => value?.serverConfiguration?.quickConnectAvailable ?? false));
    return SettingsScaffold(
      label: context.localized.settings,
      scrollController: scrollController,
      showUserIcon: true,
      items: [
        if (context.canPop() && AdaptiveLayout.of(context).isDesktop)
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: IconButton.filledTonal(
                style: IconButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.8),
                ),
                onPressed: () {
                  context.pop();
                },
                icon: Padding(
                  padding: EdgeInsets.all(AdaptiveLayout.of(context).inputDevice == InputDevice.pointer ? 0 : 4),
                  child: const Icon(IconsaxOutline.arrow_left_2),
                ),
              ),
            ),
          ),
        SettingsListTile(
          label: Text(context.localized.settingsClientTitle),
          subLabel: Text(context.localized.settingsClientDesc),
          selected: containsRoute(ClientSettingsRoute()),
          icon: deviceIcon,
          onTap: () => context.routeReplaceOrPush(ClientSettingsRoute()),
        ),
        if (quickConnectAvailable)
          SettingsListTile(
            label: Text(context.localized.settingsQuickConnectTitle),
            icon: IconsaxOutline.password_check,
            onTap: () => openQuickConnectDialog(context),
          ),
        SettingsListTile(
          label: Text(context.localized.settingsProfileTitle),
          subLabel: Text(context.localized.settingsProfileDesc),
          selected: containsRoute(SecuritySettingsRoute()),
          icon: IconsaxOutline.security_user,
          onTap: () => context.routeReplaceOrPush(SecuritySettingsRoute()),
        ),
        SettingsListTile(
          label: Text(context.localized.settingsPlayerTitle),
          subLabel: Text(context.localized.settingsPlayerDesc),
          selected: containsRoute(PlayerSettingsRoute()),
          icon: IconsaxOutline.video_play,
          onTap: () => context.routeReplaceOrPush(PlayerSettingsRoute()),
        ),
        SettingsListTile(
          label: Text(context.localized.about),
          subLabel: const Text("Fladder"),
          suffix: Opacity(
              opacity: 1,
              child: FladderIconOutlined(
                size: 24,
                color: context.colors.onSurfaceVariant,
              )),
          onTap: () => showAboutDialog(
            context: context,
            applicationIcon: const FladderIcon(size: 85),
            applicationVersion: ref.watch(applicationInfoProvider).versionAndPlatform,
            applicationLegalese: "Donut Factory",
          ),
        ),
      ],
      floatingActionButton: HideOnScroll(
        controller: scrollController,
        visibleBuilder: (visible) {
          return AnimatedFadeSize(
            child: visible
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.paddingOf(context).horizontal),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Spacer(),
                          FloatingActionButton(
                            key: Key(context.localized.switchUser),
                            tooltip: context.localized.switchUser,
                            onPressed: () {
                              ref.read(userProvider.notifier).logoutUser();
                              context.routeGo(LoginRoute());
                            },
                            child: const Icon(
                              IconsaxOutline.arrow_swap_horizontal,
                            ),
                          ),
                          const SizedBox(width: 16),
                          FloatingActionButton(
                            key: Key(context.localized.logout),
                            tooltip: context.localized.logout,
                            backgroundColor: Theme.of(context).colorScheme.errorContainer,
                            onPressed: () {
                              final user = ref.read(userProvider);
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog.adaptive(
                                  title: Text(context.localized.logoutUserPopupTitle(user?.name ?? "")),
                                  scrollable: true,
                                  content: Text(
                                    context.localized.logoutUserPopupContent(user?.name ?? "", user?.server ?? ""),
                                  ),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text(context.localized.cancel),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom().copyWith(
                                        foregroundColor:
                                            WidgetStatePropertyAll(Theme.of(context).colorScheme.onErrorContainer),
                                        backgroundColor:
                                            WidgetStatePropertyAll(Theme.of(context).colorScheme.errorContainer),
                                      ),
                                      onPressed: () async {
                                        await ref.read(authProvider.notifier).logOutUser();
                                        if (context.mounted) context.routeGo(SplashRoute());
                                      },
                                      child: Text(context.localized.logout),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: Icon(
                              IconsaxOutline.logout,
                              color: Theme.of(context).colorScheme.onErrorContainer,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Container(
                    height: 0,
                    key: UniqueKey(),
                  ),
          );
        },
      ),
    );
  }
}
