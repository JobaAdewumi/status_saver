import 'dart:async';

import 'package:all_status_saver/functions/global_functions.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'package:all_status_saver/routes/routes.dart' as route;

class MultimediaViewer {
  final bool isImage;
  final int index;
  final bool isStatusPage;
  final List<FileType> allFiles;

  MultimediaViewer({
    this.isImage = false,
    required this.index,
    this.isStatusPage = false,
    required this.allFiles,
  });
}

class Viewer extends StatefulWidget {
  final MultimediaViewer multimediaViewer;
  const Viewer({Key? key, required this.multimediaViewer}) : super(key: key);
  @override
  _ViewerState createState() => _ViewerState();
}

class _ViewerState extends State<Viewer> {
  late VideoPlayerController _controller;
  final _transformationController = TransformationController();
  late TapDownDetails _doubleTapDetails;

  late PageController _pageController;

  late int globalIndex;

  bool controlInView = true;

  Timer scheduleTimeout([int seconds = 3]) =>
      Timer(Duration(seconds: seconds), handleTimeout);

  void handleTimeout() {
    setState(
      () {
        controlInView = false;
      },
    );
  }

  onVideoTap() {
    setState(
      () {
        controlInView = true;
      },
    );
    scheduleTimeout();
  }

  @override
  void initState() {
    super.initState();
    _pageController =
        PageController(initialPage: widget.multimediaViewer.index);

    globalIndex = widget.multimediaViewer.index;

    _controller = VideoPlayerController.file(
        widget.multimediaViewer.allFiles[widget.multimediaViewer.index].file)
      ..initialize().then((_) {
        scheduleTimeout();

        setState(() {});
      });
  }

  initializeVideo(int index) {
    _controller = VideoPlayerController.file(
      widget.multimediaViewer.allFiles[index].file,
    )..initialize().then((_) {
        scheduleTimeout();
        setState(() {
          if (_controller.value.isInitialized) {
            _controller.play();
          }
        });
      });
  }

  // saveStatus(String statusPath) async {
  //   await GlobalFunctions().saveStatus(statusPath).then(
  //     (value) {
  //       bool check = value == null
  //           ? false
  //           : value == true
  //               ? true
  //               : false;
  //       if (check) {
  //         return ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(
  //             content: Text(
  //               'Status was saved successfully',
  //               style: TextStyle(color: Colors.white),
  //             ),
  //             behavior: SnackBarBehavior.floating,
  //             elevation: 1,
  //             dismissDirection: DismissDirection.horizontal,
  //             duration: Duration(milliseconds: 400),
  //           ),
  //         );
  //       } else {
  //         return ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(
  //             content: Text(
  //               'Error Saving Status',
  //               style: TextStyle(color: Colors.white),
  //             ),
  //             behavior: SnackBarBehavior.floating,
  //             backgroundColor: Colors.redAccent,
  //             elevation: 1,
  //             dismissDirection: DismissDirection.horizontal,
  //             duration: Duration(milliseconds: 400),
  //           ),
  //         );
  //       }
  //     },
  //   );
  // }

  void _handleDoubleTapDown(TapDownDetails details) {
    _doubleTapDetails = details;
  }

  void _handleDoubleTap() {
    if (_transformationController.value != Matrix4.identity()) {
      _transformationController.value = Matrix4.identity();
    } else {
      final position = _doubleTapDetails.localPosition;

      // _transformationController.value = Matrix4.identity()
      //   ..translate(-position.dx * 2, -position.dy * 2)
      //   ..scale(3.0);
      // For a 2x zoom
      _transformationController.value = Matrix4.identity()
        ..translate(-position.dx, -position.dy)
        ..scale(2.0);
    }
  }

  removeScale() {
    _transformationController.value = Matrix4.identity();
  }

  Widget ImageViewer(int index) {
    return Center(
      child: GestureDetector(
        onDoubleTapDown: _handleDoubleTapDown,
        onDoubleTap: _handleDoubleTap,
        child: InteractiveViewer(
          transformationController: _transformationController,
          panEnabled: true,
          boundaryMargin: EdgeInsets.zero,
          minScale: 0.5,
          maxScale: 3,
          child: Image.file(
            widget.multimediaViewer.allFiles[index].file,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget VideoViewer(int index) {
    return Stack(
      children: [
        Center(
          child: GestureDetector(
            onTap: onVideoTap,
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),
          ),
        ),
        controlInView == true
            ? Positioned(
                bottom: 0.0,
                left: 0.0,
                right: 0.0,
                child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 20,
                                right: 20,
                              ),
                              child: _controller.value.position.inSeconds > 9
                                  ? Text(
                                      '00:${_controller.value.position.inSeconds}',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    )
                                  : Text(
                                      '00:0${_controller.value.position.inSeconds}',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                right: 20,
                                left: 20,
                              ),
                              child: _controller.value.duration.inSeconds > 9
                                  ? Text(
                                      '00:${_controller.value.duration.inSeconds}',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    )
                                  : Text(
                                      '00:0${_controller.value.duration.inSeconds}',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                            ),
                          ],
                        ),
                        ConstrainedBox(
                          constraints: BoxConstraints.loose(
                            Size.fromHeight(
                                MediaQuery.of(context).size.width * 0.7),
                          ),
                          child: VideoProgressIndicator(
                            _controller,
                            padding: const EdgeInsets.only(
                                top: 10.0, left: 7.0, right: 7.0),
                            allowScrubbing: true,
                            colors: const VideoProgressColors(
                                backgroundColor: Colors.blue,
                                playedColor: Colors.green,
                                bufferedColor: Colors.grey),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {
                                int seconds =
                                    _controller.value.position.inSeconds - 5;
                                setState(
                                  () {
                                    _controller
                                        .seekTo(Duration(seconds: seconds));
                                  },
                                );
                              },
                              icon: const Icon(
                                Icons.fast_rewind_rounded,
                                color: Colors.white,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(
                                  () {
                                    _controller.value.isPlaying
                                        ? _controller.pause()
                                        : _controller.play();
                                  },
                                );
                              },
                              icon: Icon(
                                _controller.value.isPlaying
                                    ? Icons.pause
                                    : Icons.play_arrow,
                                color: Colors.white,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                int seconds =
                                    _controller.value.position.inSeconds + 5;
                                setState(
                                  () {
                                    _controller
                                        .seekTo(Duration(seconds: seconds));
                                  },
                                );
                              },
                              icon: const Icon(
                                Icons.fast_forward_rounded,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : Container()
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(' '),
        foregroundColor: Colors.white,
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.black,
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.multimediaViewer.allFiles.length,
        allowImplicitScrolling: false,
        onPageChanged: (int i) {
          globalIndex = i;
          _controller.pause();
          if (!widget.multimediaViewer.allFiles[i].isImage) {
            initializeVideo(i);
          }
          if (widget.multimediaViewer.allFiles[i].isImage) {
            removeScale();
          }
        },
        itemBuilder: (context, index) {
          if (widget.multimediaViewer.allFiles[index].isImage) {
            return ImageViewer(index);
          } else if (!widget.multimediaViewer.allFiles[index].isImage &&
              _controller.value.isInitialized) {
            // if (_controller.value.isPlaying) {
            //   _controller.pause();
            // } else {
            //   _controller.play();
            // }
            return VideoViewer(index);
          } else {
            // return const Center(
            //   child: Text('hiiii'),
            // );
            return Container();
          }
        },
      ),
      persistentFooterButtons: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 15,
                right: 15,
              ),
              child: IconButton(
                onPressed: () async {
                  await GlobalFunctions().shareFile(
                      widget.multimediaViewer.allFiles[globalIndex].file.path);
                },
                iconSize: 35,
                padding: const EdgeInsets.all(15.0),
                icon: const Icon(
                  Icons.share,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 15,
                right: 15,
              ),
              child: IconButton(
                onPressed: () async {
                  await GlobalFunctions().shareFile(
                      widget.multimediaViewer.allFiles[globalIndex].file.path);
                },
                iconSize: 35,
                padding: const EdgeInsets.all(15.0),
                icon: const Icon(
                  Icons.cached,
                  color: Colors.white,
                ),
              ),
            ),
            widget.multimediaViewer.isStatusPage
                ? Padding(
                    padding: const EdgeInsets.only(
                      left: 15,
                      right: 15,
                    ),
                    child: IconButton(
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
                                    await GlobalFunctions().deleteItem(widget
                                        .multimediaViewer
                                        .allFiles[globalIndex]
                                        .file);
                                    Navigator.of(context)
                                      ..pop()
                                      ..pop()
                                      ..pop()
                                      ..pushNamed(route.savedStatusPage);
                                  },
                                  child: const Text('Delete'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      iconSize: 35,
                      padding: const EdgeInsets.all(15.0),
                      icon: const Icon(
                        Icons.delete_forever_rounded,
                        color: Colors.white,
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(
                      left: 15,
                      right: 15,
                    ),
                    child: IconButton(
                      onPressed: () async {
                        await GlobalFunctions().saveStatus(
                            widget.multimediaViewer.allFiles[globalIndex].file
                                .path,
                            context);
                      },
                      iconSize: 35,
                      padding: const EdgeInsets.all(15.0),
                      icon: const Icon(
                        Icons.save_alt,
                        color: Colors.white,
                      ),
                    ),
                  ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
