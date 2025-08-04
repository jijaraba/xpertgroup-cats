import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/pages/splash_page.dart';
import '../../presentation/pages/breeds_page.dart';
import '../../presentation/pages/voting_page.dart';
import '../../presentation/widgets/main_navigation.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashPage(),
    ),
    ShellRoute(
      builder: (context, state, child) => MainNavigation(child: child),
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const BreedsPage(),
        ),
        GoRoute(
          path: '/voting',
          builder: (context, state) => const VotingPage(),
        ),
      ],
    ),
  ],
);