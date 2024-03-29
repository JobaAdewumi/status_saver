import 'package:all_status_saver/helpers/storage_manager.dart';
import 'package:flutter/foundation.dart';

class SettingsLogic {
  late final theme = ValueNotifier<String>('light');

  Future<String> get getTheme async => await loadTheme();

  Future loadTheme() async {
    await StorageManager.readData('themeMode').then((value) {
      return value;
    });
  }

  // Future saveTheme() {
  //   await  StorageManager.saveData('themeMode', ).then((value) {
  //     return value;
  //   });
  // }
}
