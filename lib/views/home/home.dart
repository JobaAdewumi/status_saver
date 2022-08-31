import 'package:flutter/material.dart';
import 'package:saf/saf.dart';

import 'package:all_status_saver/routes/routes.dart' as route;
import 'package:permission_handler/permission_handler.dart';

import 'package:all_status_saver/views/Permissions.dart';

import 'package:all_status_saver/widgets/exit-popup.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  Saf safBusiness = Saf(
      '/storage/emulated/0/Android/media/com.whatsapp.w4b/WhatsApp Business/Media/.Statuses');

  List<Permission> permissionsNeeded = [
    Permission.storage,
    Permission.manageExternalStorage
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => showExitPopup(context),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Status Saver'),
        ),
        drawer: Drawer(
          width: 280.0,
          child: ListView(
            children: [
              DrawerHeader(
                decoration:
                    BoxDecoration(color: Theme.of(context).colorScheme.primary),
                child: const FlutterLogo(),
              ),
              ListTile(
                leading: const Icon(Icons.whatsapp_rounded),
                title: const Text('WA Status'),
                onTap: () async {
                  if (await requestPermission11().then((value) {
                    print('value for android 11');
                    print(value);
                    return value;
                  })) {
                    Navigator.pushNamed(context, route.whatsAppPage);
                  } else {
                    return;
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.business),
                title: const Text('WB Status'),
                onTap: () async {
                  if (await requestPermission([Permission.storage])) {
                    Navigator.pushNamed(context, route.whatsappBPage);
                  } else {
                    return;
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.list),
                title: const Text('Saved Statuses'),
                onTap: () async {
                  if (await requestPermissionForSavedStatus().then((value) {
                    print('value for saved status');
                    print(value);
                    return value;
                  })) {
                    Navigator.pushNamed(context, route.savedStatusPage);
                  } else {
                    return;
                  }
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () {
                  Navigator.pushNamed(context, route.settingsP);
                },
              ),
            ],
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: GestureDetector(
                      onTap: () async {
                        if (await requestPermission([
                          Permission.storage,
                        ])) {
                          Navigator.pushNamed(context, route.whatsAppPage);
                        } else {
                          return;
                        }
                      },
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: const [
                              FlutterLogo(
                                size: 60.0,
                              ),
                              Text('WA STATUS'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: GestureDetector(
                      onTap: () async {
                        if (await requestPermission([Permission.storage])) {
                          Navigator.pushNamed(context, route.whatsappBPage);
                        } else {
                          return;
                        }
                      },
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: const [
                              FlutterLogo(
                                size: 60.0,
                              ),
                              Text('WB STATUS'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.save_alt_outlined),
                    onPressed: () async {
                      if (await requestPermission([Permission.storage])) {
                        Navigator.pushNamed(context, route.savedStatusPage);
                      } else {
                        return;
                      }
                    },
                    label: const Text('Saved Statuses'),
                  ),
                  // ElevatedButton.icon(
                  //   icon: const Icon(Icons.bug_report),
                  //   onPressed: () async {
                  //     if (await requestPermission(Permission.storage)) {
                  //       Navigator.pushNamed(context, route.introScreen);
                  //     } else {
                  //       return;
                  //     }
                  //   },
                  //   label: const Text('Intro Screen debug'),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
