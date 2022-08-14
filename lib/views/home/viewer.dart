import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'package:all_status_saver/views/home/home.dart';

class MultimediaViewer {
  final bool isImage;
  final File file;
  final String copyPath;
  final bool isStatusPage;

  MultimediaViewer({
    this.isImage = false,
    required this.file,
    required this.copyPath,
    this.isStatusPage = false,
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

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.multimediaViewer.file)
      ..initialize().then((_) {
        _controller.play();
        setState(() {});
      });
  }

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

  @override
  Widget build(BuildContext context) {
    String newPath = '/storage/emulated/0/All Status Saver/';
    // final args = ModalRoute.of(context)!.settings.arguments as MultimediaViewer;
    return Scaffold(
      appBar: AppBar(
        title: const Text(' '),
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            widget.multimediaViewer.isImage
                ? Expanded(
                    flex: 5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: ConstrainedBox(
                            constraints: BoxConstraints.loose(
                              Size.fromHeight(
                                  MediaQuery.of(context).size.height * 0.7),
                            ),
                            child: GestureDetector(
                              onDoubleTapDown: _handleDoubleTapDown,
                              onDoubleTap: _handleDoubleTap,
                              child: InteractiveViewer(
                                transformationController:
                                    _transformationController,
                                panEnabled: true,
                                boundaryMargin: const EdgeInsets.all(20),
                                minScale: 0.5,
                                maxScale: 3,
                                child: Image.file(
                                  widget.multimediaViewer.file,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : _controller.value.isInitialized
                    ? Container(
                        child: ConstrainedBox(
                          constraints: BoxConstraints.loose(
                            Size.fromHeight(
                                MediaQuery.of(context).size.height * 0.6),
                          ),
                          child: AspectRatio(
                            aspectRatio: _controller.value.aspectRatio,
                            child: VideoPlayer(_controller),
                          ),
                        ),
                      )
                    : Container(),
            !widget.multimediaViewer.isImage && _controller.value.isInitialized
                ? Expanded(
                    child: Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          children: [
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 20,
                                      right: 20,
                                    ),
                                    child:
                                        _controller.value.position.inSeconds > 9
                                            ? Text(
                                                '00:${_controller.value.position.inSeconds}',
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              )
                                            : Text(
                                                '00:0${_controller.value.position.inSeconds}',
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      right: 20,
                                      left: 20,
                                    ),
                                    child:
                                        _controller.value.duration.inSeconds > 9
                                            ? Text(
                                                '00:${_controller.value.duration.inSeconds}',
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              )
                                            : Text(
                                                '00:0${_controller.value.duration.inSeconds}',
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                  ),
                                ],
                              ),
                            ),
                            VideoProgressIndicator(
                              _controller,
                              padding: const EdgeInsets.only(
                                  top: 10.0, left: 7.0, right: 7.0),
                              allowScrubbing: true,
                              colors: const VideoProgressColors(
                                  backgroundColor: Colors.blue,
                                  playedColor: Colors.green,
                                  bufferedColor: Colors.grey),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      int seconds =
                                          _controller.value.position.inSeconds -
                                              5;
                                      setState(
                                        () {
                                          _controller.seekTo(
                                              Duration(seconds: seconds));
                                          setState(() {});
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
                                          _controller.value.position.inSeconds +
                                              5;
                                      setState(
                                        () {
                                          _controller.seekTo(
                                              Duration(seconds: seconds));
                                          setState(() {});
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
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      await const HomePage().shareFile(
                                          widget.multimediaViewer.file.path);
                                    },
                                    iconSize: 54,
                                    padding: const EdgeInsets.all(15.0),
                                    icon: const Icon(
                                      Icons.share,
                                      color: Colors.white,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      await const HomePage().shareFile(
                                          widget.multimediaViewer.file.path);
                                    },
                                    iconSize: 54,
                                    padding: const EdgeInsets.all(15.0),
                                    icon: const Icon(
                                      Icons.cached,
                                      color: Colors.white,
                                    ),
                                  ),
                                  widget.multimediaViewer.isStatusPage
                                      ? IconButton(
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
                                                          24.0,
                                                          20.0,
                                                          24.0,
                                                          17.0),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child:
                                                          const Text('Cancel'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () async {
                                                        await const HomePage()
                                                            .deleteItem(widget
                                                                .multimediaViewer
                                                                .file);
                                                      },
                                                      child:
                                                          const Text('Delete'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          iconSize: 54,
                                          padding: const EdgeInsets.all(15.0),
                                          icon: const Icon(
                                            Icons.delete_forever_rounded,
                                            color: Colors.white,
                                          ),
                                        )
                                      : IconButton(
                                          onPressed: () async {
                                            await const HomePage()
                                                .saveStatus(
                                                    newPath,
                                                    widget.multimediaViewer.file
                                                        .path,
                                                    widget.multimediaViewer
                                                        .copyPath)
                                                .then(
                                              (value) {
                                                return showDialog(
                                                  context: context,
                                                  barrierDismissible: true,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: const Text(
                                                          'Status was saved successfully'),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child:
                                                              const Text('Ok'),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                            );
                                          },
                                          iconSize: 54,
                                          padding: const EdgeInsets.all(15.0),
                                          icon: const Icon(
                                            Icons.save_alt,
                                            color: Colors.white,
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : Expanded(
                    child: Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () async {
                                await const HomePage().shareFile(
                                    widget.multimediaViewer.file.path);
                              },
                              iconSize: 54,
                              padding: const EdgeInsets.all(15.0),
                              icon: const Icon(
                                Icons.share,
                                color: Colors.white,
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                await const HomePage().shareFile(
                                    widget.multimediaViewer.file.path);
                              },
                              iconSize: 54,
                              padding: const EdgeInsets.all(15.0),
                              icon: const Icon(
                                Icons.cached,
                                color: Colors.white,
                              ),
                            ),
                            widget.multimediaViewer.isStatusPage
                                ? IconButton(
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
                                                  await const HomePage()
                                                      .deleteItem(widget
                                                          .multimediaViewer
                                                          .file);
                                                },
                                                child: const Text('Delete'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    iconSize: 54,
                                    padding: const EdgeInsets.all(15.0),
                                    icon: const Icon(
                                      Icons.delete_forever_rounded,
                                      color: Colors.white,
                                    ),
                                  )
                                : IconButton(
                                    onPressed: () async {
                                      await const HomePage()
                                          .saveStatus(
                                              newPath,
                                              widget.multimediaViewer.file.path,
                                              widget.multimediaViewer.copyPath)
                                          .then(
                                        (value) {
                                          return showDialog(
                                            context: context,
                                            barrierDismissible: true,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: const Text(
                                                    'Status was saved successfully'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Text('Ok'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                      );
                                    },
                                    iconSize: 54,
                                    padding: const EdgeInsets.all(15.0),
                                    icon: const Icon(
                                      Icons.save_alt,
                                      color: Colors.white,
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
