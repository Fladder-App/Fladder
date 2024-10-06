import 'package:flutter/material.dart';

import 'package:ficonsax/ficonsax.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fladder/models/item_base_model.dart';
import 'package:fladder/models/items/season_model.dart';
import 'package:fladder/providers/items/season_details_provider.dart';
import 'package:fladder/providers/user_provider.dart';
import 'package:fladder/screens/details_screens/components/overview_header.dart';
import 'package:fladder/screens/shared/detail_scaffold.dart';
import 'package:fladder/screens/shared/media/components/media_header.dart';
import 'package:fladder/screens/shared/media/episode_details_list.dart';
import 'package:fladder/screens/shared/media/expanding_overview.dart';
import 'package:fladder/screens/shared/media/people_row.dart';
import 'package:fladder/screens/shared/media/person_list_.dart';
import 'package:fladder/util/fladder_image.dart';
import 'package:fladder/util/item_base_model/item_base_model_extensions.dart';
import 'package:fladder/util/list_padding.dart';
import 'package:fladder/util/localization_helper.dart';
import 'package:fladder/util/string_extensions.dart';
import 'package:fladder/util/widget_extensions.dart';
import 'package:fladder/widgets/shared/selectable_icon_button.dart';

class SeasonDetailScreen extends ConsumerStatefulWidget {
  final ItemBaseModel item;
  const SeasonDetailScreen({required this.item, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SeasonDetailScreenState();
}

class _SeasonDetailScreenState extends ConsumerState<SeasonDetailScreen> {
  Set<EpisodeDetailsViewType> viewOptions = {EpisodeDetailsViewType.grid};
  AutoDisposeStateNotifierProvider<SeasonDetailsNotifier, SeasonModel?> get providerId =>
      seasonDetailsProvider(widget.item.id);

  @override
  Widget build(BuildContext context) {
    final details = ref.watch(providerId);

    return DetailScaffold(
      label: details?.localizedName(context) ?? "",
      item: details,
      actions: (context) => details?.generateActions(context, ref, exclude: {
        ItemActions.details,
      }),
      onRefresh: () async {
        await ref.read(providerId.notifier).fetchDetails(widget.item.id);
      },
      backDrops: details?.parentImages,
      content: (padding) => Padding(
        padding: const EdgeInsets.only(bottom: 64),
        child: details != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.35),
                  Wrap(
                    alignment: WrapAlignment.spaceAround,
                    runAlignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 600,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            MediaHeader(
                              name: "${details.seriesName} - ${details.name}",
                              logo: details.parentImages?.logo,
                            ),
                            OverviewHeader(
                              name: details.seriesName,
                              padding: padding,
                              subTitle: details.localizedName(context),
                              onTitleClicked: () => details.parentBaseModel.navigateTo(context),
                              originalTitle: details.seriesName,
                              productionYear: details.overview.productionYear,
                              runTime: details.overview.runTime,
                              studios: details.overview.studios,
                              officialRating: details.overview.parentalRating,
                              genres: details.overview.genreItems,
                              communityRating: details.overview.communityRating,
                              externalUrls: details.overview.externalUrls,
                            ),
                          ],
                        ),
                      ),
                      ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 300),
                          child: Card(child: FladderImage(image: details.getPosters?.primary))),
                    ],
                  ).padding(padding),
                  Row(
                    children: [
                      Expanded(
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            SelectableIconButton(
                              onPressed: () async => await ref
                                  .read(userProvider.notifier)
                                  .setAsFavorite(!details.userData.isFavourite, details.id),
                              selected: details.userData.isFavourite,
                              selectedIcon: IconsaxBold.heart,
                              icon: IconsaxOutline.heart,
                            ),
                            SelectableIconButton(
                              onPressed: () async => await ref
                                  .read(userProvider.notifier)
                                  .markAsPlayed(!details.userData.played, details.id),
                              selected: details.userData.played,
                              selectedIcon: IconsaxBold.tick_circle,
                              icon: IconsaxOutline.tick_circle,
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(200)),
                            child: SegmentedButton(
                              style: const ButtonStyle(
                                elevation: WidgetStatePropertyAll(5),
                                side: WidgetStatePropertyAll(BorderSide.none),
                              ),
                              showSelectedIcon: true,
                              segments: EpisodeDetailsViewType.values
                                  .map(
                                    (e) => ButtonSegment(
                                      value: e,
                                      icon: Icon(e.icon),
                                      label: SizedBox(
                                          height: 50,
                                          child: Center(
                                            child: Text(
                                              e.name.capitalize(),
                                            ),
                                          )),
                                    ),
                                  )
                                  .toList(),
                              selected: viewOptions,
                              onSelectionChanged: (newOptions) {
                                setState(() {
                                  viewOptions = newOptions;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ).padding(padding),
                  if (details.overview.summary.isNotEmpty)
                    ExpandingOverview(
                      text: details.overview.summary,
                    ).padding(padding),
                  if (details.overview.directors.isNotEmpty)
                    PersonList(
                      label: context.localized.director(2),
                      people: details.overview.directors,
                    ).padding(padding),
                  if (details.overview.writers.isNotEmpty)
                    PersonList(label: context.localized.writer(2), people: details.overview.writers).padding(padding),
                  if (details.episodes.isNotEmpty)
                    EpisodeDetailsList(
                      viewType: viewOptions.first,
                      episodes: details.episodes,
                      padding: padding,
                    ),
                  if (details.overview.people.isNotEmpty)
                    PeopleRow(
                      people: details.overview.people,
                      contentPadding: padding,
                    ),
                ].addPadding(const EdgeInsets.symmetric(vertical: 16)),
              )
            : null,
      ),
    );
  }
}
