// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'dashboard.dart';

// // Background message handler
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   print("Handling background message: ${message.messageId}");
// }

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
  
//   // Initialize Firebase Messaging
//   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  
//   // Subscribe to topic for push notifications
//   await FirebaseMessaging.instance.subscribeToTopic('trashbin_alerts');
  
//   // Request notification permissions
//   await FirebaseMessaging.instance.requestPermission(
//     alert: true,
//     badge: true,
//     sound: true,
//   );
  
//   runApp(const TrashBinApp());
// }

// class TrashBinApp extends StatelessWidget {
//   const TrashBinApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Smart Trashbin',
//       theme: ThemeData(
//         primarySwatch: Colors.green,
//         useMaterial3: true,
//         brightness: Brightness.light,
//       ),
//       darkTheme: ThemeData(
//         primarySwatch: Colors.green,
//         useMaterial3: true,
//         brightness: Brightness.dark,
//       ),
//       home: const DashboardScreen(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }
// ----------------------------------
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'dashboard.dart';

// // Background message handler
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   print("Handling background message: ${message.messageId}");
// }

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
  
//   // Set background message handler
//   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  
//   runApp(const TrashBinApp());
// }

// class TrashBinApp extends StatelessWidget {
//   const TrashBinApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Smart Trashbin',
//       theme: ThemeData(
//         primarySwatch: Colors.green,
//         useMaterial3: true,
//         brightness: Brightness.light,
//       ),
//       darkTheme: ThemeData(
//         primarySwatch: Colors.green,
//         useMaterial3: true,
//         brightness: Brightness.dark,
//       ),
//       home: const DashboardWrapper(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

// /// Wrapper widget to handle Firebase Messaging initialization safely
// class DashboardWrapper extends StatefulWidget {
//   const DashboardWrapper({super.key});

//   @override
//   _DashboardWrapperState createState() => _DashboardWrapperState();
// }

// class _DashboardWrapperState extends State<DashboardWrapper> {
//   @override
//   void initState() {
//     super.initState();
//     _setupFirebaseMessaging();
//   }

//   void _setupFirebaseMessaging() async {
//     // Subscribe to topic
//     await FirebaseMessaging.instance.subscribeToTopic('trashbin_alerts');

//     // Request permissions (Android 13+)
//     await FirebaseMessaging.instance.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//     );

//     // Optional: print FCM token for testing
//     final token = await FirebaseMessaging.instance.getToken();
//     print('FCM Token: $token');

//     // Listen for foreground messages
//     FirebaseMessaging.onMessage.listen((message) {
//       print('Foreground message received: ${message.notification?.title}');
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return const DashboardScreen();
//   }
// }


import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dashboard.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("🔔 Background message: ${message.notification?.title}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'trashbin_alerts',
    'Trashbin Alerts',
    description: 'Notifications for smart trashbin status',
    importance: Importance.max,
    enableVibration: true,
    playSound: true,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  
  runApp(const TrashBinApp());
}

class TrashBinApp extends StatelessWidget {
  const TrashBinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartBin',
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      home: const DashboardWrapper(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class DashboardWrapper extends StatefulWidget {
  const DashboardWrapper({super.key});

  @override
  _DashboardWrapperState createState() => _DashboardWrapperState();
}

class _DashboardWrapperState extends State<DashboardWrapper> {
  @override
  void initState() {
    super.initState();
    _setupFirebaseMessaging();
  }

  void _setupFirebaseMessaging() async {
    NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    
    print('✅ Permission: ${settings.authorizationStatus}');

    await FirebaseMessaging.instance.subscribeToTopic('trashbin_alerts');
    print('✅ Subscribed to: trashbin_alerts');

    final token = await FirebaseMessaging.instance.getToken();
    print('📱 FCM Token: $token');

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('🔔 Foreground message: ${message.notification?.title}');
      _showLocalNotification(message);
    });
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'trashbin_alerts',
      'Trashbin Alerts',
      channelDescription: 'Notifications for smart trashbin status',
      importance: Importance.max,
      priority: Priority.high,
      enableVibration: true,
      playSound: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title ?? '🗑️ Trashbin Alert',
      message.notification?.body ?? 'Please check your trashbin',
      notificationDetails,
    );
  }

  @override
  Widget build(BuildContext context) {
    return const DashboardScreen();
  }
}