import 'package:flutter/material.dart';

import 'package:all_status_saver/views/home/home.dart';
import 'package:all_status_saver/views/whatsapp/whatsapp.dart';
import 'package:all_status_saver/views/whatsappb/whatsappb.dart';
import 'package:all_status_saver/views/saved_statuses/saved_statuses.dart';

const String homePage = 'homepage';
const String whatsAppPage = 'whatsapppage';
const String whatsappBPage = 'whatsappbpage';
const String savedStatusPage = 'savedStatusPage';

Route<dynamic> controller(RouteSettings settings) {
  switch (settings.name) {
    case homePage:
      return MaterialPageRoute(builder: (context) => const HomePage());
    case whatsAppPage:
      return MaterialPageRoute(builder: (context) => const WhatsappPage());
    case whatsappBPage:
      return MaterialPageRoute(builder: (context) => WhatsappBPage());
    case savedStatusPage:
      return MaterialPageRoute(builder: (context) => const SavedStatusPage());
    default:
      throw ('this route name does not exist');
  }
}
