// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class VideoPlayerSettingsModel {
  final double? screenBrightness;
  final BoxFit videoFit;
  final bool fillScreen;
  final bool hardwareAccel;
  final bool useLibass;
  final double internalVolume;
  final String? audioDevice;
  const VideoPlayerSettingsModel({
    this.screenBrightness,
    this.videoFit = BoxFit.contain,
    this.fillScreen = false,
    this.hardwareAccel = true,
    this.useLibass = false,
    this.internalVolume = 100,
    this.audioDevice,
  });

  double get volume => switch (defaultTargetPlatform) {
        TargetPlatform.android || TargetPlatform.iOS => 100,
        _ => internalVolume,
      };

  VideoPlayerSettingsModel copyWith({
    ValueGetter<double?>? screenBrightness,
    BoxFit? videoFit,
    bool? fillScreen,
    bool? hardwareAccel,
    bool? useLibass,
    double? internalVolume,
    ValueGetter<String?>? audioDevice,
  }) {
    return VideoPlayerSettingsModel(
      screenBrightness: screenBrightness != null ? screenBrightness() : this.screenBrightness,
      videoFit: videoFit ?? this.videoFit,
      fillScreen: fillScreen ?? this.fillScreen,
      hardwareAccel: hardwareAccel ?? this.hardwareAccel,
      useLibass: useLibass ?? this.useLibass,
      internalVolume: internalVolume ?? this.internalVolume,
      audioDevice: audioDevice != null ? audioDevice() : this.audioDevice,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'screenBrightness': screenBrightness,
      'videoFit': videoFit.name,
      'fillScreen': fillScreen,
      'hardwareAccel': hardwareAccel,
      'useLibass': useLibass,
      'internalVolume': internalVolume,
      'audioDevice': audioDevice,
    };
  }

  factory VideoPlayerSettingsModel.fromMap(Map<String, dynamic> map) {
    return VideoPlayerSettingsModel(
      screenBrightness: map['screenBrightness']?.toDouble(),
      videoFit: BoxFit.values.firstWhereOrNull((element) => element.name == map['videoFit']) ?? BoxFit.contain,
      fillScreen: map['fillScreen'] ?? false,
      hardwareAccel: map['hardwareAccel'] ?? false,
      useLibass: map['useLibass'] ?? false,
      internalVolume: map['internalVolume']?.toDouble() ?? 0.0,
      audioDevice: map['audioDevice'],
    );
  }

  String toJson() => json.encode(toMap());

  factory VideoPlayerSettingsModel.fromJson(String source) => VideoPlayerSettingsModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'VideoPlayerSettingsModel(screenBrightness: $screenBrightness, videoFit: $videoFit, fillScreen: $fillScreen, hardwareAccel: $hardwareAccel, useLibass: $useLibass, internalVolume: $internalVolume, audioDevice: $audioDevice)';
  }

  bool playerSame(VideoPlayerSettingsModel other) {
    return other.hardwareAccel == hardwareAccel && other.useLibass == useLibass;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is VideoPlayerSettingsModel &&
        other.screenBrightness == screenBrightness &&
        other.videoFit == videoFit &&
        other.fillScreen == fillScreen &&
        other.hardwareAccel == hardwareAccel &&
        other.useLibass == useLibass &&
        other.internalVolume == internalVolume &&
        other.audioDevice == audioDevice;
  }

  @override
  int get hashCode {
    return screenBrightness.hashCode ^
        videoFit.hashCode ^
        fillScreen.hashCode ^
        hardwareAccel.hashCode ^
        useLibass.hashCode ^
        internalVolume.hashCode ^
        audioDevice.hashCode;
  }
}
