import 'package:flutter/material.dart';

class CustomColors {
  static const HeaderBlueDark = Color(0xFF3A63FF);
  static const HeaderBlueLight = Color(0xFF789FFF);
  static const HeaderCircle = Color(0xFFE5E5E5);
  static const HeaderGreyLight = Color(0xFFEBEBEB);
}

// AppBar for your notes screen
PreferredSizeWidget fullAppbar(BuildContext context) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(210.0), // Custom height
    child: AppBar(
      automaticallyImplyLeading: false, // Prevents back button
      flexibleSpace: Stack(
        children: [
          // Gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  CustomColors.HeaderBlueDark,
                  CustomColors.HeaderBlueLight,
                ],
              ),
            ),
          ),
          // Circular decorations
          Positioned(
            top: -50,
            left: -50,
            child: CustomPaint(painter: CircleOne()),
          ),
          Positioned(
            bottom: -30,
            right: -30,
            child: CustomPaint(painter: CircleTwo()),
          ),
        ],
      ),
      title: Container(
        margin: const EdgeInsets.only(top: 20),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello User!',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white),
            ),
            Text(
              'Today you have 9 tasks',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w300, color: Colors.white),
            ),
          ],
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.fromLTRB(0, 20, 20, 0),
          child: const CircleAvatar(
            backgroundImage: AssetImage('assets/images/photo.png'),
            radius: 18,
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(60.0), // Bottom container height
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          decoration: BoxDecoration(
            color: CustomColors.HeaderGreyLight,
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Today Reminder',
                    style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Meeting with client at 1:00 PM',
                    style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w300),
                  ),
                ],
              ),
              Icon(Icons.notifications, color: Colors.white),
            ],
          ),
        ),
      ),
    ),
  );
}

// AppBar for empty states
PreferredSizeWidget emptyAppbar(BuildContext context) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(75.0),
    child: AppBar(
      automaticallyImplyLeading: false,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              CustomColors.HeaderBlueDark,
              CustomColors.HeaderBlueLight,
            ],
          ),
        ),
      ),
      title: const Text(
        'Hello User!',
        style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
      ),
      elevation: 0,
    ),
  );
}

// Custom circle decorators
class CircleOne extends CustomPainter {
  final Paint _paint = Paint()
    ..color = CustomColors.HeaderCircle
    ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(const Offset(28.0, 0.0), 99.0, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class CircleTwo extends CustomPainter {
  final Paint _paint = Paint()
    ..color = CustomColors.HeaderCircle
    ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(const Offset(-30, 20), 50.0, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
