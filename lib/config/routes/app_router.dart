import 'package:flutter/material.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/profile/presentation/pages/profile_create_page.dart';
import '../../features/profile/presentation/pages/profile_edit_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/schemes/presentation/pages/scheme_list_page.dart';
import '../../features/schemes/presentation/pages/scheme_detail_page.dart';
import '../../features/applications/presentation/pages/application_form_page.dart';
import '../../features/applications/presentation/pages/applications_list_page.dart';
import '../../features/applications/presentation/pages/application_detail_page.dart';
import '../../features/tutorials/presentation/pages/tutorial_player_page.dart';
import '../../features/notifications/presentation/pages/notifications_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';

class AppRouter {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String profileCreate = '/profile-create';
  static const String profileEdit = '/profile-edit';
  static const String home = '/home';
  static const String schemeList = '/schemes';
  static const String schemeDetail = '/scheme-detail';
  static const String applicationForm = '/application-form';
  static const String applicationsList = '/applications';
  static const String applicationDetail = '/application-detail';
  static const String tutorialPlayer = '/tutorial';
  static const String notifications = '/notifications';
  static const String settings = '/settings';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashPage());
      
      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterPage());
      
      case profileCreate:
        return MaterialPageRoute(builder: (_) => const ProfileCreatePage());
      
      case profileEdit:
        return MaterialPageRoute(builder: (_) => const ProfileEditPage());
      
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      
      case schemeList:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => SchemeListPage(
            category: args?['category'],
            eligibleOnly: args?['eligibleOnly'] ?? false,
          ),
        );
      
      case schemeDetail:
        final schemeId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => SchemeDetailPage(schemeId: schemeId),
        );
      
      case applicationForm:
        final schemeId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => ApplicationFormPage(schemeId: schemeId),
        );
      
      case applicationsList:
        return MaterialPageRoute(builder: (_) => const ApplicationsListPage());
      
      case applicationDetail:
        final applicationId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => ApplicationDetailPage(applicationId: applicationId),
        );
      
      case tutorialPlayer:
        final tutorialId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => TutorialPlayerPage(tutorialId: tutorialId),
        );
      
      case notifications:
        return MaterialPageRoute(builder: (_) => const NotificationsPage());
      
      case settings:
        return MaterialPageRoute(builder: (_) => const SettingsPage());
      
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
