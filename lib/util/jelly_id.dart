// ignore: depend_on_referenced_packages
import 'package:uuid/uuid.dart';

String get jellyId {
  var uuid = const Uuid();
  var guid = uuid.v4().replaceAll('-', ''); // Remove hyphens
  return guid.substring(0, 32); // Take only the first 32 characters
}
