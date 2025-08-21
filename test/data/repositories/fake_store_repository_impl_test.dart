import 'package:either_dart/either.dart';
import 'package:fake_store_get_request/core/errors/failures.dart';
import 'package:fake_store_get_request/core/infrastructure/api_client.dart';
import 'package:fake_store_get_request/data/datasources/fake_store_datasource.dart';
import 'package:fake_store_get_request/data/models/cart.dart';
import 'package:fake_store_get_request/data/models/login_response.dart';
import 'package:fake_store_get_request/data/models/product.dart';
import 'package:fake_store_get_request/data/models/rating.dart';
import 'package:fake_store_get_request/data/repositories/fake_store_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'fake_store_repository_impl_test.mocks.dart';

@GenerateMocks([FakeStoreDataSource])
void main() {
  late FakeStoreRepositoryImpl repositoryImpl;
  late MockFakeStoreDataSource mockFakeStoreDataSource;

  setUp(() {
    mockFakeStoreDataSource = MockFakeStoreDataSource();
    repositoryImpl = FakeStoreRepositoryImpl(
      dataSource: mockFakeStoreDataSource,
    );
  });
  final tProducts = [
    Product(
      id: 1,
      title: 'Test Product',
      price: 109.95,
      description: 'Test Description',
      category: 'electronics',
      image: 'test.jpg',
      rating: Rating(count: 120, rate: 4.5),
    ),
    Product(
      id: 2,
      title: 'Test Product 2',
      price: 108.95,
      description: 'Test Description 2',
      category: 'jewelery',
      image: 'test2.jpg',
      rating: Rating(count: 200, rate: 5.0),
    ),
  ];
  group('getProducts', () {
    test('Debería retornar la lista de productos', () async {
      // Arrange
      when(
        mockFakeStoreDataSource.getProducts(),
      ).thenAnswer((_) async => tProducts);

      // Act
      final result = await repositoryImpl.getProducts();

      // Assert
      expect(result, isA<Right<Failure, List<Product>>>());
      result.fold((failure) => fail('No debería retornar failure'), (products) {
        expect(products.length, 2);
        expect(products[0].id, 1);
        expect(products[1].title, 'Test Product 2');
      });
    });

    test('Debe mostrar un error cuando el llamado a la API falla', () async {
      /// Arrange
      when(
        mockFakeStoreDataSource.getProducts(),
      ).thenThrow(ServerException(message: 'Error'));

      final result = await repositoryImpl.getProducts();

     expect(result, isA<Left<Failure, List<Product>>>());
    });
  });

  group('getCategories', () {
    final tCategoriesJson = ['electronics', 'jewelery', 'men\'s clothing'];

    test('Debería retornar la lista de categorías', () async {
      when(
        mockFakeStoreDataSource.getCategories(),
      ).thenAnswer((_) async => tCategoriesJson);

      final result = await repositoryImpl.getCategories();

      expect(result, isA<Right<Failure, List<String>>>());
      result.fold((failure) => fail('No debería retornar failure'), (
        categories,
      ) {
        expect(categories.length, 3);
        expect(categories[0], 'electronics');
      });
    });

    test('Debe mostrar un error cuando el llamado a la API falla', () async {
      when(
        mockFakeStoreDataSource.getCategories(),
      ).thenThrow(ServerException(message: 'Error'));

     final result = await repositoryImpl.getCategories();

      // Assert
      expect(result, isA<Left<Failure, List<String>>>());
    });
  });

  group('login', () {
    final tLoginResponse = LoginResponse(
      token: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
    );

    test('Debería retornar un token al hacer login', () async {
      // Arrange
      when(
        mockFakeStoreDataSource.login('username', 'password'),
      ).thenAnswer((_) async => tLoginResponse);

      // Act
      final result = await repositoryImpl.login('username', 'password');

      // Assert
      expect(result, isA<Right<Failure, LoginResponse>>());
     
    });

    test(
      'Debería retornar un error cuando el llamado a la API falla',
      () async {
        // Arrange
        when(
          mockFakeStoreDataSource.login('username', 'password'),
        ).thenThrow(ServerException(message: 'Error'));

        // Act
        final result = await repositoryImpl.login('username', 'password');

        // Assert
        expect(result, isA<Left<Failure, LoginResponse>>());
      },
    );
  });

  group('get products by category', () {
    final tCategory = 'electronics';

    test('Debería retornar la lista de productos por categoría', () async {
      when(
        mockFakeStoreDataSource.getProductByCategory(tCategory),
      ).thenAnswer((_) async => tProducts);

      final result = await repositoryImpl.getProductByCategory(tCategory);

      expect(result, isA<Right<Failure, List<Product>>>());
      result.fold((failure) => fail('No debería retornar failure'), (products) {
        expect(products.length, 2);
        expect(products[0].category, tCategory);
      });
    });

    test('Debe mostrar un error cuando el llamado a la API falla', () async {
      when(
        mockFakeStoreDataSource.getProductByCategory(tCategory),
      ).thenThrow(ServerException(message: 'Error'));

      final result = await repositoryImpl.getProductByCategory(tCategory);

      expect(result, isA<Left<Failure, List<Product>>>());
    });
  });

  group('get user cart', () {
    final tUserId = 1;

    final tCart = Cart(
      id: 1,
      userId: 1,
      date: '2020-03-02T00:00:00.000Z',
      products: [
        CartProducts(productId: 1, quantity: 4),
        CartProducts(productId: 2, quantity: 1),
      ],
    );

    test('Debería retornar los productos del carrito', () async {
      when(
        mockFakeStoreDataSource.getUserCart(tUserId),
      ).thenAnswer((_) async => tCart);

      final result = await repositoryImpl.getUserCart(tUserId);

      expect(result, isA<Right<Failure, Cart>>());
      result.fold((failure) => fail('No debería retornar failure'), (cart) {
        expect(cart.id, 1);
        expect(cart.products?.length, 2);
      });
    });

    test('Debe mostrar un error cuando el llamado a la API falla', () async {
      when(
        mockFakeStoreDataSource.getUserCart(tUserId),
      ).thenThrow(ServerException(message: 'Error'));
      final result = await repositoryImpl.getUserCart(1);
      expect(result, isA<Left<Failure, Cart>>());
    });
  });
}
