import 'package:billing_client/models/base_response.dart';
import 'package:billing_client/models/technisian.dart';
import 'package:billing_client/models/ticket.dart';
import 'package:billing_client/models/transaction.dart';
import 'package:billing_client/models/transaction_detail.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dio_service.dart';

class TicketService {
  final Dio _dio = DioService().dio;

  Future<BaseResponse<List<TicketModel>>> index({
    required String idClient,
  }) async {
    try {
      final bearerToken = dotenv.env['AUTH_BEARER_TOKEN'];

      if (bearerToken == null || bearerToken.isEmpty) {
        throw Exception('AUTH_BEARER_TOKEN belum diset di env');
      }

      final response = await _dio.get(
        '/a_get_ticket',
        queryParameters: {'id_client': idClient},
        options: Options(
          headers: {
            'Authorization': 'Bearer $bearerToken',
            'Content-Type': 'application/json',
          },
        ),
      );

      final body = response.data;

      // Handle 204 No Content atau body kosong/null
      if (body == null || body == '' || response.statusCode == 204) {
        return BaseResponse(data: [], statusCode: 200, msg: 'Data kosong');
      }

      // Handle jika body bukan Map (misal string kosong)
      if (body is! Map<String, dynamic>) {
        return BaseResponse(data: [], statusCode: 200, msg: 'Data kosong');
      }

      if (body['statusCode'] != 200) {
        throw Exception(body['msg'] ?? 'Gagal mengambil data ticket');
      }

      final rawData = body['data'];

      // 🔥 HANDLE NULL / BUKAN LIST
      final List<TicketModel> tickets = rawData is List
          ? rawData.map((e) => TicketModel.fromJson(e)).toList()
          : [];

      return BaseResponse(
        statusCode: body['statusCode'],
        msg: body['msg'],
        data: tickets,
      );
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['msg'] ?? 'Gagal mendapatkan data ticket',
      );
    }
  }

  /// CREATE / STORE TICKET
  Future<BaseResponse<dynamic>> store({
    required int idClient,
    required int idMitra,
    required String tipeProblem,
    required String idTeknisi,
    required String difficulty,
    required String problem,
  }) async {
    try {
      final bearerToken = dotenv.env['AUTH_BEARER_TOKEN'];

      if (bearerToken == null || bearerToken.isEmpty) {
        throw Exception('AUTH_BEARER_TOKEN belum diset di env');
      }

      final response = await _dio.post(
        '/a_create_ticket',
        data: {
          'id_client': idClient,
          'id_mitra': idMitra,
          'tipe_problem': tipeProblem,
          'id_teknisi': idTeknisi,
          'difficulty': difficulty,
          'problem': problem,
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

      return BaseResponse.fromJson(response.data, (_) => null);
    } on DioException catch (e) {
      throw Exception(e.response?.data?['msg'] ?? 'gagal membuat ticket');
    }
  }

  Future<BaseResponse<List<TechnisianModel>>> getTechnisian({
    required int idMitra,
  }) async {
    try {
      final bearerToken = dotenv.env['AUTH_BEARER_TOKEN'];

      if (bearerToken == null || bearerToken.isEmpty) {
        throw Exception('AUTH_BEARER_TOKEN belum diset di env');
      }

      final response = await _dio.get(
        '/a_get_teknisi',
        queryParameters: {'id_mitra': idMitra},
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
        response.data,
        (json) =>
            (json as List).map((e) => TechnisianModel.fromJson(e)).toList(),
      );
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['msg'] ?? 'gagal mendapatkan data teknisi',
      );
    }
  }
}
