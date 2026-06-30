import 'package:eventhub/lib/features/auth/presentation/ui/loginScreen.dart';
import 'package:eventhub/lib/features/auth/presentation/ui/signUp.dart';
import 'package:eventhub/lib/features/details/presentation/Ui/detailsScreen.dart';
import 'package:eventhub/lib/features/home/domain/entities/event_entity.dart';
import 'package:eventhub/lib/features/home/presentation/Ui/homeScreen.dart';
import 'package:eventhub/lib/features/onBoard/Ui/OnboardingScreen.dart';
import 'package:eventhub/lib/features/search/presentation/ui/search_screen.dart';
import 'package:flutter/material.dart';

class AppRoute {
  Route? onGenarate(RouteSettings settings) {
    switch (settings.name) {
      case '/':           return _r((_) => const HomeScreen());
      case '/login':      return _r((_) => LoginScreen());
      case '/sign_up':    return _r((_) => SignUp());
      case '/home':       return _r((_) => const HomeScreen());
      case '/onboarding': return _r((_) => const OnboardingScreen());

      case '/detail':
        final event = settings.arguments as EventEntity;
        return _r((_) => EventDetailsScreen(eventData: event));

      case '/search':
        final cat = settings.arguments as String?;
        return _r((_) => SearchScreen(initialCategory: cat));
    }
    return null;
  }

  MaterialPageRoute _r(Widget Function(BuildContext) builder) =>
      MaterialPageRoute(builder: builder);
}
