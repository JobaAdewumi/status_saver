import 'dart:io';

import 'package:all_status_saver/common_libs.dart';
import 'package:all_status_saver/routes/routes.dart' as route;
import 'package:all_status_saver/views/WhatsAppViews/home/viewer.dart';
import 'package:file_manager/file_manager.dart';
import 'package:flutter/material.dart';

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
  final String path;

  SelectedFile({
    required this.file,
    required this.path,
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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    if (appLogic.androidVersion! <= 29) {
      if (widget.whatsAppOptions.isWhatsApp) {
        if (whatsappLogic.showNoWAStatusError) {
          setState(() {
            showErrorPage = true;
          });
        }
      } else if (widget.whatsAppOptions.isStatusPage) {
        if (whatsappLogic.showNoStatusError) {
          setState(() {
            showErrorPage = true;
          });
        }
      } else if (!widget.whatsAppOptions.isWhatsApp &&
          !widget.whatsAppOptions.isStatusPage) {
        if (whatsappLogic.showNoWBStatusError) {
          setState(() {
            showErrorPage = true;
          });
        }
      }
    }

    initialStateLoader();
  }

  Future initialStateLoader() async {
    if (widget.whatsAppOptions.isStatusPage) {
      setState(() {
        globalStatusPath = whatsappLogic.savedStatusPath ?? '';
        globalStatusPath11 = '';
        gImages = whatsappLogic.gSSImages;
        gVideos = whatsappLogic.gSSVideos;
        gImagesVideo = whatsappLogic.gSSImagesVideo;
      });
      if (gImagesVideo.isEmpty) {
        setState(() {
          globalStatusPath = '/storage/emulated/0/DCIM/All Status Saver';
          globalStatusPath11 = '';
        });
        await GlobalFunctions()
            .getFileTypes(globalStatusPath, globalStatusPath11)
            .then((value) {
          Map<String, List<FileType>> allFiles = value;
          if (allFiles.isNotEmpty) {
            setState(
              () {
                gImages = allFiles['images'] ?? [];
                gVideos = allFiles['videos'] ?? [];
                gImagesVideo = allFiles['all'] ?? [];
              },
            );
          } else {
            setState(() {
              showErrorPage = true;
            });
          }
        });
      }
      if (gImagesVideo.isNotEmpty) {
        setState(() {
          showErrorPage = false;
        });
      }
      if (appLogic.androidVersion! >= 30 &&
          whatsappLogic.gSSImagesVideo.isEmpty) {
        await GlobalFunctions()
            .getFileTypes(globalStatusPath, globalStatusPath11)
            .then(
          (value) {
            Map<String, List<FileType>> allFiles = value;
            if (allFiles.isNotEmpty) {
              setState(
                () {
                  gImages = allFiles['images'] ?? [];
                  gVideos = allFiles['videos'] ?? [];
                  gImagesVideo = allFiles['all'] ?? [];
                },
              );
            } else {
              setState(() {
                showErrorPage = true;
              });
            }
          },
        );
      }
    }

    if (widget.whatsAppOptions.isWhatsApp &&
        !widget.whatsAppOptions.isStatusPage) {
      setState(() {
        globalStatusPath = whatsappLogic.whatsappPath ?? '';
        globalStatusPath11 = whatsappLogic.whatsappPath11 ?? '';
        gImages = whatsappLogic.gWImages;
        gVideos = whatsappLogic.gWVideos;
        gImagesVideo = whatsappLogic.gWImagesVideo;
      });
      if (gImagesVideo.isEmpty) {
        setState(() {
          globalStatusPath = '/storage/emulated/0/WhatsApp/Media/.Statuses';
          globalStatusPath11 =
              '/storage/emulated/0/Android/media/com.whatsapp/WhatsApp/Media/.Statuses';
        });
        await GlobalFunctions()
            .getFileTypes(globalStatusPath, globalStatusPath11)
            .then((value) {
          Map<String, List<FileType>> allFiles = value;
          if (allFiles.isNotEmpty) {
            setState(
              () {
                gImages = allFiles['images'] ?? [];
                gVideos = allFiles['videos'] ?? [];
                gImagesVideo = allFiles['all'] ?? [];
              },
            );
          } else {
            setState(() {
              showErrorPage = true;
            });
          }
        });
      }
      if (gImagesVideo.isNotEmpty) {
        setState(() {
          showErrorPage = false;
        });
      }
      if (appLogic.androidVersion! >= 30 &&
          whatsappLogic.gWImagesVideo.isEmpty) {
        await GlobalFunctions()
            .getFileTypes(globalStatusPath, globalStatusPath11)
            .then(
          (value) {
            Map<String, List<FileType>> allFiles = value;
            if (allFiles.isNotEmpty) {
              setState(
                () {
                  gImages = allFiles['images'] ?? [];
                  gVideos = allFiles['videos'] ?? [];
                  gImagesVideo = allFiles['all'] ?? [];
                },
              );
            } else {
              setState(() {
                showErrorPage = true;
              });
            }
          },
        );

        // await whatsappLogic.init(true, false, false).then((value) {
        //   setState(() {
        //     triedToGetStatusAgain11 = true;
        //   });
        //   if (whatsappLogic.gWImagesVideo.isNotEmpty) {
        //     setState(() {
        //       gImages = whatsappLogic.gWImages;
        //       gVideos = whatsappLogic.gWVideos;
        //       gImagesVideo = whatsappLogic.gWImagesVideo;
        //     });
        //   } else {
        //     setState(() {
        //       showErrorPage = true;
        //     });
        //   }
        // });
      }
    }

    if (!widget.whatsAppOptions.isWhatsApp &&
        !widget.whatsAppOptions.isStatusPage) {
      setState(() {
        globalStatusPath = whatsappLogic.whatsappBPath ?? '';
        globalStatusPath11 = whatsappLogic.whatsappBPath11 ?? '';
        gImages = whatsappLogic.gWBImages;
        gVideos = whatsappLogic.gWBVideos;
        gImagesVideo = whatsappLogic.gWBImagesVideo;
      });
      if (gImagesVideo.isEmpty) {
        setState(() {
          globalStatusPath =
              '/storage/emulated/0/WhatsApp Business/Media/.Statuses';
          globalStatusPath11 =
              '/storage/emulated/0/Android/media/com.whatsapp.w4b/WhatsApp Business/Media/.Statuses';
        });
        await GlobalFunctions()
            .getFileTypes(globalStatusPath, globalStatusPath11)
            .then((value) {
          Map<String, List<FileType>> allFiles = value;
          print(allFiles);
          if (allFiles.isNotEmpty) {
            setState(
              () {
                gImages = allFiles['images'] ?? [];
                gVideos = allFiles['videos'] ?? [];
                gImagesVideo = allFiles['all'] ?? [];
              },
            );
          } else {
            setState(() {
              showErrorPage = true;
            });
          }
        });
      }
      if (gImagesVideo.isNotEmpty) {
        setState(() {
          showErrorPage = false;
        });
      }
      if (appLogic.androidVersion! >= 30 &&
          whatsappLogic.gWBImagesVideo.isEmpty) {
        await GlobalFunctions()
            .getFileTypes(globalStatusPath, globalStatusPath11)
            .then(
          (value) {
            Map<String, List<FileType>> allFiles = value;
            if (allFiles.isNotEmpty) {
              setState(
                () {
                  gImages = allFiles['images'] ?? [];
                  gVideos = allFiles['videos'] ?? [];
                  gImagesVideo = allFiles['all'] ?? [];
                },
              );
            } else {
              setState(() {
                showErrorPage = true;
              });
            }
          },
        );
      }
    }
  }

  void onCardLongPress(File file, String path) {
    if (selectedCards.any((element) => element.path == path)) {
      setState(() {
        selectedCards.removeWhere((element) => element.path == path);
      });
    } else {
      setState(() {
        selectedCards.add(SelectedFile(file: file, path: path));
      });
    }
  }

  deleteAllSelected() {
    List<String> selectedCardsPaths = selectedCards.map((e) => e.path).toList();
    List<File> filesToDelete = [];

    List<String> toRemoveFromImages = [];
    List<String> toRemoveFromVideos = [];

    List<FileType> gInnerImages = gImages;
    List<FileType> gInnerVideos = gVideos;
    List<FileType> gInnerImagesVideo = gImagesVideo;

    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Permanently?'),
          content: Text(
              'Are you sure you want to delete ${selectedCards.length} file(s) permanently?'),
          contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 17.0),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                for (var element in gInnerImagesVideo) {
                  bool isPresent =
                      selectedCardsPaths.any((e) => e == element.file.path);

                  if (isPresent) {
                    filesToDelete.add(element.file);
                  }
                }

                for (var element in gInnerImages) {
                  bool isPresent =
                      selectedCardsPaths.any((e) => e == element.file.path);

                  if (isPresent) {
                    toRemoveFromImages.add(selectedCardsPaths
                        .firstWhere((e) => e == element.file.path));
                  }
                }

                for (var element in gInnerVideos) {
                  bool isPresent =
                      selectedCardsPaths.any((e) => e == element.file.path);

                  if (isPresent) {
                    toRemoveFromVideos.add(selectedCardsPaths
                        .firstWhere((e) => e == element.file.path));
                  }
                }
                setState(() {
                  gImages.removeWhere(
                      (e) => toRemoveFromImages.contains(e.file.path));
                  gVideos.removeWhere(
                      (e) => toRemoveFromVideos.contains(e.file.path));
                });

                if (filesToDelete.isNotEmpty) {
                  for (var element in filesToDelete) {
                    print('deleted');
                    setState(() {
                      if (element.existsSync()) {
                        element.deleteSync();
                      }
                    });
                  }
                  setState(() {
                    selectedCards.clear();
                  });
                }
                Navigator.of(context).pop();
                onDragGridDown();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  bool triedToGetStatusAgain11 = false;

  bool showErrorPage = false;

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  Future onDragGridDown() async {
    print(globalStatusPath);
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

  _onVideoTap(List<FileType> allFiles, int index, bool isImage) {
    Navigator.pushNamed(
      context,
      route.viewer,
      arguments: MultimediaViewer(
          allFiles: allFiles,
          index: index,
          isStatusPage: widget.whatsAppOptions.isStatusPage,
          isImage: isImage),
    );
  }

  Future<FileType> _handleVideoThumbnails(
      List<FileType> files, int index, bool allFilesVideo) async {
    late FileType thumbnailFile;
    var checker = files[index].videoThumbnail ?? [];
    if (checker.isEmpty) {
      if (allFilesVideo) {
        await GlobalFunctions()
            .generateVideoThumbnail(files[index].file)
            .then((value) {
          print('working');
          var imagesVideo = gImagesVideo.elementAt(index);
          gImagesVideo.removeAt(index);
          gImagesVideo.insert(
              index,
              (FileType(
                file: imagesVideo.file,
                dateTime: imagesVideo.dateTime,
                videoThumbnail: value,
              )));
          thumbnailFile = gImagesVideo.elementAt(index);
        });
      }
      if (!allFilesVideo) {
        await GlobalFunctions()
            .generateVideoThumbnail(files[index].file)
            .then((value) {
          var video = gVideos.elementAt(index);
          gVideos.removeAt(index);
          gVideos.insert(
              index,
              (FileType(
                file: video.file,
                dateTime: video.dateTime,
                videoThumbnail: value,
              )));
          thumbnailFile = gVideos.elementAt(index);
        });
      }
    } else {
      thumbnailFile = files[index];
    }
    return thumbnailFile;
  }

  Widget ImageGrid(
    File statuses,
    List<FileType> files,
    int index,
    BuildContext context,
  ) {
    Widget image = InkWell(
      onLongPress: () {
        onCardLongPress(statuses, statuses.path);
      },
      onTap: () {
        if (selectedCards.isEmpty) {
          _onVideoTap(files, index, true);
        } else {
          onCardLongPress(statuses, statuses.path);
        }
      },
      child: Image.file(statuses, height: 100, width: 100, fit: BoxFit.cover),
    );
    return Card(
      color: selectedCards.isNotEmpty
          ? selectedCards.any((element) => element.path == statuses.path)
              ? Theme.of(context).focusColor
              : Theme.of(context).appBarTheme.backgroundColor
          : Theme.of(context).appBarTheme.backgroundColor,
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
                // selectedCards.isNotEmpty
                //     ? Positioned(
                //         left: 7,
                //         top: 7,
                //         child: selectedCards
                //                 .any((element) => element.path == statuses.path)
                //             ? Icon(
                //                 Icons.check_circle,
                //                 color: Theme.of(context)
                //                     .appBarTheme
                //                     .backgroundColor,
                //               )
                //             : Icon(
                //                 Icons.circle_outlined,
                //                 color: Theme.of(context)
                //                     .appBarTheme
                //                     .backgroundColor,
                //               ),
                //       )
                //     : Container(),
              ],
            ),
          ),
          Expanded(
            child: selectedCards.isEmpty
                ? Row(
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
                  )
                : Container(),
          ),
        ],
      ),
    );
  }

  Widget VideoGrid(List<FileType> allStatuses, File statuses, int index,
      BuildContext context, bool allFilesVideo) {
    return FutureBuilder(
        future: _handleVideoThumbnails(allStatuses, index, allFilesVideo),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var snapshotData = snapshot.data as FileType;
            print(snapshotData);
            Image video = Image.memory(snapshotData.videoThumbnail!,
                height: 100, width: 100, fit: BoxFit.cover);
            return Card(
              color: selectedCards.isNotEmpty
                  ? selectedCards
                          .any((element) => element.path == statuses.path)
                      ? Theme.of(context).focusColor
                      : Theme.of(context).appBarTheme.backgroundColor
                  : Theme.of(context).appBarTheme.backgroundColor,
              child: Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onLongPress: () {
                        onCardLongPress(statuses, statuses.path);
                      },
                      onTap: () {
                        if (selectedCards.isEmpty) {
                          _onVideoTap(allStatuses, index, false);
                        } else {
                          onCardLongPress(statuses, statuses.path);
                        }
                      },
                      child: Stack(
                        children: [
                          SizedBox(
                            width: 350,
                            height: 134,
                            child: video,
                          ),
                          // selectedCards.isNotEmpty
                          //     ? Positioned(
                          //         left: 7,
                          //         top: 7,
                          //         child: selectedCards.any((element) =>
                          //                 element.path == statuses.path)
                          //             ? Icon(
                          //                 Icons.check_circle,
                          //                 color: Theme.of(context)
                          //                     .appBarTheme
                          //                     .backgroundColor,
                          //               )
                          //             : Icon(
                          //                 Icons.circle_outlined,
                          //                 color: Theme.of(context)
                          //                     .appBarTheme
                          //                     .backgroundColor,
                          //               ),
                          //       )
                          //     : Container(),
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
                    child: selectedCards.isEmpty
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                flex: 1,
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                      foregroundColor: Colors.red,
                                      fixedSize: const Size(60.0, 53.0)),
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
                                      foregroundColor: Colors.green,
                                      fixedSize: const Size(60.0, 53.0)),
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
                                            foregroundColor: Colors.red,
                                            fixedSize: const Size(60.0, 53.0)),
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
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Text('Cancel'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () async {
                                                      setState(() {
                                                        statuses.deleteSync();
                                                        allStatuses;
                                                      });
                                                      Navigator.of(context)
                                                          .pop();
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
                                          await GlobalFunctions().saveStatus(
                                              statuses.path, context);
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
                          )
                        : Container(),
                  ),
                ],
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  Widget AllStatuses(List<FileType> gImagesVideo) {
    Widget imagesVideos = Container();
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
            return VideoGrid(gImagesVideo, statuses, index, context, true);
          },
        ),
      );
    }
    if (gImagesVideo.isEmpty && checkTypes.isEmpty) {
      imagesVideos = GlobalFunctions().noStatusError(
          widget.whatsAppOptions.isWhatsApp,
          widget.whatsAppOptions.isStatusPage);
    }
    return imagesVideos;
  }

  Widget StatusVideos(List<FileType> gVideos) {
    Widget videos = Container();
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

            return VideoGrid(gVideos, statuses, index, context, false);
          },
        ),
      );
    }
    if (gVideos.isEmpty && checkTypes.isEmpty) {
      videos = GlobalFunctions().noStatusError(
          widget.whatsAppOptions.isWhatsApp,
          widget.whatsAppOptions.isStatusPage);
    }
    return videos;
  }

  Widget StatusImages(List<FileType> gImages) {
    Widget images = Container();
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
    }
    if (gImages.isEmpty && checkTypes.isEmpty) {
      print('hey');
      images = GlobalFunctions().noStatusError(
          widget.whatsAppOptions.isWhatsApp,
          widget.whatsAppOptions.isStatusPage);
    }
    return images;
  }

  PreferredSizeWidget tabBar() {
    return TabBar(
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
    );
  }

  PreferredSizeWidget selectedAppbar() {
    return AppBar(
      title: Text('${selectedCards.length} Selected'),
      foregroundColor: Colors.white,
      actions: [
        IconButton(
          onPressed: () async {
            await GlobalFunctions()
                .shareMultipleFile(selectedCards.map((e) => e.path).toList());
          },
          icon: Icon(
            Icons.share,
            color: Theme.of(context).primaryTextTheme.bodySmall?.color,
          ),
        ),
        IconButton(
          onPressed: () async {
            await GlobalFunctions()
                .shareMultipleFile(selectedCards.map((e) => e.path).toList());
          },
          icon: Icon(
            Icons.cached,
            color: Theme.of(context).primaryTextTheme.bodySmall?.color,
          ),
        ),
        widget.whatsAppOptions.isStatusPage
            ? IconButton(
                onPressed: () async {
                  await deleteAllSelected();
                },
                icon: Icon(
                  Icons.delete_forever_rounded,
                  color: Theme.of(context).primaryTextTheme.bodySmall?.color,
                ),
              )
            : IconButton(
                onPressed: () async {
                  await GlobalFunctions()
                      .saveMultipleStatuses(selectedCards, context);
                  setState(() {
                    selectedCards.clear();
                  });
                },
                icon: Icon(
                  Icons.save_alt,
                  color: Theme.of(context).primaryTextTheme.bodySmall?.color,
                ),
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
    if (appLogic.androidVersion! >= 30) {
      if (triedToGetStatusAgain11) {
        showErrorPage = true;
      }
    }
    return Scaffold(
      appBar: selectedCards.isNotEmpty ? selectedAppbar() : normalAppbar(),
      body: Container(
          margin: const EdgeInsets.all(10), child: returnFromInitCalculation()),
    );
  }
}
