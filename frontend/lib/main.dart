import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'onboarding.dart';
import 'util.dart';

void main() => runApp(SpeechScribeApp());

class SpeechScribeApp extends StatefulWidget {
  const SpeechScribeApp({super.key});

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<SpeechScribeApp> {
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, //top bar color
      ),
    );
    // SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        canvasColor: CustomColors.GreyBackground,
        fontFamily: 'rubik',
      ),
      home: const Onboarding(),
    );
  }
}
