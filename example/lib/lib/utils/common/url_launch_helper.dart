import 'dart:io';

import 'package:sample/business_logics/service/app_urls.dart';
import 'package:sample/utils/common/app_snackbar.dart';
import 'package:sample/utils/common/app_string.dart';
import 'package:sample/utils/common/print_log.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


/// add config in AndroidManifest.xml and Info.plist
class AppUrlLauncher {

  static Future<void> launchUrlFun({required String? url}) async {
    if (url == null || url.isEmpty) {
      return;
    }
    showSnackBar(success: true,message: "Please wait..");
    try {
      final Uri uri = (!url.startsWith("https")) ? Uri.parse("https://$url") : Uri.parse(url);
      await launchUrl(uri);
    } catch (e) {
      showSnackBar(success: true,message: "Error while launching url");
    }
  }
  static Future<void> openMapLaunch({
    required String latitude,
    required String longitude,
  }) async {
    try {
      String googleUrl =
          'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
      final url = Uri.parse(googleUrl);
      final isNotLaunch = await canLaunchUrl(url).whenComplete(() {});

      if (!isNotLaunch) {
        showSnackBar(
          message: AppStrings.couldNotOpenTheMap,
        );
      } else {
        await launchUrl(url).whenComplete(() {}).onError((error, stackTrace) {
          return false;
        });
      }
    } catch (e) {
      errorLog(e.toString(), fun: "openMapLaunch");
      showSnackBar(
        message: AppStrings.couldNotOpenTheMap,
        snackBarBehavior: SnackBarBehavior.floating,
      );
    }
  }

  static Future<void> openBrowserLaunch(String uri) async {
    try {
      final url =
      (!uri.startsWith("https")) ? Uri.parse("https://$uri") : Uri.parse(uri);
      final isNotLaunch = await canLaunchUrl(url).whenComplete(() {});
      if (!isNotLaunch) {
        showSnackBar(
          message: AppStrings.couldNotOpenTheBrowser,
        );
      } else {
        await launchUrl(url, webOnlyWindowName: '_self')
            .whenComplete(() {})
            .onError((error, stackTrace) {
          return false;
        });
      }
    } catch (e) {
      errorLog(e.toString(), fun: "openBrowserLaunch");
      showSnackBar(
        message: AppStrings.couldNotOpenTheBrowser,
        snackBarBehavior: SnackBarBehavior.floating,
      );
    }
  }

  static Future<void> openPhoneLaunch(String phoneNumber) async {
    try {
      final Uri url = Uri(
        scheme: 'tel',
        path: phoneNumber,
      );
      final isNotLaunch = await canLaunchUrl(url);
      if (!isNotLaunch) {
        showSnackBar(
          message: AppStrings.couldNotOpenThePhoneDialer,
        );
      } else {
        await launchUrl(url).whenComplete(() {}).onError((error, stackTrace) {
          return false;
        });
      }
    } catch (e) {
      errorLog(e.toString(), fun: "openPhoneLaunch");
      showSnackBar(
        message: AppStrings.couldNotOpenThePhoneDialer,
        snackBarBehavior: SnackBarBehavior.floating,
      );
    }
  }

  static String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
    '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  static void openEmailUrlLaunch(String email) async {
    try {
      final Uri emailLaunchUri = Uri(
        scheme: 'mailto',
        path: email,
        query: encodeQueryParameters(<String, String>{
          "subject": 'User ID :',
        }),
      );
      launchUrl(emailLaunchUri);
    } catch (e) {
      errorLog(e.toString(), fun: "launchEmailUrl");
      showSnackBar(
        message: AppStrings.couldNotOpenTheEmailBox,
        snackBarBehavior: SnackBarBehavior.floating,
      );
    }
  }

  static void openSMSLaunch(String phoneNumber,{String? message}) async {
    try {
      final Uri emailLaunchUri = Uri(
        scheme: 'sms',
        path: phoneNumber,
        queryParameters: <String, String>{
          'body': Uri.encodeComponent(message??AppEndPoint.baseUrl),
        },
      );
      launchUrl(emailLaunchUri);
    } catch (e) {
      errorLog(e.toString(), fun: "launchEmailUrl");
      showSnackBar(
        message: AppStrings.couldNotOpenTheEmailBox,
        snackBarBehavior: SnackBarBehavior.floating,
      );
    }
  }

  static Future<void> openWhatsappLaunch(String phoneNumber,{String? message}) async {
    try {
      var contact = phoneNumber;
      var value = message??AppEndPoint.baseUrl;
      FocusManager.instance.primaryFocus?.unfocus();
      var whatsappAndroid =
      Uri.parse("whatsapp://send?phone=$contact" +
          "&text=${Uri.encodeComponent(value)}");
      var whatsappIos = Uri.parse("https://wa.me/$contact/?text=${Uri.parse(value)}");

      final url=Platform.isIOS?whatsappIos:whatsappAndroid;
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
          showSnackBar(
              message: "WhatsApp is not installed on the device",
              snackBarBehavior: SnackBarBehavior.floating,
          );
      }
    } catch (e, t) {
      errorLog(e.toString() + t.toString(), fun: "_launchWhatsapp");
    }
    return;
  }
}