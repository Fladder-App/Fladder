// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'intro_skip_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$IntroOutSkipModelImpl _$$IntroOutSkipModelImplFromJson(
        Map<String, dynamic> json) =>
    _$IntroOutSkipModelImpl(
      intro: json['intro'] == null
          ? null
          : IntroSkipModel.fromJson(json['intro'] as Map<String, dynamic>),
      credits: json['credits'] == null
          ? null
          : IntroSkipModel.fromJson(json['credits'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$IntroOutSkipModelImplToJson(
        _$IntroOutSkipModelImpl instance) =>
    <String, dynamic>{
      'intro': instance.intro,
      'credits': instance.credits,
    };

_$IntroSkipModelImpl _$$IntroSkipModelImplFromJson(Map<String, dynamic> json) =>
    _$IntroSkipModelImpl(
      id: json['EpisodeId'] as String,
      valid: json['Valid'] as bool,
      start: _durationFromMilliseconds(json['IntroStart'] as num),
      end: _durationFromMilliseconds(json['IntroEnd'] as num),
      showTime: _durationFromMilliseconds(json['ShowSkipPromptAt'] as num),
      hideTime: _durationFromMilliseconds(json['HideSkipPromptAt'] as num),
    );

Map<String, dynamic> _$$IntroSkipModelImplToJson(
        _$IntroSkipModelImpl instance) =>
    <String, dynamic>{
      'EpisodeId': instance.id,
      'Valid': instance.valid,
      'IntroStart': _durationToMilliseconds(instance.start),
      'IntroEnd': _durationToMilliseconds(instance.end),
      'ShowSkipPromptAt': _durationToMilliseconds(instance.showTime),
      'HideSkipPromptAt': _durationToMilliseconds(instance.hideTime),
    };
