import 'dart:io';
import 'package:all_status_saver/functions/global_functions.dart';
import 'package:all_status_saver/helpers/storage_manager.dart';
import 'package:all_status_saver/views/Permissions.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';

import 'package:file_manager/file_manager.dart';

import 'package:all_status_saver/routes/routes.dart' as route;
import 'package:all_status_saver/views/home/Viewer.dart';

import 'package:saf/saf.dart';

class WhatsappBPage extends StatefulWidget {
  const WhatsappBPage({super.key});

  @override
  WhatsappBPageState createState() => WhatsappBPageState();
}

class WhatsappBPageState extends State<WhatsappBPage> {
  final FileManagerController controller = FileManagerController();
  final PageController _pageController = PageController(initialPage: 0);

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
    getAndroidVersion();
    saf = Saf(
        '/storage/emulated/0/Android/media/com.whatsapp.w4b/WhatsApp Business/Media/.Statuses/');
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
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

  saveStatus(String statusPath) async {
    await GlobalFunctions().saveStatus(statusPath).then(
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
              duration: Duration(seconds: 1),
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
              duration: Duration(seconds: 1),
            ),
          );
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

  Widget noStatusError() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
            'No Status Found, You have to watch stories on WhatsApp Business to make them appear here',
            textAlign: TextAlign.center),
        ElevatedButton.icon(
          onPressed: null,
          icon: const Icon(Icons.launch_rounded),
          label: const Text('OPEN WHATSAPP BUSINESS'),
        ),
      ],
    );
  }

  // static const List<Widget> _widgetOptions

  Widget ImageGrid(File statuses, FileType entit) {
    Widget image = InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          route.viewer,
          arguments: MultimediaViewer(isImage: true, file: statuses),
        );
      },
      child: Image.file(statuses, height: 100, width: 100, fit: BoxFit.cover),
    );
    return Card(
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: SizedBox(
              width: 350,
              // height: 134,
              child: image,
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: TextButton(
                    style: TextButton.styleFrom(
                        fixedSize: const Size(60.0, 53.0), primary: Colors.red),
                    onPressed: () async {
                      await GlobalFunctions().shareFile(statuses.path);
                    },
                    child: Column(
                      children: const [
                        Icon(Icons.share),
                        Text(
                          'SHARE',
                          style: TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: TextButton(
                    style: TextButton.styleFrom(
                        fixedSize: const Size(60.0, 53.0),
                        primary: Colors.green),
                    onPressed: () async {
                      await GlobalFunctions().shareFile(statuses.path);
                    },
                    child: Column(
                      children: const [
                        Icon(Icons.cached),
                        Text(
                          'REPOST',
                          style: TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: TextButton(
                    style:
                        TextButton.styleFrom(fixedSize: const Size(60.0, 53.0)),
                    onPressed: () async {
                      saveStatus(statuses.path);
                    },
                    child: Column(
                      children: const [
                        Icon(Icons.save_alt),
                        Text(
                          'SAVE',
                          style: TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget VideoGrid(List<FileType> allStatuses, File statuses, int index) {
    return FutureBuilder(
      future: GlobalFunctions().generateVideoThumbnail(statuses),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Image video = Image.memory(snapshot.data as dynamic,
              height: 100, width: 100, fit: BoxFit.cover);
          return Card(
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: Stack(
                    children: [
                      SizedBox(
                        width: 350,
                        height: 134,
                        child: video,
                      ),
                      Positioned(
                        top: 30,
                        left: 60,
                        child: IconButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              route.viewer,
                              arguments: MultimediaViewer(file: statuses),
                            );
                          },
                          icon: const Icon(
                            Icons.play_circle_outline,
                            color: Colors.white,
                            size: 50,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        flex: 1,
                        child: TextButton(
                          style: TextButton.styleFrom(
                              fixedSize: const Size(60.0, 53.0),
                              primary: Colors.red),
                          onPressed: () async {
                            await GlobalFunctions().shareFile(statuses.path);
                          },
                          child: Column(
                            children: const [
                              Icon(Icons.share),
                              Text(
                                'SHARE',
                                style: TextStyle(fontSize: 10),
                              )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: TextButton(
                          style: TextButton.styleFrom(
                              fixedSize: const Size(60.0, 53.0),
                              primary: Colors.green),
                          onPressed: () async {
                            await GlobalFunctions().shareFile(statuses.path);
                          },
                          child: Column(
                            children: const [
                              Icon(Icons.cached),
                              Text(
                                'REPOST',
                                style: TextStyle(fontSize: 10),
                              )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            fixedSize: const Size(60.0, 53.0),
                          ),
                          onPressed: () async {
                            saveStatus(statuses.path);
                          },
                          child: Column(
                            children: const [
                              Icon(Icons.save_alt),
                              Text(
                                'SAVE',
                                style: TextStyle(fontSize: 10),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
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
              return ImageGrid(statuses, entit);
            }
            return VideoGrid(gImagesVideo, statuses, index);
          },
        ),
      );
    } else {
      imagesVideos = noStatusError();
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

            return VideoGrid(gVideos, statuses, index);
          },
        ),
      );
    } else {
      videos = noStatusError();
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

            return ImageGrid(statuses, entit);
          },
        ),
      );
    } else {
      images = noStatusError();
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
                return noStatusError();
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

            print(directoriesPaths);

            String? path = entity?.path ?? '';
            String newPath = '$path/Media/.Statuses/';
            entity = Directory(newPath);

            String? path11 = directoryPath;
            // trial();

            String newPath11 =
                '/storage/emulated/0/$path11/com.whatsapp.w4b/WhatsApp Business/Media/.Statuses';

            print(newPath11);
            entity11 = Directory(newPath11);

            if (!entity.existsSync() && !entity11.existsSync()) {
              return noStatusError();
            }

            Directory content11 = Directory(newPath);
            Directory content = Directory(newPath);
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
                  return PageView(
                    controller: _pageController,
                    scrollDirection: Axis.horizontal,
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
