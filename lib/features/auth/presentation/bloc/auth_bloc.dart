import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/services/auth_service.dart';
import '../../../profile/data/services/profile_service.dart';

// Events
abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CheckAuthStatusEvent extends AuthEvent {}

class SignInWithEmailPasswordEvent extends AuthEvent {
  final String email;
  final String password;

  SignInWithEmailPasswordEvent(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

class RegisterWithEmailPasswordEvent extends AuthEvent {
  final String email;
  final String password;

  RegisterWithEmailPasswordEvent(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

class SignInWithPhoneEvent extends AuthEvent {
  final String verificationId;
  final String smsCode;

  SignInWithPhoneEvent(this.verificationId, this.smsCode);

  @override
  List<Object?> get props => [verificationId, smsCode];
}

class VerifyPhoneNumberEvent extends AuthEvent {
  final String phoneNumber;

  VerifyPhoneNumberEvent(this.phoneNumber);

  @override
  List<Object?> get props => [phoneNumber];
}

class SignOutEvent extends AuthEvent {}

class SendPasswordResetEmailEvent extends AuthEvent {
  final String email;

  SendPasswordResetEmailEvent(this.email);

  @override
  List<Object?> get props => [email];
}

// States
abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final User user;
  final bool hasCompletedProfile;

  AuthAuthenticated(this.user, this.hasCompletedProfile);

  @override
  List<Object?> get props => [user, hasCompletedProfile];
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

class PhoneVerificationSent extends AuthState {
  final String verificationId;

  PhoneVerificationSent(this.verificationId);

  @override
  List<Object?> get props => [verificationId];
}

class PasswordResetEmailSent extends AuthState {}

// BLoC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;
  final ProfileService _profileService;

  AuthBloc(this._authService, this._profileService) : super(AuthInitial()) {
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<SignInWithEmailPasswordEvent>(_onSignInWithEmailPassword);
    on<RegisterWithEmailPasswordEvent>(_onRegisterWithEmailPassword);
    on<SignInWithPhoneEvent>(_onSignInWithPhone);
    on<VerifyPhoneNumberEvent>(_onVerifyPhoneNumber);
    on<SignOutEvent>(_onSignOut);
    on<SendPasswordResetEmailEvent>(_onSendPasswordResetEmail);
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    final user = _authService.currentUser;
    if (user != null) {
      final hasProfile = await _authService.hasCompletedProfile();
      emit(AuthAuthenticated(user, hasProfile));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onSignInWithEmailPassword(
    SignInWithEmailPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await _authService.signInWithEmailPassword(
        event.email,
        event.password,
      );
      if (user != null) {
        final hasProfile = await _authService.hasCompletedProfile();
        emit(AuthAuthenticated(user, hasProfile));
      } else {
        emit(AuthError('Sign in failed'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onRegisterWithEmailPassword(
    RegisterWithEmailPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await _authService.registerWithEmailPassword(
        event.email,
        event.password,
      );
      if (user != null) {
        emit(AuthAuthenticated(user, false));
      } else {
        emit(AuthError('Registration failed'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignInWithPhone(
    SignInWithPhoneEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await _authService.signInWithPhone(
        event.verificationId,
        event.smsCode,
      );
      if (user != null) {
        final hasProfile = await _authService.hasCompletedProfile();
        emit(AuthAuthenticated(user, hasProfile));
      } else {
        emit(AuthError('Phone sign in failed'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onVerifyPhoneNumber(
    VerifyPhoneNumberEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _authService.verifyPhoneNumber(
        phoneNumber: event.phoneNumber,
        onCodeSent: (verificationId) {
          emit(PhoneVerificationSent(verificationId));
        },
        onError: (error) {
          emit(AuthError(error));
        },
      );
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignOut(
    SignOutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _authService.signOut();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSendPasswordResetEmail(
    SendPasswordResetEmailEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _authService.sendPasswordResetEmail(event.email);
      emit(PasswordResetEmailSent());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
