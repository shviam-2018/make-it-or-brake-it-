import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habit Tracker',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _goalController = TextEditingController();
  final _durationController = TextEditingController();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void scheduleNotification() async {
    var initializationSettings =
        IOSInitializationSettings(requestSoundPermission: true);
    await flutterLocalNotificationsPlugin.initialize(
        InitializationSettings(android: const AndroidInitializationSettings(), iOS: initializationSettings));

    var scheduledNotification = ScheduleNotification(
      id: 1,
      title: 'Habit Tracker',
      body: 'Did you complete your habit today?',
      payload: 'habit_reminder',
      androidDetails: AndroidNotificationDetails(
        channelId: 'habit_tracker_channel',
        channelName: 'Habit Tracker',
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
        category: NotificationCategory.reminder,
      ),
      iOSDetails: IOSNotificationDetails(
        sound: const RawResourceAndroidNotificationSound('slow_spring_board.caf'),
      ),
    );

    await flutterLocalNotificationsPlugin.schedule(
        scheduledNotification, DateTime.now().add(const Duration(minutes: 5)));
  }

  void _addHabit(String goal, int duration) {
    // Implement logic to store the habit in a database or shared preferences

    // Schedule a daily notification to remind the user about their habit
    scheduleNotification();

    setState(() {
      _goalController.clear();
      _durationController.clear();
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Habit Added!'),
          content: const Text('Your habit has been successfully added.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Habit Tracker'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _goalController,
              decoration: const InputDecoration(
                labelText: 'Enter your habit goal:',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _durationController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter the duration (days):',
              ),
            ),
            const SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () {
                final goal = _goalController.text;
                final duration = int.parse(_durationController.text);

                _addHabit(goal, duration);
              },
              child: const Text('Add Habit'),
            ),
          ],
        ),
      ),
    );
  }
}
