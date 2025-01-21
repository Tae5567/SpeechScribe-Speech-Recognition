import 'package:flutter/material.dart';

import 'util.dart';
import 'appBars.dart' hide CustomColors;
import 'bottomNavigation.dart' hide CustomColors;
import 'fab.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final bottomNavigationBarIndex = 0;

  // Sample task data
  final List<Map<String, dynamic>> tasks = [
    {
      "time": "07:00 AM",
      "title": "Go jogging with Christin",
      "isCompleted": true,
      "iconColor": CustomColors.YellowIcon,
    },
    {
      "time": "08:00 AM",
      "title": "Send project file",
      "isCompleted": false,
      "iconColor": CustomColors.GreenIcon,
    },
    {
      "time": "10:00 AM",
      "title": "Meeting with client",
      "isCompleted": false,
      "iconColor": CustomColors.PurpleIcon,
    },
  ];

  void deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: fullAppbar(context),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return Dismissible(
            key: Key(task['title']),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              deleteTask(index);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${task['title']} deleted'),
                ),
              );
            },
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              color: Colors.red,
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            child: Container(
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 15),
              padding: const EdgeInsets.fromLTRB(5, 13, 5, 13),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  stops: const [0.015, 0.015],
                  colors: [task['iconColor'], Colors.white],
                ),
                borderRadius: BorderRadius.circular(5.0),
                boxShadow: const [
                  BoxShadow(
                    color: CustomColors.GreyBorder,
                    blurRadius: 10.0,
                    spreadRadius: 5.0,
                    offset: Offset(0.0, 0.0),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset(
                    task['isCompleted']
                        ? 'assets/images/checked.png'
                        : 'assets/images/checked-empty.png',
                  ),
                  Text(
                    task['time'],
                    style: const TextStyle(color: CustomColors.TextGrey),
                  ),
                  SizedBox(
                    width: 180,
                    child: Text(
                      task['title'],
                      style: TextStyle(
                        color: task['isCompleted']
                            ? CustomColors.TextGrey
                            : CustomColors.TextHeader,
                        decoration: task['isCompleted']
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        fontWeight: task['isCompleted']
                            ? FontWeight.normal
                            : FontWeight.w600,
                      ),
                    ),
                  ),
                  Image.asset('assets/images/bell-small.png'),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: customFab(context),
      bottomNavigationBar:
          BottomNavigationBarApp(context, bottomNavigationBarIndex),
    );
  }
}