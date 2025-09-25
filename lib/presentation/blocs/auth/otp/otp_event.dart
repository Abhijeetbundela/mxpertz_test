import 'package:equatable/equatable.dart';

sealed class OtpEvent extends Equatable {
  const OtpEvent();

  @override
  List<Object> get props => [];
}

class OtpErrorEvent extends OtpEvent {
  const OtpErrorEvent(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

class OtpCodeResent extends OtpEvent {
  const OtpCodeResent(this.verificationId, this.phoneNumber);

  final String verificationId;
  final String phoneNumber;

  @override
  List<Object> get props => [verificationId, phoneNumber];
}

class OtpResendPressed extends OtpEvent {
  const OtpResendPressed(this.phoneNumber);

  final String phoneNumber;

  @override
  List<Object> get props => [phoneNumber];
}

class OtpStartCountdown extends OtpEvent {
  const OtpStartCountdown(this.seconds);

  final int seconds;

  @override
  List<Object> get props => [seconds];
}

class OtpTicked extends OtpEvent {
  const OtpTicked(this.remaining);

  final int remaining;

  @override
  List<Object> get props => [remaining];
}

class OtpCodeChanged extends OtpEvent {
  const OtpCodeChanged(this.code);

  final String code;

  @override
  List<Object> get props => [code];
}

class VerifyOtpEvent extends OtpEvent {
  const VerifyOtpEvent(this.verificationId, this.otp);

  final String verificationId;
  final String otp;

  @override
  List<Object> get props => [verificationId, otp];
}
