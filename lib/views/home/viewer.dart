import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'package:all_status_saver/views/whatsapp/whatsapp.dart';

class MultimediaViewer {
  final bool isImage;
  final File file;
  final String copyPath;

  MultimediaViewer({
    this.isImage = false,
    required this.file,
    required this.copyPath,
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

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.multimediaViewer.file)
      ..initialize().then((_) {
        _controller.play();
        setState(() {});
      });
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
                            child: InteractiveViewer(
                              panEnabled: true,
                              boundaryMargin: EdgeInsets.zero,
                              minScale: 0.5,
                              maxScale: 2,
                              child: Image.file(
                                widget.multimediaViewer.file,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : _controller.value.isInitialized
                    ? Column(
                        children: [
                          ConstrainedBox(
                            constraints: BoxConstraints.loose(Size.fromHeight(
                                MediaQuery.of(context).size.height * 0.7)),
                            child: AspectRatio(
                              aspectRatio: _controller.value.aspectRatio,
                              child: VideoPlayer(_controller),
                            ),
                          ),
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20, top: 20),
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
                                        right: 20, left: 20, top: 20),
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
                              Container(
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
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        int seconds = _controller
                                                .value.position.inSeconds -
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
                                        int seconds = _controller
                                                .value.position.inSeconds +
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
                            ],
                          ),
                        ],
                      )
                    : Container(),
            Expanded(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: Container(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () async {
                          await WhatsappPageState()
                              .shareFile(widget.multimediaViewer.file.path);
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
                          await WhatsappPageState()
                              .shareFile(widget.multimediaViewer.file.path);
                        },
                        iconSize: 54,
                        padding: const EdgeInsets.all(15.0),
                        icon: const Icon(
                          Icons.cached,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          await WhatsappPageState()
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
                                  return const AlertDialog(
                                    title:
                                        Text('Status was saved successfully'),
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
