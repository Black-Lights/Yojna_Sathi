import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'config/theme/app_theme.dart';
import 'config/routes/app_router.dart';
import 'core/di/injection_container.dart';
import 'core/utils/constants.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/profile/presentation/bloc/profile_bloc.dart';
import 'features/schemes/presentation/bloc/schemes_bloc.dart';
import 'features/applications/presentation/bloc/applications_bloc.dart';
import 'features/notifications/data/services/notification_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Initialize Hive for offline storage
  await Hive.initFlutter();
  
  // Initialize dependency injection
  await initializeDependencies();
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  runApp(const SchemaMitraApp());
}

class SchemaMitraApp extends StatelessWidget {
  const SchemaMitraApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize notifications asynchronously after app starts
    Future.microtask(() async {
      try {
        final notificationService = sl<NotificationService>();
        await notificationService.initialize();
      } catch (e) {
        debugPrint('Failed to initialize notifications: $e');
      }
    });

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<AuthBloc>()..add(CheckAuthStatusEvent())),
        BlocProvider(create: (_) => sl<ProfileBloc>()),
        BlocProvider(create: (_) => sl<SchemesBloc>()..add(LoadSchemesEvent())),
        BlocProvider(create: (_) => sl<ApplicationsBloc>()),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''),
          Locale('hi', ''),
        ],
        onGenerateRoute: AppRouter.onGenerateRoute,
        initialRoute: AppRouter.splash,
      ),
    );
  }
}
