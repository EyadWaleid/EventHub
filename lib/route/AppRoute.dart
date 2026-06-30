import 'package:eventhub/core/Di/injection.dart';
import 'package:eventhub/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:eventhub/features/auth/presentation/ui/loginScreen.dart';
import 'package:eventhub/features/auth/presentation/ui/signUp.dart';
import 'package:eventhub/features/details/presentation/Ui/detailsScreen.dart';
import 'package:eventhub/features/home/domain/entities/event_entity.dart';
import 'package:eventhub/features/home/domain/usecases/event_usecases.dart';
import 'package:eventhub/features/home/presentation/Ui/homeScreen.dart';
import 'package:eventhub/features/home/presentation/cubit/events_cubit.dart';
import 'package:eventhub/features/home/presentation/cubit/home_cubit.dart';
import 'package:eventhub/features/onBoard/Ui/OnboardingScreen.dart';
import 'package:eventhub/features/profile/domain/usecases/profile_usecases.dart';
import 'package:eventhub/features/profile/presentation/viewmodel/profile_cubit.dart';
import 'package:eventhub/features/search/presentation/cubit/search_cubit.dart';
import 'package:eventhub/features/search/presentation/ui/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRoute {
  Route? onGenarate(RouteSettings settings) {
    switch (settings.name) {
      case '/':
      case '/home':
        return _r((_) => MultiBlocProvider(
          providers: [
            BlocProvider<HomeCubit>(
              create: (_) => HomeCubit(
                getEventsUseCase: getIt<GetEventsUseCase>(),
                getProfileUseCase: getIt<GetProfileUseCase>(),
                unsaveEventUseCase: getIt<UnsaveEventUseCase>(),
              )..init(),
            ),
            BlocProvider<EventsCubit>(
              create: (_) => EventsCubit(
                getEventsUseCase: getIt<GetEventsUseCase>(),
                getProfileUseCase: getIt<GetProfileUseCase>(),
                unsaveEventUseCase: getIt<UnsaveEventUseCase>(),
              )..init(),
            ),
            BlocProvider<ProfileCubit>(
              create: (_) => ProfileCubit(
                getProfileUseCase: getIt<GetProfileUseCase>(),
                unsaveEventUseCase: getIt<UnsaveEventUseCase>(),
                logoutUseCase: getIt<LogoutUseCase>(),
              )..loadProfile(),
            ),
          ],
          child: const HomeScreen(),
        ));

      case '/login':
        return _r((_) => BlocProvider<AuthCubit>(
          create: (_) => AuthCubit(),
          child: LoginScreen(),
        ));

      case '/sign_up':
        return _r((_) => BlocProvider<AuthCubit>(
          create: (_) => AuthCubit(),
          child: SignUp(),
        ));

      case '/onboarding':
        return _r((_) => const OnboardingScreen());

      case '/detail':
        final event = settings.arguments as EventEntity;
        return _r((_) => EventDetailsScreen(eventData: event));

      case '/search':
        final cat = settings.arguments as String?;
        return _r((_) => BlocProvider<SearchCubit>(
          create: (_) => SearchCubit(
            searchEventsUseCase: getIt<SearchEventsUseCase>(),
            searchByCategoryUseCase: getIt<SearchEventsByCategoryUseCase>(),
          ),
          child: SearchScreen(initialCategory: cat),
        ));
    }
    return null;
  }

  MaterialPageRoute _r(Widget Function(BuildContext) builder) =>
      MaterialPageRoute(builder: builder);
}