import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Services
import '../../features/auth/data/services/auth_service.dart';
import '../../features/profile/data/services/profile_service.dart';
import '../../features/schemes/data/services/schemes_service.dart';
import '../../features/applications/data/services/applications_service.dart';
import '../../features/tutorials/data/services/tutorials_service.dart';
import '../../features/notifications/data/services/notification_service.dart';
import '../services/storage_service.dart';
import '../services/eligibility_service.dart';

// BLoCs
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/profile/presentation/bloc/profile_bloc.dart';
import '../../features/schemes/presentation/bloc/schemes_bloc.dart';
import '../../features/applications/presentation/bloc/applications_bloc.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // External Dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => FirebaseStorage.instance);
  sl.registerLazySingleton(() => FirebaseMessaging.instance);

  // Core Services
  sl.registerLazySingleton<StorageService>(
    () => StorageService(sl()),
  );
  
  sl.registerLazySingleton<EligibilityService>(
    () => EligibilityService(),
  );

  // Feature Services
  sl.registerLazySingleton<AuthService>(
    () => AuthService(sl(), sl()),
  );

  sl.registerLazySingleton<ProfileService>(
    () => ProfileService(sl()),
  );

  sl.registerLazySingleton<SchemesService>(
    () => SchemesService(
      sl(),
      eligibilityService: sl(),
      profileService: sl(),
    ),
  );

  sl.registerLazySingleton<ApplicationsService>(
    () => ApplicationsService(sl(), sl()),
  );

  sl.registerLazySingleton<TutorialsService>(
    () => TutorialsService(sl()),
  );

  sl.registerLazySingleton<NotificationService>(
    () => NotificationService(sl(), sl()),
  );

  // BLoCs
  sl.registerFactory(() => AuthBloc(sl(), sl()));
  sl.registerFactory(() => ProfileBloc(sl()));
  sl.registerFactory(() => SchemesBloc(sl(), sl()));
  sl.registerFactory(() => ApplicationsBloc(sl(), sl(), sl()));
}
