import 'package:media_kit/media_kit.dart';
import 'package:validators/validators.dart';
import 'string_extensions.dart';

extension SubtitleExtension on SubtitleTrack {
  String get cleanName {
    final names = {
      id,
      title,
    };
    return names
        .where((element) => element != null)
        .map((e) {
          if (e == null) return e;
          if (isNumeric(e)) return '';
          if (e == "no") {
            return "Off";
          }
          return e.capitalize();
        })
        .where((element) => element != null && element.isNotEmpty)
        .join(" - ");
  }
}

extension AudioTrackExtension on AudioTrack {
  String get cleanName {
    final names = {
      id,
      title,
    };
    return names
        .where((element) => element != null)
        .map((e) {
          if (e == null) return e;
          if (isNumeric(e)) return '';
          if (e == "no") {
            return "Off";
          }
          return e.capitalize();
        })
        .where((element) => element != null && element.isNotEmpty)
        .join(" - ");
  }
}
