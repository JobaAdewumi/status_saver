import 'package:all_status_saver/helpers/storage_manager.dart';
import 'package:device_info_plus/device_info_plus.dart';

import 'package:all_status_saver/routes/routes.dart' as route;
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:all_status_saver/views/Permissions.dart';

import 'package:all_status_saver/widgets/exit-popup.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  bool? aboveAndroid10;
  int? androidVersion;

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

  Future permissionHandler(
      BuildContext context, route, bool isWhatsApp, bool whatsappPage) async {
    if (androidVersion == null) {
      await getAndroidVersion();
    }
    if (androidVersion! >= 30) {
      if (await requestPermission11(context)) {
        if (whatsappPage) {
          Navigator.pushNamed(context, route, arguments: isWhatsApp);
        } else {
          Navigator.pushNamed(context, route);
        }
      } else {
        return;
      }
      aboveAndroid10 = true;
    } else {
      if (await requestPermission([
        Permission.storage,
      ], context)) {
        if (whatsappPage) {
          Navigator.pushNamed(context, route, arguments: isWhatsApp);
        } else {
          Navigator.pushNamed(context, route);
        }
      } else {
        return false;
      }
      aboveAndroid10 = false;
    }
  }

  Widget homeBody() {
    var size = MediaQuery.of(context).size;
    return Column(
      children: [
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
            child: Column(
              children: [
                Container(
                  width: size.width,
                  height: 55,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: Theme.of(context).appBarTheme.backgroundColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      right: 20,
                      left: 20,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            _drawerKey.currentState!.openDrawer();
                          },
                          splashColor: Colors.grey,
                          child: Icon(
                            Icons.menu,
                            size: 25,
                            color: Theme.of(context).iconTheme.color,
                          ),
                        ),
                        Text(
                          'Status Saver',
                          style: TextStyle(
                            color: Theme.of(context)
                                .primaryTextTheme
                                .headline1!
                                .color,
                            fontSize: 23,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(width: 20, child: Container()),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Center(
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
                          await permissionHandler(
                              context, route.whatsappPage, true, true);
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
                          await permissionHandler(
                              context, route.whatsappPage, false, true);
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
                            icon: Icon(Icons.save_alt_outlined,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .color),
                            onPressed: () async {
                              await permissionHandler(
                                  context, route.savedStatusPage, false, false);
                            },
                            label: Text(
                              'Saved Statuses',
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText2!
                                      .color),
                            ),
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
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => showExitPopup(context),
      child: Scaffold(
        key: _drawerKey,
        drawer: Drawer(
          width: 280.0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                  await permissionHandler(
                      context, route.whatsappPage, true, true);
                },
              ),
              ListTile(
                leading: const Icon(Icons.business),
                title: const Text('WB Status'),
                onTap: () async {
                  await permissionHandler(
                      context, route.whatsappPage, false, true);
                },
              ),
              androidVersion! >= 30
                  ? Container()
                  : ListTile(
                      leading: const Icon(Icons.list),
                      title: const Text('Saved Statuses'),
                      onTap: () async {
                        await permissionHandler(
                            context, route.savedStatusPage, false, false);
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
        body: homeBody(),
      ),
    );
  }
}
