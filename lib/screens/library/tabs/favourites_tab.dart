import 'package:fladder/models/view_model.dart';
import 'package:fladder/providers/library_provider.dart';
import 'package:fladder/screens/shared/media/poster_grid.dart';
import 'package:fladder/widgets/shared/pull_to_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavouritesTab extends ConsumerStatefulWidget {
  final ViewModel viewModel;
  const FavouritesTab({required this.viewModel, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FavouritesTabState();
}

class _FavouritesTabState extends ConsumerState<FavouritesTab> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    final favourites = ref.watch(libraryProvider(widget.viewModel.id))?.favourites ?? [];
    super.build(context);
    return PullToRefresh(
      onRefresh: () async {
        await ref.read(libraryProvider(widget.viewModel.id).notifier).loadFavourites(widget.viewModel);
      },
      child: favourites.isNotEmpty
          ? ListView(
              children: [
                PosterGrid(posters: favourites),
              ],
            )
          : const Center(child: Text("No favourites, add some using the heart icon.")),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
