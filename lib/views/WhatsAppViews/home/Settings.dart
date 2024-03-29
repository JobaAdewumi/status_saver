import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:all_status_saver/helpers/storage_manager.dart';
import 'package:all_status_saver/helpers/theme_manager.dart';
import 'package:all_status_saver/routes/routes.dart' as route;

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late String currentTheme = 'light';
  @override
  void initState() {
    super.initState();
    StorageManager.readData('themeMode').then(
      (value) {
        setState(
          () {
            currentTheme = value ?? 'light';
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, theme, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Settings'),
          ),
          body: ListView(
            children: [
              ListTile(
                leading: const Icon(Icons.palette_rounded),
                title: const Text('Theme'),
                subtitle: Text('$currentTheme mode'),
                trailing: const Icon(Icons.arrow_forward_rounded),
                onTap: () async {
                  return showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor:
                            Theme.of(context).appBarTheme.backgroundColor,
                        title: const Text('Select Theme'),
                        content: DropdownButton(
                          onChanged: (String? newValue) {
                            if (newValue == 'light') {
                              setState(
                                () {
                                  currentTheme = newValue!;
                                },
                              );
                              theme.setLightMode();
                            } else if (newValue == 'dark') {
                              setState(
                                () {
                                  currentTheme = newValue!;
                                },
                              );
                              theme.setDarkMode();
                            }
                            return;
                          },
                          value: currentTheme,
                          icon: const Icon(Icons.keyboard_arrow_down_rounded),
                          items: const [
                            DropdownMenuItem(
                              value: 'light',
                              child: Text('Light Mode'),
                            ),
                            DropdownMenuItem(
                              value: 'dark',
                              child: Text('Dark Mode'),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.info_outline_rounded),
                title: const Text('Help and info'),
                onTap: () {
                  Navigator.pushNamed(context, route.helpAndInfo);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
