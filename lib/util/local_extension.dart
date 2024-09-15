import 'package:flutter/material.dart';

extension LocalExtensions on Locale {
  String label() {
    return switch (languageCode) {
      "nl" => "Nederlands",
      "zh" => "简体中文",
      "es" => "Español",
      "fr" => "Français",
      "ja" => "日本語 (にほんご)",
      "en" || _ => "English",
    };
  }
}
