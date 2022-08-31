import 'package:device_info_plus/device_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:saf/saf.dart';

import 'package:shared_storage/media_store.dart' as mediaStore;

// Saf safBusiness = Saf('/storage/emulated/0/Android/media/');

Saf saf = Saf('/storage/emulated/0/Android/media/');
Saf savedStatuses = Saf('/storage/emulated/0/DCIM/All Status Saver/');

List<String>? directoriesPaths;

List<String>? savedStatusesPath;
late bool aboveAndroid10;

Future<bool> requestPermission11() async {
  // print(safBusiness.);

  late bool? isGranted;

  isGranted = await saf.getDirectoryPermission(isDynamic: true);
  print('value for android 11 function');
  print(isGranted);

  if (isGranted != null && isGranted) {
    directoriesPaths = await Saf.getPersistedPermissionDirectories();
    var trial = await mediaStore
        .getMediaStoreContentDirectory(mediaStore.MediaStoreCollection.images);
    print(trial);
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    if (androidInfo.version.sdkInt! >= 30) {
      aboveAndroid10 = true;
    } else {
      aboveAndroid10 = false;
    }
    print(androidInfo.version.sdkInt);
    return true;
  } else {
    return false;
  }
}

Future<bool> requestPermissionForSavedStatus() async {
  // print(safBusiness.);

  late bool? isGranted;

  isGranted = await savedStatuses.getDirectoryPermission(isDynamic: false);

  if (isGranted != null && isGranted) {
    savedStatusesPath = await savedStatuses.getFilesPath();
    var trial = await getExternalStorageDirectories();
    print('saved statuses');
    print(savedStatusesPath);
    print(trial);
    return true;
  } else {
    return false;
  }
}

// Future<bool> requestPermission11(bool isWhatsAppBusiness) async {
//   // print(safBusiness.);

//   late bool? isBusinessGranted;
//   late bool? isGranted;
//   if (isWhatsAppBusiness) {
//     isBusinessGranted =
//         await safBusiness.getDirectoryPermission(isDynamic: true);
//     // List<String>? paths = await safBusiness.getFilesPath();
//     // print('hi');
//     // print(paths);
//   } else {
//     isGranted = await saf.getDirectoryPermission(isDynamic: false);
//   }

//   if (isWhatsAppBusiness && isBusinessGranted != null && isBusinessGranted) {
//     return true;
//   } else if (!isWhatsAppBusiness && isGranted != null && isGranted) {
//     return true;
//   } else {
//     return false;
//   }
// }

Future<bool> requestPermission(List<Permission> permissions) async {
  for (var permission in permissions) {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }
  return false;
}
