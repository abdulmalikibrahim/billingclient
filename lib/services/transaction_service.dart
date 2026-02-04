import 'package:billing_client/models/base_response.dart';
import 'package:billing_client/models/transaction.dart';
import 'package:billing_client/models/transaction_detail.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dio_service.dart';

class TransactionService {
  final Dio _dio = DioService().dio;

  Future<BaseResponse<List<TransactionModel>>> index({
    required String idClient,
    required String idMitra,
    required String limit,
    required String order,
  }) async {
    try {
      final bearerToken = dotenv.env['AUTH_BEARER_TOKEN'];

      if (bearerToken == null || bearerToken.isEmpty) {
        throw Exception('AUTH_BEARER_TOKEN belum diset di env');
      }

      final response = await _dio.get(
        '/a_get_transaction',
        queryParameters: {
          'id_client': idClient,
          'id_mitra': idMitra,
          'limit':limit,
          'order':order
        },
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
            .map((e) => TransactionModel.fromJson(e))
            .toList(),
      );
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['msg'] ?? 'gagal mendapatkan data transaksi',
      );
    }
  }

  Future<BaseResponse<TransactionDetailModel>> detail({
    required String idInvoice,
  }) async {
    try {
      final bearerToken = dotenv.env['AUTH_BEARER_TOKEN'];

      if (bearerToken == null || bearerToken.isEmpty) {
        throw Exception('AUTH_BEARER_TOKEN belum diset di env');
      }

      final response = await _dio.get(
        '/a_get_detail_transaction',
        queryParameters: {
          'id_invoice': idInvoice,
        },
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

      return BaseResponse<TransactionDetailModel>.fromJson(
        response.data, (json) => TransactionDetailModel.fromJson(json),
      );

    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['msg'] ?? 'gagal mendapatkan data detail transaksi',
      );
    }
  }
}
