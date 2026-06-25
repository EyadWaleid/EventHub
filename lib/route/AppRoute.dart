import 'package:eventhub/features/auth/presentation/ui/loginScreen.dart';
import 'package:eventhub/features/auth/presentation/ui/signUp.dart';
import 'package:eventhub/features/home/presentation/Ui/homeScreen.dart';
import 'package:eventhub/features/onBoard/Ui/OnboardingScreen.dart';
import 'package:flutter/material.dart';

class AppRoute{
  Route? onGenarate(RouteSettings settings){
    switch(settings.name) {
      case('/'):
        return MaterialPageRoute(builder: (_)=>  HomeScreen());
      case('/login'):
        return MaterialPageRoute(builder: (_)=>  LoginScreen());
      case('/sign_up'):
        return MaterialPageRoute(builder: (_)=>  SignUp());
      case('/home'):
        return MaterialPageRoute(builder: (_)=>  HomeScreen() );
    }
    return null;
  }
}