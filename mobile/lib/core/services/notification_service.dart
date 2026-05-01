import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;

import '../utils/environment.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin = 
      FlutterLocalNotificationsPlugin();
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static StreamController<RemoteMessage>? _messageStreamController;
  
  static Future<void> initialize() async {
    if (!Environment.notificationsEnabled) return;
    
    try {
      // Initialize local notifications
      const AndroidInitializationSettings androidSettings = 
          AndroidInitializationSettings('@mipmap/ic_launcher');
      
      const DarwinInitializationSettings iosSettings = 
          DarwinInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true,
          );
      
      const InitializationSettings settings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );
      
      await _notificationsPlugin.initialize(
        settings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );
      
      // Initialize Firebase messaging
      await _initializeFirebaseMessaging();
      
    } catch (e) {
      debugPrint('Error initializing notifications: $e');
    }
  }
  
  static Future<void> _initializeFirebaseMessaging() async {
    // Request permission
    final settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      debugPrint('User granted provisional permission');
    } else {
      debugPrint('User declined or has not accepted permission');
      return;
    }
    
    // Get token
    final token = await _firebaseMessaging.getToken();
    debugPrint('FCM Token: $token');
    
    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    
    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    
    // Handle message when app opens from notification
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);
    
    // Check for initial message
    final initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _handleMessageOpenedApp(initialMessage);
    }
  }
  
  static void _handleForegroundMessage(RemoteMessage message) {
    debugPrint('Received foreground message: ${message.messageId}');
    
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    
    if (notification != null && android != null) {
      _showLocalNotification(
        id: notification.hashCode,
        title: notification.title ?? 'DuoDay',
        body: notification.body ?? '',
        payload: message.data.toString(),
      );
    }
    
    // Add to stream for UI updates
    _messageStreamController?.add(message);
  }
  
  static void _handleMessageOpenedApp(RemoteMessage message) {
    debugPrint('Message opened app: ${message.messageId}');
    // Handle navigation based on message data
    _messageStreamController?.add(message);
  }
  
  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    debugPrint('Handling background message: ${message.messageId}');
  }
  
  static void _onNotificationTapped(NotificationResponse response) {
    debugPrint('Notification tapped: ${response.payload}');
    // Handle notification tap navigation
  }
  
  static Future<void> _showLocalNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'duoday_channel',
      'DuoDay Notifications',
      channelDescription: 'Notifications from DuoDay app',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );
    
    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    await _notificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }
  
  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    if (!Environment.notificationsEnabled) return;
    
    await _showLocalNotification(
      id: id,
      title: title,
      body: body,
      payload: payload,
    );
  }
  
  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? payload,
  }) async {
    if (!Environment.notificationsEnabled) return;
    
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'duoday_channel',
      'DuoDay Notifications',
      channelDescription: 'Notifications from DuoDay app',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );
    
    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
  }
  
  static Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }
  
  static Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }
  
  static Future<String?> getFCMToken() async {
    return await _firebaseMessaging.getToken();
  }
  
  static Stream<RemoteMessage>? get messageStream {
    _messageStreamController ??= StreamController<RemoteMessage>.broadcast();
    return _messageStreamController?.stream;
  }
  
  static Future<void> requestPermissions() async {
    // Request notification permissions
    await Permission.notification.request();
    
    // Request iOS permissions
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }
  
  static Future<bool> areNotificationsEnabled() async {
    final settings = await _firebaseMessaging.getNotificationSettings();
    return settings.authorizationStatus == AuthorizationStatus.authorized ||
           settings.authorizationStatus == AuthorizationStatus.provisional;
  }
}
