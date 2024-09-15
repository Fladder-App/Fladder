// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fladder/jellyfin/jellyfin_open_api.enums.swagger.dart' as enums;
import 'package:fladder/models/item_base_model.dart';
import 'package:fladder/models/items/photos_model.dart';
import 'package:fladder/models/recommended_model.dart';

class LibraryModel {
  final bool loading;
  final String id;
  final String name;
  final List<PhotoModel> timelinePhotos;
  final List<ItemBaseModel> posters;
  final List<RecommendedModel> recommendations;
  final List<String> genres;
  final List<ItemBaseModel> latest;
  final List<ItemBaseModel> nextUp;
  final List<ItemBaseModel> favourites;
  final enums.BaseItemKind type;

  LibraryModel({
    this.loading = false,
    required this.id,
    required this.name,
    this.timelinePhotos = const [],
    this.posters = const [],
    this.recommendations = const [],
    this.genres = const [],
    this.latest = const [],
    this.nextUp = const [],
    this.favourites = const [],
    required this.type,
  });

  LibraryModel copyWith({
    bool? loading,
    String? id,
    String? name,
    List<PhotoModel>? timelinePhotos,
    List<ItemBaseModel>? posters,
    List<RecommendedModel>? recommendations,
    List<String>? genres,
    List<ItemBaseModel>? latest,
    List<ItemBaseModel>? nextUp,
    List<ItemBaseModel>? favourites,
    enums.BaseItemKind? type,
  }) {
    return LibraryModel(
      loading: loading ?? this.loading,
      id: id ?? this.id,
      name: name ?? this.name,
      timelinePhotos: timelinePhotos ?? this.timelinePhotos,
      posters: posters ?? this.posters,
      recommendations: recommendations ?? this.recommendations,
      genres: genres ?? this.genres,
      latest: latest ?? this.latest,
      nextUp: nextUp ?? this.nextUp,
      favourites: favourites ?? this.favourites,
      type: type ?? this.type,
    );
  }
}
