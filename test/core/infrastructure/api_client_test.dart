import 'dart:convert';
import 'package:fake_store_get_request/core/infrastructure/api_client.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'api_client_test.mocks.dart';

// Genera los mocks necesarios
@GenerateMocks([http.Client])

void main() {
  late ApiClient apiClient;
  late MockClient mockHttpClient;

  const baseUrl = 'https://api.example.com';
  final successResponse = {'id': 1, 'name': 'Test'};
  final successResponseBody = json.encode(successResponse);

  setUp(() {
    mockHttpClient = MockClient();
    apiClient = ApiClient(client: mockHttpClient);
  });

  group('GET requests', () {
    test('debería retornar datos cuando la respuesta es exitosa (200-299)', () async {
      // Arrange
      when(mockHttpClient.get(any))
          .thenAnswer((_) async => http.Response(successResponseBody, 200));

      // Act
      final result = await apiClient.get('$baseUrl/test');

      // Assert
      expect(result, equals(successResponse));
      verify(mockHttpClient.get(Uri.parse('$baseUrl/test'))).called(1);
    });

    test('debería lanzar ServerException cuando el status code es 400', () async {
      // Arrange
      when(mockHttpClient.get(any))
          .thenAnswer((_) async => http.Response('Error', 400));

      // Act & Assert
      expect(() async => await apiClient.get('$baseUrl/test'),
          throwsA(isA<ServerException>()));
      verify(mockHttpClient.get(Uri.parse('$baseUrl/test'))).called(1);
    });

    test('debería lanzar ServerException cuando el status code es 500', () async {
      // Arrange
      when(mockHttpClient.get(any))
          .thenAnswer((_) async => http.Response('Server Error', 500));

      // Act & Assert
      expect(() async => await apiClient.get('$baseUrl/test'),
          throwsA(isA<ServerException>()));
      verify(mockHttpClient.get(Uri.parse('$baseUrl/test'))).called(1);
    });

  });

  group('POST requests', () {
    test('debería retornar datos cuando la respuesta POST es exitosa', () async {
      // Arrange
      final requestBody = {'name': 'John', 'email': 'john@example.com'};
      when(mockHttpClient.post(any, body: anyNamed('body')))
          .thenAnswer((_) async => http.Response(successResponseBody, 201));

      // Act
      final result = await apiClient.post('$baseUrl/users', body: requestBody);

      // Assert
      expect(result, equals(successResponse));
      verify(mockHttpClient.post(
        Uri.parse('$baseUrl/users'),
        body: requestBody,
      )).called(1);
    });

    test('debería funcionar sin body en POST', () async {
      // Arrange
      when(mockHttpClient.post(any, body: anyNamed('body')))
          .thenAnswer((_) async => http.Response(successResponseBody, 200));

      // Act
      final result = await apiClient.post('$baseUrl/ping');

      // Assert
      expect(result, equals(successResponse));
      verify(mockHttpClient.post(
        Uri.parse('$baseUrl/ping'),
        body: null,
      )).called(1);
    });

    test('debería lanzar ServerException cuando POST falla con 400', () async {
      // Arrange
      final requestBody = {'name': 'John'};
      when(mockHttpClient.post(any, body: anyNamed('body')))
          .thenAnswer((_) async => http.Response('Bad Request', 400));

      // Act & Assert
      expect(() async => await apiClient.post('$baseUrl/users', body: requestBody),
          throwsA(isA<ServerException>()));
    });

    test('debería incluir la URL en el mensaje de error', () async {
      // Arrange
      when(mockHttpClient.get(any))
          .thenAnswer((_) async => http.Response('Error', 404));

      // Act & Assert
      try {
        await apiClient.get('$baseUrl/not-found');
        fail('Debería haber lanzado una excepción');
      } on ServerException catch (e) {
        expect(e.message, contains('Error en GET'));
        expect(e.message, contains('$baseUrl/not-found'));
      }
    });
  });

  group('Client initialization', () {
    test('debería usar client proporcionado', () {
      // Arrange
      final customClient = MockClient();
      final client = ApiClient(client: customClient);

      // Assert
      expect(client, isNotNull);
    });

    test('debería crear client por defecto si no se proporciona', () {
      // Arrange & Act
      final client = ApiClient();

      // Assert
      expect(client, isNotNull);
    });
  });
}