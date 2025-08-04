import 'get_products_test.mocks.dart';

import 'package:mockito/mockito.dart';
import 'package:either_dart/either.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_store_get_request/core/errors/failures.dart';
import 'package:fake_store_get_request/domain/usecases/get_products.dart';
import 'package:fake_store_get_request/domain/entities/rating_entity.dart';
import 'package:fake_store_get_request/domain/entities/product_entity.dart';
import 'package:fake_store_get_request/domain/repositories/fake_store_repository.dart';

void setupDummies() {
  provideDummy<ProductEntity>(
    ProductEntity(
      id: 1,
      title: 'Dummy Product',
      price: 0.0,
      description: 'Dummy description',
      category: 'dummy',
      image: 'dummy.jpg',
      rating: RatingEntity(rate: 0.0, count: 0),
    ),
  );

  provideDummy<Either<Failure, List<ProductEntity>>>(Right([]));
  provideDummy<ServerFailure>(ServerFailure(500));
  provideDummy<NetworkFailure>(NetworkFailure());
  provideDummy<TimeOutFailure>(TimeOutFailure());
  provideDummy<AnotherFailure>(AnotherFailure());
  provideDummy<DataNull>(DataNull());
}

@GenerateMocks([FakeStoreRepository])
void main() {
  late GetProducts useCase;
  late MockFakeStoreRepository mockRepository;

  final tProductEntity = ProductEntity(
    id: 1,
    title: 'Producto test',
    price: 109.95,
    description: 'Test description',
    category: 'electronics',
    image: 'test.jpg',
    rating: RatingEntity(rate: 4.5, count: 120),
  );

  setUp(() {
    setupDummies();

    mockRepository = MockFakeStoreRepository();
    useCase = GetProducts(mockRepository);
  });

  group('Casos de exito', () {
    test(
      ' Debe devolver Right con la lista de productos cuando llama al repositorio',
      () async {
        // Arrange
        when(mockRepository.getProducts()).thenAnswer(
          (_) async => Right<Failure, List<ProductEntity>>([tProductEntity]),
        );
        // Act
        final result = await useCase();

        // Assert
        expect(result.isRight, true);
        verify(mockRepository.getProducts());
      },
    );

    test(
      ' Debe devolver Right con una lista vacía cuando el repositorio devuelve una lista vacia',
      () async {
        // Arrange
        when(
          mockRepository.getProducts(),
        ).thenAnswer((_) async => Right<Failure, List<ProductEntity>>([]));

        // Act
        final result = await useCase();

        // Assert
        expect(result.isRight, true);
      },
    );
  });

  group('Casos de fallo', () {
    test(
      'Debe retornar Left cuando el repositorio falla con server failure 400',
      () async {
        // Arrange
        final tFailure = ServerFailure(404);
        when(
          mockRepository.getProducts(),
        ).thenAnswer((_) async => Left(tFailure));

        // Act
        final result = await useCase();

        // Assert
        expect(result, Left(tFailure));
      },
    );

    test(
      'Debe retornar Left con NetworkFailure cuando el repositiori falla con NetworkFailure',
      () async {
        // Arrange
        final tFailure = NetworkFailure();
        when(
          mockRepository.getProducts(),
        ).thenAnswer((_) async => Left(tFailure));

        // Act
        final result = await useCase();

        // Assert
        expect(result, Left(tFailure));
      },
    );

    test(
      'Debe retornar Left con TimeOutFailure cuando el repositorio falla con TimeOutFailure',
      () async {
        // Arrange
        final tFailure = TimeOutFailure();
        when(
          mockRepository.getProducts(),
        ).thenAnswer((_) async => Left(tFailure));

        // Act
        final result = await useCase();

        // Assert
        expect(result, Left(tFailure));
      },
    );

    test(
      'Debe retornar Left con AnotherFailure cuando el repositorio falla con AnotherFailure',
      () async {
        // Arrange
        final tFailure = AnotherFailure();
        when(
          mockRepository.getProducts(),
        ).thenAnswer((_) async => Left(tFailure));

        // Act
        final result = await useCase();

        // Assert
        expect(result, Left(tFailure));
      },
    );

    test(
      'Debe retornar Left con DataNull cuando el repositorio falla con DataNull',
      () async {
        // Arrange
        final tFailure = DataNull();
        when(
          mockRepository.getProducts(),
        ).thenAnswer((_) async => Left(tFailure));

        // Act
        final result = await useCase();

        // Assert
        expect(result, Left(tFailure));
      },
    );
  });

  group('Casos aislados', () {
    test('No debería llamar el repositorio mas de una vez', () async {
      // Arrange
      when(
        mockRepository.getProducts(),
      ).thenAnswer((_) async => Right([tProductEntity]));

      // Act
      await useCase();
      await useCase();

      // Assert
      verify(mockRepository.getProducts()).called(2);
    });
  });
}
