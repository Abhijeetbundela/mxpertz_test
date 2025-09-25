import 'package:injectable/injectable.dart';
import 'package:mxpertz_test/data/data_sources/firestore_datasource.dart';
import 'package:mxpertz_test/data/mappers/user_mapper.dart';
import 'package:mxpertz_test/domain/entities/user_entity.dart';

@LazySingleton()
class FirestoreRepository {
  FirestoreRepository(this._remoteDataSource);

  final FirestoreDatasource _remoteDataSource;

  Future<UserEntity?> getUserById({required String userId}) async {
    final model = await _remoteDataSource.getUserById(userId: userId);
    return model?.asEntity();
  }

  Future<List<UserEntity>> getAllUsers() async {
    final models = await _remoteDataSource.getAllUsers();
    return models.map((e) => e.asEntity()).toList();
  }

  Future<UserEntity> setUserById({
    required String id,
    required String name,
    required String email,
    required String phoneNumber,
  }) async {
    final model = await _remoteDataSource.setUserById(
      id: id,
      name: name,
      email: email,
      phoneNumber: phoneNumber,
    );
    return model.asEntity();
  }

  Future<UserEntity> updateUserById({
    required String id,
    required String name,
    required String email,
    required String phoneNumber,
  }) async {
    final model = await _remoteDataSource.updateUserById(
      id: id,
      name: name,
      email: email,
      phoneNumber: phoneNumber,
    );
    return model.asEntity();
  }
}
