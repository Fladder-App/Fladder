import 'package:chopper/chopper.dart';
import 'package:fladder/jellyfin/jellyfin_open_api.swagger.dart';
import 'package:fladder/models/items/item_shared_models.dart';
import 'package:fladder/models/items/movie_model.dart';
import 'package:fladder/models/items/person_model.dart';
import 'package:fladder/models/items/series_model.dart';
import 'package:fladder/providers/api_provider.dart';
import 'package:fladder/providers/service_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final personDetailsProvider =
    StateNotifierProvider.autoDispose.family<PersonDetailsNotifier, PersonModel?, String>((ref, id) {
  return PersonDetailsNotifier(ref);
});

class PersonDetailsNotifier extends StateNotifier<PersonModel?> {
  PersonDetailsNotifier(this.ref) : super(null);

  final Ref ref;

  late final JellyService api = ref.read(jellyApiProvider);

  Future<Response?> fetchPerson(Person person) async {
    final response = await api.usersUserIdItemsItemIdGet(itemId: person.id);

    if (response.isSuccessful && response.body != null) {
      state = response.bodyOrThrow as PersonModel;
      fetchMovies();
    }

    return response;
  }

  Future<Response?> fetchMovies() async {
    final movies = await api.itemsGet(
      personIds: [state?.id ?? ""],
      limit: 25,
      sortBy: [ItemSortBy.premieredate, ItemSortBy.communityrating, ItemSortBy.sortname, ItemSortBy.productionyear],
      sortOrder: [SortOrder.descending],
      recursive: true,
      fields: [
        ItemFields.primaryimageaspectratio,
      ],
      includeItemTypes: [
        BaseItemKind.movie,
      ],
    );

    final series = await api.itemsGet(
      personIds: [state?.id ?? ""],
      limit: 25,
      sortBy: [ItemSortBy.premieredate, ItemSortBy.communityrating, ItemSortBy.sortname, ItemSortBy.productionyear],
      sortOrder: [SortOrder.descending],
      recursive: true,
      fields: [
        ItemFields.primaryimageaspectratio,
      ],
      includeItemTypes: [
        BaseItemKind.series,
      ],
    );

    state = state?.copyWith(
      movies: movies.body?.items.whereType<MovieModel>().toList(),
      series: series.body?.items.whereType<SeriesModel>().toList(),
    );
    return movies;
  }
}
