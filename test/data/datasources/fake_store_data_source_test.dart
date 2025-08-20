import 'package:fake_store_get_request/core/infrastructure/api_client.dart';
import 'package:fake_store_get_request/data/datasources/fake_store_datasource.dart';
import 'package:fake_store_get_request/data/models/cart.dart';
import 'package:fake_store_get_request/data/models/login_response.dart';
import 'package:fake_store_get_request/data/models/product.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'fake_store_data_source_test.mocks.dart';

@GenerateMocks([ApiClient])
void main() {
  late FakeStoreRemoteDataSource dataSource;
  late MockApiClient mockApiClient;
  const String baseUrl = 'https://fakestoreapi.com';

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
      {
        'id': 2,
        'title': 'Test Product 2',
        'price': 108.95,
        'description': 'Test Description 2',
        'category': 'jewelery',
        'image': 'test2.jpg',
        'rating': {'rate': 5.0, 'count': 200},
      },
    ];

    test('Debería retornar la lista de productos', () async {
      // Arrange
      when(
        mockApiClient.get('$baseUrl/products'),
      ).thenAnswer((_) async => tProductsJson);

      // Act
      final result = await dataSource.getProducts();

      // Assert
      expect(result, isA<List<Product>>());
      expect(result.length, 2);
    });

    test('Debe mostrar un error cuando el llamado a la API falla', () async {
      /// Arrange
      when(
        mockApiClient.get('$baseUrl/products'),
      ).thenThrow(ServerException(message: 'Error'));

      expect(() => dataSource.getProducts(), throwsA(isA<ServerException>()));
    });

    group('getCategories', () {
      final tCategoriesJson = ['electronics', 'jewelery', 'men\'s clothing'];

      test('Debería retornar la lista de categorías', () async {
        when(
          mockApiClient.get('$baseUrl/products/categories'),
        ).thenAnswer((_) async => tCategoriesJson);

        final result = await dataSource.getCategories();

        expect(result, isA<List<String>>());
        expect(result.length, 3);
      });

      test('Debe mostrar un error cuando el llamado a la API falla', () async {
        when(
          mockApiClient.get(any),
        ).thenThrow(ServerException(message: 'Error'));

        expect(() => dataSource.getProducts(), throwsA(isA<ServerException>()));
      });
    });

    group('login', () {
      final tLoginResponse = {
        "token":
            "eyJhbGciJIUzI1NinR5cCI6IkpXVCJ9.eyJzdWIiOjEsInVzZXIiOiJqb2huZCIsImlhdCI6MTc1NTY1MjkyMX0.TDkYAEEmz-Jdet7NyuSObXdnmwlt2HOktqXvtgYJ8ls",
      };

      test('Debería retornar un token y un id al hacer login', () async {
        // Arrange
        when(
          mockApiClient.post(
            '$baseUrl/auth/login',
            body: {'username': 'test', 'password': 'test'},
          ),
        ).thenAnswer((_) async => tLoginResponse);

        // Act
        final result = await dataSource.login('test', 'test');

        // Assert
        expect(result, isA<LoginResponse>());
      });

      test(
        'Debería retornar un error cuando el llamado a la API falla',
        () async {
          // Arrange
          when(
            mockApiClient.post(
              '$baseUrl/auth/login',
              body: {'username': 'test', 'password': 'test'},
            ),
          ).thenAnswer((_) async => tLoginResponse);

          // Act
          final result = await dataSource.login('test', 'test');

          // Assert
          expect(result, isA<LoginResponse>());
        },
      );

      test('Debe mostrar un error cuando el llamado a la API falla', () async {
        when(
          mockApiClient.post('$baseUrl/auth/login',
              body: {'username': 'test', 'password': 'test'},),
        ).thenThrow(ServerException(message: 'Error'));

        expect(() => dataSource.login('test', 'test'), throwsA(isA<ServerException>()));
      });
    });

    group('get products by category', (){
      final tCategory = 'electronics';
     

      test('Debería retornar la lista de productos por categoría', () async {
        when(
          mockApiClient.get('$baseUrl/products/category/$tCategory'),
        ).thenAnswer((_) async => tProductsJson);

        final result = await dataSource.getProductByCategory(tCategory);

        expect(result, isA<List<Product>>());
        expect(result.length, 2);
      });

      test('Debe mostrar un error cuando el llamado a la API falla', () async {
        when(
          mockApiClient.get(any),
        ).thenThrow(ServerException(message: 'Error'));

        expect(() => dataSource.getProductByCategory(tCategory), throwsA(isA<ServerException>()));
      });
    });

     group('get user cart', (){
      final tUserId = 1;   

      final tCart = {
    "id": 1,
    "userId": 1,
    "date": "2020-03-02T00:00:00.000Z",
    "products": [
        {
            "productId": 1,
            "quantity": 4
        },
        {
            "productId": 2,
            "quantity": 1
        },
        {
            "productId": 3,
            "quantity": 6
        }
    ],
    "__v": 0
};  

      test('Debería retornar los productos del carrito', () async {
        when(
          mockApiClient.get('$baseUrl/carts/$tUserId'),
        ).thenAnswer((_) async => tCart);

        final result = await dataSource.getUserCart(tUserId);

        expect(result, isA<Cart>());
      });

      test('Debe mostrar un error cuando el llamado a la API falla', () async {
        when(
          mockApiClient.get(any),
        ).thenThrow(ServerException(message: 'Error'));

        expect(() => dataSource.getUserCart(tUserId), throwsA(isA<ServerException>()));
      });
    });
  });
}
