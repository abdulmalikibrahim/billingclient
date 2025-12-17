import 'package:dio/dio.dart';
import 'dio_service.dart';

class AuthService {
  final Dio _dio = DioService().dio;

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '/login',
        data: {
          'username': email,
          'password': password,
        },
      );

      return response.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data['msg'] ?? 'Login gagal');
    }
  }
}
