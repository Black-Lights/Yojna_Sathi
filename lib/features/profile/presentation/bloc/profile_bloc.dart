import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/user_profile.dart';
import '../../data/services/profile_service.dart';

// Events
abstract class ProfileEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadProfileEvent extends ProfileEvent {
  final String userId;

  LoadProfileEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class CreateProfileEvent extends ProfileEvent {
  final UserProfile profile;

  CreateProfileEvent(this.profile);

  @override
  List<Object?> get props => [profile];
}

class UpdateProfileEvent extends ProfileEvent {
  final UserProfile profile;

  UpdateProfileEvent(this.profile);

  @override
  List<Object?> get props => [profile];
}

// States
abstract class ProfileState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserProfile profile;

  ProfileLoaded(this.profile);

  @override
  List<Object?> get props => [profile];
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}

class ProfileCreated extends ProfileState {}

class ProfileUpdated extends ProfileState {}

// BLoC
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileService _profileService;

  ProfileBloc(this._profileService) : super(ProfileInitial()) {
    on<LoadProfileEvent>(_onLoadProfile);
    on<CreateProfileEvent>(_onCreateProfile);
    on<UpdateProfileEvent>(_onUpdateProfile);
  }

  Future<void> _onLoadProfile(
    LoadProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      final profile = await _profileService.getProfile(event.userId);
      if (profile != null) {
        emit(ProfileLoaded(profile));
      } else {
        emit(ProfileError('Profile not found'));
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onCreateProfile(
    CreateProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      await _profileService.createProfile(event.profile);
      emit(ProfileCreated());
      emit(ProfileLoaded(event.profile));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onUpdateProfile(
    UpdateProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      await _profileService.updateProfile(event.profile);
      emit(ProfileUpdated());
      emit(ProfileLoaded(event.profile));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}
