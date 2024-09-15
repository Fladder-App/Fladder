import 'package:fladder/models/view_model.dart';
import 'package:fladder/providers/library_provider.dart';
import 'package:fladder/screens/shared/media/poster_grid.dart';
import 'package:fladder/util/grouping.dart';
import 'package:fladder/util/keyed_list_view.dart';
import 'package:fladder/widgets/shared/pull_to_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LibraryTab extends ConsumerStatefulWidget {
  final ViewModel viewModel;
  const LibraryTab({required this.viewModel, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LibraryTabState();
}

class _LibraryTabState extends ConsumerState<LibraryTab> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final library = ref.watch(libraryProvider(widget.viewModel.id).select((value) => value?.posters)) ?? [];
    final items = groupByName(library);
    return PullToRefresh(
      onRefresh: () async {
        await ref.read(libraryProvider(widget.viewModel.id).notifier).loadLibrary(widget.viewModel);
      },
      child: KeyedListView(
        map: items,
        itemBuilder: (context, index) {
          final currentIndex = items.entries.elementAt(index);
          return PosterGrid(name: currentIndex.key, posters: currentIndex.value);
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
