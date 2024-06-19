import 'package:flutter_local_notifications/flutter_local_notifications.dart'; // Flutter local notifications package

/// Service for managing local notifications.
class LocalNotificationService {
  static final _flutterLocalNotifications = FlutterLocalNotificationsPlugin();

  /// Initializes the local notification service.
  static Future init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher'); // Android initialization settings
    const iOS = DarwinInitializationSettings(); // iOS initialization settings
    const settings = InitializationSettings(android: android, iOS: iOS); // Notification settings
    await _flutterLocalNotifications.initialize(settings); // Initialize the local notification plugin
  }

  /// Retrieves the notification details.
  static NotificationDetails _notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        "default_notification_channel_id", // Notification channel ID
        "default_notification_channel_id", // Notification channel name
        channelDescription: "channel description", // Channel description
        importance: Importance.max, // Importance level
        playSound: true, // Play notification sound
        icon: '@mipmap/ic_launcher', // Notification icon
        priority: Priority.max, // Notification priority
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true, // Present alert
        presentBadge: true, // Present badge
        presentSound: true, // Present sound
      ),
    );
  }

  /// Displays a local notification.
  static Future<void> showNotification({
    int id = 0, // Notification ID
    String? title, // Notification title
    String? body, // Notification body
    String? payload, // Notification payload
  }) async {
    _flutterLocalNotifications.show( // Show local notification
      0, // Notification ID
      title, // Notification title
      body, // Notification body
      _notificationDetails(), // Notification details
      payload: payload, // Notification payload
    );
  }
}
