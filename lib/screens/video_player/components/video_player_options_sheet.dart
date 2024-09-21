import 'package:collection/collection.dart';
import 'package:ficonsax/ficonsax.dart';
import 'package:fladder/models/item_base_model.dart';
import 'package:fladder/models/items/episode_model.dart';
import 'package:fladder/models/playback/direct_playback_model.dart';
import 'package:fladder/models/playback/offline_playback_model.dart';
import 'package:fladder/models/playback/playback_model.dart';
import 'package:fladder/models/playback/transcode_playback_model.dart';
import 'package:fladder/providers/settings/video_player_settings_provider.dart';
import 'package:fladder/providers/user_provider.dart';
import 'package:fladder/providers/video_player_provider.dart';
import 'package:fladder/screens/collections/add_to_collection.dart';
import 'package:fladder/screens/metadata/info_screen.dart';
import 'package:fladder/screens/playlists/add_to_playlists.dart';
import 'package:fladder/screens/video_player/components/video_player_queue.dart';
import 'package:fladder/screens/video_player/components/video_subtitle_controls.dart';
import 'package:fladder/util/adaptive_layout.dart';
import 'package:fladder/util/refresh_state.dart';
import 'package:fladder/util/string_extensions.dart';
import 'package:fladder/widgets/shared/enum_selection.dart';
import 'package:fladder/widgets/shared/modal_bottom_sheet.dart';
import 'package:fladder/widgets/shared/spaced_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> showVideoPlayerOptions(BuildContext context) {
  return showBottomSheetPill(
    context: context,
    content: (context, scrollController) {
      return VideoOptions(
        controller: scrollController,
      );
    },
  );
}

class VideoOptions extends ConsumerStatefulWidget {
  final ScrollController controller;
  const VideoOptions({required this.controller, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _VideoOptionsMobileState();
}

class _VideoOptionsMobileState extends ConsumerState<VideoOptions> {
  late int page = 0;

  @override
  Widget build(BuildContext context) {
    final currentItem = ref.watch(playBackModel.select((value) => value?.item));
    final videoSettings = ref.watch(videoPlayerSettingsProvider);
    final currentMediaStreams = ref.watch(playBackModel.select((value) => value?.mediaStreams));

    Widget mainPage() {
      return ListView(
        key: const Key("mainPage"),
        shrinkWrap: true,
        controller: widget.controller,
        children: [
          InkWell(
            onTap: () => setState(() => page = 2),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (currentItem?.title.isNotEmpty == true)
                        Text(
                          currentItem?.title ?? "",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      if (currentItem?.detailedName(context)?.isNotEmpty == true)
                        Text(
                          currentItem?.detailedName(context) ?? "",
                          style: Theme.of(context).textTheme.titleSmall,
                        )
                    ],
                  ),
                  const Spacer(),
                  const Opacity(opacity: 0.1, child: Icon(Icons.info_outline_rounded))
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          if (!AdaptiveLayout.of(context).isDesktop)
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Flexible(flex: 1, child: Text("Screen Brightness")),
                  Flexible(
                    child: Row(
                      children: [
                        Flexible(
                          child: Opacity(
                            opacity: videoSettings.screenBrightness == null ? 0.5 : 1,
                            child: Slider(
                              value: videoSettings.screenBrightness ?? 1.0,
                              min: 0,
                              max: 1,
                              onChanged: (value) =>
                                  ref.read(videoPlayerSettingsProvider.notifier).setScreenBrightness(value),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => ref.read(videoPlayerSettingsProvider.notifier).setScreenBrightness(null),
                          icon: Opacity(
                            opacity: videoSettings.screenBrightness != null ? 0.5 : 1,
                            child: Icon(
                              IconsaxBold.autobrightness,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          SpacedListTile(
            title: const Text("Subtitles"),
            content: Text(currentMediaStreams?.currentSubStream?.displayTitle ?? "Off"),
            onTap: currentMediaStreams?.subStreams.isNotEmpty == true ? () => showSubSelection(context) : null,
          ),
          SpacedListTile(
            title: const Text("Audio"),
            content: Text(currentMediaStreams?.currentAudioStream?.displayTitle ?? "Off"),
            onTap: currentMediaStreams?.audioStreams.isNotEmpty == true ? () => showAudioSelection(context) : null,
          ),
          ListTile(
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: EnumSelection(
                    label: const Text("Scale"),
                    current: videoSettings.videoFit.name.toUpperCaseSplit(),
                    itemBuilder: (context) => BoxFit.values
                        .map((value) => PopupMenuItem(
                              value: value,
                              child: Text(value.name.toUpperCaseSplit()),
                              onTap: () => ref.read(videoPlayerSettingsProvider.notifier).setFitType(value),
                            ))
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
          if (!AdaptiveLayout.of(context).isDesktop)
            ListTile(
              onTap: () => ref.read(videoPlayerSettingsProvider.notifier).setFillScreen(!videoSettings.fillScreen),
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Expanded(
                    flex: 3,
                    child: Text("Fill-screen"),
                  ),
                  const Spacer(),
                  Switch.adaptive(
                    value: videoSettings.fillScreen,
                    onChanged: (value) => ref.read(videoPlayerSettingsProvider.notifier).setFillScreen(value),
                  )
                ],
              ),
            ),
          // ListTile(
          //   title: const Text("Playback settings"),
          //   onTap: () => setState(() => page = 1),
          // ),
        ],
      );
    }

    Widget itemOptions() {
      final currentItem = ref.watch(playBackModel.select((value) => value?.item));
      return ListView(
        shrinkWrap: true,
        children: [
          navTitle("${currentItem?.title} \n${currentItem?.detailedName}"),
          if (currentItem != null) ...{
            if (currentItem.type == FladderItemType.episode)
              ListTile(
                onTap: () {
                  //Pop twice once for sheet once for player
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  (this as EpisodeModel).parentBaseModel.navigateTo(context);
                },
                title: const Text("Open show"),
              ),
            ListTile(
              onTap: () async {
                //Pop twice once for sheet once for player
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                await currentItem.navigateTo(context);
              },
              title: const Text("Show details"),
            ),
            if (currentItem.type != FladderItemType.boxset)
              ListTile(
                onTap: () async {
                  await addItemToCollection(context, [currentItem]);
                  if (context.mounted) {
                    context.refreshData();
                  }
                },
                title: const Text("Add to collection"),
              ),
            if (currentItem.type != FladderItemType.playlist)
              ListTile(
                onTap: () async {
                  await addItemToPlaylist(context, [currentItem]);
                  if (context.mounted) {
                    context.refreshData();
                  }
                },
                title: const Text("Add to playlist"),
              ),
            ListTile(
              onTap: () {
                final favourite = !(currentItem.userData.isFavourite == true);
                ref.read(userProvider.notifier).setAsFavorite(favourite, currentItem.id);
                final newUserData = currentItem.userData;
                final playbackModel = switch (ref.read(playBackModel)) {
                  DirectPlaybackModel value => value.copyWith(item: currentItem.copyWith(userData: newUserData)),
                  TranscodePlaybackModel value => value.copyWith(item: currentItem.copyWith(userData: newUserData)),
                  OfflinePlaybackModel value => value.copyWith(item: currentItem.copyWith(userData: newUserData)),
                  _ => null
                };
                if (playbackModel != null) {
                  ref.read(playBackModel.notifier).update((state) => playbackModel);
                }
                Navigator.of(context).pop();
              },
              title: Text(currentItem.userData.isFavourite == true ? "Remove from favorites" : "Add to favourites"),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).pop();
                showInfoScreen(context, currentItem);
              },
              title: const Text('Media info'),
            ),
          }
        ],
      );
    }

    Widget playbackSettings() {
      final playbackState = ref.watch(playBackModel);
      return ListView(
        key: const Key("PlaybackSettings"),
        shrinkWrap: true,
        controller: widget.controller,
        children: [
          navTitle("Playback Settings"),
          if (playbackState?.queue.isNotEmpty == true)
            ListTile(
              leading: const Icon(Icons.video_collection_rounded),
              title: const Text("Show queue"),
              onTap: () {
                Navigator.of(context).pop();
                ref.read(videoPlayerProvider).pause();
                showFullScreenItemQueue(
                  context,
                  items: playbackState?.queue ?? [],
                  currentItem: playbackState?.item,
                  playSelected: (item) {
                    throw UnimplementedError();
                  },
                );
              },
            )
        ],
      );
    }

    return Column(
      children: [
        AnimatedSize(
          duration: const Duration(milliseconds: 250),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: switch (page) {
              1 => playbackSettings(),
              2 => itemOptions(),
              _ => mainPage(),
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget navTitle(String title) {
    return Column(
      children: [
        Row(
          children: [
            const SizedBox(width: 8),
            BackButton(
              onPressed: () => setState(() => page = 0),
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            )
          ],
        ),
        const SizedBox(height: 12),
        const Divider(height: 1),
        const SizedBox(height: 12),
      ],
    );
  }
}

Future<void> showSubSelection(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      return Consumer(
        builder: (context, ref, child) {
          final playbackModel = ref.watch(playBackModel);
          final player = ref.watch(videoPlayerProvider);
          return SimpleDialog(
            contentPadding: const EdgeInsets.only(top: 8, bottom: 24),
            title: Row(
              children: [
                const Text("Subtitle"),
                const Spacer(),
                IconButton.outlined(
                    onPressed: () {
                      Navigator.pop(context);
                      showSubtitleControls(
                        context: context,
                        label: 'Subtitle configuration',
                      );
                    },
                    icon: const Icon(Icons.display_settings_rounded))
              ],
            ),
            children: playbackModel?.subStreams?.mapIndexed(
              (index, subModel) {
                final selected = playbackModel.mediaStreams?.defaultSubStreamIndex == subModel.index;
                return ListTile(
                  title: Text(subModel.displayTitle),
                  tileColor: selected ? Theme.of(context).colorScheme.primary.withOpacity(0.3) : null,
                  subtitle: subModel.language.isNotEmpty
                      ? Opacity(opacity: 0.6, child: Text(subModel.language.capitalize()))
                      : null,
                  onTap: () async {
                    final newModel = await playbackModel.setSubtitle(subModel, player);
                    ref.read(playBackModel.notifier).update((state) => newModel);
                    if (newModel != null) {
                      await ref.read(playbackModelHelper).shouldReload(newModel);
                    }
                  },
                );
              },
            ).toList(),
          );
        },
      );
    },
  );
}

Future<void> showAudioSelection(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      return Consumer(
        builder: (context, ref, child) {
          final playbackModel = ref.watch(playBackModel);
          final player = ref.watch(videoPlayerProvider);
          return SimpleDialog(
            contentPadding: const EdgeInsets.only(top: 8, bottom: 24),
            title: Row(
              children: [
                const Text("Subtitle"),
                const Spacer(),
                IconButton.outlined(
                    onPressed: () {
                      Navigator.pop(context);
                      showSubtitleControls(
                        context: context,
                        label: 'Subtitle configuration',
                      );
                    },
                    icon: const Icon(Icons.display_settings_rounded))
              ],
            ),
            children: playbackModel?.audioStreams?.mapIndexed(
              (index, audioStream) {
                final selected = playbackModel.mediaStreams?.defaultAudioStreamIndex == audioStream.index;
                return ListTile(
                    title: Text(audioStream.displayTitle),
                    tileColor: selected ? Theme.of(context).colorScheme.primary.withOpacity(0.3) : null,
                    subtitle: audioStream.language.isNotEmpty
                        ? Opacity(opacity: 0.6, child: Text(audioStream.language.capitalize()))
                        : null,
                    onTap: () async {
                      final newModel = await playbackModel.setAudio(audioStream, player);
                      ref.read(playBackModel.notifier).update((state) => newModel);
                      if (newModel != null) {
                        await ref.read(playbackModelHelper).shouldReload(newModel);
                      }
                    });
              },
            ).toList(),
          );
        },
      );
    },
  );
}
