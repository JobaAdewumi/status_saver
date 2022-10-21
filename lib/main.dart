import 'package:all_status_saver/common_libs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_it/get_it.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:provider/provider.dart';

import 'helpers/theme_manager.dart';
import 'routes/routes.dart' as route;

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  registerSingletons();
  runApp(
    ChangeNotifierProvider<ThemeNotifier>(
      create: (_) => ThemeNotifier(),
      child: MyApp(),
    ),
  );
  await appLogic.bootstrap();

  FlutterNativeSplash.remove();
}

class MyApp extends StatelessWidget with GetItMixin {
  MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, theme, _) {
        SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
        );
        print(theme.getCurrentTheme());
        if (theme.getCurrentTheme() == 'dark') {
          SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle.dark.copyWith(
              systemNavigationBarColor: const Color.fromARGB(255, 37, 51, 63),
              systemNavigationBarDividerColor:
                  const Color.fromARGB(255, 37, 51, 63),
            ),
          );
        } else if (theme.getCurrentTheme() == 'light') {
          SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle.light.copyWith(
                systemNavigationBarColor: Colors.white,
                systemNavigationBarDividerColor: Colors.grey,
                systemNavigationBarIconBrightness: Brightness.dark),
          );
        }

        return MaterialApp(
          title: 'All Status Saver',
          theme: theme.getTheme(),
          onGenerateRoute: route.controller,
          initialRoute: route.introScreen,
        );
      },
    );
  }
}

void registerSingletons() {
  GetIt.I.registerLazySingleton<AppLogic>(() => AppLogic());

  GetIt.I.registerLazySingleton<SettingsLogic>(() => SettingsLogic());
}

AppLogic get appLogic => GetIt.I.get<AppLogic>();
SettingsLogic get settingsLogic => GetIt.I.get<SettingsLogic>();
