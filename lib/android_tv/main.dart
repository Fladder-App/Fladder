import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:media_kit/media_kit.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fladder/providers/shared_provider.dart';
import 'package:fladder/util/application_info.dart';
import 'package:fladder/util/string_extensions.dart';

void main() async {
  _setupLogging();
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();

  final sharedPreferences = await SharedPreferences.getInstance();

  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWith((ref) => sharedPreferences),
        applicationInfoProvider.overrideWith(
          (ref) => ApplicationInfo(
            name: packageInfo.appName,
            buildNumber: packageInfo.buildNumber,
            version: packageInfo.version,
            os: defaultTargetPlatform.name.capitalize(),
          ),
        ),
      ],
      child: const Main(),
    ),
  );
}

void _setupLogging() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((rec) {
    if (kDebugMode) {
      print('${rec.level.name}: ${rec.time}: ${rec.message}');
    }
  });
}

class Main extends ConsumerWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(child: Text("AndroidTV")),
      ),
    );
  }
}
