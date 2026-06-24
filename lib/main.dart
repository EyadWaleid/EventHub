import 'package:eventhub/core/appColours/AppColours.dart';
import 'package:eventhub/features/auth/presentation/ui/loginScreen.dart';
import 'package:eventhub/route/AppRoute.dart';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        initialRoute: '/',
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: "Manrope",

        scaffoldBackgroundColor: AppColours.backgroundColour,
      ),
        onGenerateRoute:AppRoute().onGenarate,

    );
  }
}

