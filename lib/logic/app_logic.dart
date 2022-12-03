import 'package:all_status_saver/common_libs.dart';
import 'package:all_status_saver/helpers/storage_manager.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

class AppLogic {
  bool isBootstrapComplete = false;

  int? androidVersion;

  Future<void> bootstrap() async {
    FlutterError.onError = _handleFlutterError;

    await _getPlatformDetails();

    await settingsLogic.loadTheme();

    await whatsappLogic.init();

    isBootstrapComplete = true;
  }

  void _handleFlutterError(FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
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
