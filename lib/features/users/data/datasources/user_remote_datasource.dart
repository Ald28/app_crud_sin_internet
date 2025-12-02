import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';

class UserRemoteDataSource {
  final dio = DioClient().dio;

  Future<Map<String, dynamic>> register(String email, String password) async {
    try {
      final response = await dio.post(
        "/users/register",
        data: {"email": email, "password": password},
      );

      return response.data;
    } on DioException catch (e) {
      throw Exception("Error de conexión al registrar");
    } catch (e) {
      throw Exception("Error inesperado al registrar");
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await dio.post(
        "/users/login",
        data: {"email": email, "password": password},
      );

      return response.data;
    } on DioException catch (e) {
      throw Exception("Error de conexión: no se pudo contactar al servidor");
    } catch (e) {
      throw Exception("Error inesperado al iniciar sesión");
    }
  }
}
