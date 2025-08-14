// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// class PushNotificationService {
//
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//   static final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
//
//   /// ব্যাকগ্রাউন্ড মেসেজ হ্যান্ডলার
//   @pragma('vm:entry-point') // When app is background the it must need
//   static Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//
//     print("ব্যাকগ্রাউন্ড মেসেজ: ${message.messageId}");
//     print("ব্যাকগ্রাউন্ড মেসেজ: ${message.notification?.title.toString()}");
//
//     await Firebase.initializeApp();
//     await initLocalNotifications();
//     if (message.data.isNotEmpty) {
//       await PushNotificationService.showLocalNotification(
//         message.data['title'] ?? 'No Title',
//         message.data['body'] ?? 'No Body',
//       );
//     }
//   }
//
//   /// লোকাল নোটিফিকেশন ইনিশিয়ালাইজ
//   static Future<void> initLocalNotifications() async {
//     const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
//
//     const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestSoundPermission: true,
//     );
//
//     const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
//
//     await _localNotifications.initialize(initializationSettings, onDidReceiveNotificationResponse: (NotificationResponse response) async {
//           print("লোকাল নোটিফিকেশন ক্লিক করা হয়েছে");
//         });
//   }
//
//   /// লোকাল নোটিফিকেশন ডিটেইলস
//   static NotificationDetails notificationDetails() {
//     return const NotificationDetails(
//       android: AndroidNotificationDetails(
//         'default_channel',
//         'Default',
//         importance: Importance.high,
//         priority: Priority.high,
//         icon: '@mipmap/ic_launcher',
//       ),
//       iOS: DarwinNotificationDetails(),
//     );
//   }
//
//   /// লোকাল নোটিফিকেশন দেখানো
//   static Future<void> showLocalNotification(String title, String body) async {
//     await _localNotifications.show(0, title, body, notificationDetails());
//   }
//
//   /// নোটিফিকেশন পারমিশন রিকোয়েস্ট
//   Future<void> requestPermissions() async {
//     if (await Permission.notification.isDenied) {
//       await Permission.notification.request();
//     }
//     await _firebaseMessaging.requestPermission();
//   }
//
//   // ------------------Firebase Part------------------------------
//   /// Firebase Messaging ইনিশিয়ালাইজ
//   Future<void> initFirebaseMessaging() async {
//     await requestPermissions();
//
//     // ডিভাইস টোকেন পাওয়া
//     String? token = await _firebaseMessaging.getToken();
//     print("ডিভাইস টোকেন: $token");
//     // এখানে টোকেন ব্যাকএন্ডে পাঠাতে পারেন
//
//     // ফোরগ্রাউন্ড মেসেজ শোনা
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       print("ফোরগ্রাউন্ড মেসেজ: ${message.notification?.title}");
//       print("ফোরগ্রাউন্ড মেসেজ: ${message.notification?.body}");
//
//       if (message.notification != null) {
//         showLocalNotification(
//           message.notification!.title ?? 'No Title',
//           message.notification!.body ?? 'No Body',
//         );
//       }
//     });
//
//     // নোটিফিকেশন ক্লিক করলে অ্যাপ ওপেন
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       print("নোটিফিকেশন ক্লিক করা হয়েছে!");
//     });
//   }
//
//   /// সবকিছু ইনিশিয়ালাইজ
//   Future<void> init() async {
//     await initLocalNotifications();
//     await initFirebaseMessaging();
//   }
// }


import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class PushNotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  /// লোকাল নোটিফিকেশন ইনিশিয়ালাইজ
  static Future<void> initLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    await _localNotifications.initialize(initializationSettings, onDidReceiveNotificationResponse: (NotificationResponse response) async {
        print("লোকাল নোটিফিকেশন ক্লিক করা হয়েছে");
      },
    );
  }

  /// লোকাল নোটিফিকেশন ডিটেইলস
  static NotificationDetails notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'high_importance_channel', // must match manifest
        'High Importance Notifications',
        channelDescription: 'This channel is used for important notifications.', // Optional description
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  /// লোকাল নোটিফিকেশন দেখানো
  static Future<void> showLocalNotification(String title, String body) async {
    await _localNotifications.show(0, title, body, notificationDetails());
  }

  /// নোটিফিকেশন পারমিশন রিকোয়েস্ট
  Future<void> requestPermissions() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
    await _firebaseMessaging.requestPermission();
  }

  // ------------------Firebase Part------------------------------

  /// Firebase Messaging ইনিশিয়ালাইজ
  Future<void> initFirebaseMessaging() async {
    await requestPermissions();

    // ডিভাইস টোকেন পাওয়া
    String? token = await _firebaseMessaging.getToken();
    print("ডিভাইস টোকেন: $token");

    // ফোরগ্রাউন্ড মেসেজ শোনা
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("ফোরগ্রাউন্ড মেসেজ: ${message.notification?.title}");
      print("ফোরগ্রাউন্ড মেসেজ: ${message.notification?.body}");
      if (message.notification != null) {
        showLocalNotification(
          message.notification!.title ?? 'No Title',
          message.notification!.body ?? 'No Body',
        );
      }
    });

    // নোটিফিকেশন ক্লিক করলে অ্যাপ ওপেন
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("নোটিফিকেশন ক্লিক করা হয়েছে!");
    });
  }

  /// সবকিছু ইনিশিয়ালাইজ
  Future<void> init() async {
    await initLocalNotifications();
    await initFirebaseMessaging();
  }
}

/// 🛑 ব্যাকগ্রাউন্ড হ্যান্ডলার (must be top-level for AOT)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("ব্যাকগ্রাউন্ড মেসেজ: ${message.messageId}");
  print("---> ব্যাকগ্রাউন্ড Data: ${message.data}");


  print("ব্যাকগ্রাউন্ড মেসেজ শিরোনাম: ${message.data['title']}");
  print("ব্যাকগ্রাউন্ড মেসেজ শরীর: ${message.data['body'] ?? 'No Body'}");

  await Firebase.initializeApp();
  await PushNotificationService.initLocalNotifications();

  print("-->${message.data.isEmpty}");
  if (message.notification != null) {
    if (message.data.isNotEmpty) {
      await PushNotificationService.showLocalNotification(
        message.data['title'] ?? 'No Title',
        message.data['body'] ?? 'No Body',
      );
    }
    return;
  }
   // if (message.data.isNotEmpty) {
   //   await PushNotificationService.showLocalNotification(
   //     message.data['title'] ?? 'No Title',
   //     message.data['body'] ?? 'No Body',
   //   );
   // }
}


