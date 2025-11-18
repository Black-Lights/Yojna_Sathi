import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'dart:io';
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

class SubmitApplicationEvent extends ApplicationsEvent {
  final String userId;
  final String schemeId;
  final Map<String, File> documents; // documentType -> file

  SubmitApplicationEvent({
    required this.userId,
    required this.schemeId,
    required this.documents,
  });

  @override
  List<Object?> get props => [userId, schemeId, documents];
}

class UploadDocumentEvent extends ApplicationsEvent {
  final String recordId;
  final String documentType;
  final File file;

  UploadDocumentEvent({
    required this.recordId,
    required this.documentType,
    required this.file,
  });

  @override
  List<Object?> get props => [recordId, documentType, file];
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

class ApplicationSubmitting extends ApplicationsState {
  final double progress;

  ApplicationSubmitting(this.progress);

  @override
  List<Object?> get props => [progress];
}

class ApplicationSubmitted extends ApplicationsState {
  final UserScheme application;

  ApplicationSubmitted(this.application);

  @override
  List<Object?> get props => [application];
}

class ApplicationCreated extends ApplicationsState {}

class ApplicationUpdated extends ApplicationsState {}

class DocumentUploading extends ApplicationsState {
  final double progress;

  DocumentUploading(this.progress);

  @override
  List<Object?> get props => [progress];
}

class DocumentUploaded extends ApplicationsState {
  final String documentUrl;

  DocumentUploaded(this.documentUrl);

  @override
  List<Object?> get props => [documentUrl];
}

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
    on<SubmitApplicationEvent>(_onSubmitApplication);
    on<UploadDocumentEvent>(_onUploadDocument);
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

  Future<void> _onSubmitApplication(
    SubmitApplicationEvent event,
    Emitter<ApplicationsState> emit,
  ) async {
    try {
      emit(ApplicationSubmitting(0.0));

      // Check if application already exists
      final existing = await _applicationsService.getUserScheme(event.userId, event.schemeId);
      if (existing != null) {
        emit(ApplicationsError('You have already applied for this scheme'));
        return;
      }

      // Create initial application record
      final recordId = '${event.userId}_${event.schemeId}_${DateTime.now().millisecondsSinceEpoch}';
      final documents = <Document>[];
      
      // Upload documents one by one
      int uploadedCount = 0;
      for (final entry in event.documents.entries) {
        final documentType = entry.key;
        final file = entry.value;
        
        emit(ApplicationSubmitting((uploadedCount / event.documents.length) * 0.8));
        
        final storagePath = await _applicationsService.uploadDocument(
          userId: event.userId,
          schemeId: event.schemeId,
          documentType: documentType,
          file: file,
        );
        
        documents.add(Document(
          documentId: '${recordId}_${documentType}',
          type: documentType,
          uploadedAt: DateTime.now(),
          storagePath: storagePath,
        ));
        
        uploadedCount++;
      }

      emit(ApplicationSubmitting(0.9));

      // Create the application
      final application = UserScheme(
        recordId: recordId,
        userId: event.userId,
        schemeId: event.schemeId,
        status: 'Pending',
        matchScore: 0.0,
        appliedAt: DateTime.now(),
        documents: documents,
        lastUpdated: DateTime.now(),
      );

      await _applicationsService.createApplication(application);
      
      emit(ApplicationSubmitting(1.0));
      emit(ApplicationSubmitted(application));
    } catch (e) {
      emit(ApplicationsError('Failed to submit application: $e'));
    }
  }

  Future<void> _onUploadDocument(
    UploadDocumentEvent event,
    Emitter<ApplicationsState> emit,
  ) async {
    try {
      emit(DocumentUploading(0.0));
      
      // Get the application
      final application = await _applicationsService.getApplication(event.recordId);
      if (application == null) {
        emit(ApplicationsError('Application not found'));
        return;
      }

      emit(DocumentUploading(0.3));

      // Upload document
      final storagePath = await _applicationsService.uploadDocument(
        userId: application.userId,
        schemeId: application.schemeId,
        documentType: event.documentType,
        file: event.file,
      );

      emit(DocumentUploading(0.7));

      // Add document to application
      final newDocument = Document(
        documentId: '${event.recordId}_${event.documentType}',
        type: event.documentType,
        uploadedAt: DateTime.now(),
        storagePath: storagePath,
      );

      final updatedDocuments = [...application.documents, newDocument];
      final updatedApplication = application.copyWith(documents: updatedDocuments);
      
      await _applicationsService.updateApplication(updatedApplication);

      emit(DocumentUploading(1.0));
      emit(DocumentUploaded(storagePath));
    } catch (e) {
      emit(ApplicationsError('Failed to upload document: $e'));
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
