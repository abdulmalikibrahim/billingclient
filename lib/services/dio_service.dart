import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DioService {
  static final DioService _instance = DioService._internal();
  late Dio dio;

  factory DioService() {
    return _instance;
  }

  DioService._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: dotenv.env['API_BASE_URL'] ?? '',
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
        headers: {
          'Accept': 'application/json',
        },
      ),
    );

    // Add retry interceptor (harus sebelum log interceptor)
    dio.interceptors.add(
      RetryInterceptor(
        dio: dio,
        retries: 3,
        retryDelays: const [
          Duration(seconds: 1), // Delay sebelum retry 1
          Duration(seconds: 2), // Delay sebelum retry 2
          Duration(seconds: 3), // Delay sebelum retry 3
        ],
      ),
    );

    // Logging (dev only)
    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
      ),
    );
  }
}

/// Retry Interceptor untuk auto-retry request yang gagal
/// Akan otomatis retry 3x untuk status code 500-599 (server errors)
class RetryInterceptor extends Interceptor {
  final Dio dio;
  final int retries;
  final List<Duration> retryDelays;

  RetryInterceptor({
    required this.dio,
    required this.retries,
    required this.retryDelays,
  });

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Cek apakah perlu retry
    final shouldRetry = _shouldRetry(err);

    if (shouldRetry && err.requestOptions.extra['retryCount'] == null) {
      // Set retry count
      err.requestOptions.extra['retryCount'] = 0;
    }

    final currentRetry = err.requestOptions.extra['retryCount'] ?? 0;

    if (shouldRetry && currentRetry < retries) {
      // Increment retry count
      err.requestOptions.extra['retryCount'] = currentRetry + 1;

      final delay = retryDelays[currentRetry < retryDelays.length
          ? currentRetry
          : retryDelays.length - 1];

      debugPrint('🔄 Retry ${currentRetry + 1}/$retries untuk ${err.requestOptions.path} setelah ${delay.inSeconds}s');

      // Delay dan retry
      Future.delayed(delay, () async {
        try {
          // Clone requestOptions untuk retry
          final newOptions = _cloneRequestOptions(err.requestOptions);
          final response = await dio.fetch(newOptions);
          handler.resolve(response);
        } on DioException catch (e) {
          super.onError(e, handler);
        }
      });

      return;
    }

    // Jika tidak perlu retry atau sudah max retries, lanjut ke error handler
    super.onError(err, handler);
  }

  /// Clone RequestOptions untuk retry
  /// FormData akan dibuat ulang untuk menghindari error "already finalized"
  RequestOptions _cloneRequestOptions(RequestOptions original) {
    final newOptions = original.copyWith();

    // Jika data adalah FormData yang sudah finalized, buat baru
    if (original.data is FormData) {
      final originalFormData = original.data as FormData;
      final newFormData = FormData();

      // Copy fields dari FormData asli
      for (var field in originalFormData.fields) {
        newFormData.fields.add(MapEntry(field.key, field.value));
      }

      // Copy files dari FormData asli (jika ada)
      for (var file in originalFormData.files) {
        newFormData.files.add(file);
      }

      newOptions.data = newFormData;
    }

    // Copy extra data seperti retryCount
    newOptions.extra.addAll(original.extra);

    return newOptions;
  }

  bool _shouldRetry(DioException err) {
    // Retry untuk server errors (500-599)
    if (err.response != null) {
      final statusCode = err.response!.statusCode;
      return statusCode != null &&
          statusCode >= 500 &&
          statusCode < 600;
    }

    // Juga retry untuk network errors
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError;
  }
}
