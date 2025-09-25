import 'package:mxpertz_test/data/models/user_model.dart';
import 'package:mxpertz_test/domain/entities/user_entity.dart';

extension UserModelMapper on UserModel {
  UserEntity asEntity() =>
      UserEntity(id: id, name: name, email: email, phoneNumber: phoneNumber);
}
