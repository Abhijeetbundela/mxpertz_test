import 'package:mxpertz_test/data/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(this._authRepository) : super(const LoginLoading(false)) {
    on<SendOtpEvent>(_sentOtpEvent);

    on<OtpCodeSent>(_otpCodeSent);

    on<LoginErrorEvent>(_errorEvent);
  }

  final AuthRepository _authRepository;

  void _sentOtpEvent(SendOtpEvent event, emit) async {
    emit(const LoginLoading(true));
    try {
      await _authRepository.sendOtp(
        phoneNumber: event.phoneNumber,
        codeSent: (verificationId, _) {
          add(OtpCodeSent(verificationId, event.phoneNumber));
        },
        onError: (error) {
          add(LoginErrorEvent(error));
        },
      );
    } on Exception catch (e) {
      _emitError(emit, 'Failed to send OTP: $e');
    }
  }

  void _otpCodeSent(OtpCodeSent event, emit) {
    emit(const LoginLoading(false));
    emit(OtpSent(event.verificationId, event.phoneNumber));
  }

  void _errorEvent(LoginErrorEvent event, emit) {
    _emitError(emit, event.message);
  }

  void _emitError(Emitter<LoginState> emit, String message) {
    emit(const LoginLoading(false));
    emit(LoginError(message));
  }
}
