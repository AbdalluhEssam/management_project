import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:noqta/Features/auth/presentation/pages/create_account.dart';
import 'package:noqta/Features/auth/presentation/pages/login.dart';
import 'package:noqta/Features/calculator/presentation/pages/calculator_page.dart';
import 'package:noqta/Features/home/presentation/pages/home_screen.dart';

// Helper method for page transitions
CustomTransitionPage customPageTransition(Widget child) {
  return CustomTransitionPage(
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      );
    },
  );
}

abstract class AppRouter {
  static const createAccount = '/createAccount';
  static const login = '/login';
  static const calculatorPage = '/calculatorPage';
  static const kBookDetailsView = '/bookDetailsView';
  static const kSearchView = '/searchView';
  static const homeScreen = '/HomeScreen';

  static final router = GoRouter(
    initialLocation: createAccount,
    routes: [
      GoRoute(
        path: createAccount,
        pageBuilder: (context, state) =>
            customPageTransition(CreateAccountPage()),
      ),
      GoRoute(
        path: login,
        pageBuilder: (context, state) => customPageTransition(LogInPage()),
      ),
      GoRoute(
        path: calculatorPage,
        pageBuilder: (context, state) =>  customPageTransition( const CalculatorPage()),

      ),
      GoRoute(
        path: homeScreen,
        pageBuilder: (context, state) =>  customPageTransition( const HomeScreen()),

      ),
    ],
  );
}
