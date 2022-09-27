import 'dart:io';

import 'package:all_status_saver/functions/global_functions.dart';
import 'package:all_status_saver/views/WhatsAppViews/home/Viewer.dart';
import 'package:flutter/material.dart';
import 'package:all_status_saver/routes/routes.dart' as route;

class GlobalWidgets {
  // saveStatus(String statusPath, BuildContext context) async {
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
                Expanded(
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
                      Expanded(
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
}
