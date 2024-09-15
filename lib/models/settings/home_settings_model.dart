import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:fladder/util/localization_helper.dart';
import 'package:flutter/material.dart';

enum HomeCarouselSettings {
  off,
  nextUp,
  cont,
  combined,
  ;

  const HomeCarouselSettings();

  String label(BuildContext context) => switch (this) {
        HomeCarouselSettings.off => context.localized.hide,
        HomeCarouselSettings.nextUp => context.localized.nextUp,
        HomeCarouselSettings.cont => context.localized.settingsContinue,
        HomeCarouselSettings.combined => context.localized.combined,
      };

  String toMap() {
    return toString();
  }

  static HomeCarouselSettings fromMap(String value) {
    return HomeCarouselSettings.values.firstWhereOrNull((element) => element.name == value) ??
        HomeCarouselSettings.combined;
  }
}

enum HomeNextUp {
  off,
  nextUp,
  cont,
  combined,
  separate,
  ;

  const HomeNextUp();

  String label(BuildContext context) => switch (this) {
        HomeNextUp.off => context.localized.hide,
        HomeNextUp.nextUp => context.localized.nextUp,
        HomeNextUp.cont => context.localized.settingsContinue,
        HomeNextUp.combined => context.localized.combined,
        HomeNextUp.separate => context.localized.separate,
      };

  String toMap() {
    return toString();
  }

  static HomeNextUp fromMap(String value) {
    return HomeNextUp.values.firstWhereOrNull((element) => element.name == value) ?? HomeNextUp.separate;
  }
}

class HomeSettingsModel {
  final HomeCarouselSettings carouselSettings;
  final HomeNextUp nextUp;
  HomeSettingsModel({
    this.carouselSettings = HomeCarouselSettings.combined,
    this.nextUp = HomeNextUp.separate,
  });

  HomeSettingsModel copyWith({
    HomeCarouselSettings? carouselSettings,
    HomeNextUp? nextUp,
  }) {
    return HomeSettingsModel(
      carouselSettings: carouselSettings ?? this.carouselSettings,
      nextUp: nextUp ?? this.nextUp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'carouselSettings': carouselSettings.toMap(),
      'nextUp': nextUp.toMap(),
    };
  }

  factory HomeSettingsModel.fromMap(Map<String, dynamic> map) {
    return HomeSettingsModel(
      carouselSettings: HomeCarouselSettings.fromMap(map['carouselSettings']),
      nextUp: HomeNextUp.fromMap(map['nextUp']),
    );
  }

  String toJson() => json.encode(toMap());

  factory HomeSettingsModel.fromJson(String source) => HomeSettingsModel.fromMap(json.decode(source));

  @override
  String toString() => 'HomeSettingsModel(carouselSettings: $carouselSettings, nextUp: $nextUp)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is HomeSettingsModel && other.carouselSettings == carouselSettings && other.nextUp == nextUp;
  }

  @override
  int get hashCode => carouselSettings.hashCode ^ nextUp.hashCode;
}
