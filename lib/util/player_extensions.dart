import 'package:collection/collection.dart';
import 'package:fladder/models/items/media_streams_model.dart';
import 'package:media_kit/media_kit.dart';
import 'dart:io' show Platform;

extension PlayerExtensions on Player {
  Future<void> addSubtitles(List<SubStreamModel> subtitles) async {
    final separator = Platform.isWindows ? ";" : ":";
    await (platform as NativePlayer).setProperty(
      "sub-files",
      subtitles
          .mapIndexed((index, e) => "${Platform.isWindows ? e.url : e.url?.replaceFirst(":", "\\:")}@${e.displayTitle}")
          .join(separator),
    );
  }
}
