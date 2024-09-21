import 'package:fladder/models/items/episode_model.dart';
import 'package:fladder/models/items/season_model.dart';
import 'package:fladder/models/syncing/sync_item.dart';
import 'package:fladder/providers/sync_provider.dart';
import 'package:fladder/screens/shared/animated_fade_size.dart';
import 'package:fladder/screens/syncing/widgets/synced_episode_item.dart';
import 'package:fladder/util/fladder_image.dart';
import 'package:fladder/util/list_padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SyncedSeasonPoster extends ConsumerStatefulWidget {
  const SyncedSeasonPoster({
    super.key,
    required this.syncedItem,
    required this.season,
  });

  final SyncedItem syncedItem;
  final SeasonModel season;

  @override
  ConsumerState<SyncedSeasonPoster> createState() => _SyncedSeasonPosterState();
}

class _SyncedSeasonPosterState extends ConsumerState<SyncedSeasonPoster> {
  bool expanded = false;
  @override
  Widget build(BuildContext context) {
    final season = widget.season;
    final children = ref.read(syncProvider.notifier).getChildren(widget.syncedItem);
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 125,
              child: AspectRatio(
                aspectRatio: 0.65,
                child: Card(
                  child: FladderImage(
                    image: season.getPosters?.primary ??
                        season.parentImages?.backDrop?.firstOrNull ??
                        season.parentImages?.primary,
                  ),
                ),
              ),
            ),
            Column(
              children: [
                Text(
                  season.name,
                  style: Theme.of(context).textTheme.titleMedium,
                )
              ],
            ),
            const Spacer(),
            IconButton(
              onPressed: () {
                setState(() {
                  expanded = !expanded;
                });
              },
              icon: Icon(!expanded ? Icons.keyboard_arrow_down_rounded : Icons.keyboard_arrow_up_rounded),
            )
          ].addPadding(const EdgeInsets.symmetric(horizontal: 6)),
        ),
        AnimatedFadeSize(
          duration: const Duration(milliseconds: 250),
          child: expanded && children.isNotEmpty
              ? ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    const Divider(),
                    ...children.map(
                      (item) {
                        final baseItem = ref.read(syncProvider.notifier).getItem(item);
                        return IntrinsicHeight(
                          child: SyncedEpisodeItem(
                            episode: baseItem as EpisodeModel,
                            syncedItem: item,
                            hasFile: item.videoFile.existsSync(),
                          ),
                        );
                      },
                    )
                  ].addPadding(const EdgeInsets.symmetric(vertical: 10)),
                )
              : Container(),
        )
      ].addPadding(EdgeInsets.only(top: 10, bottom: expanded ? 10 : 0)),
    );
  }
}
