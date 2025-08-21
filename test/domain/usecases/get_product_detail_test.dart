import 'package:fake_store_get_request/data/models/rating.dart';
import 'package:fake_store_get_request/domain/usecases/get_product_detail.dart';
import 'package:fake_store_get_request/fake_store_get_request.dart';

import 'get_products_test.mocks.dart';

import 'package:mockito/mockito.dart';
import 'package:either_dart/either.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_store_get_request/core/errors/failures.dart';
import 'package:fake_store_get_request/domain/repositories/fake_store_repository.dart';

@GenerateNiceMocks([MockSpec<FakeStoreRepository>()])
void main() {
  late GetProductDetail usecase;
  late MockFakeStoreRepository mockRepository;

  final tProduct = Product(
    id: 1,
    title: 'Test Product',
    price: 109.95,
    description: 'Test Description',
    category: 'electronics',
    image: 'test.jpg',
    rating: Rating(rate: 4.5, count: 120),
  );

  final tFailure = ServerFailure(401);

  setUp(() {
    provideDummy<Either<Failure, Product>>(Right(tProduct));

    mockRepository = MockFakeStoreRepository();
    usecase = GetProductDetail(mockRepository);
  });

  group('GetProductDetail', () {
    test('debería ser una instancia de GetProductDetail', () {
      expect(usecase, isA<GetProductDetail>());
    });

    test(
      'debería retornar el producto cuando el repository tiene éxito',
      () async {
        when(
          mockRepository.getProductDetail(any),
        ).thenAnswer((_) async => Right(tProduct));

        final result = await usecase(1);

        expect(result.isRight, true);
        expect(result, isA<Right<Failure, Product>>());

        result.fold((failure) => fail('No debería retornar failure'), (
          product,
        ) {
          expect(product, tProduct);
          expect(product.id, 1);
          expect(product.title, 'Test Product');
          expect(product.price, 109.95);
        });
      },
    );

    test('debería retornar Failure cuando el repository falla', () async {
      when(
        mockRepository.getProductDetail(any),
      ).thenAnswer((_) async => Left(tFailure));

      final result = await usecase(1);

      expect(result.isLeft, true);
      expect(result, isA<Left<Failure, Product>>());

      result.fold((failure) {
        expect(failure, tFailure);
        expect(failure, isA<ServerFailure>());
      }, (product) => fail('No debería retornar producto'));
    });

    test('debería funcionar con diferentes IDs de producto', () async {
      final testProducts = [
        Product(
          id: 1,
          title: 'Product 1',
          price: 10.0,
          description: 'Desc 1',
          category: 'cat1',
          image: 'img1.jpg',
        ),
        Product(
          id: 2,
          title: 'Product 2',
          price: 20.0,
          description: 'Desc 2',
          category: 'cat2',
          image: 'img2.jpg',
        ),
        Product(
          id: 3,
          title: 'Product 3',
          price: 30.0,
          description: 'Desc 3',
          category: 'cat3',
          image: 'img3.jpg',
        ),
      ];

      for (int i = 0; i < testProducts.length; i++) {
        final product = testProducts[i];
        final productId = i + 1;

        when(
          mockRepository.getProductDetail(productId),
        ).thenAnswer((_) async => Right(product));

        final result = await usecase(productId);

        expect(result.isRight, true);
        result.fold(
          (failure) =>
              fail('No debería retornar failure para el producto $productId'),
          (returnedProduct) {
            expect(returnedProduct, product);
            expect(returnedProduct.id, productId);
          },
        );
      }
    });
  });
}
