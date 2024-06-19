import 'dart:io'; // For platform-specific operations
import 'package:firebase_core/firebase_core.dart'; // Firebase core functionality
import 'package:firebase_messaging/firebase_messaging.dart'; // Firebase Cloud Messaging (FCM)
import 'package:flutter/cupertino.dart'; // Cupertino widgets
import 'package:sample/business_logics/service/notification/local_notification_api.dart'; // Local notification service
import 'package:sample/utils/common/print_log.dart'; // Logging utility

/// Service for managing push notifications.
class NotificationService {
  /// Initializes the notification service.
  static init() async {
    if (Platform.isIOS) {
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
      await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );
    }

    /// Listens for incoming messages when the app is in the foreground.
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        infoLog(message.toMap(), fun: "onMessage");
        if(Platform.isAndroid) {
          LocalNotificationService.showNotification(
            title: message.notification?.title,
            body: message.notification?.body);
        }
        manageApiAndDialogOnNotification(message);
      },
    );

    /// Listens for incoming messages when the app is in the background.
    FirebaseMessaging.onBackgroundMessage(backgroundHandler);

    /// Listens for incoming messages when the app is active and the user taps on the notification.
    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) {
        infoLog(message.toMap(), fun: "onMessageOpenedApp");
        manageApiAndDialogOnNotification(message);
      },
    );

    /// Initializes Firebase messaging and retrieves the FCM token.
    FirebaseMessaging.instance
        .getToken()
        .then((value) => printLog(fun: "FCM Token", value));
  }
}

void manageApiAndDialogOnNotification(RemoteMessage message) {
}

/// Background handler for processing incoming messages when the app is in the background.
@pragma('vm:entry-point')
Future<void> backgroundHandler(RemoteMessage message) async {
  debugPrint("Received notification: ${message.data}");
  infoLog(message.toMap(), fun: "backgroundHandler");
  try {
    manageApiAndDialogOnNotification(message);
    await Firebase.initializeApp();
  } catch (e, t) {
    errorLog(e.toString() + t.toString(), fun: "backgroundHandler");
  }
}
