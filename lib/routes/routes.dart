import 'package:flutter/material.dart';

import 'package:all_status_saver/views/home/home.dart';
import 'package:all_status_saver/views/home/introduction_screen.dart';
import 'package:all_status_saver/views/whatsapp/whatsapp.dart';
import 'package:all_status_saver/views/whatsappb/whatsappb.dart';
import 'package:all_status_saver/views/saved_statuses/saved_statuses.dart';
import 'package:all_status_saver/views/home/viewer.dart';
import 'package:all_status_saver/views/home/settings.dart';

const String homePage = 'homepage';
const String introScreen = 'introScreen';
const String whatsAppPage = 'whatsapppage';
const String whatsappBPage = 'whatsappbpage';
const String savedStatusPage = 'savedStatusPage';
const String viewerB = 'viewerb';
const String viewer = 'viewer';
const String settingsP = 'settings';

Route<dynamic> controller(RouteSettings settings) {
  switch (settings.name) {
    case introScreen:
      return MaterialPageRoute(builder: (context) => IntroScreen());
    case homePage:
      return MaterialPageRoute(builder: (context) => const HomePage());
    case whatsAppPage:
      return MaterialPageRoute(builder: (context) => const WhatsappPage());
    case whatsappBPage:
      return MaterialPageRoute(builder: (context) => const WhatsappBPage());
    case savedStatusPage:
      return MaterialPageRoute(builder: (context) => const SavedStatusPage());
    case viewer:
      final args = settings.arguments as MultimediaViewer;
      final MultimediaViewer multimediaViewer;
      return MaterialPageRoute(builder: (context) {
        return Viewer(multimediaViewer: args);
      });
    case settingsP:
      return MaterialPageRoute(builder: (context) {
        return const Settings();
      });
    default:
      throw ('this route name does not exist');
  }
}
