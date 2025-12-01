import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';

class UserRemoteDataSource {
  final dio = DioClient().dio;

  Future<Map<String, dynamic>> register(String email, String password) async {
    final response = await dio.post(
      "/users/register",
      data: {"email": email, "password": password},
    );

    return response.data;
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await dio.post(
      "/users/login",
      data: {"email": email, "password": password},
    );

    return response.data;
  }
}