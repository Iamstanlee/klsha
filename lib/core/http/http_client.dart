import "dart:convert";

import "package:dio/dio.dart";
import "package:klsha/core/http/error.dart";

enum RequestType {
  get,
}

const successCodes = [200, 201];

class HttpClient {
  final Dio dio;

  ///allows us map custom error response
  final AppException Function(Response<dynamic>? data)? errorResponseMapper;

  HttpClient({
    required this.dio,
    this.errorResponseMapper,
  }) {
    dio.options.connectTimeout = const Duration(seconds: 15);
    dio.options.receiveTimeout = const Duration(seconds: 15);
  }

  Future get(String endpoint, {Map<String, dynamic> query = const {}}) =>
      _futureNetworkRequest(
        RequestType.get,
        endpoint,
        query: query,
      );

  Future _futureNetworkRequest(
    RequestType type,
    String endpoint, {
    Map<String, dynamic> data = const {},
    Map<String, dynamic> query = const {},
  }) async {
    try {
      late Response response;
      switch (type) {
        case RequestType.get:
          response = await dio.get(
            endpoint,
            queryParameters: query,
            data: data,
          );
          break;
      }
      if (successCodes.contains(response.statusCode)) {
        return response.data;
      }
      throw errorResponseMapper?.call(response) ??
          serverErrorResponseMapper(response);
    } catch (e) {
      if (e is FormatException) {
        throw InvalidArgOrDataException();
      }

      if (e is DioError) {
        if ([DioErrorType.connectionTimeout, DioErrorType.receiveTimeout]
            .contains(e.type)) {
          throw TimeoutServerException();
        }

        if (e.response?.data != null) {
          throw errorResponseMapper?.call(e.response) ??
              serverErrorResponseMapper(e.response);
        }
      }

      throw UnexpectedServerException();
    }
  }
}

AppException serverErrorResponseMapper(Response<dynamic>? response) {
  final data = jsonDecode(response?.data);
  if (data is Map) {
    if (data['message'] != null) return ServerException(data['message']);
    if (data['error'] != null) return ServerException(data['error']);
  }
  return UnexpectedServerException();
}
