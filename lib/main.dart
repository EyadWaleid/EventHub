import 'package:eventhub/core/appColours/AppColours.dart';
import 'package:eventhub/presentation/SplashScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: "Manrope",
        scaffoldBackgroundColor: AppColours.backgroundColour,
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home:Splashscreen()
    );
  }
}

