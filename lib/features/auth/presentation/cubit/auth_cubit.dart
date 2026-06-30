import 'package:eventhub/core/service/hive/hive_service.dart';
import 'package:eventhub/core/service/hive/session_service.dart';
import 'package:eventhub/features/auth/presentation/cubit/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    final user = HiveService.login(email: email.trim(), password: password);
    if (user == null) {
      emit(AuthError('Wrong email or password.'));
    } else {
      await SessionService.saveSession(user.email);
      emit(AuthSuccess());
    }
  }

  Future<void> register(String name, String email, String password) async {
    emit(AuthLoading());
    final ok = await HiveService.register(
        name: name.trim(), email: email.trim(), password: password);
    if (!ok) {
      emit(AuthError('This email is already registered.'));
    } else {
      await SessionService.saveSession(email.trim());
      emit(AuthSuccess());
    }
  }

  void reset() => emit(AuthInitial());
}
