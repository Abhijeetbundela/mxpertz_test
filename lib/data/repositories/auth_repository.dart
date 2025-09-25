import 'package:injectable/injectable.dart';
import 'package:mxpertz_test/data/data_sources/firebase_auth_datasource.dart';
import 'package:mxpertz_test/domain/entities/user_entity.dart';

@LazySingleton()
class AuthRepository {
  AuthRepository(this._remoteDataSource);

  final FirebaseAuthDataSource _remoteDataSource;

  Future<void> sendOtp({
    required String phoneNumber,
    required Function(String verificationId, int? forceResend) codeSent,
    required Function(String error)? onError,
  }) async {
    await _remoteDataSource.sendOtp(phoneNumber, codeSent, onError);
  }

  Future<UserEntity?> verifyOtp({
    required String verificationId,
    required String smsCode,
  }) async {
    final user = await _remoteDataSource.verifyOtp(verificationId, smsCode);
    if (user != null) {
      return UserEntity(
        id: user.uid,
        phoneNumber: user.phoneNumber ?? '',
        name: '',
        email: '',
      );
    }
    return null;
  }

  Future<void> resendOtp({
    required String phoneNumber,
    required Function(String verificationId, int? forceResend) codeSent,
    required Function(String error)? onError,
  }) async {
    await _remoteDataSource.resendOtp(phoneNumber, codeSent, onError);
  }

  UserEntity? getCurrentUser() {
    final user = _remoteDataSource.getCurrentUser();
    if (user != null) {
      return UserEntity(
        id: user.uid,
        phoneNumber: user.phoneNumber ?? '',
        name: '',
        email: '',
      );
    }
    return null;
  }

  Future<void> signOut() async {
    await _remoteDataSource.signOut();
  }
}
