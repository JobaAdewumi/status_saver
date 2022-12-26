import 'dart:io';

import 'package:all_status_saver/common_libs.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:saf/saf.dart';

class WhatsappLogic {
  final String baseAndroidDirectory = '/storage/emulated/0/';

  Saf saf = Saf('/storage/emulated/0/Android/media/');

  bool showNoWBStatusError = false;
  bool showNoWAStatusError = false;
  bool showNoStatusError = false;

  FileSystemEntity? savedStatusEntity;

  FileSystemEntity? whatsappEntity;
  FileSystemEntity? whatsappEntity11;

  FileSystemEntity? whatsappBEntity;
  FileSystemEntity? whatsappBEntity11;

  String? savedStatusPath;

  String? whatsappPath;
  String? whatsappPath11;

  String? whatsappBPath;
  String? whatsappBPath11;

  String? directoryPath;
  List<String>? directoriesPaths;

  bool androidStoragePermission = false;

  bool android11Permission = false;

  List<FileType> gWImages = [];
  List<FileType> gWVideos = [];
  List<FileType> gWImagesVideo = [];

  List<FileType> gWBImages = [];
  List<FileType> gWBVideos = [];
  List<FileType> gWBImagesVideo = [];

  List<FileType> gSSImages = [];
  List<FileType> gSSVideos = [];
  List<FileType> gSSImagesVideo = [];

  Future init() async {
    directoriesPaths = await Saf.getPersistedPermissionDirectories();
    if (directoriesPaths == null && directoriesPaths!.isNotEmpty) {
      if (directoriesPaths![0] == 'Android/media') {
        directoryPath = directoriesPaths![0];
      }
    }
    await checkPermissionStatus(
        [Permission.storage, Permission.manageExternalStorage]);

    if (androidStoragePermission) {
      final List<FileSystemEntity> entities =
          await Directory(baseAndroidDirectory).list().toList();

      if (appLogic.androidVersion! <= 29) {
        if (entities.isEmpty) {
          showNoWAStatusError = true;
          showNoWBStatusError = true;
          showNoStatusError = true;
        }
      }

      for (var e in entities) {
        if (_getBasename(e) == 'WhatsApp') {
          whatsappEntity = e;
        }
        if (_getBasename(e) == 'Android') {
          whatsappEntity11 = e;
        }
      }

      for (var e in entities) {
        if (_getBasename(e) == 'WhatsApp Business') {
          whatsappBEntity = e;
        }
        if (_getBasename(e) == 'Android') {
          whatsappBEntity11 = e;
        }
      }

      for (var e in entities) {
        if (_getBasename(e) == 'DCIM') {
          savedStatusEntity = e;
        }
      }

      ///Whatsapp
      String? wPath = whatsappEntity?.path ?? '';
      String wNewPath = '$wPath/Media/.Statuses/';
      whatsappEntity = Directory(wNewPath);

      String? wPath11 = directoryPath ?? 'Android/media';

      String wNewPath11 =
          '/storage/emulated/0/$wPath11/com.whatsapp/WhatsApp/Media/.Statuses';

      whatsappPath = wNewPath;
      whatsappPath11 = wNewPath11;

      whatsappEntity11 = Directory(wNewPath11);

      if (!whatsappEntity!.existsSync() && !whatsappEntity11!.existsSync()) {
        showNoWAStatusError = true;
      }

      ///Whatsapp Business
      String? wbPath = whatsappBEntity?.path ?? '';
      String wbNewPath = '$wbPath/Media/.Statuses/';
      whatsappBEntity = Directory(wbNewPath);

      String? wbPath11 = directoryPath ?? 'Android/media';

      String wbNewPath11 =
          '/storage/emulated/0/$wbPath11/com.whatsapp.w4b/WhatsApp Business/Media/.Statuses';

      whatsappBPath = wbNewPath;
      whatsappBPath11 = wbNewPath11;

      whatsappBEntity11 = Directory(wbNewPath11);

      if (!whatsappBEntity!.existsSync() && !whatsappBEntity11!.existsSync()) {
        showNoWBStatusError = true;
      }

      /// Saved status
      String? ssPath = savedStatusEntity?.path ?? '';
      String ssNewPath = '$ssPath/All Status Saver/';
      savedStatusEntity = Directory(ssNewPath);

      savedStatusPath = ssNewPath;

      if (!savedStatusEntity!.existsSync()) {
        showNoStatusError = true;
      }

      ///whatsapp
      GlobalFunctions().getFileTypes(wNewPath, wNewPath11).then((value) {
        Map<String, List<FileType>> allWFiles = value;
        gWImages = allWFiles['images'] ?? [];
        gWVideos = allWFiles['videos'] ?? [];
        gWImagesVideo = allWFiles['all'] ?? [];
      });

      ///whatsapp business
      GlobalFunctions().getFileTypes(wbNewPath, wbNewPath11).then((value) {
        Map<String, List<FileType>> allWBFiles = value;
        gWBImages = allWBFiles['images'] ?? [];
        gWBVideos = allWBFiles['videos'] ?? [];
        gWBImagesVideo = allWBFiles['all'] ?? [];
      });

      if (appLogic.androidVersion! <= 29) {
        ///saved status
        GlobalFunctions().getFileTypes(ssNewPath, '').then((value) {
          Map<String, List<FileType>> allSSFiles = value;
          gSSImages = allSSFiles['images'] ?? [];
          gSSVideos = allSSFiles['videos'] ?? [];
          gSSImagesVideo = allSSFiles['all'] ?? [];
        });
      }

      if (gSSImagesVideo.isEmpty &&
          gWBImagesVideo.isEmpty &&
          gWImagesVideo.isEmpty) {
        FlutterLogs.logWarn('Statuses', 'Warning',
            'No status error triggered in init function');
        showNoStatusError = true;
        showNoWAStatusError = true;
        showNoWBStatusError = true;
      }
    }
  }

  static String _getBasename(dynamic entity, [bool showFileExtension = true]) {
    if (entity is Directory) {
      return entity.path.split('/').last;
    } else if (entity is File) {
      return (showFileExtension)
          ? entity.path.split('/').last.split('.').first
          : entity.path.split('/').last;
    } else {
      print('Error getting basename');
      return '';
    }
  }

  Future checkPermissionStatus(List<Permission> permissions) async {
    for (var permission in permissions) {
      if (await permission.isGranted) {
        androidStoragePermission = true;
      } else {
        return;
      }
    }
  }
}
