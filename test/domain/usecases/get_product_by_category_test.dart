import 'package:either_dart/either.dart';
import 'package:fake_store_get_request/core/errors/failures.dart';
import 'package:fake_store_get_request/data/models/product.dart';
import 'package:fake_store_get_request/data/models/rating.dart';
import 'package:fake_store_get_request/domain/repositories/fake_store_repository.dart';
import 'package:fake_store_get_request/domain/usecases/get_product_by_category.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import '../../dummies.dart';
import 'get_products_test.mocks.dart';

@GenerateNiceMocks([MockSpec<FakeStoreRepository>()])
void main() {
  setUpAll(() {
    setupDummies();
  });
  late GetProductByCategory usecase;
  late MockFakeStoreRepository mockRepository;

  setUp(() {
    mockRepository = MockFakeStoreRepository();
    usecase = GetProductByCategory(mockRepository);
  });

  const tCategory = 'electronics';
  final tProducts = [
    Product(
      id: 1,
      title: 'Computador',
      price: 999.99,
      description: 'HP',
      category: 'electronics',
      image: 'laptop.jpg',
      rating: Rating(rate: 4.5, count: 120),
    ),
    Product(
      id: 2,
      title: 'Celular',
      price: 499.99,
      description: 'iphone',
      category: 'electronics',
      image: 'phone.jpg',
      rating: Rating(rate: 4.2, count: 85),
    ),
  ];

  group('GetProductByCategory', () {
    test('debería ser una instancia de UseCase', () {
      expect(usecase, isA<GetProductByCategory>());
    });

    test(
      'debería retornar lista de productos cuando el repository tiene éxito',
      () async {
        when(
          mockRepository.getProductByCategory(any),
        ).thenAnswer((_) async => Right(tProducts));

        final result = await usecase(tCategory);

        expect(result, isA<Right<Failure, List<Product>>>());
      },
    );

    test('debería retornar Failure cuando el repository falla', () async {
      final tFailure = ServerFailure(400);
      when(
        mockRepository.getProductByCategory(any),
      ).thenAnswer((_) async => Left(tFailure));

      final result = await usecase(tCategory);

      expect(result, isA<Left<Failure, List<Product>>>());
    });

    test('debería funcionar con diferentes categorías', () async {
      const testCategories = ['jewelery', 'men clothing', 'women clothing'];

      for (final category in testCategories) {
        when(
          mockRepository.getProductByCategory(category),
        ).thenAnswer((_) async => Right(tProducts));

        final result = await usecase(category);

        expect(result, isA<Right<Failure, List<Product>>>());
      }
    });

    test(
      'debería retornar lista vacía cuando no hay productos en la categoría',
      () async {
        final emptyProducts = <Product>[];
        when(
          mockRepository.getProductByCategory(any),
        ).thenAnswer((_) async => Right(emptyProducts));

        final result = await usecase(tCategory);

        expect(result, isA<Right<Failure, List<Product>>>());
        result.fold((failure) => fail('No debería retornar failure'), (
          products,
        ) {
          expect(products, emptyProducts);
          expect(products.isEmpty, true);
        });
      },
    );
  });
}
