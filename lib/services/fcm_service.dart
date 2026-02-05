import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../models/notification.dart';
import '../utils/notification_db.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Map<String, dynamic>? pendingNotificationData;

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse response) {
  if (response.payload != null) {
    pendingNotificationData = jsonDecode(response.payload!);
  }
}

/// Background message handler - dijalankan saat app terminated/background
/// PENTING: Harus di-setup di main() sebelum Firebase.initializeApp()
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('🔔 BACKGROUND/TERMINATED MESSAGE RECEIVED');
  debugPrint('🔔 title: ${message.notification?.title}');
  debugPrint('🔔 body: ${message.notification?.body}');
  debugPrint('🔔 data: ${message.data}');

  // 🔥 CRITICAL: Initialize Firebase di background isolate
  try {
    await Firebase.initializeApp();
    debugPrint('🔔 Firebase initialized in background handler');
  } catch (e) {
    debugPrint('⚠️ Firebase already initialized or failed: $e');
  }

  // Extract data
  final notification = message.notification;
  final data = Map<String, dynamic>.from(message.data);

  if (notification != null) {
    data['title'] ??= notification.title;
    data['body'] ??= notification.body;
  }

  if (data.isNotEmpty) {
    debugPrint('🔔 Saving notification to local DB from background...');

    try {
      // Save ke local DB
      final notif = LocalNotification(
        title: data['title'] ?? '-',
        description: data['body'] ?? '',
        image: data['image'],
        createdAt: DateTime.now(),
      );

      final insertedId = await NotificationDB.instance.insert(notif);
      debugPrint('🔔 Notification saved successfully, id: $insertedId');

      // Get total unread count
      final totalUnread = await NotificationDB.instance.countUnread();
      debugPrint('🔔 Total unread notifications: $totalUnread');

      // Update badge di launcher icon
      try {
        if (totalUnread > 0) {
          await FlutterAppBadger.updateBadgeCount(totalUnread);
          debugPrint('🔔 Badge updated to $totalUnread from background handler');
        } else {
          await FlutterAppBadger.removeBadge();
          debugPrint('🔔 Badge removed (count = 0)');
        }
      } catch (e) {
        debugPrint('⚠️ Failed to update badge from background: $e');
      }

      // Show local notification untuk memastikan notif muncul
      await _showBackgroundLocalNotification(data, insertedId, totalUnread);

    } catch (e) {
      debugPrint('⚠️ Failed to save notification in background: $e');
    }
  }
}

/// Helper untuk show local notification dari background handler
Future<void> _showBackgroundLocalNotification(
  Map<String, dynamic> data,
  int notifId,
  int unreadCount,
) async {
  try {
    final FlutterLocalNotificationsPlugin localNotif =
        FlutterLocalNotificationsPlugin();

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);

    await localNotif.initialize(
      settings,
      onDidReceiveNotificationResponse: notificationTapBackground,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    // Buat notification channel
    const channel = AndroidNotificationChannel(
      'billing_client_channel',
      'Billing Client Notifications',
      importance: Importance.high,
      showBadge: true,
    );

    await localNotif
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // Show notification
    final androidDetails = AndroidNotificationDetails(
      'billing_client_channel',
      'Billing Client Notifications',
      importance: Importance.max,
      priority: Priority.high,
      number: unreadCount,
      channelShowBadge: true,
    );

    await localNotif.show(
      notifId,
      data['title'],
      data['body'],
      NotificationDetails(android: androidDetails),
      payload: jsonEncode({'id': notifId, 'type': 'notification'}),
    );

    debugPrint('🔔 Local notification shown from background handler');
  } catch (e) {
    debugPrint('⚠️ Failed to show local notification from background: $e');
  }
}

class FCMService {
  FCMService._();
  static final FCMService instance = FCMService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotif =
      FlutterLocalNotificationsPlugin();

  /// Callback untuk notify saat ada notifikasi baru (update badge)
  VoidCallback? onNotificationReceived;

  /// INIT
  Future<void> init() async {
    await _requestPermission();
    await _initLocalNotification();
    await _getToken();

    FirebaseMessaging.onMessage.listen(_onForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpened);

    // 1. Cek apakah app dilaunched dari LOCAL notification (terminated)
    final launchDetails = await _localNotif.getNotificationAppLaunchDetails();
    if (launchDetails?.didNotificationLaunchApp ?? false) {
      debugPrint('🔔 App launched from LOCAL notification');
      final payload = launchDetails!.notificationResponse?.payload;
      if (payload != null) {
        final data = jsonDecode(payload);
        _handleNavigation(data);
        return; // Jangan proses lagi
      }
    }

    // 2. Cek apakah app dilaunched dari FCM notification (terminated)
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      debugPrint('🔔 App launched from FCM notification');
      final data = _extractNotificationData(initialMessage);
      _handleNavigation(data);
      return;
    }

    // 3. Cek pending data dari background tap
    if (pendingNotificationData != null) {
      debugPrint('🔔 Processing pending notification data');
      _handleNavigation(pendingNotificationData!);
      pendingNotificationData = null;
    }
  }

  /// PERMISSION
  Future<void> _requestPermission() async {
    await _messaging.requestPermission(alert: true, badge: true, sound: true);
  }

  /// TOKEN
  Future<void> _getToken() async {
    final token = await _messaging.getToken();
    debugPrint("FCM TOKEN: $token");

    // TODO: kirim ke backend (user_id + device_id)
  }

  /// LOCAL NOTIF INIT
  Future<void> _initLocalNotification() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');

    const ios = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(android: android, iOS: ios);

    await _localNotif.initialize(
      settings: settings,

      // 👉 TAP saat app foreground / background
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        debugPrint('🔔 Notification tapped! payload: ${response.payload}');
        if (response.payload != null) {
          final data = jsonDecode(response.payload!);
          _handleNavigation(data);
        }
      },

      // 👉 TAP saat app terminated (Android)
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    const channel = AndroidNotificationChannel(
      'billing_client_channel',
      'Billing Client Notifications',
      importance: Importance.high,
      showBadge: true,
    );

    await _localNotif
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  /// FOREGROUND
  void _onForegroundMessage(RemoteMessage message) async {
    debugPrint('🔔 FOREGROUND MESSAGE RECEIVED');
    debugPrint('🔔 notification: ${message.notification?.title}');
    debugPrint('🔔 data: ${message.data}');

    // Ambil data dari notification payload atau data payload
    final Map<String, dynamic> data = _extractNotificationData(message);
    debugPrint('🔔 extractedData: $data');

    if (data.isNotEmpty) {
      debugPrint('🔔 Saving to local DB...');
      final insertedId = await _saveToLocalDB(data);
      debugPrint('🔔 insertedId: $insertedId');

      if (insertedId != null) {
        int totalUnread = await NotificationDB.instance.countUnread();
        debugPrint('🔔 totalUnread: $totalUnread');
        _showLocalNotification(data, insertedId, totalUnread);
        
        // Update badge di icon launcher
        _updateBadgeCount(totalUnread);

        // Notify listener (HomePage) untuk update badge
        debugPrint('🔔 Calling onNotificationReceived callback...');
        debugPrint(
          '🔔 onNotificationReceived is null? ${onNotificationReceived == null}',
        );
        onNotificationReceived?.call();
      }
    } else {
      debugPrint('🔔 WARNING: data is empty, nothing to save');
    }
  }

  /// Extract notification data from RemoteMessage
  /// Handles both notification payload and data-only payload
  Map<String, dynamic> _extractNotificationData(RemoteMessage message) {
    final notification = message.notification;
    final data = Map<String, dynamic>.from(message.data);

    // Jika ada notification payload, gunakan title/body dari sana
    if (notification != null) {
      data['title'] ??= notification.title;
      data['body'] ??= notification.body;
    }

    return data;
  }

  Future<int?> _saveToLocalDB(Map<String, dynamic> data) async {
    final notif = LocalNotification(
      title: data['title'] ?? '-',
      description: data['body'] ?? '',
      image: data['image'],
      createdAt: DateTime.now(),
    );

    return await NotificationDB.instance.insert(notif);
  }

  /// BACKGROUND TAP
  void _onMessageOpened(RemoteMessage message) {
    debugPrint('🔔 onMessageOpenedApp triggered');
    final data = _extractNotificationData(message);
    _handleNavigation(data);
  }

  /// SHOW LOCAL
  Future<void> _showLocalNotification(
    Map<String, dynamic> data,
    int notifId,
    int unreadCount,
  ) async {
    final androidDetails = AndroidNotificationDetails(
      'billing_client_channel',
      'Billing Client Notifications',
      importance: Importance.max,
      priority: Priority.high,
      number: unreadCount,
      channelShowBadge: true,
    );

    await _localNotif.show(
      id: notifId,
      title: data['title'],
      body: data['body'],
      notificationDetails: NotificationDetails(android: androidDetails),
      payload: jsonEncode({'id': notifId, 'type': 'notification'}),
    );
  }

  Future<void> clearAllSystemNotifications() async {
    await _localNotif.cancelAll();
  }

  /// UPDATE BADGE di launcher icon
  Future<void> _updateBadgeCount(int count) async {
    try {
      if (count > 0) {
        await FlutterAppBadger.updateBadgeCount(count);
        debugPrint('🔔 Badge count updated to: $count');
      } else {
        await FlutterAppBadger.removeBadge();
        debugPrint('🔔 Badge removed');
      }
    } catch (e) {
      debugPrint('⚠️ Failed to update badge: $e');
    }
  }

  /// PUBLIC METHOD - Update badge di launcher icon
  Future<void> updateBadgeCount(int count) async {
    await _updateBadgeCount(count);
  }

  /// PUBLIC METHOD - Clear badge di launcher icon
  Future<void> clearBadge() async {
    try {
      await FlutterAppBadger.removeBadge();
      debugPrint('🔔 Badge cleared');
    } catch (e) {
      debugPrint('⚠️ Failed to clear badge: $e');
    }
  }

  /// ROUTING
  Future<void> _handleNavigation(Map<String, dynamic> data) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final nav = navigatorKey.currentState;
    if (nav == null) {
      debugPrint('Navigator not ready');
      return;
    }

    debugPrint('🔔 handleNavigation: navigating to /home');
    nav.pushNamedAndRemoveUntil('/home', (route) => false);
  }
}
