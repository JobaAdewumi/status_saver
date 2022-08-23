import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:saf/saf.dart';

import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:share_plus/share_plus.dart';

import 'package:all_status_saver/routes/routes.dart' as route;
import 'package:permission_handler/permission_handler.dart';

import 'package:all_status_saver/views/permission.dart';

import 'package:all_status_saver/widgets/exit-popup.dart';

class FileType {
  final bool isImage;
  final File file;
  final DateTime? dateTime;

  FileType({
    this.isImage = false,
    required this.file,
    this.dateTime,
  });
}

class HomePage extends StatelessWidget {
  HomePage({super.key});

  Future<void> shareFile(String path) async {
    await Share.shareFiles([path]);
  }

  Saf safBusiness = Saf(
      '/storage/emulated/0/Android/media/com.whatsapp.w4b/WhatsApp Business/Media/.Statuses');

  List<Permission> permissionsNeeded = [
    Permission.storage,
    Permission.manageExternalStorage
  ];

  Future saveStatus(String oldPath) async {
    bool? savedFile;
    if (oldPath.contains('.jpg') ||
        oldPath.contains('.jpeg') ||
        oldPath.contains('.png')) {
      await GallerySaver.saveImage(oldPath,
              toDcim: true, albumName: 'All Status Saver')
          .then(
        (value) {
          savedFile = value;
        },
      );
    }

    if (oldPath.contains('.mp4')) {
      await GallerySaver.saveVideo(oldPath,
              toDcim: true, albumName: 'All Status Saver')
          .then(
        (value) {
          savedFile = value;
        },
      );
      return savedFile;
    }

    // if (!await directory.exists()) {
    //   await directory.create(recursive: true);
    // }

    // if (await directory.exists()) {
    //   File path = File(oldPath);
    //   savedFile = path.copySync(filePath);
    // }
    // return savedFile;
  }

  // Future saveStatus(String newPath, String oldPath, String filePath) async {
  //   Directory directory = Directory(newPath);
  //   late File savedFile;
  //   if (oldPath.contains('.jpg') ||
  //       oldPath.contains('.jpeg') ||
  //       oldPath.contains('.png')) {
  //     GallerySaver.saveImage(oldPath);
  //   }

  //   if (!await directory.exists()) {
  //     await directory.create(recursive: true);
  //   }

  //   if (await directory.exists()) {
  //     File path = File(oldPath);
  //     savedFile = path.copySync(filePath);
  //   }
  //   return savedFile;
  // }

  Future<Map<String, List<FileType>>> getFileTypes(
      String path, String secondaryPath) async {
    // String paths =
    //     '/storage/emulated/0/Android/media/com.whatsapp.w4b/WhatsApp Business/Media/.Statuses';
    // List<String>? paths = await safBusiness.getFilesPath();
    List<FileType> mapVideoFiles = [];
    List<FileType> mapImageFiles = [];
    List<FileType> mapAllFiles = [];

    if (await Directory(path).exists()) {
      // List<String>? paths = await safBusiness.getFilesPath();
      // //  List<FileSystemEntity> dirFiless = [];
      // List<FileSystemEntity> dirFiles = [];

      // for (var path in paths!) {
      //   dirFiles.add(Directory(path));
      // }

      final dirFiles = Directory(path)
          .listSync(recursive: false, followLinks: false)
          .toList();
      // final dirFiles = Directory(path)
      //     .listSync(recursive: false, followLinks: false)
      //     .toList();

      List<FileSystemEntity> videoFiles =
          dirFiles.where((f) => f.path.contains('.mp4')).toList();

      List<FileSystemEntity> imageFiles = dirFiles
          .where((f) =>
              f.path.contains('.jpg') ||
              f.path.contains('.jpeg') ||
              f.path.contains('.png'))
          .toList();

      for (FileSystemEntity fv in videoFiles) {
        if (mapVideoFiles.isEmpty) {
          mapVideoFiles.clear();
        }
        mapVideoFiles.add(FileType(
          file: File(fv.path),
          dateTime: (await fv.stat()).modified,
        ));
      }

      for (FileSystemEntity fv in imageFiles) {
        if (mapImageFiles.isEmpty) {
          mapImageFiles.clear();
        }
        mapImageFiles.add(FileType(
          file: File(fv.path),
          dateTime: (await fv.stat()).modified,
          isImage: true,
        ));
      }
      mapAllFiles = mapImageFiles + mapVideoFiles;

      mapImageFiles.sort(((a, b) => b.dateTime!.compareTo(a.dateTime!)));
      mapVideoFiles.sort(((a, b) => b.dateTime!.compareTo(a.dateTime!)));
      mapAllFiles.sort(((a, b) => b.dateTime!.compareTo(a.dateTime!)));
    }

    if (await Directory(secondaryPath).exists()) {
      final dirFiles = Directory(path)
          .listSync(recursive: false, followLinks: false)
          .toList();

      List<FileSystemEntity> videoFiles =
          dirFiles.where((f) => f.path.contains('.mp4')).toList();

      List<FileSystemEntity> imageFiles = dirFiles
          .where((f) =>
              f.path.contains('.jpg') ||
              f.path.contains('.jpeg') ||
              f.path.contains('.png'))
          .toList();

      for (FileSystemEntity fv in videoFiles) {
        if (mapVideoFiles.isEmpty) {
          mapVideoFiles.clear();
        }
        mapVideoFiles.add(FileType(
          file: File(fv.path),
          dateTime: (await fv.stat()).modified,
        ));
      }

      for (FileSystemEntity fv in imageFiles) {
        if (mapImageFiles.isEmpty) {
          mapImageFiles.clear();
        }
        mapImageFiles.add(FileType(
          file: File(fv.path),
          dateTime: (await fv.stat()).modified,
          isImage: true,
        ));
      }
      mapAllFiles = mapImageFiles + mapVideoFiles;

      mapImageFiles.sort(((a, b) => b.dateTime!.compareTo(a.dateTime!)));
      mapVideoFiles.sort(((a, b) => b.dateTime!.compareTo(a.dateTime!)));
      mapAllFiles.sort(((a, b) => b.dateTime!.compareTo(a.dateTime!)));
    }

    return {
      'images': mapImageFiles,
      'videos': mapVideoFiles,
      'all': mapAllFiles
    };
  }

  Future generateVideoThumbnail(File file) async {
    final unit8list = await VideoThumbnail.thumbnailData(
      video: file.path,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 128,
      quality: 100,
    );
    return unit8list;
  }

  Future deleteItem(File file) async {
    if (!await file.exists()) {
      await file.delete();
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => showExitPopup(context),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Status Saver'),
        ),
        drawer: Drawer(
          width: 280.0,
          child: ListView(
            children: [
              DrawerHeader(
                decoration:
                    BoxDecoration(color: Theme.of(context).colorScheme.primary),
                child: const FlutterLogo(),
              ),
              ListTile(
                leading: const Icon(Icons.whatsapp_rounded),
                title: const Text(' WA Status'),
                onTap: () async {
                  if (await requestPermission([Permission.storage])) {
                    Navigator.pushNamed(context, route.whatsAppPage);
                  } else {
                    return;
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.business),
                title: const Text('WB Status'),
                onTap: () async {
                  if (await requestPermission([Permission.storage])) {
                    Navigator.pushNamed(context, route.whatsappBPage);
                  } else {
                    return;
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.list),
                title: const Text('Saved Statuses'),
                onTap: () async {
                  if (await requestPermission([Permission.storage])) {
                    Navigator.pushNamed(context, route.savedStatusPage);
                  } else {
                    return;
                  }
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () {
                  Navigator.pushNamed(context, route.settingsP);
                },
              ),
            ],
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: GestureDetector(
                      onTap: () async {
                        if (await requestPermission([Permission.storage])) {
                          Navigator.pushNamed(context, route.whatsAppPage);
                        } else {
                          return;
                        }
                      },
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: const [
                              FlutterLogo(
                                size: 60.0,
                              ),
                              Text('WA STATUS'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: GestureDetector(
                      onTap: () async {
                        if (await requestPermission([Permission.storage])) {
                          Navigator.pushNamed(context, route.whatsappBPage);
                        } else {
                          return;
                        }
                      },
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: const [
                              FlutterLogo(
                                size: 60.0,
                              ),
                              Text('WB STATUS'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.save_alt_outlined),
                    onPressed: () async {
                      if (await requestPermission([Permission.storage])) {
                        Navigator.pushNamed(context, route.savedStatusPage);
                      } else {
                        return;
                      }
                    },
                    label: const Text('Saved Statuses'),
                  ),
                  // ElevatedButton.icon(
                  //   icon: const Icon(Icons.bug_report),
                  //   onPressed: () async {
                  //     if (await requestPermission(Permission.storage)) {
                  //       Navigator.pushNamed(context, route.introScreen);
                  //     } else {
                  //       return;
                  //     }
                  //   },
                  //   label: const Text('Intro Screen debug'),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
