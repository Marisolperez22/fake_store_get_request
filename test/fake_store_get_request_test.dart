import 'dart:convert';
import 'package:fake_store_get_request/models/product.dart';
import 'package:fake_store_get_request/services/fake_store_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'fake_store_get_request_test.mocks.dart';

@GenerateNiceMocks([MockSpec<http.Client>()])
void main() {
  late FakeStoreService service;
  late MockClient mockClient;

  setUp(() {
    mockClient = MockClient();
    service = FakeStoreService(client: mockClient);
  });

  group('getProducts', () {
    test(
      'should return list of products when API call is successful',
      () async {
        // Arrange
        final mockProducts = [
          {
            "id": 1,
            "title": "Test Product",
            "price": 99.99,
            "description": "Test Description",
            "category": "electronics",
            "image": "https://test.com/image.jpg",
            "rating": {"rate": 4.5, "count": 100},
          },
        ];

        when(mockClient.get(any)).thenAnswer(
          (_) async => http.Response(json.encode(mockProducts), 200),
        );

        //  Act
        final result = await service.getProducts();

        // Assert
        expect(result, isA<List<Product>>());
        expect(result.length, 1);
        expect(result.first.title, "Test Product");
        verify(
          mockClient.get(Uri.parse('https://fakestoreapi.com/products')),
        ).called(1);
      },
    );

    test('should throw exception when API call fails', () async {
      // Arrange
      when(
        mockClient.get(any),
      ).thenAnswer((_) async => http.Response('Not Found', 404));

      // Act y Assert
      expect(() => service.getProducts(), throwsException);
    });
  });
}
