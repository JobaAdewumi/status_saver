import 'package:all_status_saver/helpers/storage_manager.dart';
import 'package:all_status_saver/routes/routes.dart' as route;
import 'package:all_status_saver/views/WhatsAppViews/whatsapp/whatsapp.dart';
import 'package:all_status_saver/views/permissions.dart';
import 'package:all_status_saver/widgets/exit-popup.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

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
      BuildContext context, route, WhatsAppOptions whatsAppOptions) async {
    if (androidVersion == null) {
      await getAndroidVersion();
    }
    if (androidVersion! >= 30) {
      if (await requestPermission11(context)) {
        if (!whatsAppOptions.isStatusPage) {
          Navigator.pushNamed(context, route,
              arguments:
                  WhatsAppOptions(isWhatsApp: whatsAppOptions.isWhatsApp));
        } else if (whatsAppOptions.isStatusPage) {
          Navigator.pushNamed(context, route,
              arguments: WhatsAppOptions(
                  isWhatsApp: whatsAppOptions.isWhatsApp,
                  isStatusPage: whatsAppOptions.isStatusPage));
        }
      } else {
        return;
      }
      aboveAndroid10 = true;
    } else {
      if (await requestPermission([
        Permission.storage,
      ], context)) {
        if (!whatsAppOptions.isStatusPage) {
          Navigator.pushNamed(context, route,
              arguments:
                  WhatsAppOptions(isWhatsApp: whatsAppOptions.isWhatsApp));
        } else if (whatsAppOptions.isStatusPage) {
          Navigator.pushNamed(context, route,
              arguments: WhatsAppOptions(
                  isWhatsApp: whatsAppOptions.isWhatsApp,
                  isStatusPage: whatsAppOptions.isStatusPage));
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
                              context,
                              route.whatsappPage,
                              WhatsAppOptions(
                                  isWhatsApp: true, isStatusPage: false));
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
                              context,
                              route.whatsappPage,
                              WhatsAppOptions(
                                  isWhatsApp: false, isStatusPage: false));
                        },
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 5.0),
                                  child: Image.asset(
                                    'assets/splash/logo.png',
                                    height: 60,
                                  ),
                                ),
                                const Text('WB STATUS'),
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
                                  context,
                                  route.whatsappPage,
                                  WhatsAppOptions(
                                      isWhatsApp: false, isStatusPage: true));
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
                child: Image.asset(
                  'assets/splash/logo.png',
                  height: 100,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.whatsapp_rounded),
                title: const Text('WA Status'),
                onTap: () async {
                  await permissionHandler(context, route.whatsappPage,
                      WhatsAppOptions(isWhatsApp: true, isStatusPage: false));
                },
              ),
              ListTile(
                leading: const Icon(Icons.business),
                title: const Text('WB Status'),
                onTap: () async {
                  await permissionHandler(context, route.whatsappPage,
                      WhatsAppOptions(isWhatsApp: false, isStatusPage: false));
                },
              ),
              androidVersion! >= 30
                  ? Container()
                  : ListTile(
                      leading: const Icon(Icons.list),
                      title: const Text('Saved Statuses'),
                      onTap: () async {
                        await permissionHandler(
                            context,
                            route.whatsappPage,
                            WhatsAppOptions(
                                isWhatsApp: false, isStatusPage: true));
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
