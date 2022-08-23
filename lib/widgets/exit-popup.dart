import 'dart:io';

import 'package:flutter/material.dart';

Future<bool> showExitPopup(context) async {
  return await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: SizedBox(
          height: 90,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Do you want to exit'),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        print('yes selected');
                        exit(0);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red.shade800,
                      ),
                      child: const Text('Yes'),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        print('no selected');
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(primary: Colors.white),
                      child: const Text(
                        'No',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

// Future<bool> showExitPopup(context) async {
//   return await showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return Align(
//         alignment: FractionalOffset.bottomCenter,
//         child: AlertDialog(
//           content: SizedBox(
//             height: 90,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text('Do you want to exit'),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: ElevatedButton(
//                         onPressed: () {
//                           print('yes selected');
//                           exit(0);
//                         },
//                         style: ElevatedButton.styleFrom(
//                           primary: Colors.red.shade800,
//                         ),
//                         child: const Text('Yes'),
//                       ),
//                     ),
//                     const SizedBox(
//                       width: 15,
//                     ),
//                     Expanded(
//                       child: ElevatedButton(
//                         onPressed: () {
//                           print('no selected');
//                           Navigator.of(context).pop();
//                         },
//                         style: ElevatedButton.styleFrom(primary: Colors.white),
//                         child: const Text(
//                           'No',
//                           style: TextStyle(color: Colors.black),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//     },
//   );
// }
