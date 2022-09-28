import 'package:flutter/material.dart';

import 'package:all_status_saver/routes/routes.dart' as route;

// class IntroScreen extends StatefulWidget {
//   const IntroScreen({Key? key}) : super(key: key);
//   @override
//   _IntroScreenState createState() => _IntroScreenState();
// }

class IntroScreen extends StatelessWidget {
  const IntroScreen({Key? key}) : super(key: key);
  // late String currentTheme = 'light';
  // @override
  // void initState() {
  //   super.initState();
  //   StorageManager.readData('themeMode').then(
  //     (value) {
  //       setState(
  //         () {
  //           currentTheme = value ?? 'light';
  //         },
  //       );
  //     },
  //   );
  // }

  // PageViewModel lightPage = PageViewModel(
  //   title: 'Title of first Page',
  //   body: 'This is the body of the introduction screen',
  //   image: const Center(
  //     child: FlutterLogo(size: 70.0),
  //   ),
  //   decoration: const PageDecoration(pageColor: Colors.white),
  // );

  // PageViewModel darkPage = PageViewModel(
  //   title: 'Title of first Page',
  //   body: 'This is the body of the introduction screen',
  //   image: const Center(
  //     child: FlutterLogo(size: 70.0),
  //   ),
  //   decoration: const PageDecoration(pageColor: Colors.black),
  // );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Expanded(
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: FlutterLogo(
                size: 80.0,
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.popAndPushNamed(context, route.homePage);
                  },
                  child: Text(
                    'PROCEED',
                    style: TextStyle(
                        color: Theme.of(context).textTheme.bodySmall?.color),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Consumer<ThemeNotifier>(
  //     builder: (context, theme, _) {
  //       return Scaffold(
  //         body: IntroductionScreen(
  //           showDoneButton: false,
  //           showNextButton: false,
  //           pages: [currentTheme == 'light' ? lightPage : darkPage],
  //           onChange: (e) {},
  //           onDone: () {
  //             Navigator.pushNamed(context, route.homePage);
  //           },
  //           onSkip: () {},
  //           // overrideDone: ElevatedButton(
  //           //   onPressed: () {
  //           //     Navigator.pushNamed(context, route.homePage);
  //           //   },
  //           //   child: const Text('PROCEED'),
  //           // ),
  //           globalFooter: ElevatedButton(
  //             onPressed: () {
  //               Navigator.pushNamed(context, route.homePage);
  //             },
  //             child: const Text('PROCEED'),
  //           ),
  //           dotsDecorator: DotsDecorator(
  //               size: const Size.square(24.0),
  //               color: currentTheme == 'light' ? Colors.white : Colors.black),
  //         ),
  //       );
  //     },
  //   );
  // }
}
