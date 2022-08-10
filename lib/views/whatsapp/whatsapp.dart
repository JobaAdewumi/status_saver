import 'dart:io';
import 'package:flutter/material.dart';

import 'package:file_manager/file_manager.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:share_plus/share_plus.dart';

import 'package:all_status_saver/routes/routes.dart' as route;

import 'package:all_status_saver/views/whatsappb/whatsappb.dart';

import 'package:all_status_saver/views/home/viewer.dart';

class WhatsappPage extends StatefulWidget {
  const WhatsappPage({super.key});

  @override
  WhatsappPageState createState() => WhatsappPageState();
}

class WhatsappPageState extends State<WhatsappPage> {
  final FileManagerController controller = FileManagerController();
  final PageController _pageController = PageController(initialPage: 0);
  final int _selectedIndex = 0;

  late List<FileType> gImages;
  late List<FileType> gVideos;
  late List<FileType> gImagesVideo;
  // @override
  // void initState() {
  //   super.initState();
  //   setState(() {});
  // }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  // static const List<Widget> _widgetOptions

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

  Future<Map<String, List<FileType>>> _getFileTypes(String path) async {
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

  Widget AllStatuses(List<FileType> allStatuses) {
    Widget ImagesVideos;
    if (allStatuses.isNotEmpty) {
      ImagesVideos = GridView.builder(
        itemCount: allStatuses.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (context, index) {
          FileType entit = allStatuses[index];

          File statuses = File(entit.file.path);

          String filenameWithExt = FileManager.basename(statuses, false);

          String newPath = '/storage/emulated/0/All Status Saver/';
          String copyPath = newPath + filenameWithExt;

          if (entit.file.path.contains('.nomedia')) {
            entit.file.delete();
          }

          if (entit.file.path.contains('.jpg') ||
              entit.file.path.contains('.jpeg') ||
              entit.file.path.contains('.png')) {
            Widget image = InkWell(
              onTap: () {
                Navigator.pushNamed(context, route.viewer,
                    arguments: MultimediaViewer(
                        isImage: true, file: statuses, copyPath: copyPath));
              },
              child: Image.file(statuses,
                  height: 100, width: 100, fit: BoxFit.cover),
            );
            return Card(
              child: Column(children: [
                SizedBox(
                  width: 350,
                  height: 134,
                  child: image,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: TextButton(
                        style: TextButton.styleFrom(
                            fixedSize: const Size(60.0, 53.0),
                            primary: Colors.red),
                        onPressed: () async {
                          await shareFile(statuses.path);
                        },
                        child: Column(
                          children: const [Icon(Icons.share), Text('SHARE')],
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
                          await shareFile(statuses.path);
                        },
                        child: Column(
                          children: const [Icon(Icons.cached), Text('REPOST')],
                        ),
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: TextButton(
                          style: TextButton.styleFrom(
                              fixedSize: const Size(60.0, 53.0)),
                          onPressed: () async {
                            await saveStatus(newPath, statuses.path, copyPath)
                                .then((value) {
                              return showDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (context) {
                                    return const AlertDialog(
                                      title:
                                          Text('Status was saved successfully'),
                                    );
                                  });
                            });
                          },
                          child: Column(
                            children: const [
                              Icon(Icons.save_alt),
                              Text('SAVE')
                            ],
                          ),
                        )),
                  ],
                )
              ]),
            );
          }
          return FutureBuilder(
              future: generateVideoThumbnail(statuses),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Image video = Image.memory(snapshot.data as dynamic,
                      height: 100, width: 100, fit: BoxFit.cover);
                  return Card(
                    child: Column(children: [
                      Stack(
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
                                Navigator.pushNamed(context, route.viewer,
                                    arguments: MultimediaViewer(
                                        file: statuses, copyPath: copyPath));
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
                      Row(
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
                                await shareFile(statuses.path);
                              },
                              child: Column(
                                children: const [
                                  Icon(Icons.share),
                                  Text('SHARE')
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
                                await shareFile(statuses.path);
                              },
                              child: Column(
                                children: const [
                                  Icon(Icons.cached),
                                  Text('REPOST')
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
                                  await saveStatus(
                                          newPath, statuses.path, copyPath)
                                      .then((value) {
                                    return showDialog(
                                        context: context,
                                        barrierDismissible: true,
                                        builder: (context) {
                                          return const AlertDialog(
                                            title: Text(
                                                'Status was saved successfully'),
                                          );
                                        });
                                  });
                                },
                                child: Column(
                                  children: const [
                                    Icon(Icons.save_alt),
                                    Text('SAVE')
                                  ],
                                ),
                              )),
                        ],
                      )
                    ]),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              });
        },
      );
    } else {
      ImagesVideos = const Center(
        child: Text(
            'No Status Found, You have to watch stories on WhatsApp Business to make them appear here'),
      );
    }
    return ImagesVideos;
  }

  Widget StatusVideos(List<FileType> allVideos) {
    Widget Videos;
    if (allVideos.isNotEmpty) {
      Videos = GridView.builder(
        itemCount: allVideos.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (context, index) {
          FileType entit = allVideos[index];

          File statuses = File(entit.file.path);

          String filenameWithExt = FileManager.basename(statuses, false);

          String newPath = '/storage/emulated/0/All Status Saver/';
          String copyPath = newPath + filenameWithExt;

          if (entit.file.path.contains('.nomedia')) {
            entit.file.delete();
          }

          return FutureBuilder(
              future: generateVideoThumbnail(statuses),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Image video = Image.memory(snapshot.data as dynamic,
                      height: 100, width: 100, fit: BoxFit.cover);
                  return Card(
                    child: Column(children: [
                      Stack(
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
                                Navigator.pushNamed(context, route.viewer,
                                    arguments: MultimediaViewer(
                                        file: statuses, copyPath: copyPath));
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
                      Row(
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
                                await shareFile(statuses.path);
                              },
                              child: Column(
                                children: const [
                                  Icon(Icons.share),
                                  Text('SHARE')
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
                                await shareFile(statuses.path);
                              },
                              child: Column(
                                children: const [
                                  Icon(Icons.cached),
                                  Text('REPOST')
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
                                  await saveStatus(
                                          newPath, statuses.path, copyPath)
                                      .then((value) {
                                    return showDialog(
                                        context: context,
                                        barrierDismissible: true,
                                        builder: (context) {
                                          return const AlertDialog(
                                            title: Text(
                                                'Status was saved successfully'),
                                          );
                                        });
                                  });
                                },
                                child: Column(
                                  children: const [
                                    Icon(Icons.save_alt),
                                    Text('SAVE')
                                  ],
                                ),
                              )),
                        ],
                      )
                    ]),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              });
        },
      );
    } else {
      Videos = const Center(
        child: Text(
            'No Status Found, You have to watch stories on WhatsApp Business to make them appear here'),
      );
    }
    return Videos;
  }

  Widget StatusImages(List<FileType> allImages) {
    Widget Images;
    if (allImages.isNotEmpty) {
      Images = GridView.builder(
        itemCount: allImages.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (context, index) {
          FileType entit = allImages[index];

          File statuses = File(entit.file.path);

          String filenameWithExt = FileManager.basename(statuses, false);

          String newPath = '/storage/emulated/0/All Status Saver/';
          String copyPath = newPath + filenameWithExt;

          if (entit.file.path.contains('.nomedia')) {
            entit.file.delete();
          }

          Widget image = InkWell(
            onTap: () {
              Navigator.pushNamed(context, route.viewer,
                  arguments: MultimediaViewer(
                      isImage: true, file: statuses, copyPath: copyPath));
            },
            child: Image.file(statuses,
                height: 100, width: 100, fit: BoxFit.cover),
          );
          return Card(
            child: Column(children: [
              SizedBox(
                width: 350,
                height: 134,
                child: image,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: TextButton(
                      style: TextButton.styleFrom(
                          fixedSize: const Size(60.0, 53.0),
                          primary: Colors.red),
                      onPressed: () async {
                        await shareFile(statuses.path);
                      },
                      child: Column(
                        children: const [Icon(Icons.share), Text('SHARE')],
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
                        await shareFile(statuses.path);
                      },
                      child: Column(
                        children: const [Icon(Icons.cached), Text('REPOST')],
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: TextButton(
                        style: TextButton.styleFrom(
                            fixedSize: const Size(60.0, 53.0)),
                        onPressed: () async {
                          await saveStatus(newPath, statuses.path, copyPath)
                              .then((value) {
                            return showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (context) {
                                  return const AlertDialog(
                                    title:
                                        Text('Status was saved successfully'),
                                  );
                                });
                          });
                        },
                        child: Column(
                          children: const [Icon(Icons.save_alt), Text('SAVE')],
                        ),
                      )),
                ],
              )
            ]),
          );
        },
      );
    } else {
      Images = const Center(
        child: Text(
            'No Status Found, You have to watch stories on WhatsApp Business to make them appear here'),
      );
    }
    return Images;
  }

  // List<Widget> pagesList = [
  //  widget1: AllStatuses(gImagesVideo),
  //   StatusImages(gImages),
  //   StatusVideos(gVideos),
  // ];

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

            late FileSystemEntity entity;
            for (var e in entities) {
              if (FileManager.basename(e) == 'WhatsApp') {
                entity = e;
              }
            }
            String? path = entity.path;
            String newPath = '$path/Media/.Statuses/';
            entity = Directory(newPath);
            Directory content = Directory(newPath);

            List contentList =
                content.listSync(recursive: false, followLinks: false);
            // print(contentList.stat())
            var images = contentList
              ..where((f) =>
                  f.path.contains('.jpg') ||
                  f.path.contains('.jpeg') ||
                  f.path.contains('.png')).toList();

            return FutureBuilder(
              future: _getFileTypes(newPath),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Map<String, List<FileType>> allFiles =
                      snapshot.data as Map<String, List<FileType>>;
                  List<FileType> images = allFiles['images']!;
                  List<FileType> videos = allFiles['videos']!;
                  List<FileType> imagesVideo = allFiles['all']!;
                  return PageView(
                    controller: _pageController,
                    scrollDirection: Axis.horizontal,
                    children: [
                      AllStatuses(imagesVideo),
                      StatusImages(images),
                      StatusVideos(videos),
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
