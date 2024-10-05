import 'package:flutter/material.dart';

import 'package:auto_route/auto_route.dart';
import 'package:ficonsax/ficonsax.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fladder/models/item_base_model.dart';
import 'package:fladder/models/items/images_models.dart';
import 'package:fladder/models/media_playback_model.dart';
import 'package:fladder/providers/items/item_details_provider.dart';
import 'package:fladder/providers/video_player_provider.dart';
import 'package:fladder/routes/auto_router.gr.dart';
import 'package:fladder/theme.dart';
import 'package:fladder/util/adaptive_layout.dart';
import 'package:fladder/util/fladder_image.dart';
import 'package:fladder/util/localization_helper.dart';
import 'package:fladder/util/refresh_state.dart';
import 'package:fladder/widgets/navigation_scaffold/components/floating_player_bar.dart';
import 'package:fladder/widgets/navigation_scaffold/components/settings_user_icon.dart';
import 'package:fladder/widgets/shared/item_actions.dart';
import 'package:fladder/widgets/shared/modal_bottom_sheet.dart';
import 'package:fladder/widgets/shared/pull_to_refresh.dart';

class DetailScreen extends ConsumerStatefulWidget {
  final String id;
  final ItemBaseModel? item;
  const DetailScreen({required this.id, this.item, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DetailScreenState();
}

class _DetailScreenState extends ConsumerState<DetailScreen> {
  late Widget currentWidget = const Center(
    key: Key("progress-indicator"),
    child: CircularProgressIndicator.adaptive(strokeCap: StrokeCap.round),
  );

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      if (widget.item != null) {
        setState(() {
          currentWidget = widget.item!.detailScreenWidget;
        });
      } else {
        final response = await ref.read(itemDetailsProvider.notifier).fetchDetails(widget.id);
        if (context.mounted) {
          if (response != null) {
            setState(() {
              currentWidget = response.detailScreenWidget;
            });
          } else {
            context.router.navigate(const DashboardRoute());
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Hero(
          tag: widget.id,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface.withOpacity(1.0),
            ),
            //Small offset to match detailscaffold
            child: Transform.translate(
                offset: const Offset(0, -5), child: FladderImage(image: widget.item?.getPosters?.primary)),
          ),
        ),
        AnimatedSwitcher(
          duration: const Duration(seconds: 1),
          child: currentWidget,
        )
      ],
    );
  }
}

class DetailScaffold extends ConsumerStatefulWidget {
  final String label;
  final ItemBaseModel? item;
  final List<ItemAction>? Function(BuildContext context)? actions;
  final Color? backgroundColor;
  final ImagesData? backDrops;
  final Function(EdgeInsets padding) content;
  final Future<void> Function()? onRefresh;
  const DetailScaffold({
    required this.label,
    this.item,
    this.actions,
    this.backgroundColor,
    required this.content,
    this.backDrops,
    this.onRefresh,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DetailScaffoldState();
}

class _DetailScaffoldState extends ConsumerState<DetailScaffold> {
  List<ImageData>? lastImages;
  ImageData? backgroundImage;

  @override
  void didUpdateWidget(covariant DetailScaffold oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (lastImages == null) {
      lastImages = widget.backDrops?.backDrop;
      setState(() {
        backgroundImage = widget.backDrops?.randomBackDrop;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final padding = EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 25);
    final backGroundColor = Theme.of(context).colorScheme.surface.withOpacity(0.8);
    final playerState = ref.watch(mediaPlaybackProvider.select((value) => value.state));
    return PullToRefresh(
      onRefresh: () async {
        await widget.onRefresh?.call();
        setState(() {
          if (widget.backDrops?.backDrop?.contains(backgroundImage) == true) {
            backgroundImage = widget.backDrops?.randomBackDrop;
          }
        });
      },
      refreshOnStart: true,
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: switch (playerState) {
          VideoPlayerState.minimized => const Padding(
              padding: EdgeInsets.all(8.0),
              child: FloatingPlayerBar(),
            ),
          _ => null,
        },
        backgroundColor: Theme.of(context).colorScheme.surface,
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height - 10,
                    width: MediaQuery.of(context).size.width,
                    child: FladderImage(
                      image: backgroundImage,
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Theme.of(context).colorScheme.surface.withOpacity(0),
                          Theme.of(context).colorScheme.surface.withOpacity(0.10),
                          Theme.of(context).colorScheme.surface.withOpacity(0.35),
                          Theme.of(context).colorScheme.surface.withOpacity(0.85),
                          Theme.of(context).colorScheme.surface,
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    color: widget.backgroundColor,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: 0,
                        left: MediaQuery.of(context).padding.left,
                        top: MediaQuery.of(context).padding.top + 50),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height,
                        maxWidth: MediaQuery.of(context).size.width,
                      ),
                      child: widget.content(padding),
                    ),
                  ),
                ],
              ),
            ),
            //Top row buttons
            IconTheme(
              data: IconThemeData(color: Theme.of(context).colorScheme.onSurface),
              child: Transform.translate(
                offset: const Offset(0, kToolbarHeight),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: IconButton.filledTonal(
                        style: IconButton.styleFrom(
                          backgroundColor: backGroundColor,
                        ),
                        onPressed: () => context.router.maybePop(),
                        icon: Padding(
                          padding:
                              EdgeInsets.all(AdaptiveLayout.of(context).inputDevice == InputDevice.pointer ? 0 : 4),
                          child: const Icon(IconsaxOutline.arrow_left_2),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: AnimatedSize(
                        duration: const Duration(milliseconds: 250),
                        child: Container(
                          decoration: BoxDecoration(
                              color: backGroundColor, borderRadius: FladderTheme.defaultShape.borderRadius),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (widget.item != null) ...[
                                Builder(
                                  builder: (context) {
                                    final newActions = widget.actions?.call(context);
                                    if (AdaptiveLayout.of(context).inputDevice == InputDevice.pointer) {
                                      return PopupMenuButton(
                                        tooltip: context.localized.moreOptions,
                                        enabled: newActions?.isNotEmpty == true,
                                        icon: Icon(widget.item!.type.icon),
                                        itemBuilder: (context) => newActions?.popupMenuItems(useIcons: true) ?? [],
                                      );
                                    } else {
                                      return IconButton(
                                        onPressed: () => showBottomSheetPill(
                                          context: context,
                                          content: (context, scrollController) => ListView(
                                            controller: scrollController,
                                            shrinkWrap: true,
                                            children: newActions?.listTileItems(context, useIcons: true) ?? [],
                                          ),
                                        ),
                                        icon: Icon(
                                          widget.item!.type.icon,
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ],
                              if (AdaptiveLayout.of(context).inputDevice == InputDevice.pointer)
                                Builder(
                                  builder: (context) => Tooltip(
                                    message: context.localized.refresh,
                                    child: IconButton(
                                      onPressed: () => context.refreshData(),
                                      icon: const Icon(IconsaxOutline.refresh),
                                    ),
                                  ),
                                )
                              else
                                const SizedBox(height: 30, width: 30, child: SettingsUserIcon()),
                              Tooltip(
                                message: context.localized.home,
                                child: IconButton(
                                  onPressed: () => context.router.navigate(const DashboardRoute()),
                                  icon: const Icon(IconsaxOutline.home),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
