import 'package:flutter/material.dart';

import '../screens/auth/forgot_password_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/emergency/ambulance_assigned_screen.dart';
import '../screens/emergency/confirm_location_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/hospitals/nearby_hospitals_screen.dart';
import '../screens/medical_profile/medical_profile_screen.dart';

/// Simple named-route generator with a shared slide+fade transition, used
/// instead of go_router's declarative API for straightforward push/pop flows.
class AppRouter {
  AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final builders = <String, WidgetBuilder>{
      '/login': (_) => const LoginScreen(),
      '/signup': (_) => const SignupScreen(),
      '/forgot-password': (_) => const ForgotPasswordScreen(),
      '/home': (_) => const HomeScreen(),
      '/medical-profile': (_) => const MedicalProfileScreen(),
      '/confirm-location': (_) => const ConfirmLocationScreen(),
      '/ambulance-assigned': (_) => const AmbulanceAssignedScreen(),
      '/hospitals': (_) => const NearbyHospitalsScreen(),
    };

    final builder = builders[settings.name] ?? (_) => const LoginScreen();

    return PageRouteBuilder(
      settings: settings,
      transitionDuration: const Duration(milliseconds: 320),
      pageBuilder: (context, animation, secondaryAnimation) => builder(context),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final fade = CurvedAnimation(parent: animation, curve: Curves.easeOut);
        final slide = Tween<Offset>(
          begin: const Offset(0.04, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));
        return FadeTransition(
          opacity: fade,
          child: SlideTransition(position: slide, child: child),
        );
      },
    );
  }
}
