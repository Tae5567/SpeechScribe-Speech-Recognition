import 'package:flutter/material.dart';

import 'util.dart';
import 'appBars.dart' hide CustomColors;
import 'bottomNavigation.dart' hide CustomColors;
import 'fab.dart';


class Empty extends StatefulWidget {
  const Empty({super.key});

  @override
  _EmptyState createState() => _EmptyState();
}

class _EmptyState extends State<Empty> {
  var bottomNavigationBarIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: emptyAppbar(context),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width / 1.2,
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 8,
                child: Hero(
                  tag: 'Clipboard',
                  child: Image.asset('assets/images/Clipboard-empty.png'),
                ),
              ),
              const Expanded(
                flex: 3,
                child: Column(
                  children: <Widget>[
                    Text(
                      'No tasks',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: CustomColors.TextHeader),
                    ),
                    SizedBox(height: 15),
                    Text(
                      'You have no tasks to do.',
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                          color: CustomColors.TextBody,
                          fontFamily: 'opensans'),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(),
              )
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: customFab(context),
      bottomNavigationBar: BottomNavigationBarApp(context, bottomNavigationBarIndex),
    );
  }
}
