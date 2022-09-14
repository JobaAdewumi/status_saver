import 'package:all_status_saver/helpers/storage_manager.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:saf/saf.dart';

import 'package:all_status_saver/routes/routes.dart' as route;
import 'package:permission_handler/permission_handler.dart';

import 'package:all_status_saver/views/Permissions.dart';

import 'package:all_status_saver/widgets/exit-popup.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  bool? aboveAndroid10;
  int? androidVersion;

  Saf safBusiness = Saf(
      '/storage/emulated/0/Android/media/com.whatsapp.w4b/WhatsApp Business/Media/.Statuses');

  List<Permission> permissionsNeeded = [
    Permission.storage,
    Permission.manageExternalStorage
  ];

  Future getAndroidVersion() async {
    StorageManager.readData('androidVersion').then(
      (value) async {
        if (value == null) {
          DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
          AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
          StorageManager.saveData(
              'androidVersion', androidInfo.version.sdkInt!);
          setState(() {
            androidVersion = androidInfo.version.sdkInt!;
          });
        } else {
          setState(() {
            androidVersion = value;
          });
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    androidVersion = 30;
    getAndroidVersion();
  }

  Future permissionHandler(context, route) async {
    if (androidVersion == null) {
      await getAndroidVersion();
    }
    if (androidVersion! >= 30) {
      if (await requestPermission11(context)) {
        Navigator.pushNamed(context, route);
      } else {
        return;
      }
      aboveAndroid10 = true;
    } else {
      if (await requestPermission([
        Permission.storage,
      ], context)) {
        Navigator.pushNamed(context, route);
      } else {
        return false;
      }
      aboveAndroid10 = false;
    }
  }

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
                  await permissionHandler(context, route.whatsAppPage);
                },
              ),
              ListTile(
                leading: const Icon(Icons.business),
                title: const Text('WB Status'),
                onTap: () async {
                  await permissionHandler(context, route.whatsappBPage);
                },
              ),
              androidVersion! >= 30
                  ? Container()
                  : ListTile(
                      leading: const Icon(Icons.list),
                      title: const Text('Saved Statuses'),
                      onTap: () async {
                        await permissionHandler(context, route.savedStatusPage);
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
                        await permissionHandler(context, route.whatsAppPage);
                      },
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: const [
                              Padding(
                                padding: EdgeInsets.only(bottom: 5.0),
                                child: Icon(
                                  Icons.whatsapp,
                                  size: 60.0,
                                ),
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
                        await permissionHandler(context, route.whatsappBPage);
                      },
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: const [
                              Padding(
                                padding: EdgeInsets.only(bottom: 5.0),
                                child: FlutterLogo(
                                  size: 60.0,
                                ),
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
              androidVersion! >= 30
                  ? Container()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          icon: const Icon(Icons.save_alt_outlined),
                          onPressed: () async {
                            await permissionHandler(
                                context, route.savedStatusPage);
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
