import 'package:eventhub/lib/core/appColours/AppColours.dart';
import 'package:eventhub/lib/core/service/hive/hive_service.dart';
import 'package:eventhub/lib/core/service/shared_perferance/session_service.dart';
import 'package:eventhub/lib/route/AppRoute.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HiveService.init();

  final hasOnboarded = await SessionService.hasSeenOnboarding();
  final isLoggedIn   = await SessionService.isLoggedIn();

  String initialRoute;
  if (!hasOnboarded) {
    initialRoute = '/onboarding';
  } else if (!isLoggedIn) {
    initialRoute = '/login';
  } else {
    initialRoute = '/home';
  }

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: initialRoute,
      title: 'EventHub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Manrope',
        scaffoldBackgroundColor: AppColours.backgroundColour,
      ),
      onGenerateRoute: AppRoute().onGenarate,
    );
  }
}
