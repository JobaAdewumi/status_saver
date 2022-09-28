import 'dart:io';

import 'package:all_status_saver/functions/global_functions.dart';
import 'package:all_status_saver/helpers/storage_manager.dart';
import 'package:all_status_saver/views/Permissions.dart';
import 'package:all_status_saver/views/WhatsAppViews/home/Viewer.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_manager/file_manager.dart';
import 'package:flutter/material.dart';

import 'package:all_status_saver/routes/routes.dart' as route;

class WhatsAppOptions {
  final bool isWhatsApp;
  final bool isStatusPage;

  WhatsAppOptions({
    required this.isWhatsApp,
    this.isStatusPage = false,
  });
}

class WhatsApp extends StatefulWidget {
  final WhatsAppOptions whatsAppOptions;
  const WhatsApp({super.key, required this.whatsAppOptions});

  @override
  State<WhatsApp> createState() => _WhatsAppState();
}

class _WhatsAppState extends State<WhatsApp> with TickerProviderStateMixin {
  final FileManagerController controller = FileManagerController();

  late TabController _tabController;

  late List<FileType> gImages;
  late List<FileType> gVideos;
  late List<FileType> gImagesVideo;

  late String globalStatusPath;
  late String globalStatusPath11;

  int? androidVersion;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    getAndroidVersion();
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
          print(value);
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

  Widget ImageGrid(
    File statuses,
    List<FileType> files,
    int index,
    BuildContext context,
  ) {
    Widget image = InkWell(
      onTap: () {
        Navigator.pushNamed(context, route.viewer,
            arguments:
                MultimediaViewer(isImage: true, allFiles: files, index: index));
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
              height: 134,
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
                widget.whatsAppOptions.isStatusPage
                    ? Expanded(
                        flex: 1,
                        child: TextButton(
                          style: TextButton.styleFrom(
                              fixedSize: const Size(60.0, 53.0),
                              primary: Colors.red),
                          onPressed: () async {
                            return showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Delete Permanently?'),
                                  content: const Text(
                                      'Are you sure you want to delete this file permanently?'),
                                  contentPadding: const EdgeInsets.fromLTRB(
                                      24.0, 20.0, 24.0, 17.0),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        setState(() {
                                          statuses.deleteSync();
                                        });
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Column(
                            children: const [
                              Icon(Icons.delete_forever_rounded),
                              Text(
                                'DELETE',
                                style: TextStyle(fontSize: 10),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Expanded(
                        flex: 1,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            fixedSize: const Size(60.0, 53.0),
                            primary: Colors.blue,
                          ),
                          onPressed: () async {
                            await GlobalFunctions()
                                .saveStatus(statuses.path, context);
                          },
                          child: Column(
                            children: const [
                              Icon(Icons.save_alt),
                              Text(
                                'SAVE',
                                style: TextStyle(fontSize: 10),
                              )
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

  Widget VideoGrid(
    List<FileType> allStatuses,
    File statuses,
    int index,
    BuildContext context,
  ) {
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
                              arguments: MultimediaViewer(
                                  allFiles: allStatuses, index: index),
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
                      widget.whatsAppOptions.isStatusPage
                          ? Expanded(
                              flex: 1,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                    fixedSize: const Size(60.0, 53.0),
                                    primary: Colors.red),
                                onPressed: () async {
                                  return showDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (context) {
                                      return AlertDialog(
                                        title:
                                            const Text('Delete Permanently?'),
                                        content: const Text(
                                            'Are you sure you want to delete this file permanently?'),
                                        contentPadding:
                                            const EdgeInsets.fromLTRB(
                                                24.0, 20.0, 24.0, 17.0),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              setState(() {
                                                statuses.deleteSync();
                                              });
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Delete'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Column(
                                  children: const [
                                    Icon(Icons.delete_forever_rounded),
                                    Text(
                                      'DELETE',
                                      style: TextStyle(fontSize: 10),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Expanded(
                              flex: 1,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  fixedSize: const Size(60.0, 53.0),
                                  primary: Colors.blue,
                                ),
                                onPressed: () async {
                                  await GlobalFunctions()
                                      .saveStatus(statuses.path, context);
                                },
                                child: Column(
                                  children: const [
                                    Icon(Icons.save_alt),
                                    Text(
                                      'SAVE',
                                      style: TextStyle(fontSize: 10),
                                    )
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
              return ImageGrid(
                statuses,
                gImagesVideo,
                index,
                context,
              );
            }
            return VideoGrid(
              gImagesVideo,
              statuses,
              index,
              context,
            );
          },
        ),
      );
    } else {
      imagesVideos = GlobalFunctions().noStatusError(
          widget.whatsAppOptions.isWhatsApp,
          widget.whatsAppOptions.isStatusPage);
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

            return VideoGrid(gVideos, statuses, index, context);
          },
        ),
      );
    } else {
      videos = GlobalFunctions().noStatusError(
          widget.whatsAppOptions.isWhatsApp,
          widget.whatsAppOptions.isStatusPage);
    }
    return videos;
  }

  Widget StatusImages(List<FileType> gImages) {
    Widget images;
    var checkTypes = gImagesVideo.where(
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

            return ImageGrid(statuses, gImages, index, context);
          },
        ),
      );
    } else {
      images = GlobalFunctions().noStatusError(
          widget.whatsAppOptions.isWhatsApp,
          widget.whatsAppOptions.isStatusPage);
    }
    return images;
  }

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
                return GlobalFunctions().noStatusError(
                    widget.whatsAppOptions.isWhatsApp,
                    widget.whatsAppOptions.isStatusPage);
              }
            }

            FileSystemEntity? entity;
            FileSystemEntity? entity11;
            if (widget.whatsAppOptions.isWhatsApp) {
              for (var e in entities) {
                if (FileManager.basename(e) == 'WhatsApp') {
                  entity = e;
                }
                if (FileManager.basename(e) == 'Android') {
                  entity11 = e;
                }
              }
            } else if (!widget.whatsAppOptions.isWhatsApp &&
                !widget.whatsAppOptions.isStatusPage) {
              for (var e in entities) {
                if (FileManager.basename(e) == 'WhatsApp Business') {
                  entity = e;
                }
                if (FileManager.basename(e) == 'Android') {
                  entity11 = e;
                }
              }
            } else if (widget.whatsAppOptions.isStatusPage) {
              for (var e in entities) {
                if (FileManager.basename(e) == 'DCIM') {
                  entity = e;
                }
              }
            }

            var directoryPath = directoriesPaths?[0];

            String? path = entity?.path ?? '';
            String newPath = widget.whatsAppOptions.isStatusPage
                ? '$path/All Status Saver/'
                : '$path/Media/.Statuses/';
            entity = Directory(newPath);

            String? path11 = directoryPath ?? 'Android/media';

            String newPath11 = widget.whatsAppOptions.isWhatsApp
                ? '/storage/emulated/0/$path11/com.whatsapp/WhatsApp/Media/.Statuses'
                : '/storage/emulated/0/$path11/com.whatsapp.w4b/WhatsApp Business/Media/.Statuses';
            print(newPath11);

            entity11 = Directory(newPath11);

            if (!entity.existsSync() && !entity11.existsSync()) {
              return GlobalFunctions().noStatusError(
                  widget.whatsAppOptions.isWhatsApp,
                  widget.whatsAppOptions.isStatusPage);
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
