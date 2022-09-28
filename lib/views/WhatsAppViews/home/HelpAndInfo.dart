import 'package:flutter/material.dart';

class HelpAndInfo extends StatelessWidget {
  const HelpAndInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(' '),
        foregroundColor: Colors.white,
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        // crossAxisAlignment: CrossAxisAlignment.center,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: FlutterLogo(
              size: 95,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              'All Status Saver',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 19),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 7),
            child: Text(
              '2.2.0 build4',
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Divider(),
          ),
          Padding(
            padding: EdgeInsets.only(top: 15, left: 20),
            child: Text(
              'Changelog',
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 30),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 15, left: 20),
            child: Text(
              '+ UI and UX improvements',
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 15),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 15, left: 20),
            child: Text(
              '+ Now using Material 3 design',
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 15),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 15, left: 20),
            child: Text(
              '+ Added a scroll view in images and video player',
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 15),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 15, left: 20),
            child: Text(
              '+ Added tab for scrolling between all statuses or only video or image',
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 15),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 15, left: 20),
            child: Text(
              '+ Performance improvements',
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}
