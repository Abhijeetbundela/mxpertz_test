import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mxpertz_test/presentation/screens/auth/login_screen.dart';
import 'package:mxpertz_test/presentation/screens/auth/otp_screen.dart';
import 'package:mxpertz_test/presentation/screens/auth/signup_screen.dart';
import 'package:mxpertz_test/presentation/screens/home/home_screen.dart';
import 'package:mxpertz_test/presentation/screens/onboarding/onboarding_screen.dart';

class RouterPaths {
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String otp = '/otp';
  static const String signup = '/signup';
  static const String home = '/home';
}

class AppRouter {
  AppRouter(this._isLoggedIn, this._hasCompletedOnboarding, this._navigatorKey);

  final bool _isLoggedIn;
  final bool _hasCompletedOnboarding;
  final GlobalKey<NavigatorState> _navigatorKey;

  String getInitialLocation() {
    if (!_hasCompletedOnboarding) {
      return RouterPaths.onboarding;
    }
    if (_isLoggedIn) {
      return RouterPaths.home;
    }
    return RouterPaths.login;
  }

  late final GoRouter router = GoRouter(
    initialLocation: getInitialLocation(),
    navigatorKey: _navigatorKey,
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Page Not Found')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64),
            const SizedBox(height: 16),
            Text(
              'Page not found: ${state.error}',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(RouterPaths.home),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),

    routes: [
      GoRoute(
        path: RouterPaths.onboarding,
        builder: (context, state) => const OnboardingScreen(),
        pageBuilder: (context, state) => _buildPageWithFadeTransition(
          context,
          state,
          const OnboardingScreen(),
        ),
      ),
      GoRoute(
        path: RouterPaths.login,
        builder: (context, state) => const LoginScreen(),
        pageBuilder: (context, state) =>
            _buildPageWithSlideTransition(context, state, const LoginScreen()),
      ),
      GoRoute(
        path: RouterPaths.otp,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return OtpScreen(
            verificationId: extra?['verificationId'] ?? '',
            phoneNumber: extra?['phoneNumber'] ?? '',
          );
        },
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return _buildPageWithSlideTransition(
            context,
            state,
            OtpScreen(
              verificationId: extra?['verificationId'] ?? '',
              phoneNumber: extra?['phoneNumber'] ?? '',
            ),
          );
        },
      ),
      GoRoute(
        path: RouterPaths.signup,
        builder: (context, state) => const SignupScreen(),
        pageBuilder: (context, state) =>
            _buildPageWithSlideTransition(context, state, const SignupScreen()),
      ),
      GoRoute(
        path: RouterPaths.home,
        builder: (context, state) => const HomeScreen(),
        pageBuilder: (context, state) =>
            _buildPageWithFadeTransition(context, state, const HomeScreen()),
      ),
    ],
  );

  // Custom page transitions for better UX
  static Page<void> _buildPageWithSlideTransition(
    BuildContext context,
    GoRouterState state,
    Widget child,
  ) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: animation.drive(
            Tween(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).chain(CurveTween(curve: Curves.easeInOut)),
          ),
          child: child,
        );
      },
    );
  }

  static Page<void> _buildPageWithFadeTransition(
    BuildContext context,
    GoRouterState state,
    Widget child,
  ) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
          child: child,
        );
      },
    );
  }
}
