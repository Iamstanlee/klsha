import "package:dio/dio.dart";
import "package:klsha/core/http/error.dart";

enum RequestType {
  get,
  post,
}

const successCodes = [200, 201];

class HttpClient {
  final Dio dio;

  ///allows us map custom error response
  final ServerException Function(Response<dynamic>? data)? errorResponseMapper;

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

  Future post(String endpoint, {Map<String, dynamic> data = const {}}) =>
      _futureNetworkRequest(
        RequestType.post,
        endpoint,
        data: data,
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
          response = await dio.get(endpoint, queryParameters: query);
          break;
        case RequestType.post:
          response = await dio.post(endpoint, data: data);
          break;
        default:
          throw InvalidArgOrDataException();
      }
      if (successCodes.contains(response.statusCode)) {
        return response.data;
      }
      throw errorResponseMapper?.call(response) ??
          serverErrorResponseMapper(response);
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      if (e is DioError) {
        if ([DioErrorType.connectionTimeout, DioErrorType.receiveTimeout]
            .contains(e.type)) {
          throw TimeoutServerException();
        }
        if (e is FormatException) {
          throw InvalidArgOrDataException();
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
  final data = response?.data;
  if (data is Map) {
    if (data['message'] != null) return ServerException(data['message']);
    if (data['error'] != null) return ServerException(data['error']);
  }
  return UnexpectedServerException();
}
