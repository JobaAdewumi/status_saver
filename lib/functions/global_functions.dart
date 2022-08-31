import 'dart:io';

import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path/path.dart' as path;

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

class GlobalFunctions {
  Future<void> shareFile(String path) async {
    await Share.shareFiles([path]);
  }

  Future<bool?> saveStatus(String oldPath) async {
    late bool? savedFile;
    if (oldPath.contains('.jpg') ||
        oldPath.contains('.jpeg') ||
        oldPath.contains('.png')) {
      await GallerySaver.saveImage(oldPath,
              toDcim: false, albumName: 'All Status Saver')
          .then(
        (value) {
          savedFile = value;
          return value;
        },
      );
    }

    if (oldPath.contains('.mp4')) {
      await GallerySaver.saveVideo(oldPath,
              toDcim: false, albumName: 'All Status Saver')
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
        print(entity);
        var newDirectory = Directory(
            path.join(destination.absolute.path, path.basename(entity.path)));
        newDirectory.create();
        copyDirectory(entity.absolute, newDirectory);
      } else if (entity is File) {
        print(entity);
        entity
            .copySync(path.join(destination.path, path.basename(entity.path)));
      }
    });
  }

  Future<Map<String, List<FileType>>> getFileTypes(
      String path, String secondaryPath) async {
    var tempDir = await getTemporaryDirectory();
    print(tempDir);
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
      // var check = copyDirectory(Directory(secondaryPath),
      //     Directory('/storage/emulated/0/Android${tempDir.path}'));
      // // File sPath = File(secondaryPath);
      // // // var tempPath = tempDir.path;
      // // var check =
      // //     await sPath.copy('/storage/emulated/0/Android${tempDir.path}');
      // print('check');
      // print(check);
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
}
