import 'package:all_status_saver/views/permissions.dart';
import 'package:all_status_saver/views/WhatsAppViews/whatsapp/whatsapp.dart';
import 'package:all_status_saver/views/WhatsAppViews/home/help_and_info.dart';

import 'package:flutter/material.dart';

import 'package:all_status_saver/views/WhatsAppViews/home/home.dart';
import 'package:all_status_saver/views/WhatsAppViews/home/introduction_screen.dart';
import 'package:all_status_saver/views/WhatsAppViews/home/viewer.dart';
import 'package:all_status_saver/views/WhatsAppViews/home/settings.dart';

const String homePage = 'homepage';
const String introScreen = 'introScreen';
const String whatsappPage = 'whatsapppage';
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
    case whatsappPage:
      final args = settings.arguments as WhatsAppOptions;
      return MaterialPageRoute(builder: (context) {
        return WhatsApp(whatsAppOptions: args);
      });

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
        return HelpAndInfo();
      });

    default:
      throw ('this route name does not exist');
  }
}
