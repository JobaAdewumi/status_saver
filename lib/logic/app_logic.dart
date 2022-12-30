import 'package:all_status_saver/common_libs.dart';
import 'package:all_status_saver/helpers/storage_manager.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

class AppLogic {
  bool isBootstrapComplete = false;

  int? androidVersion;

  Future<void> bootstrap() async {
    await _flutterLogsInit();

    await _getPlatformDetails();

    FlutterError.onError = _handleFlutterError;

    await settingsLogic.loadTheme();

    await whatsappLogic.init();

    isBootstrapComplete = true;
  }

  void _handleFlutterError(FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    FlutterLogs.logThis(
        tag: 'Init Error',
        subTag: 'Flutter error',
        logMessage: 'Flutter error during initialization',
        errorMessage: 'Error thrown during handle flutter error initialization',
        level: LogLevel.SEVERE);
  }

  Future _flutterLogsInit() async {
    await FlutterLogs.initLogs(
      logLevelsEnabled: [
        LogLevel.INFO,
        LogLevel.WARNING,
        LogLevel.ERROR,
        LogLevel.SEVERE
      ],
      timeStampFormat: TimeStampFormat.TIME_FORMAT_READABLE,
      directoryStructure: DirectoryStructure.FOR_DATE,
      logTypesEnabled: [
        'device',
        'network',
        'errors',
      ],
      logFileExtension: LogFileExtension.LOG,
      logsWriteDirectoryName: 'DebugLogs',
      logsExportDirectoryName: 'Debug/Exported',
      debugFileOperations: true,
      isDebuggable: true,
      logSystemCrashes: true,
    );
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    FlutterLogs.logWarn(
        'Device Info',
        "Device model - ${androidInfo.model ?? ''} \n deviceId - ${androidInfo.id ?? ''} \n deviceBrand - ${androidInfo.brand ?? ''} \n deviceManufacturer - ${androidInfo.manufacturer ?? ''} \n deviceSdkInt - ${androidInfo.version.sdkInt.toString()}",
        'My Log Message');
  }

  Future _getPlatformDetails() async {
    StorageManager.readData('androidVersion').then(
      (value) async {
        if (value == null) {
          print(value);
          DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
          AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
          StorageManager.saveData(
              'androidVersion', androidInfo.version.sdkInt!);

          androidVersion = androidInfo.version.sdkInt!;
        } else {
          androidVersion = value;
        }
      },
    );
  }
}
