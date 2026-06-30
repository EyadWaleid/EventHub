import 'package:eventhub/core/Di/injection.dart';
import 'package:eventhub/core/appColours/AppColours.dart';
import 'package:eventhub/core/service/hive/hive_service.dart';
import 'package:eventhub/core/service/hive/session_service.dart';
import 'package:eventhub/route/AppRoute.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.init();
  setupDependencies();

  final hasOnboarded = await SessionService.hasSeenOnboarding();
  final isLoggedIn   = await SessionService.isLoggedIn();

  runApp(MyApp(
    initialRoute: !hasOnboarded
        ? '/onboarding'
        : !isLoggedIn ? '/login' : '/home',
  ));
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
