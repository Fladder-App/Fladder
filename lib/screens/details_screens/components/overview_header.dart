import 'package:fladder/models/items/item_shared_models.dart';
import 'package:fladder/screens/shared/media/components/small_detail_widgets.dart';
import 'package:fladder/screens/shared/media/external_urls.dart';
import 'package:fladder/util/humanize_duration.dart';
import 'package:fladder/util/list_padding.dart';
import 'package:fladder/util/localization_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OverviewHeader extends ConsumerWidget {
  final String name;
  final EdgeInsets? padding;
  final String? subTitle;
  final String? originalTitle;
  final Function()? onTitleClicked;
  final int? productionYear;
  final Duration? runTime;
  final String? officialRating;
  final double? communityRating;
  final List<Studio> studios;
  final List<GenreItems> genres;
  final List<ExternalUrls>? externalUrls;
  final List<Widget> actions;
  const OverviewHeader({
    required this.name,
    this.padding,
    this.subTitle,
    this.originalTitle,
    this.onTitleClicked,
    this.productionYear,
    this.runTime,
    this.officialRating,
    this.communityRating,
    this.externalUrls,
    this.genres = const [],
    this.studios = const [],
    this.actions = const [],
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mainStyle = Theme.of(context).textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.bold,
        );
    final subStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
          fontSize: 20,
        );

    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 32),
          if (subTitle == null)
            Flexible(
              child: SelectableText(
                name,
                style: mainStyle,
              ),
            )
          else ...{
            Flexible(
              child: SelectableText(
                subTitle ?? "",
                style: mainStyle,
              ),
            ),
            Flexible(
              child: Opacity(
                opacity: 0.75,
                child: Row(
                  children: [
                    Flexible(
                      child: SelectableText(
                        name,
                        style: subStyle,
                        onTap: onTitleClicked,
                      ),
                    ),
                    if (onTitleClicked != null)
                      IconButton(
                          onPressed: onTitleClicked,
                          icon: Transform.translate(offset: const Offset(0, 1.5), child: const Icon(Icons.read_more_rounded)))
                  ],
                ),
              ),
            ),
          },
          if (name != originalTitle && originalTitle != null)
            SelectableText(
              originalTitle.toString(),
              style: subStyle,
            ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              if (productionYear != null)
                SelectableText(
                  productionYear.toString(),
                  style: subStyle,
                ),
              if (runTime != null && (runTime?.inSeconds ?? 0) > 1)
                SelectableText(
                  runTime.humanize.toString(),
                  style: subStyle,
                ),
              if (officialRating != null)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                    child: SelectableText(
                      officialRating.toString(),
                      style: subStyle,
                    ),
                  ),
                ),
              if (communityRating != null)
                Row(
                  children: [
                    Icon(
                      Icons.star_rate_rounded,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    Text(
                      communityRating?.toStringAsFixed(1) ?? "",
                      style: subStyle,
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 6),
          if (studios.isNotEmpty)
            Text(
              "${context.localized.watchOn} ${studios.map((e) => e.name).first}",
              style: subStyle?.copyWith(fontSize: 16, color: Colors.grey),
            ),
          const SizedBox(height: 6),
          if (externalUrls?.isNotEmpty ?? false)
            ExternalUrlsRow(
              urls: externalUrls,
            ),
          const SizedBox(height: 6),
          if (genres.isNotEmpty)
            Genres(
              genres: genres.take(10).toList(),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: actions.addPadding(
              const EdgeInsets.symmetric(horizontal: 6),
            ),
          ),
        ],
      ),
    );
  }
}
