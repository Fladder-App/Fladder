// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_riverpod/flutter_riverpod.dart';

final applicationInfoProvider = StateProvider<ApplicationInfo>((ref) {
  return ApplicationInfo(
    name: "",
    version: "",
    os: "",
  );
});

class ApplicationInfo {
  final String name;
  final String version;
  final String os;
  ApplicationInfo({
    required this.name,
    required this.version,
    required this.os,
  });

  ApplicationInfo copyWith({
    String? name,
    String? version,
    String? os,
  }) {
    return ApplicationInfo(
      name: name ?? this.name,
      version: version ?? this.version,
      os: os ?? this.os,
    );
  }

  String get versionAndPlatform => "$version ($os)";

  @override
  String toString() => 'ApplicationInfo(name: $name, version: $version, os: $os)';
}
