import 'dart:io';

import 'package:all_status_saver/common_libs.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:path_provider/path_provider.dart';

class LogLogic {
  Future _exportAllLogs() async {
    await FlutterLogs.exportLogs(
      exportType: ExportType.ALL,
    );
  }

  Future getAllLogs() async {
    _exportAllLogs();
    Directory? externalDirectory = await getExternalStorageDirectory();
    Directory exportDirectory =
        Directory('${externalDirectory?.path}/DebugLogs/Debug/Exported');
    List<FileSystemEntity> dirFiles =
        exportDirectory.listSync(followLinks: false, recursive: false).toList();
    dirFiles.sort(
        ((a, b) => b.statSync().modified.compareTo(a.statSync().modified)));
    FileSystemEntity lastExportFile = dirFiles.first;

    final Email email = Email(
        body: 'debug log generated automatically',
        subject: 'Debug log',
        recipients: ['jobaadewumid@gmail.com'],
        attachmentPaths: [lastExportFile.path],
        isHTML: false);

    await FlutterEmailSender.send(email);
    await FlutterLogs.clearLogs();
  }
}
