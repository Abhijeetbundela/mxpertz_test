part of 'login_bloc.dart';

sealed class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginLoading extends LoginState {
  const LoginLoading(this.isLoading);

  final bool isLoading;

  @override
  List<Object> get props => [isLoading];
}

class LoginError extends LoginState {
  const LoginError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

class OtpSent extends LoginState {
  const OtpSent(this.verificationId, this.phoneNumber);

  final String verificationId;
  final String phoneNumber;

  @override
  List<Object> get props => [verificationId, phoneNumber];
}
