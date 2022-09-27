import 'dart:io';
import 'package:all_status_saver/functions/global_functions.dart';
import 'package:all_status_saver/helpers/storage_manager.dart';
import 'package:all_status_saver/views/Permissions.dart';
import 'package:all_status_saver/widgets/grid-views.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';

import 'package:file_manager/file_manager.dart';

import 'package:saf/saf.dart';

class WhatsappBPage extends StatefulWidget {
  const WhatsappBPage({super.key});

  @override
  WhatsappBPageState createState() => WhatsappBPageState();
}

class WhatsappBPageState extends State<WhatsappBPage>
    with TickerProviderStateMixin {
  final FileManagerController controller = FileManagerController();

  late TabController _tabController;

  late List<FileType> gImages;
  late List<FileType> gVideos;
  late List<FileType> gImagesVideo;

  late String globalStatusPath;
  late String globalStatusPath11;

  late Saf saf;

  int? androidVersion;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    getAndroidVersion();
    saf = Saf(
        '/storage/emulated/0/Android/media/com.whatsapp.w4b/WhatsApp Business/Media/.Statuses/');
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  Future getAndroidVersion() async {
    StorageManager.readData('androidVersion').then(
      (value) async {
        if (value == null) {
          DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
          AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
          StorageManager.saveData(
              'androidVersion', androidInfo.version.sdkInt!);
          setState(() {
            androidVersion = androidInfo.version.sdkInt!;
          });
        } else {
          setState(() {
            androidVersion = value;
          });
        }
      },
    );
  }

  Future onDragGridDown() async {
    await GlobalFunctions()
        .getFileTypes(globalStatusPath, globalStatusPath11)
        .then(
      (value) {
        Map<String, List<FileType>> allFiles = value;
        setState(
          () {
            gImages = allFiles['images']!;
            gVideos = allFiles['videos']!;
            gImagesVideo = allFiles['all']!;
          },
        );
      },
    );
  }

  Widget AllStatuses(List<FileType> gImagesVideo) {
    Widget imagesVideos;
    var checkTypes = gImagesVideo.where(
      (e) {
        if (e.file.path.contains('.jpg') ||
            e.file.path.contains('.jpeg') ||
            e.file.path.contains('.png') ||
            e.file.path.contains('.mp4')) {
          return true;
        }
        return false;
      },
    );
    if (gImagesVideo.isNotEmpty && checkTypes.isNotEmpty) {
      imagesVideos = RefreshIndicator(
        onRefresh: onDragGridDown,
        triggerMode: RefreshIndicatorTriggerMode.anywhere,
        child: GridView.builder(
          itemCount: gImagesVideo.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2),
          itemBuilder: (context, index) {
            FileType entit = gImagesVideo[index];

            File statuses = File(entit.file.path);

            if (entit.file.path.contains('.nomedia')) {
              entit.file.delete();
            }

            if (entit.file.path.contains('.jpg') ||
                entit.file.path.contains('.jpeg') ||
                entit.file.path.contains('.png')) {
              return GlobalWidgets()
                  .ImageGrid(statuses, gImagesVideo, index, context);
            }
            return GlobalWidgets()
                .VideoGrid(gImagesVideo, statuses, index, context);
          },
        ),
      );
    } else {
      imagesVideos = GlobalFunctions().noStatusError(false);
    }
    return imagesVideos;
  }

  Widget StatusVideos(List<FileType> gVideos) {
    Widget videos;
    var checkTypes = gVideos.where(
      (e) {
        if (e.file.path.contains('.mp4')) {
          return true;
        }
        return false;
      },
    );
    if (gVideos.isNotEmpty && checkTypes.isNotEmpty) {
      videos = RefreshIndicator(
        onRefresh: onDragGridDown,
        triggerMode: RefreshIndicatorTriggerMode.anywhere,
        child: GridView.builder(
          itemCount: gVideos.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2),
          itemBuilder: (context, index) {
            FileType entit = gVideos[index];

            File statuses = File(entit.file.path);

            if (entit.file.path.contains('.nomedia')) {
              entit.file.delete();
            }

            return GlobalWidgets().VideoGrid(gVideos, statuses, index, context);
          },
        ),
      );
    } else {
      videos = GlobalFunctions().noStatusError(false);
    }
    return videos;
  }

  Widget StatusImages(List<FileType> gImages) {
    Widget images;
    var checkTypes = gImages.where(
      (e) {
        if (e.file.path.contains('.jpg') ||
            e.file.path.contains('.jpeg') ||
            e.file.path.contains('.png')) {
          return true;
        }
        return false;
      },
    );
    if (gImages.isNotEmpty && checkTypes.isNotEmpty) {
      images = RefreshIndicator(
        onRefresh: onDragGridDown,
        triggerMode: RefreshIndicatorTriggerMode.anywhere,
        child: GridView.builder(
          itemCount: gImages.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2),
          itemBuilder: (context, index) {
            FileType entit = gImages[index];

            File statuses = File(entit.file.path);

            if (entit.file.path.contains('.nomedia')) {
              entit.file.delete();
            }

            return GlobalWidgets().ImageGrid(statuses, gImages, index, context);
          },
        ),
      );
    } else {
      images = GlobalFunctions().noStatusError(false);
    }
    return images;
  }

  // Future<void> copyPath(String from, String to) async {
  //   // if (_doNothing(from, to)) {
  //   //   return;
  //   // }
  //   await Directory(to).create(recursive: true);
  //   await for (final file in Directory(from).list(recursive: true)) {
  //     final copyTo = p.join(to, p.relative(file.path, from: from));
  //     if (file is Directory) {
  //       await Directory(copyTo).create(recursive: true);
  //     } else if (file is File) {
  //       await File(file.path).copy(copyTo);
  //     } else if (file is Link) {
  //       await Link(copyTo).create(await file.target(), recursive: true);
  //     }
  //   }
  // }

  // Future trial() async {
  //   File copyfile;
  //   String newPath11 =
  //       '/storage/emulated/0/Android/media/com.whatsapp.w4b/WhatsApp Business/Media';
  //   // String newPath11 =
  //   //     '/storage/emulated/0/Android/media/com.whatsapp.w4b/WhatsApp Business/Media/.Statuses';
  //   var tempDir = await getTemporaryDirectory();
  //   var patht = tempDir.path;
  //   print(patht);
  //   String temppath = '$patht/.Statuses';
  //   Directory directory = Directory(patht);
  //   Directory directory2 = Directory(temppath);
  //   // if (!await directory.exists()) {
  //   //   await directory.create(recursive: true);
  //   //   print('hi');
  //   // }

  //   if (await directory.exists()) {
  //     Directory path = Directory(newPath11);
  //     print(path);
  //     // File media = path;
  //     // copyfile = path.copySync('$patht/$media.path');
  //     // print(copyfile);

  //     p.copyPath(path.path, patht);
  //   }
  //   List contentList =
  //       directory2.listSync(recursive: false, followLinks: false);
  //   print(contentList);
  //   // copyfile =
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recent Statuses'),
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              icon: Icon(Icons.all_inbox_rounded),
            ),
            Tab(
              icon: Icon(Icons.image),
            ),
            Tab(
              icon: Icon(Icons.video_library_rounded),
            ),
          ],
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        child: FileManager(
          controller: controller,
          hideHiddenEntity: false,
          builder: (context, snapshot) {
            final List<FileSystemEntity> entities = snapshot;

            if (androidVersion! <= 29) {
              if (entities.isEmpty) {
                return GlobalFunctions().noStatusError(false);
              }
            }

            FileSystemEntity? entity;
            FileSystemEntity? entity11;
            for (var e in entities) {
              if (FileManager.basename(e) == 'WhatsApp Business') {
                entity = e;
              }
              if (FileManager.basename(e) == 'Android') {
                entity11 = e;
              }
            }

            var directoryPath = directoriesPaths?[0];

            String? path = entity?.path ?? '';
            String newPath = '$path/Media/.Statuses/';
            entity = Directory(newPath);

            String? path11 = directoryPath;
            // trial();

            String newPath11 =
                '/storage/emulated/0/$path11/com.whatsapp.w4b/WhatsApp Business/Media/.Statuses';

            entity11 = Directory(newPath11);

            if (!entity.existsSync() && !entity11.existsSync()) {
              return GlobalFunctions().noStatusError(false);
            }

            globalStatusPath = newPath;
            globalStatusPath11 = newPath11;

            return FutureBuilder(
              future: GlobalFunctions().getFileTypes(newPath, newPath11),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Map<String, List<FileType>> allFiles =
                      snapshot.data as Map<String, List<FileType>>;
                  gImages = allFiles['images']!;
                  gVideos = allFiles['videos']!;
                  gImagesVideo = allFiles['all']!;
                  return TabBarView(
                    controller: _tabController,
                    children: [
                      AllStatuses(gImagesVideo),
                      StatusImages(gImages),
                      StatusVideos(gVideos),
                    ],
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
