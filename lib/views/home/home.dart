import 'dart:io';
import 'package:flutter/material.dart';

import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:share_plus/share_plus.dart';

import 'package:all_status_saver/routes/routes.dart' as route;
import 'package:permission_handler/permission_handler.dart';

import 'package:all_status_saver/views/permission.dart';

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
  const HomePage({super.key});

  Future<void> shareFile(String path) async {
    await Share.shareFiles([path]);
  }

  Future saveStatus(String newPath, String oldPath, String filePath) async {
    Directory directory = Directory(newPath);
    late File savedFile;

    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    if (await directory.exists()) {
      File path = File(oldPath);
      savedFile = path.copySync(filePath);
    }
    return savedFile;
  }

  Future<Map<String, List<FileType>>> getFileTypes(String path) async {
    List<FileType> mapVideoFiles = [];
    List<FileType> mapImageFiles = [];
    List<FileType> mapAllFiles = [];

    if (await Directory(path).exists()) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Status Saver'),
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () async {
                      if (await requestPermission(Permission.storage)) {
                        Navigator.pushNamed(context, route.whatsAppPage);
                      } else {
                        return;
                      }
                    },
                    child: Card(
                      child: Column(
                        children: const [
                          FlutterLogo(
                            size: 60.0,
                          ),
                          Text('WhatsApp'),
                        ],
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      if (await requestPermission(Permission.storage)) {
                        Navigator.pushNamed(context, route.whatsappBPage);
                      } else {
                        return;
                      }
                    },
                    child: Card(
                      child: Column(
                        children: const [
                          FlutterLogo(
                            size: 60.0,
                          ),
                          Text('WhatsApp Business'),
                        ],
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
                      if (await requestPermission(Permission.storage)) {
                        Navigator.pushNamed(context, route.savedStatusPage);
                      } else {
                        return;
                      }
                    },
                    label: const Text('Saved Statuses'),
                  ),
                ],
              )
            ]),
      ),
    );
  }
}
