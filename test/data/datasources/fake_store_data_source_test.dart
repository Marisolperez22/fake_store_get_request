import 'package:fake_store_get_request/core/infrastructure/api_client.dart';
import 'package:fake_store_get_request/data/datasources/fake_store_datasource.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'fake_store_data_source_test.mocks.dart';

@GenerateMocks([ApiClient])
void main() {
  late FakeStoreRemoteDataSource dataSource;
  late MockApiClient mockApiClient;

  setUp(() {
    mockApiClient = MockApiClient();
    dataSource = FakeStoreRemoteDataSource(apiClient: mockApiClient);
  });

  group('getProducts', () {
    final tProductsJson = [
      {
        'id': 1,
        'title': 'Test Product',
        'price': 109.95,
        'description': 'Test Description',
        'category': 'electronics',
        'image': 'test.jpg',
        'rating': {'rate': 4.5, 'count': 120},
      },
    ];

    test('debe retornar el producto cuando hace el llamado', () async {
      when(mockApiClient.get(any)).thenAnswer((_) async => tProductsJson);

      final result = await dataSource.getProducts();

      expect(result, equals(tProductsJson));
      verify(mockApiClient.get('https://fakestoreapi.com/products'));
    });

    test('Debe mostrar un error cuando el llamado a la API falla', () async {
      when(mockApiClient.get(any)).thenThrow(ServerException(message: 'Error'));

      expect(() => dataSource.getProducts(), throwsA(isA<ServerException>()));
    });
  });

  group('getCategories', () {
    final tCategoriesJson = ['electronics', 'jewelery', 'men\'s clothing'];

    test('debe retornar la categoria cuando hace el llamado', () async {
      when(mockApiClient.get(any)).thenAnswer((_) async => tCategoriesJson);

      final result = await dataSource.getCategories();

      expect(result, equals(tCategoriesJson));
      verify(mockApiClient.get('https://fakestoreapi.com/products/categories'));
    });

    test('Debe mostrar un error cuando el llamado a la API falla', () async {
      when(mockApiClient.get(any)).thenThrow(ServerException(message: 'Error'));

      expect(() => dataSource.getProducts(), throwsA(isA<ServerException>()));
    });
  });
}
