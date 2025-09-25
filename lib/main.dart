import 'dart:async';

import 'package:flutter/material.dart';

import 'core/config/app_initializer.dart';
import 'presentation/routes/app_router.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

void main() async {
  await runZonedGuarded(
    () async {
      final appRouter = await initializeApp(_rootNavigatorKey);
      runApp(MyApp(appRouter: appRouter));
    },
    (error, stack) {
      runApp(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Text('App initialization error: ${error.toString()}'),
            ),
          ),
        ),
      );
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({required this.appRouter, super.key});

  final AppRouter appRouter;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter.router,
      debugShowCheckedModeBanner: false,
    );
  }
}
