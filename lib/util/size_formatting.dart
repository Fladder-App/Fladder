// ignore_for_file: constant_identifier_names

extension IntExtension on int? {
  String? get byteFormat {
    final bytes = this;
    if (bytes == null) return null;
    if (bytes == 0) return "- bytes";
    const int KB = 1024;
    const int MB = KB * KB;
    const int GB = MB * KB;

    if (bytes >= GB) {
      return '${(bytes / GB).toStringAsFixed(2)} GB';
    } else if (bytes >= MB) {
      return '${(bytes / MB).toStringAsFixed(2)} MB';
    } else if (bytes >= KB) {
      return '${(bytes / KB).toStringAsFixed(2)} KB';
    } else {
      return '$bytes Bytes';
    }
  }
}
