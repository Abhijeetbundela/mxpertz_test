import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:mxpertz_test/core/di/injector.dart' as di;
import 'package:mxpertz_test/core/services/auth_session_service.dart';
import 'package:mxpertz_test/presentation/routes/app_router.dart';

Future<AppRouter> initializeApp(
  GlobalKey<NavigatorState> rootNavigatorKey,
) async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: WidgetsBinding.instance);
  await Firebase.initializeApp();
  await di.configureDependencies();
  final authSessionService = di.getIt<AuthSessionService>();
  final isLoggedInAndExist = await authSessionService.isLoggedInAndExist();
  FlutterNativeSplash.remove();
  return AppRouter(isLoggedInAndExist, rootNavigatorKey);
}
