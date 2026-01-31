import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../error/faliures.dart';
import 'network_info.dart';

/// Dio konfiguratsiyasi va API so'rovlari uchun markaziy klient
class DioClient {
  final Dio _dio;
  final NetworkInfo _networkInfo;
  final Logger _logger = Logger();

  DioClient({
    required NetworkInfo networkInfo,
    String? baseUrl,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    Duration? sendTimeout,
  })  : _networkInfo = networkInfo,
        _dio = Dio(
          BaseOptions(
            baseUrl: baseUrl ?? '',
            connectTimeout: connectTimeout ?? const Duration(seconds: 30),
            receiveTimeout: receiveTimeout ?? const Duration(seconds: 30),
            sendTimeout: sendTimeout ?? const Duration(seconds: 30),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        ) {
    _setupInterceptors();
  }

  /// Interceptorlarni sozlash
  void _setupInterceptors() {
    _dio.interceptors.addAll([
      _LoggingInterceptor(_logger),
      _ErrorInterceptor(),
      _RetryInterceptor(_dio),
    ]);
  }

  /// Auth token'ini yangilash
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  /// Auth token'ini o'chirish
  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }

  /// Base URL'ni yangilash
  void updateBaseUrl(String baseUrl) {
    _dio.options.baseUrl = baseUrl;
  }

  /// Custom header qo'shish
  void addHeader(String key, String value) {
    _dio.options.headers[key] = value;
  }

  /// Internet ulanishini tekshirish
  Future<void> _checkConnectivity() async {
    final isConnected = await _networkInfo.isConnected;
    if (!isConnected) {
      throw NetworkException(
        message: NetworkFailure.noConnection().message,
      );
    }
  }

  /// GET so'rovi
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onReceiveProgress,
    bool checkConnectivity = true,
  }) async {
    if (checkConnectivity) await _checkConnectivity();
    
    return _dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    );
  }

  /// POST so'rovi
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
    bool checkConnectivity = true,
  }) async {
    if (checkConnectivity) await _checkConnectivity();
    
    return _dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  /// PUT so'rovi
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
    bool checkConnectivity = true,
  }) async {
    if (checkConnectivity) await _checkConnectivity();
    
    return _dio.put<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  /// PATCH so'rovi
  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
    bool checkConnectivity = true,
  }) async {
    if (checkConnectivity) await _checkConnectivity();
    
    return _dio.patch<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  /// DELETE so'rovi
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    bool checkConnectivity = true,
  }) async {
    if (checkConnectivity) await _checkConnectivity();
    
    return _dio.delete<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  /// Fayl yuklash (Upload)
  Future<Response<T>> uploadFile<T>(
    String path, {
    required File file,
    required String fieldName,
    Map<String, dynamic>? additionalData,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    bool checkConnectivity = true,
  }) async {
    if (checkConnectivity) await _checkConnectivity();

    final fileName = file.path.split('/').last;
    final formData = FormData.fromMap({
      fieldName: await MultipartFile.fromFile(
        file.path,
        filename: fileName,
      ),
      if (additionalData != null) ...additionalData,
    });

    return _dio.post<T>(
      path,
      data: formData,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
    );
  }

  /// Bir nechta fayllarni yuklash
  Future<Response<T>> uploadMultipleFiles<T>(
    String path, {
    required List<File> files,
    required String fieldName,
    Map<String, dynamic>? additionalData,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    bool checkConnectivity = true,
  }) async {
    if (checkConnectivity) await _checkConnectivity();

    final multipartFiles = <MultipartFile>[];
    for (final file in files) {
      final fileName = file.path.split('/').last;
      multipartFiles.add(
        await MultipartFile.fromFile(file.path, filename: fileName),
      );
    }

    final formData = FormData.fromMap({
      fieldName: multipartFiles,
      if (additionalData != null) ...additionalData,
    });

    return _dio.post<T>(
      path,
      data: formData,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
    );
  }

  /// Faylni yuklab olish (Download)
  Future<Response> downloadFile(
    String url,
    String savePath, {
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    void Function(int, int)? onReceiveProgress,
    bool checkConnectivity = true,
  }) async {
    if (checkConnectivity) await _checkConnectivity();

    return _dio.download(
      url,
      savePath,
      queryParameters: queryParameters,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    );
  }
}

/// Logging Interceptor - barcha so'rovlar va javoblarni log qiladi
class _LoggingInterceptor extends Interceptor {
  final Logger _logger;

  _LoggingInterceptor(this._logger);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _logger.i('''
┌──────────────────────────────────────────────────────────────────────────────
│ 🌐 REQUEST
├──────────────────────────────────────────────────────────────────────────────
│ ${options.method} ${options.uri}
│ Headers: ${options.headers}
│ Data: ${options.data}
│ QueryParameters: ${options.queryParameters}
└──────────────────────────────────────────────────────────────────────────────
''');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _logger.i('''
┌──────────────────────────────────────────────────────────────────────────────
│ ✅ RESPONSE [${response.statusCode}]
├──────────────────────────────────────────────────────────────────────────────
│ ${response.requestOptions.method} ${response.requestOptions.uri}
│ Data: ${response.data}
└──────────────────────────────────────────────────────────────────────────────
''');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _logger.e('''
┌──────────────────────────────────────────────────────────────────────────────
│ ❌ ERROR [${err.response?.statusCode ?? 'N/A'}]
├──────────────────────────────────────────────────────────────────────────────
│ ${err.requestOptions.method} ${err.requestOptions.uri}
│ Type: ${err.type}
│ Message: ${err.message}
│ Response: ${err.response?.data}
└──────────────────────────────────────────────────────────────────────────────
''');
    handler.next(err);
  }
}

/// Error Interceptor - xatolarni qayta ishlash
class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final failure = _mapDioExceptionToFailure(err);
    
    handler.next(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: failure,
        message: failure.message,
      ),
    );
  }

  Failure _mapDioExceptionToFailure(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkFailure.timeout();
      
      case DioExceptionType.connectionError:
        return NetworkFailure.connectionError();
      
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode != null) {
          return ServerFailure.fromStatusCode(statusCode);
        }
        return const ServerFailure(message: 'Noma\'lum server xatosi');
      
      case DioExceptionType.cancel:
        return const ServerFailure(message: 'So\'rov bekor qilindi');
      
      case DioExceptionType.badCertificate:
        return const ServerFailure(message: 'SSL sertifikat xatosi');
      
      case DioExceptionType.unknown:
        if (error.error is SocketException) {
          return NetworkFailure.noConnection();
        }
        return const UnknownFailure();
    }
  }
}

/// Retry Interceptor - muvaffaqiyatsiz so'rovlarni qayta yuborish
class _RetryInterceptor extends Interceptor {
  final Dio _dio;
  final int _maxRetries;
  final Duration _retryDelay;

  _RetryInterceptor(
    this._dio, {
    int maxRetries = 3,
    Duration retryDelay = const Duration(seconds: 1),
  })  : _maxRetries = maxRetries,
        _retryDelay = retryDelay;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final retryCount = err.requestOptions.extra['retryCount'] ?? 0;

    // Faqat timeout va connection error uchun retry
    if (_shouldRetry(err) && retryCount < _maxRetries) {
      await Future.delayed(_retryDelay * (retryCount + 1));

      final options = err.requestOptions;
      options.extra['retryCount'] = retryCount + 1;

      try {
        final response = await _dio.fetch(options);
        handler.resolve(response);
        return;
      } catch (e) {
        // Retry failed, continue to error handler
      }
    }

    handler.next(err);
  }

  bool _shouldRetry(DioException error) {
    return error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.connectionError;
  }
}

/// Network Exception sinfi
class NetworkException implements Exception {
  final String message;
  final int? statusCode;

  NetworkException({
    required this.message,
    this.statusCode,
  });

  @override
  String toString() => 'NetworkException: $message';
}

/// API javoblarini parsing qilish uchun extension
extension DioResponseExtension on Response {
  /// Javobni model'ga parse qilish
  T parseAs<T>(T Function(Map<String, dynamic> json) fromJson) {
    if (data is Map<String, dynamic>) {
      return fromJson(data as Map<String, dynamic>);
    }
    throw ParseFailure.jsonError();
  }

  /// Javobni list model'ga parse qilish
  List<T> parseAsList<T>(T Function(Map<String, dynamic> json) fromJson) {
    if (data is List) {
      return (data as List)
          .map((item) => fromJson(item as Map<String, dynamic>))
          .toList();
    }
    throw ParseFailure.jsonError();
  }
}
