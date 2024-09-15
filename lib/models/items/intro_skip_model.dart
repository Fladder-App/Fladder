// ignore_for_file: public_member_api_docs, sort_constructors_first, invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'intro_skip_model.freezed.dart';
part 'intro_skip_model.g.dart';

@freezed
class IntroOutSkipModel with _$IntroOutSkipModel {
  const IntroOutSkipModel._();
  factory IntroOutSkipModel({
    IntroSkipModel? intro,
    IntroSkipModel? credits,
  }) = _IntroOutSkipModel;

  factory IntroOutSkipModel.fromJson(Map<String, dynamic> json) => _$IntroOutSkipModelFromJson(json);

  bool introInRange(Duration position) {
    if (intro == null) return false;
    return (position.compareTo(intro!.showTime) >= 0 && position.compareTo(intro!.hideTime) <= 0);
  }

  bool creditsInRange(Duration position) {
    if (credits == null) return false;
    return (position.compareTo(credits!.showTime) >= 0 && position.compareTo(credits!.hideTime) <= 0);
  }
}

@freezed
class IntroSkipModel with _$IntroSkipModel {
  factory IntroSkipModel({
    @JsonKey(name: "EpisodeId") required String id,
    @JsonKey(name: "Valid") required bool valid,
    @JsonKey(name: "IntroStart", fromJson: _durationFromMilliseconds, toJson: _durationToMilliseconds)
    required Duration start,
    @JsonKey(name: "IntroEnd", fromJson: _durationFromMilliseconds, toJson: _durationToMilliseconds)
    required Duration end,
    @JsonKey(name: "ShowSkipPromptAt", fromJson: _durationFromMilliseconds, toJson: _durationToMilliseconds)
    required Duration showTime,
    @JsonKey(name: "HideSkipPromptAt", fromJson: _durationFromMilliseconds, toJson: _durationToMilliseconds)
    required Duration hideTime,
  }) = _IntroSkipModel;

  factory IntroSkipModel.fromJson(Map<String, dynamic> json) => _$IntroSkipModelFromJson(json);
}

Duration _durationFromMilliseconds(num milliseconds) => Duration(milliseconds: (milliseconds * 1000).toInt());
num _durationToMilliseconds(Duration duration) => duration.inMilliseconds.toDouble() / 1000.0;
