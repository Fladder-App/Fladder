import 'package:fladder/models/item_base_model.dart';

class SearchModel {
  final bool loading;
  final String searchQuery;
  final int resultCount;
  final Map<FladderItemType, List<ItemBaseModel>> results;
  SearchModel({
    this.loading = false,
    this.searchQuery = "",
    this.resultCount = 0,
    this.results = const {},
  });

  SearchModel copyWith({
    bool? loading,
    String? searchQuery,
    int? resultCount,
    Map<FladderItemType, List<ItemBaseModel>>? results,
  }) {
    return SearchModel(
      loading: loading ?? this.loading,
      searchQuery: searchQuery ?? this.searchQuery,
      resultCount: resultCount ?? this.resultCount,
      results: results ?? this.results,
    );
  }
}
