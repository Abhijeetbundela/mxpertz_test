part of 'login_bloc.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginErrorEvent extends LoginEvent {
  const LoginErrorEvent(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

class SendOtpEvent extends LoginEvent {
  const SendOtpEvent(this.phoneNumber);

  final String phoneNumber;

  @override
  List<Object> get props => [phoneNumber];
}

class OtpCodeSent extends LoginEvent {
  const OtpCodeSent(this.verificationId, this.phoneNumber);

  final String verificationId;
  final String phoneNumber;

  @override
  List<Object> get props => [verificationId, phoneNumber];
}
