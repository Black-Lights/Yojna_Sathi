# SchemaMitra Development Guide

## Overview

This Flutter application follows Clean Architecture principles with a feature-based structure and BLoC pattern for state management.

## Architecture

### Clean Architecture Layers

```
Feature Module
├── Data Layer
│   ├── models/          # Data models with fromFirestore/toFirestore
│   ├── services/        # Firebase and API services
│   └── repositories/    # Data repositories (optional)
├── Domain Layer
│   ├── entities/        # Business entities (optional)
│   └── usecases/        # Business logic (optional)
└── Presentation Layer
    ├── bloc/            # BLoC state management
    ├── pages/           # UI pages/screens
    └── widgets/         # Reusable widgets
```

### Project Structure

```
lib/
├── config/              # App-wide configuration
│   ├── routes/          # Navigation routing
│   └── theme/           # Theme and styling
├── core/                # Core functionality
│   ├── di/              # Dependency injection (GetIt)
│   ├── services/        # Shared services
│   └── utils/           # Constants, helpers, extensions
└── features/            # Feature modules
    └── [feature_name]/  # Each feature is self-contained
```

## State Management with BLoC

### BLoC Pattern

We use the BLoC (Business Logic Component) pattern for state management:

```dart
// Event
class LoadSchemesEvent extends SchemesEvent {}

// State
class SchemesLoaded extends SchemesState {
  final List<Scheme> schemes;
  SchemesLoaded(this.schemes);
}

// BLoC
class SchemesBloc extends Bloc<SchemesEvent, SchemesState> {
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
}
```

### Using BLoC in UI

```dart
// Provide BLoC
BlocProvider(
  create: (_) => SchemesBloc(sl())..add(LoadSchemesEvent()),
  child: SchemesPage(),
)

// Listen to state changes
BlocListener<SchemesBloc, SchemesState>(
  listener: (context, state) {
    if (state is SchemesError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message)),
      );
    }
  },
  child: YourWidget(),
)

// Build UI based on state
BlocBuilder<SchemesBloc, SchemesState>(
  builder: (context, state) {
    if (state is SchemesLoading) {
      return CircularProgressIndicator();
    } else if (state is SchemesLoaded) {
      return SchemesList(schemes: state.schemes);
    } else if (state is SchemesError) {
      return ErrorWidget(message: state.message);
    }
    return SizedBox();
  },
)
```

## Dependency Injection

We use GetIt for dependency injection. All dependencies are registered in `lib/core/di/injection_container.dart`.

### Adding a New Service

```dart
// 1. Create the service
class MyNewService {
  final FirebaseFirestore _firestore;
  MyNewService(this._firestore);
  
  Future<void> doSomething() async {
    // Implementation
  }
}

// 2. Register in injection_container.dart
sl.registerLazySingleton<MyNewService>(
  () => MyNewService(sl()),
);

// 3. Use in BLoC or anywhere
class MyBloc extends Bloc<MyEvent, MyState> {
  final MyNewService _service;
  
  MyBloc(this._service) : super(MyInitial());
}
```

## Firebase Integration

### Firestore Data Models

All models should implement:
- `fromFirestore(DocumentSnapshot doc)` - Convert Firestore doc to model
- `toFirestore()` - Convert model to Firestore map

```dart
class Scheme {
  factory Scheme.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Scheme(
      schemeId: data['schemeId'] as String,
      name: data['name'] as String,
      // ... other fields
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'schemeId': schemeId,
      'name': name,
      // ... other fields
    };
  }
}
```

### Firebase Services

Each feature has its own Firebase service:

```dart
class SchemesService {
  final FirebaseFirestore _firestore;
  
  Future<List<Scheme>> getAllSchemes() async {
    final snapshot = await _firestore
        .collection('schemes')
        .get();
    return snapshot.docs
        .map((doc) => Scheme.fromFirestore(doc))
        .toList();
  }
}
```

## Adding a New Feature

### Step 1: Create Feature Structure

```bash
lib/features/new_feature/
├── data/
│   ├── models/
│   │   └── feature_model.dart
│   └── services/
│       └── feature_service.dart
└── presentation/
    ├── bloc/
    │   └── feature_bloc.dart
    ├── pages/
    │   └── feature_page.dart
    └── widgets/
        └── feature_widget.dart
```

### Step 2: Create Model

```dart
// lib/features/new_feature/data/models/feature_model.dart
class FeatureModel extends Equatable {
  final String id;
  final String name;
  
  const FeatureModel({required this.id, required this.name});
  
  factory FeatureModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return FeatureModel(
      id: data['id'] as String,
      name: data['name'] as String,
    );
  }
  
  Map<String, dynamic> toFirestore() {
    return {'id': id, 'name': name};
  }
  
  @override
  List<Object?> get props => [id, name];
}
```

### Step 3: Create Service

```dart
// lib/features/new_feature/data/services/feature_service.dart
class FeatureService {
  final FirebaseFirestore _firestore;
  
  FeatureService(this._firestore);
  
  Future<FeatureModel?> getFeature(String id) async {
    final doc = await _firestore
        .collection('features')
        .doc(id)
        .get();
    
    if (doc.exists) {
      return FeatureModel.fromFirestore(doc);
    }
    return null;
  }
}
```

### Step 4: Create BLoC

```dart
// Events
abstract class FeatureEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadFeatureEvent extends FeatureEvent {
  final String id;
  LoadFeatureEvent(this.id);
  @override
  List<Object?> get props => [id];
}

// States
abstract class FeatureState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FeatureInitial extends FeatureState {}
class FeatureLoading extends FeatureState {}
class FeatureLoaded extends FeatureState {
  final FeatureModel feature;
  FeatureLoaded(this.feature);
  @override
  List<Object?> get props => [feature];
}
class FeatureError extends FeatureState {
  final String message;
  FeatureError(this.message);
  @override
  List<Object?> get props => [message];
}

// BLoC
class FeatureBloc extends Bloc<FeatureEvent, FeatureState> {
  final FeatureService _service;
  
  FeatureBloc(this._service) : super(FeatureInitial()) {
    on<LoadFeatureEvent>(_onLoadFeature);
  }
  
  Future<void> _onLoadFeature(
    LoadFeatureEvent event,
    Emitter<FeatureState> emit,
  ) async {
    emit(FeatureLoading());
    try {
      final feature = await _service.getFeature(event.id);
      if (feature != null) {
        emit(FeatureLoaded(feature));
      } else {
        emit(FeatureError('Feature not found'));
      }
    } catch (e) {
      emit(FeatureError(e.toString()));
    }
  }
}
```

### Step 5: Register Dependencies

```dart
// lib/core/di/injection_container.dart
sl.registerLazySingleton<FeatureService>(
  () => FeatureService(sl()),
);

sl.registerFactory(() => FeatureBloc(sl()));
```

### Step 6: Create UI Page

```dart
class FeaturePage extends StatelessWidget {
  const FeaturePage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<FeatureBloc>()..add(LoadFeatureEvent('id')),
      child: Scaffold(
        appBar: AppBar(title: const Text('Feature')),
        body: BlocBuilder<FeatureBloc, FeatureState>(
          builder: (context, state) {
            if (state is FeatureLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is FeatureLoaded) {
              return Center(child: Text(state.feature.name));
            } else if (state is FeatureError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
```

### Step 7: Add Route

```dart
// lib/config/routes/app_router.dart
static const String feature = '/feature';

case feature:
  return MaterialPageRoute(builder: (_) => const FeaturePage());
```

## Best Practices

### 1. State Management
- Keep BLoC logic pure and testable
- Emit loading states before async operations
- Handle errors gracefully with error states
- Use Equatable for states and events

### 2. Firebase
- Always handle null values from Firestore
- Use transactions for multiple writes
- Implement proper error handling
- Cache data locally when possible

### 3. UI
- Keep widgets small and reusable
- Use const constructors when possible
- Follow Material Design guidelines
- Implement proper error and loading states

### 4. Code Organization
- One class per file
- Group related files in folders
- Use meaningful names
- Keep functions small and focused

### 5. Error Handling
- Try-catch all async operations
- Provide user-friendly error messages
- Log errors for debugging
- Implement retry mechanisms

## Testing

### Unit Tests

```dart
test('LoadSchemesEvent emits SchemesLoaded', () async {
  when(() => mockService.getAllSchemes())
      .thenAnswer((_) async => [testScheme]);
  
  final bloc = SchemesBloc(mockService);
  
  bloc.add(LoadSchemesEvent());
  
  await expectLater(
    bloc.stream,
    emitsInOrder([
      SchemesLoading(),
      SchemesLoaded([testScheme]),
    ]),
  );
});
```

### Widget Tests

```dart
testWidgets('FeaturePage shows loading indicator', (tester) async {
  await tester.pumpWidget(
    MaterialApp(home: FeaturePage()),
  );
  
  expect(find.byType(CircularProgressIndicator), findsOneWidget);
});
```

## Common Tasks

### Adding a New Scheme Category

1. Add to `AppConstants.schemeCategories`
2. Update home page category grid
3. No code changes needed - dynamic from constants

### Adding a New Language

1. Create `l10n/app_[language].arb` file
2. Update `pubspec.yaml` supported locales
3. Implement language switcher in settings

### Updating Firebase Rules

1. Edit `firestore.rules` or `storage.rules`
2. Test rules locally
3. Deploy: `firebase deploy --only firestore:rules`

## Troubleshooting

### BLoC Not Updating UI
- Ensure states extend Equatable
- Override props in state classes
- Check BlocBuilder is inside BlocProvider

### Firebase Permission Denied
- Check Firestore rules
- Verify user is authenticated
- Ensure user has correct permissions

### Build Failures
```bash
flutter clean
flutter pub get
flutter run
```

## Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [BLoC Library](https://bloclibrary.dev/)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)

---

Happy coding! 🎉
