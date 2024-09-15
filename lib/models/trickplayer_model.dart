// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:fladder/models/items/chapters_model.dart';

class Bif {
  final String version;
  final List<int> widthResolutions;
  Bif({
    required this.version,
    required this.widthResolutions,
  });

  Bif copyWith({
    String? version,
    List<int>? widthResolutions,
  }) {
    return Bif(
      version: version ?? this.version,
      widthResolutions: widthResolutions ?? this.widthResolutions,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Version': version,
      'WidthResolutions': widthResolutions,
    };
  }

  factory Bif.fromMap(Map<String, dynamic> map) {
    return Bif(
      version: (map['Version'] ?? '') as String,
      widthResolutions: List<int>.from((map['WidthResolutions'] ?? const <int>[]) as List<dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory Bif.fromJson(String source) => Bif.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Bif(version: $version, widthResolutions: $widthResolutions)';

  @override
  bool operator ==(covariant Bif other) {
    if (identical(this, other)) return true;

    return other.version == version && listEquals(other.widthResolutions, widthResolutions);
  }

  @override
  int get hashCode => version.hashCode ^ widthResolutions.hashCode;
}

class BifUtil {
  static List<int> bifMagicNumbers = [0x89, 0x42, 0x49, 0x46, 0x0D, 0x0A, 0x1A, 0x0A];
  static const int supportedBifVersion = 0;

  static Future<BifData?> trickPlayDecode(Uint8List array, int width) async {
    Indexed8Array data = Indexed8Array(array);

    for (int b in bifMagicNumbers) {
      if (data.read() != b) {
        print('Attempted to read invalid bif file.');
        return null;
      }
    }

    int bifVersion = data.readInt32();
    if (bifVersion != supportedBifVersion) {
      print('Client only supports BIF v$supportedBifVersion but file is v$bifVersion');
      return null;
    }

    print('BIF version: $bifVersion');

    int bifImgCount = data.readInt32();
    if (bifImgCount <= 0) {
      print('BIF file contains no images.');
      return null;
    }

    print('BIF image count: $bifImgCount');

    int timestampMultiplier = data.readInt32();
    if (timestampMultiplier == 0) timestampMultiplier = 1000;

    data.addPosition(44); // Reserved

    List<BifIndexEntry> bifIndex = [];
    for (int i = 0; i < bifImgCount; i++) {
      bifIndex.add(BifIndexEntry(data.readInt32(), data.readInt32()));
    }

    List<Chapter> bifImages = [];
    for (int i = 0; i < bifIndex.length; i++) {
      BifIndexEntry indexEntry = bifIndex[i];
      int timestamp = indexEntry.timestamp;
      int offset = indexEntry.offset;
      int nextOffset = i + 1 < bifIndex.length ? bifIndex[i + 1].offset : data.limit();

      Uint8List imageBytes = Uint8List.sublistView(Uint8List.view(data.array.buffer, offset, nextOffset - offset));

      bifImages.add(
        Chapter(
          name: "",
          imageUrl: "",
          imageData: imageBytes,
          startPosition: Duration(milliseconds: timestamp * timestampMultiplier),
        ),
      );
    }
    return BifData(bifVersion, bifImgCount, bifImages, width);
  }
}

class Indexed8Array {
  Uint8List array;
  int readIndex;

  Indexed8Array(Uint8List byteArray)
      : array = byteArray,
        readIndex = 0;

  int read() {
    return array[readIndex++];
  }

  void addPosition(int amount) {
    readIndex += amount;
  }

  int readInt32() {
    int b1 = read() & 0xFF;
    int b2 = read() & 0xFF;
    int b3 = read() & 0xFF;
    int b4 = read() & 0xFF;

    return b1 | (b2 << 8) | (b3 << 16) | (b4 << 24);
  }

  Uint8List getByteArray() {
    return array;
  }

  int limit() {
    return array.length;
  }

  Endian order() {
    return Endian.big;
  }
}

class BifIndexEntry {
  int timestamp;
  int offset;

  BifIndexEntry(this.timestamp, this.offset);
}

class BifData {
  int bifVersion;
  int bifImgCount;
  List<Chapter> chapters;
  int width;

  BifData(
    this.bifVersion,
    this.bifImgCount,
    this.chapters,
    this.width,
  );
}
