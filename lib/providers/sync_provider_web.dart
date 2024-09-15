import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

class AbstractSyncNotifier {
  final Ref ref;
  final Isar? isar;
  final Directory mobileDirectory;
  final String subPath = "Synced";

  AbstractSyncNotifier(this.ref, this.isar, this.mobileDirectory);
}
