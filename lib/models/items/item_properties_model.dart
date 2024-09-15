import 'package:fladder/jellyfin/jellyfin_open_api.swagger.dart' as dto;
import 'package:freezed_annotation/freezed_annotation.dart';

part 'item_properties_model.freezed.dart';

@Freezed(fromJson: false, toJson: false)
class ItemPropertiesModel with _$ItemPropertiesModel {
  const ItemPropertiesModel._();

  factory ItemPropertiesModel._internal({
    required bool canDelete,
    required bool canDownload,
  }) = _ItemPropertiesModel;

  factory ItemPropertiesModel.fromBaseDto(dto.BaseItemDto dtoItem) {
    return ItemPropertiesModel._internal(
      canDelete: dtoItem.canDelete ?? false,
      canDownload: dtoItem.canDownload ?? false,
    );
  }
}
