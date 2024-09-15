import 'package:chopper/chopper.dart';
import 'package:fladder/models/item_base_model.dart';
import 'package:fladder/models/items/photos_model.dart';
import 'package:fladder/models/library_model.dart';
import 'package:fladder/models/recommended_model.dart';
import 'package:fladder/models/view_model.dart';
import 'package:fladder/providers/api_provider.dart';
import 'package:fladder/providers/service_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fladder/jellyfin/jellyfin_open_api.swagger.dart';

bool _useFolders(ViewModel model) {
  switch (model.collectionType) {
    case CollectionType.boxsets:
    case CollectionType.homevideos:
    case CollectionType.folders:
      return true;
    default:
      return false;
  }
}

final libraryProvider = StateNotifierProvider.autoDispose.family<LibraryNotifier, LibraryModel?, String>((ref, id) {
  return LibraryNotifier(ref);
});

class LibraryNotifier extends StateNotifier<LibraryModel?> {
  LibraryNotifier(this.ref) : super(null);

  final Ref ref;

  late final JellyService api = ref.read(jellyApiProvider);

  set loading(bool value) {
    state = state?.copyWith(loading: value);
  }

  bool get loading => state?.loading ?? true;

  Future<void> setupLibrary(ViewModel viewModel) async {
    state ??= LibraryModel(id: viewModel.id, name: viewModel.name, loading: true, type: BaseItemKind.movie);
  }

  Future<Response?> loadLibrary(ViewModel viewModel) async {
    final response = await api.itemsGet(
      parentId: viewModel.id,
      sortBy: [ItemSortBy.sortname, ItemSortBy.productionyear],
      isMissing: false,
      excludeItemTypes: !_useFolders(viewModel) ? [BaseItemKind.folder] : [],
      fields: [ItemFields.genres, ItemFields.childcount, ItemFields.parentid],
    );
    state = state?.copyWith(posters: response.body?.items);
    loading = false;
    return response;
  }

  Future<void> loadRecommendations(ViewModel viewModel) async {
    loading = true;
    //Clear recommendations because of all the copying
    state = state?.copyWith(recommendations: []);
    final latest = await api.usersUserIdItemsLatestGet(
      parentId: viewModel.id,
      limit: 14,
      isPlayed: false,
      imageTypeLimit: 1,
      includeItemTypes: viewModel.collectionType == CollectionType.tvshows ? [BaseItemKind.episode] : null,
    );
    state = state?.copyWith(
      recommendations: [
        ...?state?.recommendations,
        RecommendedModel(
          name: "Latest",
          posters: latest.body?.map((e) => ItemBaseModel.fromBaseDto(e, ref)).toList() ?? [],
          type: "Latest",
        ),
      ],
    );
    if (viewModel.collectionType == CollectionType.movies) {
      final response = await api.moviesRecommendationsGet(
        parentId: viewModel.id,
        categoryLimit: 6,
        itemLimit: 8,
        fields: [ItemFields.mediasourcecount],
      );
      state = state?.copyWith(recommendations: [
        ...?state?.recommendations,
        ...response.body?.map(
              (e) => RecommendedModel(
                name: e.baselineItemName ?? "",
                posters: e.items?.map((e) => ItemBaseModel.fromBaseDto(e, ref)).toList() ?? [],
                type: e.recommendationType.toString(),
              ),
            ) ??
            [],
      ]);
      loading = false;
    } else {
      final nextUp = await api.showsNextUpGet(
        parentId: viewModel.id,
        limit: 14,
        imageTypeLimit: 1,
        fields: [ItemFields.mediasourcecount, ItemFields.primaryimageaspectratio],
      );
      state = state?.copyWith(recommendations: [
        ...?state?.recommendations,
        ...[
          RecommendedModel(
              name: "Next up",
              posters: nextUp.body?.items
                      ?.map(
                        (e) => ItemBaseModel.fromBaseDto(
                          e,
                          ref,
                        ),
                      )
                      .toList() ??
                  [],
              type: "Latest series")
        ],
      ]);
      loading = false;
    }
  }

  Future<Response?> loadFavourites(ViewModel viewModel) async {
    loading = true;
    final response = await api.itemsGet(
      parentId: viewModel.id,
      isFavorite: true,
      recursive: true,
    );

    state = state?.copyWith(favourites: response.body?.items);
    loading = false;
    return response;
  }

  Future<Response?> loadTimeline(ViewModel viewModel) async {
    loading = true;
    final response = await api.itemsGet(
      parentId: viewModel.id,
      recursive: true,
      fields: [ItemFields.primaryimageaspectratio, ItemFields.datecreated],
      sortBy: [ItemSortBy.datecreated],
      sortOrder: [SortOrder.descending],
      includeItemTypes: [
        BaseItemKind.photo,
        BaseItemKind.video,
      ],
    );
    state = state?.copyWith(
      timelinePhotos: response.body?.items.map((e) => e as PhotoModel).toList(),
    );
    loading = false;
    return response;
  }

  Future<Response?> loadGenres(ViewModel viewModel) async {
    final genres = await api.genresGet(
      sortBy: [ItemSortBy.sortname],
      sortOrder: [SortOrder.ascending],
      includeItemTypes: viewModel.collectionType == CollectionType.movies
          ? [BaseItemKind.movie]
          : [
              BaseItemKind.series,
            ],
      parentId: viewModel.id,
    );
    state = state?.copyWith(
        genres: genres.body?.items?.where((element) => element.name?.isNotEmpty ?? false).map((e) => e.name!).toList());
    return null;
  }
}
