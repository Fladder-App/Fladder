import 'dart:convert';
import 'dart:typed_data';

import 'package:chopper/chopper.dart';
import 'package:fladder/jellyfin/jellyfin_open_api.swagger.dart';

extension JellyApiExtension on JellyfinOpenApi {
  Future<Response<dynamic>?> itemIdImagesImageTypePost(
    ImageType type,
    String itemId,
    Uint8List data,
  ) async {
    final client = this.client;
    final uri = Uri.parse('/Items/$itemId/Images/${type.value}');
    final response = await client.send(
      Request(
        'POST',
        uri,
        this.client.baseUrl,
        body: base64Encode(data),
        headers: {
          'Content-Type': 'image/*',
        },
      ),
    );
    return response;
  }
}
