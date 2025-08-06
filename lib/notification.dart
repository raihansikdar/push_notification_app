
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseNotificationServices {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // ব্যাকগ্রাউন্ড মেসেজ হ্যান্ডলার
  static Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print("ব্যাকগ্রাউন্ড মেসেজ: ${message.messageId}");
  }

  // নোটিফিকেশন ইনিশিয়ালাইজ
  Future<void> initNotifications() async {
    // iOS এর জন্য পারমিশন রিকোয়েস্ট
    await _firebaseMessaging.requestPermission();

    // ডিভাইস টোকেন পাওয়া
    String? token = await _firebaseMessaging.getToken();
    print("ডিভাইস টোকেন: $token");
    // এখানে টোকেন ব্যাকএন্ডে পাঠাতে পারেন

    // ফোরগ্রাউন্ড মেসেজ শোনা
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("ফোরগ্রাউন্ড মেসেজ: ${message.notification?.title}");
    });

    // নোটিফিকেশন ক্লিক করে অ্যাপ খোলার ইভেন্ট
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("নোটিফিকেশন ক্লিক করা হয়েছে!");
    });
  }
}
