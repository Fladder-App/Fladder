import 'package:fladder/util/application_info.dart';
import 'package:xid/xid.dart';

Map<String, String> generateHeader(ApplicationInfo application) {
  var xid = Xid();
  return {
    'content-type': 'application/json',
    'x-emby-authorization':
        'MediaBrowser Client="${application.name}", Device="${application.os}", DeviceId="$xid", Version="${application.version}"',
  };
}
