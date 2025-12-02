import 'package:shared_preferences/shared_preferences.dart';
import 'datasources/user_remote_datasource.dart';
import 'models/user_model.dart';

class UserRepositoryImpl {
  final UserRemoteDataSource remote;

  UserRepositoryImpl(this.remote);

  Future<String> register(String email, String password) async {
    final result = await remote.register(email, password);
    return result["message"];
  }

  Future<UserModel> login(String email, String password) async {
    final result = await remote.login(email, password);
    final user = UserModel.fromJson(result);

    return user;
  }
}
