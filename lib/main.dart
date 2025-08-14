// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:push_notification_app/notification.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//
//   // ব্যাকগ্রাউন্ড মেসেজ হ্যান্ডলার সেট করা
//   FirebaseMessaging.onBackgroundMessage(FirebaseNotificationServices.firebaseMessagingBackgroundHandler);
//
//   runApp(MyApp());
// }
//
// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   final FirebaseNotificationServices _notificationService = FirebaseNotificationServices();
//
//   @override
//   void initState() {
//     super.initState();
//     _notificationService.initNotifications();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         body: Center(
//           child: Text('Push Notification Setup Complete'),
//         ),
//       ),
//     );
//   }
// }



// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:push_notification_app/push_notification.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//
//   // ব্যাকগ্রাউন্ড হ্যান্ডলার
//   FirebaseMessaging.onBackgroundMessage(PushNotificationService.firebaseMessagingBackgroundHandler);
//
//   // সার্ভিস ইনিশিয়ালাইজ
//   final pushNotificationService = PushNotificationService();
//   await pushNotificationService.init();
//
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       // home: Scaffold(
//       //   body: Center(
//       //     child: Text('Push Notifications Setup Complete'),
//       //   ),
//       // ),
//       home: const HomePage(),
//     );
//   }
// }
// class HomePage extends StatefulWidget {
//   const HomePage({super.key});
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//
//  // PushNotificationService notificationService = PushNotificationService();
//
//   @override
//   void initState() {
//    // PushNotificationService.initLocalNotifications();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("data"),),
//       body: Center(child: ElevatedButton(onPressed: (){
//         PushNotificationService.showLocalNotification(
//           'Sample title',
//           'It works Raihan Sikdar!',
//         );
//       }, child: Text("data")),),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:push_notification_app/push_notification.dart';
import 'package:push_notification_app/text_component/text_component.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // 🛑 ব্যাকগ্রাউন্ড হ্যান্ডলার সেট করুন
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // Push Notification Service ইনিশিয়ালাইজ
  final pushNotificationService = PushNotificationService();
  await pushNotificationService.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Push Notifications")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            PushNotificationService.showLocalNotification(
              'Sample title',
              'It works Raihan Sikdar!',
            );
          },
         child: TextComponent(text:"Show Local Notification",style: TextStyle(fontSize: 16),),

        ),
      ),
    );
  }
}


