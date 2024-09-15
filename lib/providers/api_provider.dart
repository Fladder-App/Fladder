import 'dart:developer';

import 'package:chopper/chopper.dart';
import 'package:fladder/jellyfin/jellyfin_open_api.swagger.dart';
import 'package:fladder/providers/auth_provider.dart';
import 'package:fladder/providers/service_provider.dart';
import 'package:fladder/providers/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'api_provider.g.dart';

@riverpod
class JellyApi extends _$JellyApi {
  @override
  JellyService build() {
    return JellyService(
        ref,
        JellyfinOpenApi.create(
          interceptors: [
            JellyRequest(ref),
            JellyResponse(ref),
            HttpLoggingInterceptor(level: Level.basic),
          ],
        ));
  }
}

class JellyRequest implements RequestInterceptor {
  JellyRequest(this.ref);

  final Ref ref;

  @override
  FutureOr<Request> onRequest(Request request) async {
    if (request.method == HttpMethod.Post) {
      chopperLogger.info('Performed a POST request');
    }

    final serverUrl = Uri.parse(ref.read(userProvider)?.server ?? ref.read(authProvider).tempCredentials.server);

    //Use current logged in user otherwise use the authprovider
    var loginModel = ref.read(userProvider)?.credentials ?? ref.read(authProvider).tempCredentials;
    var headers = loginModel.header(ref);

    return request.copyWith(
      baseUri: serverUrl,
      headers: request.headers..addAll(headers),
    );
  }
}

class JellyResponse implements ResponseInterceptor {
  JellyResponse(this.ref);

  final Ref ref;

  @override
  FutureOr<Response<dynamic>> onResponse(Response<dynamic> response) {
    if (!response.isSuccessful) {
      log('x- ${response.base.statusCode} - ${response.base.reasonPhrase} - ${response.error} - ${response.base.request?.method} ${response.base.request?.url.toString()}');
    }
    if (response.statusCode == 404) {
      chopperLogger.severe('404 NOT FOUND');
    }

    if (response.statusCode == 401) {
      // ref.read(sharedUtilityProvider).removeAccount(ref.read(userProvider));
    }

    return response;
  }
}
