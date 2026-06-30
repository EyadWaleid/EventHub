import 'package:eventhub/core/service/hive/saved_event_model.dart';
import 'package:eventhub/features/profile/domain/usecases/profile_usecases.dart';
import 'package:eventhub/features/profile/presentation/viewmodel/profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileUseCase getProfileUseCase;
  final UnsaveEventUseCase unsaveEventUseCase;
  final LogoutUseCase logoutUseCase;

  ProfileCubit({
    required this.getProfileUseCase,
    required this.unsaveEventUseCase,
    required this.logoutUseCase,
  }) : super(ProfileInitial());

  Future<void> loadProfile() async {
    emit(ProfileLoading());
    final profile = await getProfileUseCase();
    if (profile == null) {
      emit(ProfileError('Could not load profile.'));
    } else {
      emit(ProfileLoaded(profile));
    }
  }

  Future<void> unsaveEvent(SavedEventModel event) async {
    await unsaveEventUseCase(event);
    await loadProfile(); // refresh
  }

  Future<void> logout() async {
    await logoutUseCase();
    emit(ProfileLoggedOut());
  }
}
