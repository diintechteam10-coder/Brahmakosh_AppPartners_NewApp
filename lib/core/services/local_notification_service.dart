import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:brahmakoshpartners/core/routes/app_pages.dart';
import 'package:brahmakoshpartners/core/services/socket/webrtc_service.dart';

/// Singleton service for showing local (on-device) notifications.
/// Supports two channels:
///   • **Messages** – normal priority, default sound
///   • **Calls**    – high priority, looping ringtone, full-screen intent
class LocalNotificationService {
  LocalNotificationService._();
  static final LocalNotificationService I = LocalNotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  // Notification IDs
  static const int _messageBaseId = 1000;
  static const int _callNotificationId = 2000;
  static const int _chatRequestNotificationId = 3000;

  // Channel IDs
  static const String _messageChannelId = 'brahmakosh_messages';
  static const String _callChannelId = 'brahmakosh_calls';
  static const String _chatRequestChannelId = 'brahmakosh_chat_requests';

  int _messageCounter = 0;

  /// Must be called once at app startup (before runApp or in main()).
  Future<void> init() async {
    // Android init settings
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    // iOS/macOS init settings
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    final initSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
      macOS: darwinSettings,
    );

    await _plugin.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create Android notification channels
    if (Platform.isAndroid) {
      final androidPlugin = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();

      if (androidPlugin != null) {
        // Request notification permission (Android 13+)
        await androidPlugin.requestNotificationsPermission();

        // Message channel
        await androidPlugin.createNotificationChannel(
          const AndroidNotificationChannel(
            _messageChannelId,
            'Chat Messages',
            description: 'Notifications for new chat messages',
            importance: Importance.high,
            playSound: true,
            enableVibration: true,
          ),
        );

        // Call channel (high priority with ringtone)
        await androidPlugin.createNotificationChannel(
          const AndroidNotificationChannel(
            _callChannelId,
            'Incoming Calls',
            description: 'Notifications for incoming voice calls',
            importance: Importance.max,
            playSound: true,
            enableVibration: true,
          ),
        );

        // Chat request channel
        await androidPlugin.createNotificationChannel(
          const AndroidNotificationChannel(
            _chatRequestChannelId,
            'Chat Requests',
            description: 'Notifications for new chat requests from users',
            importance: Importance.max,
            playSound: true,
            enableVibration: true,
          ),
        );
      }
    }

    debugPrint('🔔 [LOCAL_NOTIF] Initialized successfully');
  }

  // ──────────────────────── PUBLIC API ────────────────────────

  /// Show a notification for a new chat message.
  Future<void> showMessageNotification({
    required String conversationId,
    required String senderName,
    required String messageText,
    String? acceptedAt,
  }) async {
    _messageCounter++;
    final id = _messageBaseId + (_messageCounter % 500);

    final androidDetails = AndroidNotificationDetails(
      _messageChannelId,
      'Chat Messages',
      channelDescription: 'Notifications for new chat messages',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'New message from $senderName',
      category: AndroidNotificationCategory.message,
      groupKey: 'brahmakosh_msg_$conversationId',
      styleInformation: BigTextStyleInformation(
        messageText,
        contentTitle: senderName,
        summaryText: 'New message',
      ),
      autoCancel: true,
    );

    final darwinDetails = const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    await _plugin.show(
      id: id,
      title: senderName,
      body: messageText,
      notificationDetails: NotificationDetails(
        android: androidDetails,
        iOS: darwinDetails,
      ),
      payload: 'message|$conversationId|$acceptedAt|$senderName',
    );

    debugPrint(
      '🔔 [LOCAL_NOTIF] Message notification shown: $senderName → "$messageText"',
    );
  }

  /// Show a notification for an incoming voice call.
  Future<void> showCallNotification({
    required String conversationId,
    required String callerName,
    String? callerEmail,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      _callChannelId,
      'Incoming Calls',
      channelDescription: 'Notifications for incoming voice calls',
      importance: Importance.max,
      priority: Priority.max,
      ticker: 'Incoming call from $callerName',
      category: AndroidNotificationCategory.call,
      fullScreenIntent: true,
      ongoing: true,
      autoCancel: false,
      timeoutAfter: 60000, // 60 seconds
      actions: <AndroidNotificationAction>[
        const AndroidNotificationAction(
          'accept_call',
          'Accept',
          showsUserInterface: true,
          cancelNotification: true,
        ),
        const AndroidNotificationAction(
          'reject_call',
          'Reject',
          showsUserInterface:
              true, // true ensures app is woken up so socket can emit rejection
          cancelNotification: true,
        ),
      ],
      styleInformation: BigTextStyleInformation(
        callerEmail != null && callerEmail.isNotEmpty
            ? 'Incoming voice call\nEmail: $callerEmail'
            : 'Incoming voice call',
        contentTitle: callerName,
        summaryText: 'Tap to answer',
      ),
    );

    final darwinDetails = const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    await _plugin.show(
      id: _callNotificationId,
      title: callerName,
      body: 'Incoming voice call',
      notificationDetails: NotificationDetails(
        android: androidDetails,
        iOS: darwinDetails,
      ),
      payload: 'call|$conversationId',
    );

    debugPrint('🔔 [LOCAL_NOTIF] Call notification shown for: $callerName');
  }

  /// Dismiss the call notification (e.g., when answered or rejected).
  Future<void> dismissCallNotification() async {
    await _plugin.cancel(id: _callNotificationId);
    debugPrint('🔔 [LOCAL_NOTIF] Call notification dismissed');
  }

  /// Show a notification for a new chat request.
  Future<void> showChatRequestNotification({
    required String userName,
    String? topic,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      _chatRequestChannelId,
      'Chat Requests',
      channelDescription: 'Notifications for new chat requests from users',
      importance: Importance.max,
      priority: Priority.max,
      ticker: 'New chat request from $userName',
      category: AndroidNotificationCategory.social,
      fullScreenIntent: true,
      autoCancel: true,
      styleInformation: BigTextStyleInformation(
        topic != null && topic.isNotEmpty
            ? 'Topic: $topic'
            : 'Wants to start a consultation',
        contentTitle: '$userName wants to chat',
        summaryText: 'Chat Request',
      ),
    );

    final darwinDetails = const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    await _plugin.show(
      id: _chatRequestNotificationId,
      title: 'New Chat Request',
      body: '$userName wants to start a consultation',
      notificationDetails: NotificationDetails(
        android: androidDetails,
        iOS: darwinDetails,
      ),
      payload: 'chat_request',
    );

    debugPrint(
      '🔔 [LOCAL_NOTIF] Chat request notification shown for: $userName',
    );
  }

  /// Cancel all notifications.
  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  // ──────────────────────── PRIVATE ────────────────────────

  /// Called when the user taps on a notification.
  void _onNotificationTapped(NotificationResponse response) {
    debugPrint(
      '🔔 [LOCAL_NOTIF] Notification tapped, payload: ${response.payload}',
    );

    final payload = response.payload;
    if (payload == null || payload.isEmpty) return;

    final parts = payload.split('|');
    final type = parts[0];

    switch (type) {
      case 'message':
        if (parts.length >= 2) {
          final convId = parts[1];
          final acceptedAt = parts.length >= 3 ? parts[2] : null;
          final senderName = parts.length >= 4 ? parts[3] : null;
          Get.toNamed(
            AppPages.chatScreen,
            arguments: {
              'conversationId': convId,
              if (acceptedAt != null && acceptedAt != 'null')
                'acceptedAt': acceptedAt,
              if (senderName != null && senderName.isNotEmpty)
                'userName': senderName,
            },
          );
        }
        break;

      case 'call':
        if (response.actionId == 'accept_call') {
          WebRtcService.I.acceptCall();
          final incoming = WebRtcService.I.incomingCall;
          if (incoming != null) {
            String cName = 'User';
            if (incoming.from != null) {
              cName =
                  incoming.from!['profile']?['name']?.toString() ??
                  incoming.from!['name']?.toString() ??
                  'User';
              if (cName.contains('@')) {
                cName = cName.split('@')[0];
              }
            }
            Get.toNamed(
              AppPages.activeCallScreen,
              arguments: {
                'conversationId': incoming.conversationId,
                'callerName': cName,
              },
            );
          }
        } else if (response.actionId == 'reject_call') {
          WebRtcService.I.rejectCall();
          dismissCallNotification();
        } else {
          // Normal tap opens incoming call screen
          final incoming = WebRtcService.I.incomingCall;
          if (incoming != null) {
            Get.toNamed(AppPages.incomingCallScreen, arguments: incoming);
          }
        }
        break;

      case 'chat_request':
        // Navigate to home where the request dialog is shown
        Get.toNamed(AppPages.bottomNav);
        break;
    }
  }
}
