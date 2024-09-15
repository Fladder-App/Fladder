// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SyncItemImpl _$$SyncItemImplFromJson(Map<String, dynamic> json) =>
    _$SyncItemImpl(
      id: json['id'] as String,
      parentId: json['parentId'] as String?,
      userId: json['userId'] as String,
      path: json['path'] as String?,
      markedForDelete: json['markedForDelete'] as bool? ?? false,
      sortKey: (json['sortKey'] as num?)?.toInt(),
      fileSize: (json['fileSize'] as num?)?.toInt(),
      videoFileName: json['videoFileName'] as String?,
      introOutSkipModel: json['introOutSkipModel'] == null
          ? null
          : IntroOutSkipModel.fromJson(
              json['introOutSkipModel'] as Map<String, dynamic>),
      fTrickPlayModel: json['fTrickPlayModel'] == null
          ? null
          : TrickPlayModel.fromJson(
              json['fTrickPlayModel'] as Map<String, dynamic>),
      fImages: json['fImages'] == null
          ? null
          : ImagesData.fromJson(json['fImages'] as String),
      fChapters: (json['fChapters'] as List<dynamic>?)
              ?.map((e) => Chapter.fromJson(e as String))
              .toList() ??
          const [],
      subtitles: (json['subtitles'] as List<dynamic>?)
              ?.map((e) => SubStreamModel.fromJson(e as String))
              .toList() ??
          const [],
      userData: _$JsonConverterFromJson<String, UserData>(
          json['userData'], const UserDataJsonSerializer().fromJson),
    );

Map<String, dynamic> _$$SyncItemImplToJson(_$SyncItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'parentId': instance.parentId,
      'userId': instance.userId,
      'path': instance.path,
      'markedForDelete': instance.markedForDelete,
      'sortKey': instance.sortKey,
      'fileSize': instance.fileSize,
      'videoFileName': instance.videoFileName,
      'introOutSkipModel': instance.introOutSkipModel,
      'fTrickPlayModel': instance.fTrickPlayModel,
      'fImages': instance.fImages,
      'fChapters': instance.fChapters,
      'subtitles': instance.subtitles,
      'userData': _$JsonConverterToJson<String, UserData>(
          instance.userData, const UserDataJsonSerializer().toJson),
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
