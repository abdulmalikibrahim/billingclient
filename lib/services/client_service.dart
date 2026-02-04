import 'package:billing_client/models/base_response.dart';
import 'package:billing_client/models/client.dart';
import 'package:billing_client/services/dio_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ClientService {
  final Dio _dio = DioService().dio;

  // ============================================================
  // SHOW DETAIL CLIENT
  // ============================================================
  Future<BaseResponse<ClientModel>> show({
    required String idClient,
    required String idMitra,
  }) async {
    try {
      final bearerToken = dotenv.env['AUTH_BEARER_TOKEN'];

      if (bearerToken == null || bearerToken.isEmpty) {
        throw Exception('AUTH_BEARER_TOKEN belum diset di env');
      }

      final formData = FormData.fromMap({
        'id_client': idClient,
        'id_mitra': idMitra,
      });

      final response = await _dio.post(
        '/a_detail_client',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $bearerToken',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (response.data['statusCode'] != 200) {
        throw Exception(response.data['msg']);
      }

      return BaseResponse.fromJson(
        response.data, (json) => ClientModel.fromJson(json),
      );
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['msg'] ?? 'gagal mendapatkan detail client',
      );
    }
  }

  /// CREATE / STORE TICKET
  Future<BaseResponse<dynamic>> registerFcm({
    required int idClient,
    required int idMitra,
    required String fcmToken,
    required String deviceName,
    required String deviceID,
  }) async {
    try {
      final bearerToken = dotenv.env['AUTH_BEARER_TOKEN'];

      if (bearerToken == null || bearerToken.isEmpty) {
        throw Exception('AUTH_BEARER_TOKEN belum diset di env');
      }

      final response = await _dio.post(
        '/api/fcm/register_token',
        data: {
          'id_client': idClient,
          'id_mitra': idMitra,
          'fcm_token': fcmToken,
          'device_name': deviceName,
          'device_id': deviceID,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $bearerToken',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.data['statusCode'] != 200) {
        throw Exception(response.data['msg']);
      }

      return BaseResponse.fromJson(
        response.data, (_) => null,
      );
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['msg'] ?? 'gagal membuat ticket',
      );
    }
  }

}
