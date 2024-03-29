import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path/path.dart' as path;
import 'package:share_plus/share_plus.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class FileType {
  final bool isImage;
  final File file;
  final DateTime? dateTime;
  final Uint8List? videoThumbnail;

  FileType({
    this.isImage = false,
    required this.file,
    this.dateTime,
    this.videoThumbnail,
  });
}

class GlobalFunctions {
  // static const _channel = MethodChannel('all_status_saver');

  // Future retrieveStatuses({required String path}) async {
  //   await _channel.invokeMethod('retrieveStatuses', {'path': path});
  // }

  Future<void> shareFile(String path) async {
    await Share.shareFiles([path]);
  }

  Future<void> shareMultipleFile(List<String> paths) async {
    await Share.shareFiles(paths);
  }

  Widget noStatusError(bool isWhatsApp, bool isStatusPage) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        isWhatsApp
            ? const Text(
                'No Status Found, You have to watch stories on WhatsApp to make them appear here',
                textAlign: TextAlign.center)
            : isStatusPage
                ? const Text(
                    'No Status Found, You have to watch stories on WhatsApp Business or WhatsApp to make them appear here',
                    textAlign: TextAlign.center)
                : const Text(
                    'No Status Found, You have to watch stories on WhatsApp Business to make them appear here',
                    textAlign: TextAlign.center),
        ElevatedButton.icon(
          onPressed: null,
          icon: const Icon(Icons.launch_rounded),
          label: isWhatsApp
              ? const Text('OPEN WHATSAPP')
              : isStatusPage
                  ? const Text('OPEN PLAY STORE')
                  : const Text('OPEN WHATSAPP BUSINESS'),
        ),
      ],
    );
  }

  saveStatus(String statusPath, BuildContext context) async {
    await realSaveStatus(statusPath).then(
      (value) {
        bool check = value == null
            ? false
            : value == true
                ? true
                : false;
        if (check) {
          return ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Status was saved successfully',
                style: TextStyle(color: Colors.white),
              ),
              behavior: SnackBarBehavior.floating,
              elevation: 1,
              dismissDirection: DismissDirection.horizontal,
              duration: Duration(milliseconds: 400),
            ),
          );
        } else {
          return ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Error Saving Status',
                style: TextStyle(color: Colors.white),
              ),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.redAccent,
              elevation: 1,
              dismissDirection: DismissDirection.horizontal,
              duration: Duration(milliseconds: 400),
            ),
          );
        }
      },
    );
  }

  saveMultipleStatuses(List statuses, BuildContext context) async {
    int successfullySaved = 0;
    int failedSaved = 0;
    for (var statusPath in statuses) {
      await realSaveStatus(statusPath.path).then(
        (value) {
          bool check = value == null
              ? false
              : value == true
                  ? true
                  : false;
          if (check) {
            successfullySaved = successfullySaved + 1;
          } else {
            failedSaved = failedSaved + 1;
          }
        },
      );
    }

    if (successfullySaved >= 1 && failedSaved == 0) {
      return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            successfullySaved == 1
                ? '$successfullySaved Status was saved successfully'
                : '$successfullySaved Statuses were saved successfully',
            style: const TextStyle(color: Colors.white),
          ),
          behavior: SnackBarBehavior.floating,
          elevation: 1,
          dismissDirection: DismissDirection.horizontal,
          duration: const Duration(milliseconds: 400),
        ),
      );
    }

    if (failedSaved >= 1 && successfullySaved == 0) {
      return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            failedSaved == 1
                ? '$failedSaved Status failed to save'
                : '$failedSaved Statuses failed to save',
            style: const TextStyle(color: Colors.white),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.redAccent,
          elevation: 1,
          dismissDirection: DismissDirection.horizontal,
          duration: const Duration(milliseconds: 400),
        ),
      );
    }

    if (failedSaved >= 1 && successfullySaved >= 1) {
      return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            failedSaved == 1 && successfullySaved == 1
                ? '$successfullySaved Status saved successfully and $failedSaved failed to save'
                : '$successfullySaved Statuses saved successfully and $failedSaved failed to save',
            style: const TextStyle(color: Colors.white),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.yellowAccent,
          elevation: 1,
          dismissDirection: DismissDirection.horizontal,
          duration: const Duration(milliseconds: 400),
        ),
      );
    }
  }

  Future<bool?> realSaveStatus(String oldPath) async {
    late bool? savedFile;
    if (oldPath.contains('.jpg') ||
        oldPath.contains('.jpeg') ||
        oldPath.contains('.png')) {
      await GallerySaver.saveImage(oldPath,
              toDcim: true, albumName: 'All Status Saver')
          .then(
        (value) {
          savedFile = value;
          return value;
        },
      );
    }

    if (oldPath.contains('.mp4')) {
      await GallerySaver.saveVideo(oldPath,
              toDcim: true, albumName: 'All Status Saver')
          .then(
        (value) {
          savedFile = value;
          return value;
        },
      );
    }
    return savedFile;
  }

  copyDirectory(Directory source, Directory destination) {
    source.listSync(recursive: false).forEach((var entity) {
      if (entity is Directory) {
        var newDirectory = Directory(
            path.join(destination.absolute.path, path.basename(entity.path)));
        newDirectory.create();
        copyDirectory(entity.absolute, newDirectory);
      } else if (entity is File) {
        entity
            .copySync(path.join(destination.path, path.basename(entity.path)));
      }
    });
  }

  Future<Map<String, List<FileType>>> getFileTypes(
      String path, String secondaryPath) async {
    // var tempDir = await getTemporaryDirectory();
    // print(tempDir);

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

    if (await Directory(secondaryPath).exists()) {
      final dirFiles = Directory(secondaryPath)
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
      maxWidth: 720,
      quality: 100,
    );
    return unit8list;
  }

  Future generateLowQualityVideoThumbnail(File file) async {
    final unit8list = await VideoThumbnail.thumbnailData(
      video: file.path,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 200,
      quality: 20,
    );
    return unit8list;
  }

  Future deleteItem(File file) async {
    if (!await file.exists()) {
      await file.delete();
    }
    return;
  }
}
