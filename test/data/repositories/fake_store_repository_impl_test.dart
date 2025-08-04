import 'package:fake_store_get_request/core/errors/failures.dart';
import 'package:fake_store_get_request/data/datasources/fake_store_datasource.dart';
import 'package:fake_store_get_request/data/repositories/fake_store_repository_impl.dart';
import 'package:fake_store_get_request/domain/entities/product_entity.dart';
import 'package:fake_store_get_request/domain/entities/rating_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'fake_store_repository_impl_test.mocks.dart';

class CustomException implements Exception {
  final String type;
  final String? title;
  final String? message;
  final int? codeError;

  CustomException({
    required this.type,
    this.title,
    this.message,
    this.codeError,
  });
}

@GenerateMocks([FakeStoreDataSource])
void main() {
  late FakeStoreRepositoryImpl repository;
  late MockFakeStoreDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockFakeStoreDataSource();
    repository = FakeStoreRepositoryImpl(dataSource: mockDataSource);
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

    final tProductEntity = ProductEntity(
      id: 1,
      title: 'Test Product',
      price: 109.95,
      description: 'Test Description',
      category: 'electronics',
      image: 'test.jpg',
      rating: RatingEntity(rate: 4.5, count: 120),
    );

    test(
      'should return Right with products when data source is successful',
      () async {
        // Arrange
        when(
          mockDataSource.getProducts(),
        ).thenAnswer((_) async => tProductsJson);

        // Act
        final result = await repository.getProducts();

        // Assert
        result.fold(
          (failure) => fail('Expected Right but got Left with $failure'),
          (products) {
            expect(products, [tProductEntity]);
            expect(products.first.id, equals(1));
          },
        );
        verify(mockDataSource.getProducts());
      },
    );

    test('should return TimeOutFailure when timeout occurs', () async {
      // Arrange
      when(
        mockDataSource.getProducts(),
      ).thenThrow(CustomException(type: 'TimeoutException'));

      // Act
      final result = await repository.getProducts();

      // Assert
      result.fold(
        (failure) => expect(failure, isA<TimeOutFailure>()),
        (_) => fail('Expected Left but got Right'),
      );
    });

    test('should return AuthFailure when unauthorized', () async {
      // Arrange
      when(
        mockDataSource.getProducts(),
      ).thenThrow(CustomException(type: 'UnAuthorization'));

      // Act
      final result = await repository.getProducts();

      // Assert
      result.fold(
        (failure) => expect(failure, isA<AuthFailure>()),
        (_) => fail('Expected Left but got Right'),
      );
    });

    test('should return BadRequest when bad request occurs', () async {
      // Arrange
      when(mockDataSource.getProducts()).thenThrow(
        CustomException(
          type: 'BadRequest',
          title: 'Bad Request',
          message: 'Invalid data',
          codeError: 400,
        ),
      );

      // Act
      final result = await repository.getProducts();

      // Assert
      result.fold((failure) {
        expect(failure, isA<BadRequest>());
        expect((failure as BadRequest).title, 'Bad Request');
      }, (_) => fail('Expected Left but got Right'));
    });

    test('should return AnotherFailure for unknown exceptions', () async {
      // Arrange
      when(mockDataSource.getProducts()).thenThrow(
        CustomException(
          type: 'AnotherFailure',
          title: 'Bad Request',
          message: 'Invalid data',
          codeError: 400,
        ),
      );

      // Act
      final result = await repository.getProducts();

      // Assert
      result.fold(
        (failure) => expect(failure, isA<AnotherFailure>()),
        (_) => fail('Expected Left but got Right'),
      );
    });
  });

  group('getCategories', () {
    final tCategories = ['electronics', 'jewelery', 'men\'s clothing'];

    test(
      'should return Right with categories when data source is successful',
      () async {
        // Arrange
        when(
          mockDataSource.getCategories(),
        ).thenAnswer((_) async => tCategories);

        // Act
        final result = await repository.getCategories();

        // Assert
        result.fold(
          (failure) => fail('Expected Right but got Left'),
          (categories) => expect(categories, tCategories),
        );
        verify(mockDataSource.getCategories());
      },
    );

    test('should return TimeOutFailure when timeout occurs', () async {
      // Arrange
      when(
        mockDataSource.getCategories(),
      ).thenThrow(CustomException(type: 'TimeoutException'));

      // Act
      final result = await repository.getCategories();

      // Assert
      result.fold(
        (failure) => expect(failure, isA<TimeOutFailure>()),
        (_) => fail('Expected Left but got Right'),
      );
    });

    test('should return AnotherFailure for unknown exceptions', () async {
      // Arrange
      when(mockDataSource.getCategories()).thenThrow(
        CustomException(
          type: 'AnotherFailure',
          title: 'Bad Request',
          message: 'Invalid data',
          codeError: 400,
        ),
      );

      // Act
      final result = await repository.getCategories();

      // Assert
      result.fold(
        (failure) => expect(failure, isA<AnotherFailure>()),
        (_) => fail('Expected Left but got Right'),
      );
    });

    // test('should return DataNull when data source returns null', () async {
    //   // Arrange
    //   when(mockDataSource.getCategories()).thenAnswer((_) async => null);

    //   // Act
    //   final result = await repository.getCategories();

    //   // Assert
    //   result.fold(
    //     (failure) => expect(failure, isA<DataNull>()),
    //     (_) => fail('Expected Left but got Right'),
    //   );
    // });
  });
}
