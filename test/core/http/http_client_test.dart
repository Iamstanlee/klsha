import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:klsha/core/http/error.dart';
import 'package:klsha/core/http/http_client.dart';
import 'package:mocktail/mocktail.dart';

class MockHttpAdapter extends Mock implements HttpClientAdapter {}

class FakeRequestOptions extends Fake implements RequestOptions {}

void main() {
  late HttpClient http;
  late HttpClientAdapter adapter;
  late Dio dio;

  setUp(() {
    adapter = MockHttpAdapter();
    dio = Dio()..httpClientAdapter = adapter;
    http = HttpClient(dio: dio);

    registerFallbackValue(FakeRequestOptions());
  });

  group('Http.get', () {
    group(".onSuccess", () {
      test('should return success response when statusCode is 200', () async {
        final data = jsonEncode({'data': '1'});
        when(() => adapter.fetch(any(), any(), any())).thenAnswer(
          (_) async => ResponseBody.fromString(data, 200),
        );
        final response = await http.get("/");
        expect(response, data);
      });

      test(
          'should return unexpected error response when incorrect statusCode is returned',
          () async {
        final data = jsonEncode({'data': '1'});
        when(() => adapter.fetch(any(), any(), any())).thenAnswer(
          (_) async => ResponseBody.fromString(data, 300),
        );
        expect(
          () => http.get("/"),
          throwsA(isInstanceOf<UnexpectedServerException>()),
        );
      });
    });

    group(".onError", () {
      test('should throw [ServerException] when statusCode is not 200',
          () async {
        when(() => adapter.fetch(any(), any(), any())).thenAnswer(
          (_) async => ResponseBody.fromString(
            jsonEncode({'message': 'error'}),
            404,
          ),
        );
        expect(
          () => http.get("/"),
          throwsA(isInstanceOf<ServerException>()),
        );
      });
      test('should throw [TimeoutServerException] when request timeout',
          () async {
        when(() => adapter.fetch(any(), any(), any())).thenThrow(
          DioError(
            requestOptions: RequestOptions(),
            type: DioErrorType.connectionTimeout,
          ),
        );
        expect(
          () => http.get("/"),
          throwsA(isInstanceOf<TimeoutServerException>()),
        );
      });

      group('.onError.errorResponseMapper', () {
        setUp(() {
          http = HttpClient(
            dio: dio,
            errorResponseMapper: (response) => UnexpectedServerException(),
          );
        });
        test(
            'should throw [UnexpectedServerException] when an unparsable response is returned',
            () async {
          when(() => adapter.fetch(any(), any(), any())).thenAnswer(
            (_) async => ResponseBody.fromString(
              jsonEncode({'unparsable': 'error'}),
              500,
            ),
          );
          expect(
            () => http.get("/"),
            throwsA(isInstanceOf<UnexpectedServerException>()),
          );
        });
      });
    });
  });
}
