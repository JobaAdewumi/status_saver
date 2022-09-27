import 'package:all_status_saver/views/Permissions.dart';
import 'package:all_status_saver/views/WhatsAppViews/home/HelpAndInfo.dart';
import 'package:flutter/material.dart';

import 'package:all_status_saver/views/WhatsAppViews/home/Home.dart';
import 'package:all_status_saver/views/WhatsAppViews/home/IntroductionScreen.dart';
import 'package:all_status_saver/views/WhatsAppViews/whatsapp/Whatsapp.dart';
import 'package:all_status_saver/views/WhatsAppViews/whatsappb/WhatsappB.dart';
import 'package:all_status_saver/views/WhatsAppViews/saved_statuses/SavedStatuses.dart';
import 'package:all_status_saver/views/WhatsAppViews/home/Viewer.dart';
import 'package:all_status_saver/views/WhatsAppViews/home/Settings.dart';

const String homePage = 'homepage';
const String introScreen = 'introScreen';
const String whatsAppPage = 'whatsapppage';
const String whatsappBPage = 'whatsappbpage';
const String savedStatusPage = 'savedStatusPage';
const String viewer = 'viewer';
const String settingsP = 'settings';
const String android11Screen = 'android11Screen';
const String helpAndInfo = 'helpAndInfo';

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
    case helpAndInfo:
      return MaterialPageRoute(builder: (context) {
        return const HelpAndInfo();
      });

    default:
      throw ('this route name does not exist');
  }
}
