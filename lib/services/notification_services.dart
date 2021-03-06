import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:todo_app_flutter/ui/notify_page.dart';

import '../models/task_model.dart';

class NotifyHelper{
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  initializeNotification() async{
    _configureLocalTimezone();

    final IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification
    );

    final AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings(
      "appicon"
    );

    final InitializationSettings initializationSettings = InitializationSettings(
      iOS: initializationSettingsIOS,
      android: initializationSettingsAndroid
    );

    await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onSelectNotification: selectNotification
    );
  }

  scheduledNotification(int hour, int minutes, Task task) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        task.id!,
        task.title,
        task.note,
        _convertTime(hour, minutes),
        //tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
        const NotificationDetails(
          android: AndroidNotificationDetails('Your channel ID', 'Your channel name')),
      androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: "${task.title}|"+"${task.note}|"+"${task.color}|"+"${task.startTime}|"
    );
  }

  tz.TZDateTime _convertTime(int hour, int minutes){
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduleDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minutes);

    if(scheduleDate.isBefore(now)){
      scheduleDate = scheduleDate.add(const Duration(days: 1));
    }
    return scheduleDate;
  }

  Future<void> _configureLocalTimezone() async{
    tz.initializeTimeZones();
    final String timeZone = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZone));
  }

  displayNotification({required String title, required String body}) async{

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      title, body,  channelDescription: 'your channel desc',
      importance: Importance.max, priority: Priority.high);

    var iOSPlatformChannelSpecifics = const IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics
    );

    await flutterLocalNotificationsPlugin.show(0, title, body, platformChannelSpecifics, payload: title);
  }

  void requestIOSPermissions() {
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future onDidReceiveLocalNotification(int id, String? title, String? body, String? payload) async{
    Get.dialog(
      Text('Welcome to flutter')
    );
  }

  Future selectNotification(String? payload) async{
    if(payload != null){
      print('notification payload: $payload');
    }
    else{
      print("Notification Done");
    }
    if(payload == 'Theme Changed!'){

    }
    else{
      Get.to(() => NotifyPage(label: payload));
    }
  }
}