import 'package:equatable/equatable.dart';

sealed class SignupState extends Equatable {
  const SignupState();

  @override
  List<Object> get props => [];
}

class SignupLoading extends SignupState {
  const SignupLoading(this.isLoading);

  final bool isLoading;

  @override
  List<Object> get props => [isLoading];
}

class SignupError extends SignupState {
  const SignupError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

class SignupSuccess extends SignupState {
  const SignupSuccess();

  @override
  List<Object> get props => [];
}
