import 'package:mxpertz_test/domain/entities/user_entity.dart';
import 'package:equatable/equatable.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeLoadingState extends HomeState {
  const HomeLoadingState();

  @override
  List<Object?> get props => [];
}

class GetUsersState extends HomeState {
  const GetUsersState(this.user);

  final UserEntity? user;

  @override
  List<Object?> get props => [user];
}

class HomeErrorState extends HomeState {
  const HomeErrorState(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class LogoutUserState extends HomeState {
  const LogoutUserState();
}
