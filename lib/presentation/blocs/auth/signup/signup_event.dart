import 'package:equatable/equatable.dart';

sealed class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object> get props => [];
}

class SignupErrorEvent extends SignupEvent {
  const SignupErrorEvent(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

class SignupRegisterEvent extends SignupEvent {
  const SignupRegisterEvent(this.name, this.email);

  final String name;
  final String email;

  @override
  List<Object> get props => [name, email];
}
