import 'dart:io';
import 'package:all_status_saver/functions/global_functions.dart';
import 'package:flutter/material.dart';

import 'package:file_manager/file_manager.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_storage/environment.dart' as environment;
import 'package:shared_storage/media_store.dart' as mediaStore;

import 'package:all_status_saver/routes/routes.dart' as route;

import 'package:all_status_saver/views/WhatsAppViews/home/Viewer.dart';

class SavedStatusPage extends StatefulWidget {
  const SavedStatusPage({super.key});

  @override
  SavedStatusPageState createState() => SavedStatusPageState();
}

class SavedStatusPageState extends State<SavedStatusPage> {
  final FileManagerController controller = FileManagerController();
  final PageController _pageController = PageController(initialPage: 0);

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

  Widget noStatusError() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
            'No Status Found, You have to watch stories on WhatsApp Business or WhatsApp to make them appear here',
            textAlign: TextAlign.center),
        ElevatedButton.icon(
          onPressed: null,
          icon: const Icon(Icons.launch_rounded),
          label: const Text('OPEN PLAY STORE'),
        ),
      ],
    );
  }

  Future<void> shareFile(String path) async {
    await Share.shareFiles([path],
        text: 'how are you doing', subject: 'i hope you are doing fine');
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

    var resolver = await mediaStore
        .getMediaStoreContentDirectory(mediaStore.MediaStoreCollection.images);
    var trial = await environment.getExternalStorageDirectory();
    print('hello');
    print(trial);
    print(resolver);

    // var androidInfo = Platform.operatingSystemVersion;

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

  Widget ImageGrid(File statuses, FileType entit) {
    Widget image = InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          route.viewer,
          arguments: MultimediaViewer(
              isImage: true, file: statuses, isStatusPage: true),
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
                        fixedSize: const Size(60.0, 53.0),
                        primary: Colors.blue),
                    onPressed: () async {
                      await shareFile(statuses.path);
                    },
                    child: Column(
                      children: const [
                        Icon(Icons.share),
                        Text('SHARE'),
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
                        Text('REPOST'),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: TextButton(
                    style: TextButton.styleFrom(
                        fixedSize: const Size(60.0, 53.0), primary: Colors.red),
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
                                    entit.file.deleteSync();
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
                        Text('DELETE'),
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
                              arguments: MultimediaViewer(
                                  file: statuses, isStatusPage: true),
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
                              primary: Colors.blue),
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
                                          allStatuses[index].file.deleteSync();
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
                              Text('DELETE')
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

          if (entit.file.path.contains('.nomedia')) {
            entit.file.delete();
          }

          if (entit.file.path.contains('.jpg') ||
              entit.file.path.contains('.jpeg') ||
              entit.file.path.contains('.png')) {
            return ImageGrid(statuses, entit);
          }
          return VideoGrid(allStatuses, statuses, index);
        },
      );
    } else {
      ImagesVideos = noStatusError();
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

          if (entit.file.path.contains('.nomedia')) {
            entit.file.delete();
          }

          return VideoGrid(allVideos, statuses, index);
        },
      );
    } else {
      Videos = noStatusError();
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

          if (entit.file.path.contains('.nomedia')) {
            entit.file.delete();
          }

          return ImageGrid(statuses, entit);
        },
      );
    } else {
      Images = noStatusError();
    }
    return Images;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Statuses'),
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        child: FileManager(
          controller: controller,
          hideHiddenEntity: false,
          builder: (context, snapshot) {
            final List<FileSystemEntity> entities = snapshot;

            if (entities.isEmpty) {
              return noStatusError();
            }

            FileSystemEntity? entity;
            for (var e in entities) {
              if (FileManager.basename(e) == 'DCIM') {
                entity = e;
              }
            }
            String? path = entity?.path;
            String newPath = '$path/All Status Saver/';
            entity = Directory(newPath);

            if (!entity.existsSync()) {
              return noStatusError();
            }

            Directory content = Directory(newPath);
            List contentList =
                content.listSync(recursive: false, followLinks: false);
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
