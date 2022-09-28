import 'package:flutter/material.dart';

import 'package:saf/saf.dart';
import 'package:device_info_plus/device_info_plus.dart';

import 'package:permission_handler/permission_handler.dart';

import 'package:all_status_saver/routes/routes.dart' as route;

// Saf safBusiness = Saf('/storage/emulated/0/Android/media/');

Saf saf = Saf('/storage/emulated/0/Android/media/');
Saf savedStatuses = Saf('/storage/emulated/0/Pictures/All Status Saver/');

List<String>? directoriesPaths;

List<String>? savedStatusesPath;
bool? aboveAndroid10;

late bool dialogForStoragePermissionGranted;
bool dialogForAndroid11Granted = false;

class Android11PermissionDialog extends StatelessWidget {
  const Android11PermissionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Permission'),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 20.0, bottom: 50.0),
            child: Icon(
              Icons.folder_outlined,
              size: 200.0,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 10.0, right: 10.0),
            child: Text(
              'Starting Android 11 (Android R), \n All Status Saver can no longer access Statuses easily due to Android Storage limitations.\n',
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 10.0, right: 10.0),
            child: Text(
              'To access Statuses again, certain additional steps are required to be followed from your end. These are ony required to be performed once. \n',
            ),
          ),
          const Text(
            'Follow below steps:\n',
          ),
          const Text(
            "1: Enable 'Show Internal Storage' if you cannot see your Primary Storage.\n",
          ),
          const Text(
              '2: Select your Phones Primary Storage from the left drawer.\n'),
          const Text("3: Go to 'Android/media' folder\n"),
          const Text("4: Select the directory and it's done!\n"),
          const Padding(
            padding: EdgeInsets.only(left: 10.0, right: 10.0),
            child: Text(
                'Note: if the folder is already opened on the next screen, just allow the access to the same.\n'),
          ),
          ElevatedButton(
            onPressed: () {
              dialogForAndroid11Granted = true;
              Navigator.popAndPushNamed(context, route.homePage);
              requestPermission11(context);
            },
            child: Text(
              'Grant Folder permission',
              style: TextStyle(
                  color: Theme.of(context).textTheme.bodySmall?.color),
            ),
          ),
        ],
      ),
    );
  }
}

Future showDialogForStoragePermission(context) {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return AlertDialog(
        title: const Text('Storage Permission'),
        content: const Text(
            'The App needs Storage related Permissions to work Properly.\n (Example: Saving Statuses) \n\n Please Grant the Permission'),
        actions: [
          TextButton(
            onPressed: () {
              dialogForStoragePermissionGranted = false;
              Navigator.popAndPushNamed(context, route.homePage);
            },
            child: const Text('Exit'),
          ),
          TextButton(
            onPressed: () {
              dialogForStoragePermissionGranted = true;
              Navigator.popAndPushNamed(context, route.homePage);
            },
            child: const Text('Grant'),
          ),
        ],
      );
    },
  );
}

Future<bool> requestPermission11(context) async {
  bool normalStorage = await requestPermission([Permission.storage], context);
  directoriesPaths = await Saf.getPersistedPermissionDirectories();
  // if (directoriesPaths.isEmpty) {}
  if (directoriesPaths == null && directoriesPaths!.isNotEmpty) {
    if (directoriesPaths![0] == 'Android/media' && normalStorage) {
      return true;
    }
  }
  // print(safBusiness.);

  late bool? isGranted;

  if (!dialogForAndroid11Granted) {
    if (!normalStorage) {
      return false;
    }

    if (normalStorage) {
      Navigator.popAndPushNamed(context, route.android11Screen);
    }
    return false;
  }

  isGranted = await saf.getDirectoryPermission(isDynamic: true);

  if (isGranted != null && isGranted) {
    directoriesPaths = await Saf.getPersistedPermissionDirectories();
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
    // var trial = await getExternalStorageDirectories();

    return true;
  } else {
    return false;
  }
}

Future<bool> requestPermission(List<Permission> permissions, context) async {
  for (var permission in permissions) {
    if (await permission.isGranted) {
      return true;
    } else {
      await showDialogForStoragePermission(context);
      print(dialogForStoragePermissionGranted);
      if (dialogForStoragePermissionGranted) {
        var result = await permission.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
        return false;
      }
    }
    return false;
  }
  return false;
}
