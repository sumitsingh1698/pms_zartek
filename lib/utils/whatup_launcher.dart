import 'dart:io';

String urlWhatup({String phone, String message}) {
  if (Platform.isAndroid) {
    // add the [https]
    return "https://wa.me/$phone/?text=${Uri.parse(message)}"; // new line
    // } else {
    //   // add the [https]
    //   return "https://api.whatsapp.com/send?phone=$phone=${Uri.parse(message)}"; // new line
    // }
  }
}
