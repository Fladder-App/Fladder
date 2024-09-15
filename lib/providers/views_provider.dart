import 'package:fladder/jellyfin/jellyfin_open_api.swagger.dart';
import 'package:fladder/models/item_base_model.dart';
import 'package:fladder/models/view_model.dart';
import 'package:fladder/models/views_model.dart';
import 'package:fladder/providers/api_provider.dart';
import 'package:fladder/providers/service_provider.dart';
import 'package:fladder/providers/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final viewsProvider = StateNotifierProvider<ViewsNotifier, ViewsModel>((ref) {
  return ViewsNotifier(ref);
});

class ViewsNotifier extends StateNotifier<ViewsModel> {
  ViewsNotifier(this.ref) : super(ViewsModel());

  final Ref ref;

  late final JellyService api = ref.read(jellyApiProvider);

  Future<void> fetchViews() async {
    if (state.loading) return;
    final response = await api.usersUserIdViewsGet();
    final createdViews = response.body?.items?.map((e) => ViewModel.fromBodyDto(e, ref));
    List<ViewModel> newList = [];

    if (createdViews != null) {
      newList = await Future.wait(createdViews.map((e) async {
        if (ref.read(userProvider)?.latestItemsExcludes.contains(e.id) == true) return e;
        if ([CollectionType.boxsets, CollectionType.folders].contains(e.collectionType)) return e;
        final recents = await api.usersUserIdItemsLatestGet(
          parentId: e.id,
          imageTypeLimit: 1,
          limit: 16,
          enableImageTypes: [
            ImageType.primary,
            ImageType.backdrop,
            ImageType.thumb,
          ],
          fields: [
            ItemFields.parentid,
            ItemFields.mediastreams,
            ItemFields.mediasources,
            ItemFields.candelete,
            ItemFields.candownload,
          ],
        );
        return e.copyWith(recentlyAdded: recents.body?.map((e) => ItemBaseModel.fromBaseDto(e, ref)).toList());
      }));
    }

    state = state.copyWith(
        views: newList,
        dashboardViews: newList
            .where((element) => !(ref.read(userProvider)?.latestItemsExcludes.contains(element.id) ?? true))
            .where((element) => ![CollectionType.boxsets, CollectionType.folders].contains(element.collectionType))
            .toList(),
        loading: false);
  }

  void clear() {
    state = ViewsModel();
  }
}
