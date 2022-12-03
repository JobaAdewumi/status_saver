import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HelpAndInfo extends StatelessWidget {
  HelpAndInfo({Key? key}) : super(key: key);

  String applicationVersion = '2.3.0';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(' '),
        foregroundColor: Colors.white,
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          ListView(
            // crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Image.asset(
                  'assets/splash/logo.png',
                  height: 100,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  'All Status Saver',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 19),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 7),
                child: Text(
                  applicationVersion,
                  textAlign: TextAlign.center,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 20),
                child: Divider(),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 15, left: 20),
                child: Text(
                  'Changelog',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 30),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 15, left: 20),
                child: Text(
                  '+ Hold to select added in recent statuses page',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 15),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 15, left: 20),
                child: Text(
                  '+ Added splash screen',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 15),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 15, left: 20),
                child: Text(
                  '+ Created new icon for app',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 15),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 15, left: 20),
                child: Text(
                  '+ UI and UX improvements',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 15),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 15, left: 20),
                child: Text(
                  '+ Added a scroll view in images and video player',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 15),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 15, left: 20),
                child: Text(
                  '+ Added tab for scrolling between all statuses or only video or image',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 15),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 15, left: 20),
                child: Text(
                  '+ Performance improvements',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 15),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 15, left: 20),
                child: Text(
                  '+ Swipe down in viewer to exit',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ],
          ),
          Positioned(
            child: Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ListTile(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    showLicensePage(
                        context: context,
                        applicationName: 'All Status Saver',
                        applicationLegalese: 'Copyright (c) 2022 Joba Adewumi',
                        applicationVersion: applicationVersion);
                  },
                  tileColor: Theme.of(context).appBarTheme.backgroundColor,
                  title: const Text(
                    'View licenses',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
