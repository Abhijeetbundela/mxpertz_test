import 'package:mxpertz_test/core/di/injector.config.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

GetIt getIt = GetIt.instance;

@injectableInit
Future<void> configureDependencies() async => getIt.init();
