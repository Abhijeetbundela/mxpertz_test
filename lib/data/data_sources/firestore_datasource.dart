import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:mxpertz_test/core/constants/firebase/firestore_collections.dart';
import 'package:mxpertz_test/data/models/user_model.dart';

@LazySingleton()
class FirestoreDatasource {
  FirestoreDatasource(this._firebaseFirestore);

  final FirebaseFirestore _firebaseFirestore;

  CollectionReference get _usersCollection =>
      _firebaseFirestore.collection(FirestoreCollections.users);

  Future<UserModel?> getUserById({required String userId}) async {
    final doc = await _usersCollection.doc(userId).get();

    if (!doc.exists) {
      return null;
    }

    final data = doc.data()!;
    return UserModel.fromJson(data as Map<String, dynamic>);
  }

  Future<List<UserModel>> getAllUsers() async {
    final docs = (await _usersCollection.get()).docs;

    return docs.map((doc) {
      return UserModel.fromJson(doc.data() as Map<String, dynamic>);
    }).toList();
  }

  Future<UserModel> setUserById({
    required String id,
    required String name,
    required String email,
    required String phoneNumber,
  }) async {
    final data = UserModel(
      id: id,
      name: name,
      email: email,
      phoneNumber: phoneNumber,
    );
    await _usersCollection.doc(data.id).set(data.toJson()).catchError((e) {
      throw e;
    });
    return data;
  }

  Future<UserModel> updateUserById({
    required String id,
    required String name,
    required String email,
    required String phoneNumber,
  }) async {
    final data = UserModel(
      id: id,
      name: name,
      email: email,
      phoneNumber: phoneNumber,
    );
    await _usersCollection.doc(data.id).update(data.toJson()).catchError((e) {
      throw e;
    });
    return data;
  }
}
