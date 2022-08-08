import 'package:flutter/material.dart';

import 'package:all_status_saver/routes/routes.dart' as route;
import 'package:permission_handler/permission_handler.dart';

import 'package:all_status_saver/views/permission.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Status Saver'),
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () async {
                      if (await requestPermission(Permission.storage)) {
                        Navigator.pushNamed(context, route.whatsAppPage);
                      } else {
                        return;
                      }
                    },
                    child: Card(
                      child: Column(
                        children: const [
                          FlutterLogo(
                            size: 60.0,
                          ),
                          Text('WhatsApp'),
                        ],
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      if (await requestPermission(Permission.storage)) {
                        Navigator.pushNamed(context, route.whatsappBPage);
                      } else {
                        return;
                      }
                    },
                    child: Card(
                      child: Column(
                        children: const [
                          FlutterLogo(
                            size: 60.0,
                          ),
                          Text('WhatsApp Business'),
                        ],
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
                      if (await requestPermission(Permission.storage)) {
                        Navigator.pushNamed(context, route.savedStatusPage);
                      } else {
                        return;
                      }
                    },
                    label: const Text('Saved Statuses'),
                  ),
                ],
              )
            ]),
      ),
    );
  }
}
