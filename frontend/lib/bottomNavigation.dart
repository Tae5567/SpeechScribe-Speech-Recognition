import 'package:flutter/material.dart';

import 'home.dart'; // Import Home widget
import 'notes.dart';

class CustomColors {
  static const BlueDark = Color(0xFF003366); // Replace with your app's dark blue
  static const TextGrey = Color(0xFF999999); // Replace with your app's text grey
}

class BottomNavigationBarApp extends StatelessWidget {
  final int bottomNavigationBarIndex;
  final BuildContext context;

  const BottomNavigationBarApp(this.context, this.bottomNavigationBarIndex, {super.key});

  void onTabTapped(int index) {
    // Navigate to the selected page
    if (index == bottomNavigationBarIndex) return; // Avoid rebuilding the same page
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return (index == 0) ? Home() : NotesPage();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: bottomNavigationBarIndex,
      type: BottomNavigationBarType.fixed,
      selectedFontSize: 12,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
      selectedItemColor: CustomColors.BlueDark,
      unselectedFontSize: 10,
      unselectedItemColor: CustomColors.TextGrey,
      items: [
        BottomNavigationBarItem(
          icon: Container(
            margin: const EdgeInsets.only(bottom: 5),
            child: Image.asset(
              'assets/images/home.png',
              color: (bottomNavigationBarIndex == 0)
                  ? CustomColors.BlueDark
                  : CustomColors.TextGrey,
              height: 24,
              width: 24,
            ),
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Container(
            margin: const EdgeInsets.only(bottom: 5),
            child: Image.asset(
              'assets/images/task.png',
              color: (bottomNavigationBarIndex == 1)
                  ? CustomColors.BlueDark
                  : CustomColors.TextGrey,
              height: 24,
              width: 24,
            ),
          ),
          label: 'Notes',
        ),
      ],
      onTap: onTabTapped,
    );
  }
}