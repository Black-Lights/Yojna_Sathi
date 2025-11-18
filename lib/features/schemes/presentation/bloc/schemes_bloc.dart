import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/services/eligibility_service.dart';
import '../../data/models/scheme.dart';
import '../../data/services/schemes_service.dart';

// Events
abstract class SchemesEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadSchemesEvent extends SchemesEvent {}

class LoadSchemeDetailEvent extends SchemesEvent {
  final String schemeId;

  LoadSchemeDetailEvent(this.schemeId);

  @override
  List<Object?> get props => [schemeId];
}

class SearchSchemesEvent extends SchemesEvent {
  final String query;

  SearchSchemesEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class FilterSchemesByCategoryEvent extends SchemesEvent {
  final String category;

  FilterSchemesByCategoryEvent(this.category);

  @override
  List<Object?> get props => [category];
}

class LoadEligibleSchemesEvent extends SchemesEvent {
  final String userId;

  LoadEligibleSchemesEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

// States
abstract class SchemesState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SchemesInitial extends SchemesState {}

class SchemesLoading extends SchemesState {}

class SchemesLoaded extends SchemesState {
  final List<Scheme> schemes;
  final Map<String, double>? eligibilityScores;

  SchemesLoaded(this.schemes, {this.eligibilityScores});

  @override
  List<Object?> get props => [schemes, eligibilityScores];
}

class SchemeDetailLoaded extends SchemesState {
  final Scheme scheme;

  SchemeDetailLoaded(this.scheme);

  @override
  List<Object?> get props => [scheme];
}

class SchemesError extends SchemesState {
  final String message;

  SchemesError(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
class SchemesBloc extends Bloc<SchemesEvent, SchemesState> {
  final SchemesService _schemesService;
  final EligibilityService _eligibilityService;

  SchemesBloc(this._schemesService, this._eligibilityService)
      : super(SchemesInitial()) {
    on<LoadSchemesEvent>(_onLoadSchemes);
    on<LoadSchemeDetailEvent>(_onLoadSchemeDetail);
    on<SearchSchemesEvent>(_onSearchSchemes);
    on<FilterSchemesByCategoryEvent>(_onFilterSchemesByCategory);
    on<LoadEligibleSchemesEvent>(_onLoadEligibleSchemes);
  }

  Future<void> _onLoadSchemes(
    LoadSchemesEvent event,
    Emitter<SchemesState> emit,
  ) async {
    emit(SchemesLoading());
    try {
      final schemes = await _schemesService.getAllSchemes();
      emit(SchemesLoaded(schemes));
    } catch (e) {
      emit(SchemesError(e.toString()));
    }
  }

  Future<void> _onLoadSchemeDetail(
    LoadSchemeDetailEvent event,
    Emitter<SchemesState> emit,
  ) async {
    emit(SchemesLoading());
    try {
      final scheme = await _schemesService.getScheme(event.schemeId);
      if (scheme != null) {
        emit(SchemeDetailLoaded(scheme));
      } else {
        emit(SchemesError('Scheme not found'));
      }
    } catch (e) {
      emit(SchemesError(e.toString()));
    }
  }

  Future<void> _onSearchSchemes(
    SearchSchemesEvent event,
    Emitter<SchemesState> emit,
  ) async {
    emit(SchemesLoading());
    try {
      final schemes = await _schemesService.searchSchemes(event.query);
      emit(SchemesLoaded(schemes));
    } catch (e) {
      emit(SchemesError(e.toString()));
    }
  }

  Future<void> _onFilterSchemesByCategory(
    FilterSchemesByCategoryEvent event,
    Emitter<SchemesState> emit,
  ) async {
    emit(SchemesLoading());
    try {
      final schemes = await _schemesService.getSchemesByCategory(event.category);
      emit(SchemesLoaded(schemes));
    } catch (e) {
      emit(SchemesError(e.toString()));
    }
  }

  Future<void> _onLoadEligibleSchemes(
    LoadEligibleSchemesEvent event,
    Emitter<SchemesState> emit,
  ) async {
    emit(SchemesLoading());
    try {
      final result = await _schemesService.getEligibleSchemes(event.userId);
      emit(SchemesLoaded(result['schemes'], eligibilityScores: result['scores']));
    } catch (e) {
      emit(SchemesError(e.toString()));
    }
  }
}
