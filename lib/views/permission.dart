import 'package:permission_handler/permission_handler.dart';

// Saf safBusiness = Saf(
//     '/storage/emulated/0/Android/media/com.whatsapp.w4b/WhatsApp Business/Media/.Statuses');

// Saf saf = Saf(
//     '/storage/emulated/0/Android/media/com.whatsapp/WhatsApp/Media/.Statuses/');

// Future<bool> requestPermission(bool isWhatsAppBusiness) async {
//   // print(safBusiness.);

//   late bool? isBusinessGranted;
//   late bool? isGranted;
//   if (isWhatsAppBusiness) {
//     isBusinessGranted =
//         await safBusiness.getDirectoryPermission(isDynamic: true);
//     // List<String>? paths = await safBusiness.getFilesPath();
//     // print('hi');
//     // print(paths);
//   } else {
//     isGranted = await saf.getDirectoryPermission(isDynamic: false);
//   }

//   if (isWhatsAppBusiness && isBusinessGranted != null && isBusinessGranted) {
//     return true;
//   } else if (!isWhatsAppBusiness && isGranted != null && isGranted) {
//     return true;
//   } else {
//     return false;
//   }
// }
Future<bool> requestPermission(List<Permission> permissions) async {
  for (var permission in permissions) {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }
  return false;
}
