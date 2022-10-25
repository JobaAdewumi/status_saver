import 'dart:io';

import 'package:all_status_saver/common_libs.dart';
import 'package:all_status_saver/helpers/storage_manager.dart';
import 'package:all_status_saver/routes/routes.dart' as route;
import 'package:all_status_saver/views/WhatsAppViews/home/viewer.dart';
import 'package:all_status_saver/views/permissions.dart';
import 'package:async/async.dart';
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

class SelectedFile {
  final File file;
  final int index;

  SelectedFile({
    required this.file,
    required this.index,
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

  List<SelectedFile> selectedCards = [];

  final AsyncMemoizer _memoizer = AsyncMemoizer();

  getThumbnails(File statuses) {
    return _memoizer.runOnce(() async {
      await GlobalFunctions().generateVideoThumbnail(statuses).then((value) {
        // print(value);
        return value;
      });
    });
  }

  void onCardLongPress(File file, int index) {
    if (selectedCards.any((element) => element.index == index)) {
      setState(() {
        selectedCards.removeWhere((element) => element.index == index);
      });
    } else {
      setState(() {
        selectedCards.add(SelectedFile(file: file, index: index));
      });
    }
  }

  Future deleteAllSelected() async {
    for (var element in selectedCards) {
      print(element.index);
      // await element.file.delete();
    }
    setState(() {
      selectedCards.clear();
    });
  }

  bool triedToGetStatusAgain11 = false;

  bool showErrorPage = false;

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

  _onVideoTap(List<FileType> allFiles, int index, bool isStatusPage) {
    Navigator.pushNamed(
      context,
      route.viewer,
      arguments: MultimediaViewer(
          allFiles: allFiles,
          index: index,
          isStatusPage: widget.whatsAppOptions.isStatusPage),
    );
  }

  Widget ImageGrid(
    File statuses,
    List<FileType> files,
    int index,
    BuildContext context,
  ) {
    Widget image = InkWell(
      onLongPress: () {
        onCardLongPress(statuses, index);
      },
      onTap: () {
        if (selectedCards.isEmpty) {
          Navigator.pushNamed(
            context,
            route.viewer,
            arguments: MultimediaViewer(
                isImage: true,
                allFiles: files,
                index: index,
                isStatusPage: widget.whatsAppOptions.isStatusPage),
          );
        } else {
          onCardLongPress(statuses, index);
        }
      },
      child: Image.file(statuses, height: 100, width: 100, fit: BoxFit.cover),
    );
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
                  child: image,
                ),
                selectedCards.isNotEmpty
                    ? Positioned(
                        left: 7,
                        top: 7,
                        child: selectedCards
                                .any((element) => element.index == index)
                            ? Icon(
                                Icons.check_circle,
                                color: Theme.of(context)
                                    .appBarTheme
                                    .backgroundColor,
                              )
                            : Icon(
                                Icons.circle_outlined,
                                color: Theme.of(context)
                                    .appBarTheme
                                    .backgroundColor,
                              ),
                      )
                    : Container(),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: TextButton(
                    style: TextButton.styleFrom(
                        foregroundColor: Colors.red,
                        fixedSize: const Size(60.0, 53.0)),
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
                        foregroundColor: Colors.green,
                        fixedSize: const Size(60.0, 53.0)),
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
                              foregroundColor: Colors.red,
                              fixedSize: const Size(60.0, 53.0)),
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
                            foregroundColor: Colors.blue,
                            fixedSize: const Size(60.0, 53.0),
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
    return Card(
      child: Stack(
        children: [
          selectedCards.isNotEmpty
              ? Positioned(
                  left: 7,
                  top: 7,
                  child: selectedCards.any((element) => element.index == index)
                      ? Icon(
                          Icons.check_circle,
                          color: Theme.of(context).appBarTheme.backgroundColor,
                        )
                      : Icon(
                          Icons.circle_outlined,
                          color: Theme.of(context).appBarTheme.backgroundColor,
                        ),
                )
              : Container(),
          FutureBuilder(
            future: getThumbnails(statuses),
            builder: (context, snapshot) {
              // print(snapshot.data);
              if (snapshot.hasData) {
                Image video = Image.memory(snapshot.data as dynamic,
                    height: 100, width: 100, fit: BoxFit.cover);
                return Column(
                  children: [
                    Expanded(
                      flex: 2,
                      child: GestureDetector(
                        onLongPress: () {
                          onCardLongPress(statuses, index);
                        },
                        onTap: () {
                          if (selectedCards.isEmpty) {
                            _onVideoTap(allStatuses, index,
                                widget.whatsAppOptions.isStatusPage);
                          } else {
                            onCardLongPress(statuses, index);
                          }
                        },
                        child: Stack(
                          children: [
                            SizedBox(
                              width: 350,
                              height: 134,
                              child: video,
                            ),
                            const Positioned(
                              top: 30,
                              left: 60,
                              child: Icon(
                                Icons.play_circle_outline,
                                color: Colors.blue,
                                size: 50,
                              ),
                            ),
                          ],
                        ),
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
                                  foregroundColor: Colors.red, fixedSize: const Size(60.0, 53.0)),
                              onPressed: () async {
                                await GlobalFunctions()
                                    .shareFile(statuses.path);
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
                                  foregroundColor: Colors.green, fixedSize: const Size(60.0, 53.0)),
                              onPressed: () async {
                                await GlobalFunctions()
                                    .shareFile(statuses.path);
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
                                        foregroundColor: Colors.red, fixedSize: const Size(60.0, 53.0)),
                                    onPressed: () async {
                                      return showDialog(
                                        context: context,
                                        barrierDismissible: true,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text(
                                                'Delete Permanently?'),
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
                                      foregroundColor: Colors.blue, fixedSize: const Size(60.0, 53.0),
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
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ],
      ),
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

  Widget returnFromInitCalculation() {
    if (showErrorPage) {
      return GlobalFunctions().noStatusError(widget.whatsAppOptions.isWhatsApp,
          widget.whatsAppOptions.isStatusPage);
    }
    return TabBarView(
      controller: _tabController,
      children: [
        AllStatuses(gImagesVideo),
        StatusImages(gImages),
        StatusVideos(gVideos),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (appLogic.androidVersion! <= 29) {
      if (widget.whatsAppOptions.isWhatsApp) {
        if (whatsappLogic.showNoWAStatusError) {
          // return GlobalFunctions().noStatusError(
          //     widget.whatsAppOptions.isWhatsApp,
          //     widget.whatsAppOptions.isStatusPage);
          showErrorPage = true;
        }
      } else if (widget.whatsAppOptions.isStatusPage) {
        if (whatsappLogic.showNoStatusError) {
          // return GlobalFunctions().noStatusError(
          //     widget.whatsAppOptions.isWhatsApp,
          //     widget.whatsAppOptions.isStatusPage);
          showErrorPage = true;
        }
      } else if (!widget.whatsAppOptions.isWhatsApp &&
          !widget.whatsAppOptions.isStatusPage) {
        if (whatsappLogic.showNoWBStatusError) {
          // return GlobalFunctions().noStatusError(
          //     widget.whatsAppOptions.isWhatsApp,
          //     widget.whatsAppOptions.isStatusPage);
          showErrorPage = true;
        }
      }
    }

    // globalStatusPath = newPath;
    // globalStatusPath11 = newPath11;

    if (widget.whatsAppOptions.isStatusPage) {
      gImages = whatsappLogic.gSSImages!;
      gVideos = whatsappLogic.gSSVideos!;
      gImagesVideo = whatsappLogic.gSSImagesVideo!;
      if (appLogic.androidVersion! >= 30 &&
          whatsappLogic.gSSImagesVideo!.isEmpty) {
        whatsappLogic.init(true, false, false).then((value) {
          triedToGetStatusAgain11 = true;
          if (whatsappLogic.gSSImagesVideo!.isNotEmpty) {
            gImages = whatsappLogic.gSSImages!;
            gVideos = whatsappLogic.gSSVideos!;
            gImagesVideo = whatsappLogic.gSSImagesVideo!;
          } else {
            // return GlobalFunctions().noStatusError(
            //     widget.whatsAppOptions.isWhatsApp,
            //     widget.whatsAppOptions.isStatusPage);
            showErrorPage = true;
          }
        });
      }
    }

    if (widget.whatsAppOptions.isWhatsApp &&
        !widget.whatsAppOptions.isStatusPage) {
      gImages = whatsappLogic.gWImages!;
      gVideos = whatsappLogic.gWVideos!;
      gImagesVideo = whatsappLogic.gWImagesVideo!;
      if (appLogic.androidVersion! >= 30 &&
          whatsappLogic.gWImagesVideo!.isEmpty) {
        whatsappLogic.init(true, false, false).then((value) {
          triedToGetStatusAgain11 = true;
          if (whatsappLogic.gWImagesVideo!.isNotEmpty) {
            gImages = whatsappLogic.gWImages!;
            gVideos = whatsappLogic.gWVideos!;
            gImagesVideo = whatsappLogic.gWImagesVideo!;
          } else {
            // return GlobalFunctions().noStatusError(
            //     widget.whatsAppOptions.isWhatsApp,
            //     widget.whatsAppOptions.isStatusPage);
            showErrorPage = true;
          }
        });
      }
    }

    if (!widget.whatsAppOptions.isWhatsApp &&
        !widget.whatsAppOptions.isStatusPage) {
      gImages = whatsappLogic.gWBImages!;
      gVideos = whatsappLogic.gWBVideos!;
      gImagesVideo = whatsappLogic.gWBImagesVideo!;
      if (appLogic.androidVersion! >= 30 &&
          whatsappLogic.gWBImagesVideo!.isEmpty) {
        whatsappLogic.init(true, false, false).then((value) {
          triedToGetStatusAgain11 = true;
          if (whatsappLogic.gWBImagesVideo!.isNotEmpty) {
            gImages = whatsappLogic.gWBImages!;
            gVideos = whatsappLogic.gWBVideos!;
            gImagesVideo = whatsappLogic.gWBImagesVideo!;
          } else {
            // return GlobalFunctions().noStatusError(
            //     widget.whatsAppOptions.isWhatsApp,
            //     widget.whatsAppOptions.isStatusPage);
            showErrorPage = true;
          }
        });
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: widget.whatsAppOptions.isStatusPage
            ? const Text('Saved Statuses')
            : const Text('Recent Statuses'),
        foregroundColor: Colors.white,
        centerTitle: true,
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
        widget.whatsAppOptions.isStatusPage
            ? IconButton(
                onPressed: () async {
                  await deleteAllSelected();
                },
                icon: const Icon(Icons.delete_forever_rounded),
              )
            : const IconButton(
                onPressed: null,
                icon: Icon(Icons.save_alt),
              ),
      ],
      bottom: tabBar(),
    );
  }

  PreferredSizeWidget normalAppbar() {
    return AppBar(
      title: widget.whatsAppOptions.isStatusPage
          ? const Text('Saved Statuses')
          : const Text('Recent Statuses'),
      foregroundColor: Colors.white,
      centerTitle: true,
      bottom: tabBar(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: selectedCards.isNotEmpty ? selectedAppbar() : normalAppbar(),
      body: Container(
          margin: const EdgeInsets.all(10), child: returnFromInitCalculation()),
    );
  }
}
