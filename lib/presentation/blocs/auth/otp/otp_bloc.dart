import 'dart:async';

import 'package:mxpertz_test/core/services/auth_session_service.dart';
import 'package:mxpertz_test/core/constants/app_constants.dart';
import 'package:mxpertz_test/data/repositories/auth_repository.dart';
import 'package:mxpertz_test/data/repositories/firestore_repository.dart';
import 'package:mxpertz_test/presentation/blocs/auth/otp/otp_event.dart';
import 'package:mxpertz_test/presentation/blocs/auth/otp/otp_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OtpBloc extends Bloc<OtpEvent, OtpState> {
  OtpBloc(
    this._authRepository,
    this._firestoreRepository,
    this._authSessionService,
  ) : super(const OtpLoading(false)) {
    on<OtpCodeResent>(_otpCodeResent);

    on<OtpErrorEvent>(_errorEvent);

    on<VerifyOtpEvent>(_verifyOtpEvent);

    on<OtpStartCountdown>(_otpStartCountdown);

    on<OtpTicked>(_otpTicked);

    on<OtpResendPressed>(_otpResendPressed);
  }

  final AuthRepository _authRepository;
  final FirestoreRepository _firestoreRepository;
  final AuthSessionService _authSessionService;
  Timer? _countdownTimer;

  void _otpCodeResent(OtpCodeResent event, emit) {
    emit(
      OtpTick(
        verificationId: event.verificationId,
        phoneNumber: event.phoneNumber,
        countdownRemaining: AppConstants.otpCountdownSeconds,
        canResend: false,
      ),
    );
    add(const OtpStartCountdown(AppConstants.otpCountdownSeconds));
  }

  void _emitError(Emitter<OtpState> emit, String message) {
    emit(const OtpLoading(false));
    emit(OtpError(message));
  }

  void _errorEvent(OtpErrorEvent event, emit) {
    _emitError(emit, event.message);
  }

  void _verifyOtpEvent(VerifyOtpEvent event, emit) async {
    emit(const OtpLoading(true));
    try {
      final user = await _authRepository.verifyOtp(
        verificationId: event.verificationId,
        smsCode: event.otp,
      );
      if (user != null) {
        final userModel = await _firestoreRepository.getUserById(
          userId: user.id,
        );
        if (userModel != null) {

          final data = await _firestoreRepository.updateUserById(
            id: userModel.id,
            name: userModel.name,
            email: userModel.email,
            phoneNumber: userModel.phoneNumber,
          );

          final isSet = await _authSessionService.setSession(data);
          if (isSet) {
            emit(const Registered());
          } else {
            _emitError(emit, 'Something went wrong');
          }
        } else {
          emit(const NotRegistered());
        }
      } else {
        _emitError(emit, 'Something went wrong');
      }
    } on Exception catch (e) {
      _emitError(emit, 'Failed to verify OTP: $e');
    }
    emit(const OtpLoading(false));
  }

  void _otpStartCountdown(OtpStartCountdown event, emit) async {
    _countdownTimer?.cancel();
    int remaining = event.seconds;
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      remaining = remaining - 1;
      if (remaining > 0) {
        add(OtpTicked(remaining));
      } else {
        timer.cancel();
        add(const OtpTicked(0));
      }
    });
  }

  void _otpTicked(OtpTicked event, emit) {
    final current = state;
    if (current is OtpTick) {
      if (event.remaining <= 0) {
        emit(
          OtpTick(
            verificationId: current.verificationId,
            phoneNumber: current.phoneNumber,
            countdownRemaining: 0,
            canResend: true,
          ),
        );
      } else {
        emit(
          OtpTick(
            verificationId: current.verificationId,
            phoneNumber: current.phoneNumber,
            countdownRemaining: event.remaining,
            canResend: false,
          ),
        );
      }
    }
  }

  void _otpResendPressed(OtpResendPressed event, emit) async {
    try {
      await _authRepository.resendOtp(
        phoneNumber: event.phoneNumber,
        codeSent: (verificationId, _) {
          add(OtpCodeResent(verificationId, event.phoneNumber));
        },
        onError: (error) {
          add(OtpErrorEvent(error));
        },
      );
    } on Exception catch (e) {
      _emitError(emit, 'Failed to resend OTP: $e');
    }
  }

  @override
  Future<void> close() async {
    _countdownTimer?.cancel();
    return super.close();
  }
}
