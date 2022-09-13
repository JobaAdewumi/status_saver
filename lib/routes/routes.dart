import 'package:all_status_saver/views/Permissions.dart';
import 'package:flutter/material.dart';

import 'package:all_status_saver/views/home/Home.dart';
import 'package:all_status_saver/views/home/IntroductionScreen.dart';
import 'package:all_status_saver/views/whatsapp/Whatsapp.dart';
import 'package:all_status_saver/views/whatsappb/WhatsappB.dart';
import 'package:all_status_saver/views/saved_statuses/SavedStatuses.dart';
import 'package:all_status_saver/views/home/Viewer.dart';
import 'package:all_status_saver/views/home/Settings.dart';

const String homePage = 'homepage';
const String introScreen = 'introScreen';
const String whatsAppPage = 'whatsapppage';
const String whatsappBPage = 'whatsappbpage';
const String savedStatusPage = 'savedStatusPage';
const String viewer = 'viewer';
const String settingsP = 'settings';
const String android11Screen = 'android11Screen';

Route<dynamic> controller(RouteSettings settings) {
  switch (settings.name) {
    case introScreen:
      return MaterialPageRoute(builder: (context) => const IntroScreen());
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
    case android11Screen:
      return MaterialPageRoute(builder: (context) {
        return const Android11PermissionDialog();
      });
    default:
      throw ('this route name does not exist');
  }
}
