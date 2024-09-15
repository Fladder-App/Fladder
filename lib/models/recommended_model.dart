// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fladder/models/item_base_model.dart';

class RecommendedModel {
  final String name;
  final List<ItemBaseModel> posters;
  final String type;
  RecommendedModel({
    required this.name,
    required this.posters,
    required this.type,
  });

  RecommendedModel copyWith({
    String? name,
    List<ItemBaseModel>? posters,
    String? type,
  }) {
    return RecommendedModel(
      name: name ?? this.name,
      posters: posters ?? this.posters,
      type: type ?? this.type,
    );
  }
}
