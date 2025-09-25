// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:mxpertz_test/core/di/firebase_module.dart' as _i965;
import 'package:mxpertz_test/core/di/register_module.dart' as _i235;
import 'package:mxpertz_test/core/services/auth_session_service.dart' as _i935;
import 'package:mxpertz_test/core/services/shared_prefs_helper.dart' as _i149;
import 'package:mxpertz_test/data/data_sources/firebase_auth_datasource.dart'
    as _i557;
import 'package:mxpertz_test/data/data_sources/firestore_datasource.dart'
    as _i136;
import 'package:mxpertz_test/data/repositories/auth_repository.dart' as _i143;
import 'package:mxpertz_test/data/repositories/firestore_repository.dart'
    as _i239;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    final firebaseModule = _$FirebaseModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => registerModule.prefs,
      preResolve: true,
    );
    gh.lazySingleton<_i59.FirebaseAuth>(() => firebaseModule.auth);
    gh.lazySingleton<_i974.FirebaseFirestore>(() => firebaseModule.firestore);
    gh.lazySingleton<_i149.SharedPrefsHelper>(
      () => _i149.SharedPrefsHelper(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i136.FirestoreDatasource>(
      () => _i136.FirestoreDatasource(gh<_i974.FirebaseFirestore>()),
    );
    gh.lazySingleton<_i557.FirebaseAuthDataSource>(
      () => _i557.FirebaseAuthDataSource(gh<_i59.FirebaseAuth>()),
    );
    gh.lazySingleton<_i143.AuthRepository>(
      () => _i143.AuthRepository(gh<_i557.FirebaseAuthDataSource>()),
    );
    gh.lazySingleton<_i239.FirestoreRepository>(
      () => _i239.FirestoreRepository(gh<_i136.FirestoreDatasource>()),
    );
    gh.lazySingleton<_i935.AuthSessionService>(
      () => _i935.AuthSessionService(
        gh<_i149.SharedPrefsHelper>(),
        gh<_i239.FirestoreRepository>(),
        gh<_i143.AuthRepository>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i235.RegisterModule {}

class _$FirebaseModule extends _i965.FirebaseModule {}
