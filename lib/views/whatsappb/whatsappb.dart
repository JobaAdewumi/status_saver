import 'dart:io';
import 'package:flutter/material.dart';

import 'package:file_manager/file_manager.dart';

import 'package:all_status_saver/routes/routes.dart' as route;
import 'package:all_status_saver/views/home/viewer.dart';

import 'package:all_status_saver/views/home/home.dart';

import 'package:saf/saf.dart';

class WhatsappBPage extends StatefulWidget {
  const WhatsappBPage({super.key});

  @override
  WhatsappBPageState createState() => WhatsappBPageState();
}

class WhatsappBPageState extends State<WhatsappBPage> {
  final FileManagerController controller = FileManagerController();
  final PageController _pageController = PageController(initialPage: 0);
  final int _selectedIndex = 0;

  late List<FileType> gImages;
  late List<FileType> gVideos;
  late List<FileType> gImagesVideo;

  late String globalStatusPath;
  late String globalStatusPath11;

  late Saf saf;

  @override
  void initState() {
    super.initState();
    saf = Saf(
        '/storage/emulated/0/Android/media/com.whatsapp.w4b/WhatsApp Business/Media/.Statuses/');
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  Future onDragGridDown() async {
    await HomePage().getFileTypes(globalStatusPath, globalStatusPath11).then(
      (value) {
        Map<String, List<FileType>> allFiles = value;
        setState(
          () {
            List<FileType> gImages = allFiles['images']!;
            List<FileType> gVideos = allFiles['videos']!;
            List<FileType> gImagesVideo = allFiles['all']!;
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
                  Navigator.pushNamed(
                    context,
                    route.viewer,
                    arguments: MultimediaViewer(
                        isImage: true, file: statuses, copyPath: copyPath),
                  );
                },
                child: Image.file(statuses,
                    height: 100, width: 100, fit: BoxFit.cover),
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
                                  fixedSize: const Size(60.0, 53.0),
                                  primary: Colors.red),
                              onPressed: () async {
                                await HomePage().shareFile(statuses.path);
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
                                await HomePage().shareFile(statuses.path);
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
                              style: TextButton.styleFrom(
                                  fixedSize: const Size(60.0, 53.0)),
                              onPressed: () async {
                                await HomePage().saveStatus(statuses.path).then(
                                  (value) {
                                    if (value) {
                                      return ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Status was saved successfully',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          behavior: SnackBarBehavior.floating,
                                          elevation: 1,
                                          dismissDirection:
                                              DismissDirection.horizontal,
                                          duration: Duration(seconds: 1),
                                        ),
                                      );
                                    } else {
                                      return ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Error Saving Status',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          behavior: SnackBarBehavior.floating,
                                          backgroundColor: Colors.redAccent,
                                          elevation: 1,
                                          dismissDirection:
                                              DismissDirection.horizontal,
                                          duration: Duration(seconds: 1),
                                        ),
                                      );
                                    }
                                  },
                                );
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
            return FutureBuilder(
              future: HomePage().generateVideoThumbnail(statuses),
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
                                          file: statuses, copyPath: copyPath),
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
                                    await HomePage().shareFile(statuses.path);
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
                                    await HomePage().shareFile(statuses.path);
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
                                    await HomePage()
                                        .saveStatus(statuses.path)
                                        .then(
                                      (value) {
                                        if (value) {
                                          return ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Status was saved successfully',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              elevation: 1,
                                              dismissDirection:
                                                  DismissDirection.horizontal,
                                              duration: Duration(seconds: 1),
                                            ),
                                          );
                                        } else {
                                          return ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Error Saving Status',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              backgroundColor: Colors.redAccent,
                                              elevation: 1,
                                              dismissDirection:
                                                  DismissDirection.horizontal,
                                              duration: Duration(seconds: 1),
                                            ),
                                          );
                                        }
                                      },
                                    );
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

            String filenameWithExt = FileManager.basename(statuses, false);

            String newPath = '/storage/emulated/0/All Status Saver/';
            String copyPath = newPath + filenameWithExt;

            if (entit.file.path.contains('.nomedia')) {
              entit.file.delete();
            }

            return FutureBuilder(
              future: HomePage().generateVideoThumbnail(statuses),
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
                                          file: statuses, copyPath: copyPath),
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
                                    await HomePage().shareFile(statuses.path);
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
                                    await HomePage().shareFile(statuses.path);
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
                                    await HomePage()
                                        .saveStatus(statuses.path)
                                        .then(
                                      (value) {
                                        if (value) {
                                          return ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Status was saved successfully',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              elevation: 1,
                                              dismissDirection:
                                                  DismissDirection.horizontal,
                                              duration: Duration(seconds: 1),
                                            ),
                                          );
                                        } else {
                                          return ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Error Saving Status',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              backgroundColor: Colors.redAccent,
                                              elevation: 1,
                                              dismissDirection:
                                                  DismissDirection.horizontal,
                                              duration: Duration(seconds: 1),
                                            ),
                                          );
                                        }
                                      },
                                    );
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

            String filenameWithExt = FileManager.basename(statuses, false);

            String newPath = '/storage/emulated/0/All Status Saver/';
            String copyPath = newPath + filenameWithExt;

            if (entit.file.path.contains('.nomedia')) {
              entit.file.delete();
            }

            Widget image = InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  route.viewer,
                  arguments: MultimediaViewer(
                      isImage: true, file: statuses, copyPath: copyPath),
                );
              },
              child: Image.file(statuses,
                  height: 100, width: 100, fit: BoxFit.cover),
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
                                primary: Colors.red),
                            onPressed: () async {
                              await HomePage().shareFile(statuses.path);
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
                              await HomePage().shareFile(statuses.path);
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
                            style: TextButton.styleFrom(
                              fixedSize: const Size(60.0, 53.0),
                            ),
                            onPressed: () async {
                              await HomePage().saveStatus(statuses.path).then(
                                (value) {
                                  if (value) {
                                    return ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Status was saved successfully',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        behavior: SnackBarBehavior.floating,
                                        elevation: 1,
                                        dismissDirection:
                                            DismissDirection.horizontal,
                                        duration: Duration(seconds: 1),
                                      ),
                                    );
                                  } else {
                                    return ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Error Saving Status',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        behavior: SnackBarBehavior.floating,
                                        backgroundColor: Colors.redAccent,
                                        elevation: 1,
                                        dismissDirection:
                                            DismissDirection.horizontal,
                                        duration: Duration(seconds: 1),
                                      ),
                                    );
                                  }
                                },
                              );
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
          },
        ),
      );
    } else {
      images = noStatusError();
    }
    return images;
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

            if (entities.isEmpty) {
              return noStatusError();
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

            String? path = entity?.path ?? '';
            String newPath = '$path/Media/.Statuses/';
            globalStatusPath = newPath;
            entity = Directory(newPath);
            Directory content = Directory(newPath);

            String? path11 = entity11?.path ?? '';
            String newPath11 =
                '$path11/media/com.whatsapp.w4b/WhatsApp Business/Media/.Statuses/';
            print(newPath11);
            entity11 = Directory(newPath);
            Directory content11 = Directory(newPath);

            // List<String>? paths = await saf.getFilesPath();

            if (!entity.existsSync() && !entity11.existsSync()) {
              return noStatusError();
            }

            globalStatusPath = newPath;
            globalStatusPath11 = newPath11;

            List contentList =
                content.listSync(recursive: false, followLinks: false);
            // print(contentList.stat())
            var images = contentList
              ..where((f) =>
                  f.path.contains('.jpg') ||
                  f.path.contains('.jpeg') ||
                  f.path.contains('.png')).toList();

            return FutureBuilder(
              future: HomePage().getFileTypes(newPath, newPath11),
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
