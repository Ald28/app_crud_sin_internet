import 'package:dio/dio.dart';
import '../../auth/auth_service.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await AuthService.getToken();

    if (token != null) {
      options.headers["Authorization"] = "Bearer $token";
    }

    super.onRequest(options, handler);
  }
}
