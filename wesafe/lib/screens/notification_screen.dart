import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  @override
  void initState() {
    super.initState();
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings("@mipmap/ic_launcher");

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
      iOS: null,
      macOS: null,
      linux: null,
    );

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) {
      switch (notificationResponse.notificationResponseType) {
        case NotificationResponseType.selectedNotification:
          // TODO: Handle this case.
          break;
        case NotificationResponseType.selectedNotificationAction:
          // TODO: Handle this case.
          break;
      }
    });

    //Subscription to Collection
    Stream<QuerySnapshot<Map<String, dynamic>>> notificationStream =
        FirebaseFirestore.instance
            .collection("posts")
            .orderBy("datePublished", descending: true)
            .snapshots();

    notificationStream.listen((event) {
      if (event.docs.isEmpty) {
        return;
      }

      showNotification(event.docs.first);
    });
    //End of Subscription
  }

  showNotification(QueryDocumentSnapshot<Map<String, dynamic>> event) {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails("001", "Local Notification",
            channelDescription: "To send local notification");

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    flutterLocalNotificationsPlugin.show(
        01, event.get('title'), event.get('description'), notificationDetails);
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: const Text(
            'notifications',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: false,
        ),
        body: SafeArea(child: Container()));
  }
}
