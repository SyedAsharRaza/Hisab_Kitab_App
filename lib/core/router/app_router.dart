import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/injection_container.dart';
import '../../features/auth/presentation/screens/sign_up_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../constants/app_constants.dart';
import '../services/local_storage/local_storage_service.dart';
import 'route_names.dart';
import 'route_transitions.dart';

import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/ledger_entry/presentation/screens/add_entry_screen.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';

class AppRouter {
  AppRouter._();

  static GoRouter build({required AuthProvider authProvider}) {
    return GoRouter(
      initialLocation: RouteNames.splash, // initially splash screen par
      refreshListenable: authProvider,
      redirect: (context, state) {
        final localStorage = sl<LocalStorageService>();
        final hasSeenOnboarding = localStorage.getBool(
          AppConstants.keyHasSeenOnboarding,
        );

        final isAuthRoute = state.matchedLocation == RouteNames.login ||
            state.matchedLocation == RouteNames.signup;
        final isOnboardingRoute = state.matchedLocation == RouteNames.onboarding;
        final isSplashRoute = state.matchedLocation == RouteNames.splash;

        if (authProvider.isCheckingAuth) {
          return isSplashRoute ? null : RouteNames.splash;
        }
        if (isSplashRoute) {
          if (!hasSeenOnboarding) return RouteNames.onboarding;
          if (!authProvider.isAuthenticated) return RouteNames.login;
          return RouteNames.dashboard;
        }
        if (!hasSeenOnboarding && !isOnboardingRoute) {
          return RouteNames.onboarding;
        }
        if (hasSeenOnboarding &&
            !authProvider.isAuthenticated &&
            !isAuthRoute &&
            !isOnboardingRoute) {
          return RouteNames.login;
        }
        if (authProvider.isAuthenticated && (isAuthRoute || isOnboardingRoute)) {
          return RouteNames.dashboard;
        }

        return null;
      },
      routes: [
        GoRoute(
          path: RouteNames.splash,
          pageBuilder: (context, state) => RouteTransitions.fade(
            child: const SplashScreen(),
            state: state,
          ),
        ),
        GoRoute(
          path: RouteNames.onboarding,
          pageBuilder: (context, state) => RouteTransitions.fade(
            child: const OnboardingScreen(),
            state: state,
          ),
        ),
        GoRoute(
          path: RouteNames.login,
          pageBuilder: (context, state) => RouteTransitions.slideFromRight(
            child: const LoginScreen(),
            state: state,
          ),
        ),
        GoRoute(
          path: RouteNames.signup,
          pageBuilder: (context, state) => RouteTransitions.slideFromRight(
            child: const SignupScreen(),
            state: state,
          ),
        ),
        GoRoute(
          path: RouteNames.dashboard,
          pageBuilder: (context, state) => RouteTransitions.fade(
            child: const DashboardScreen(),
            state: state,
          ),
        ),
        GoRoute(
          path: RouteNames.addEntry,
          pageBuilder: (context, state) => RouteTransitions.slideFromBottom(
            child: const AddEntryScreen(),
            state: state,
          ),
        ),
      ],
      errorBuilder: (context, state) => Scaffold(
        body: Center(child: Text('Route not found: ${state.uri}')),
      ),
    );
  }
}