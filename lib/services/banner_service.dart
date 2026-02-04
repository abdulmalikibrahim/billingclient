import 'package:billing_client/models/banner.dart';
import 'package:billing_client/models/base_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dio_service.dart';

class BannerService {
  final Dio _dio = DioService().dio;

  Future<BaseResponse<List<BannerModel>>> index({
    required String idMitra,
    required String idMikrotik
  }) async {
    try {
      final bearerToken = dotenv.env['AUTH_BEARER_TOKEN'];

      if (bearerToken == null || bearerToken.isEmpty) {
        throw Exception('AUTH_BEARER_TOKEN belum diset di env');
      }

      final response = await _dio.get(
        '/api_banner_get_data/$idMitra/$idMikrotik',
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

      return BaseResponse.fromJson(
        response.data,
            (json) => (json as List)
            .map((e) => BannerModel.fromJson(e))
            .toList(),
      );
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['msg'] ?? 'gagal mendapatkan data banner',
      );
    }
  }

  Future<BaseResponse<BannerModel>> show({
    required String id
  }) async {
    try {
      final bearerToken = dotenv.env['AUTH_BEARER_TOKEN'];

      if (bearerToken == null || bearerToken.isEmpty) {
        throw Exception('AUTH_BEARER_TOKEN belum diset di env');
      }

      final response = await _dio.get(
        '/api_banner_detail/$id',
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

      return BaseResponse<BannerModel>.fromJson(
        response.data, (json) => BannerModel.fromJson(json),
      );
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['msg'] ?? 'gagal mendapatkan data detail banner',
      );
    }
  }

}