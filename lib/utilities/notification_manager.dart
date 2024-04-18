import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class Time {
  final int hour;
  final int minute;
  final int second;

  Time(this.hour, this.minute, this.second);

  @override
  String toString() {
    return '$hour:$minute:$second';
  }
}

// class ReceivedNotification {
//   ReceivedNotification({
//     required this.id,
//     required this.title,
//     required this.body,
//     required this.payload,
//   });

//   final int id;
//   final String? title;
//   final String? body;
//   final String? payload;
// }

class NotificationManager {
  var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  NotificationManager() {
    initNotifications();
  }

  getNotificationInstance() {
    return flutterLocalNotificationsPlugin;
  }

   void initNotifications() async{
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    
     final DarwinInitializationSettings initializationSettingsDarwin =
       DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    var initializationSettings =
        InitializationSettings(iOS: initializationSettingsDarwin);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('America/Detroit'));

   }

  void createNotif(
      int id, String title, String body, var scheduledDate) async {
      NotificationDetails notifDetails = getNotificationDetails();
      await flutterLocalNotificationsPlugin.zonedSchedule(id, "Wish $title a HBD!", "MSG: $body", scheduledDate, notifDetails, 
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime, 
      matchDateTimeComponents: DateTimeComponents.dateAndTime);
    // var time = Time(hour, minute, 0);
    // await flutterLocalNotificationsPlugin.showDailyAtTime(
    //     id, title, body, time, getPlatformChannelSpecfics());
    // print('Notification Succesfully Scheduled at ${time.toString()}');
  }

  NotificationDetails getNotificationDetails() {
    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();
    // var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics =
        NotificationDetails(iOS: iOSPlatformChannelSpecifics);

    return platformChannelSpecifics;
  }

  Future onSelectNotification(String payload) async {
    print('Notification clicked');
    return Future.value(0);
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    return Future.value(1);
  }

  void removeReminder(int notificationId) {
    flutterLocalNotificationsPlugin.cancel(notificationId);
  }

}
