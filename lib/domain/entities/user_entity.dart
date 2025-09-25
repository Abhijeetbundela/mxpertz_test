import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.fcmToken,
  });

  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final String? fcmToken;

  @override
  List<Object?> get props => [id, name, email, phoneNumber, fcmToken];
}
