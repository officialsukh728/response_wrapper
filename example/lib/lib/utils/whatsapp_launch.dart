// Future<void> launchWhatsapp(BuildContext context) async {
//   try {
//     var contact = "+96171556000";
//     FocusManager.instance.primaryFocus?.unfocus();
//     var whatsappAndroid =
//     Uri.parse("whatsapp://send?phone=$contact" +
//         "&text=${Uri.encodeComponent("Hello")}");
//     var whatsappIos = Uri.parse("https://wa.me/$contact/?text=${Uri.parse("Hello")}");
//
//     final url=Platform.isIOS?whatsappIos:whatsappAndroid;
//     if (await canLaunchUrl(url)) {
//       await launchUrl(url);
//     } else {
//       if (context.mounted) {
//         showSnackBar(
//             context: context,
//             message: "WhatsApp is not installed on the device",
//             snackBarBehavior: SnackBarBehavior.floating);
//       }
//     }
//   } catch (e, t) {
//     errorLog(e.toString() + t.toString(), fun: "_launchWhatsapp");
//   }
//   return;
// }