import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class FirebaseAuthDataSource {
  FirebaseAuthDataSource(this._auth);

  final FirebaseAuth _auth;
  String? _lastVerificationId;
  int? _lastResendToken;

  Future<void> sendOtp(
    String phoneNumber,
    Function(String verificationId, int? forceResend) codeSent,
    Function(String error)? onError,
  ) async {
    log('phoneNumber $phoneNumber');
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        if (onError != null) {
          onError(e.message ?? 'Unknown error');
        }
      },
      codeSent: (verificationId, forceResendingToken) {
        _lastVerificationId = verificationId;
        _lastResendToken = forceResendingToken;
        codeSent(verificationId, forceResendingToken);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _lastVerificationId = verificationId;
      },
      forceResendingToken: _lastResendToken,
    );
  }

  Future<void> resendOtp(
    String phoneNumber,
    Function(String verificationId, int? forceResend) codeSent,
    Function(String error)? onError,
  ) async {
    if (_lastResendToken == null) {
      if (onError != null) {
        onError('No resend token available. Try sending OTP first.');
      }
      return;
    }
    await sendOtp(phoneNumber, codeSent, onError);
  }

  Future<User?> verifyOtp(String verificationId, String smsCode) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    final userCredential = await _auth.signInWithCredential(credential);
    return userCredential.user;
  }

  User? getCurrentUser() => _auth.currentUser;

  String? get lastVerificationId => _lastVerificationId;

  Future<void> signOut() async => _auth.signOut();
}
