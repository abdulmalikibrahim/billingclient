import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dio_service.dart';
import '../utils/secure_session_service.dart';

class AuthService {
  final Dio _dio = DioService().dio;

  Future<void> login({
    required String username,
    required String password,
  }) async {
    try {
      final bearerToken = dotenv.env['AUTH_BEARER_TOKEN'];

      if (bearerToken == null || bearerToken.isEmpty) {
        throw Exception('AUTH_BEARER_TOKEN belum diset di env');
      }

      final response = await _dio.post(
        '/a_login_check',
        data: FormData.fromMap({
          'username': username,
          'password': password,
        }),
        options: Options(
          headers: {
            'Authorization': 'Bearer $bearerToken',
            'Content-Type': 'application/json'
          },
        ),
      );

      if (response.data['statusCode'] != 200) {
        throw Exception(response.data['msg']);
      }

      await SecureSessionService.saveSession(
        response.data['data'],
      );
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['msg'] ?? 'Login gagal',
      );
    }
  }
}
