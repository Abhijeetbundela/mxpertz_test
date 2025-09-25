import 'package:equatable/equatable.dart';

sealed class OtpState with EquatableMixin {
  const OtpState();

  @override
  List<Object?> get props => [];
}

class OtpLoading extends OtpState {
  const OtpLoading(this.isLoading);

  final bool isLoading;

  @override
  List<Object?> get props => [isLoading];
}

class OtpError extends OtpState {
  const OtpError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class OtpResent extends OtpState {
  const OtpResent(this.verificationId, this.phoneNumber);

  final String verificationId;
  final String phoneNumber;

  @override
  List<Object?> get props => [verificationId, phoneNumber];
}

class OtpTick extends OtpState {
  const OtpTick({
    required this.verificationId,
    required this.phoneNumber,
    this.countdownRemaining = 0,
    this.canResend = false,
  });

  final String verificationId;
  final String phoneNumber;
  final int countdownRemaining;
  final bool canResend;

  @override
  List<Object?> get props => [
    verificationId,
    phoneNumber,
    countdownRemaining,
    canResend,
  ];
}

class Registered extends OtpState {
  const Registered();

  @override
  List<Object?> get props => [];
}

class NotRegistered extends OtpState {
  const NotRegistered();

  @override
  List<Object?> get props => [];
}
