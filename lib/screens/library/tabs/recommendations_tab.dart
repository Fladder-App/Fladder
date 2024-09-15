import 'package:fladder/models/view_model.dart';
import 'package:fladder/providers/library_provider.dart';
import 'package:fladder/screens/shared/media/poster_grid.dart';
import 'package:fladder/util/list_padding.dart';
import 'package:fladder/widgets/shared/pull_to_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecommendationsTab extends ConsumerStatefulWidget {
  final ViewModel viewModel;

  const RecommendationsTab({required this.viewModel, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RecommendationsTabState();
}

class _RecommendationsTabState extends ConsumerState<RecommendationsTab> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final recommendations = ref.watch(libraryProvider(widget.viewModel.id)
            .select((value) => value?.recommendations.where((element) => element.posters.isNotEmpty))) ??
        [];
    return PullToRefresh(
      onRefresh: () async {
        await ref.read(libraryProvider(widget.viewModel.id).notifier).loadRecommendations(widget.viewModel);
      },
      child: recommendations.isNotEmpty
          ? ListView(
              children: recommendations
                  .map(
                    (e) => PosterGrid(name: e.name, posters: e.posters),
                  )
                  .toList()
                  .addPadding(
                    const EdgeInsets.only(
                      bottom: 32,
                    ),
                  ),
            )
          : const Center(
              child: Text("No recommendations, add more movies and or shows to receive more recomendations")),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
