import 'package:injectable/injectable.dart';
import 'package:mxpertz_test/core/constants/shared_prefs_keys.dart';
import 'package:mxpertz_test/core/services/shared_prefs_helper.dart';
import 'package:mxpertz_test/data/repositories/auth_repository.dart';
import 'package:mxpertz_test/data/repositories/firestore_repository.dart';
import 'package:mxpertz_test/domain/entities/user_entity.dart';

@LazySingleton()
class AuthSessionService {
  AuthSessionService(
    this._prefsHelper,
    this._firestoreRepository,
    this._authRepository,
  );

  final SharedPrefsHelper _prefsHelper;
  final FirestoreRepository _firestoreRepository;
  final AuthRepository _authRepository;

  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  UserEntity? getCurrentUser() => _prefsHelper.getUserEntity();

  Future<bool> isLoggedInAndExist() async {
    final user = _prefsHelper.getUserEntity();
    if (user == null) {
      return false;
    }
    final dbUser = await _firestoreRepository.getUserById(userId: user.id);
    _isLoggedIn = dbUser != null;
    if (dbUser != null) {
      await setSession(dbUser);
    }
    return _isLoggedIn;
  }

  Future<bool> setSession(UserEntity user) async {
    final result = await _prefsHelper.saveUserEntity(user);
    _isLoggedIn = true;
    return result;
  }

  Future<bool> setOnBoardSession(bool value) async {
    return await _prefsHelper.setBool(SharedPrefsKeys.isUserOnboard, value);
  }

  bool isOnBoardSession() {
    return _prefsHelper.getBool(SharedPrefsKeys.isUserOnboard);
  }

  Future<bool> clearSession() async {
    return _prefsHelper.clear();
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
    await clearSession();
    _isLoggedIn = false;
  }
}
