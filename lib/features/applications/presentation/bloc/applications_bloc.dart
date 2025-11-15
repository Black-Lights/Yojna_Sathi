import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/services/eligibility_service.dart';
import '../../data/models/user_scheme.dart';
import '../../data/services/applications_service.dart';
import '../../../schemes/data/services/schemes_service.dart';

// Events
abstract class ApplicationsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadUserApplicationsEvent extends ApplicationsEvent {
  final String userId;

  LoadUserApplicationsEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class CreateApplicationEvent extends ApplicationsEvent {
  final UserScheme application;

  CreateApplicationEvent(this.application);

  @override
  List<Object?> get props => [application];
}

class UpdateApplicationEvent extends ApplicationsEvent {
  final UserScheme application;

  UpdateApplicationEvent(this.application);

  @override
  List<Object?> get props => [application];
}

// States
abstract class ApplicationsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ApplicationsInitial extends ApplicationsState {}

class ApplicationsLoading extends ApplicationsState {}

class ApplicationsLoaded extends ApplicationsState {
  final List<UserScheme> applications;

  ApplicationsLoaded(this.applications);

  @override
  List<Object?> get props => [applications];
}

class ApplicationCreated extends ApplicationsState {}

class ApplicationUpdated extends ApplicationsState {}

class ApplicationsError extends ApplicationsState {
  final String message;

  ApplicationsError(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
class ApplicationsBloc extends Bloc<ApplicationsEvent, ApplicationsState> {
  final ApplicationsService _applicationsService;
  final SchemesService _schemesService;
  final EligibilityService _eligibilityService;

  ApplicationsBloc(
    this._applicationsService,
    this._schemesService,
    this._eligibilityService,
  ) : super(ApplicationsInitial()) {
    on<LoadUserApplicationsEvent>(_onLoadUserApplications);
    on<CreateApplicationEvent>(_onCreateApplication);
    on<UpdateApplicationEvent>(_onUpdateApplication);
  }

  Future<void> _onLoadUserApplications(
    LoadUserApplicationsEvent event,
    Emitter<ApplicationsState> emit,
  ) async {
    emit(ApplicationsLoading());
    try {
      final applications = await _applicationsService.getUserApplications(event.userId);
      emit(ApplicationsLoaded(applications));
    } catch (e) {
      emit(ApplicationsError(e.toString()));
    }
  }

  Future<void> _onCreateApplication(
    CreateApplicationEvent event,
    Emitter<ApplicationsState> emit,
  ) async {
    emit(ApplicationsLoading());
    try {
      await _applicationsService.createApplication(event.application);
      emit(ApplicationCreated());
    } catch (e) {
      emit(ApplicationsError(e.toString()));
    }
  }

  Future<void> _onUpdateApplication(
    UpdateApplicationEvent event,
    Emitter<ApplicationsState> emit,
  ) async {
    emit(ApplicationsLoading());
    try {
      await _applicationsService.updateApplication(event.application);
      emit(ApplicationUpdated());
    } catch (e) {
      emit(ApplicationsError(e.toString()));
    }
  }
}
