
import 'package:fake_store_get_request/data/models/product.dart';

import '../../dummies.dart';
import 'get_products_test.mocks.dart';

import 'package:mockito/mockito.dart';
import 'package:either_dart/either.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_store_get_request/core/errors/failures.dart';
import 'package:fake_store_get_request/domain/usecases/get_products.dart';
import 'package:fake_store_get_request/domain/entities/rating_entity.dart';
import 'package:fake_store_get_request/domain/repositories/fake_store_repository.dart';



@GenerateMocks([FakeStoreRepository])
void main() {
  late GetProducts useCase;
  late MockFakeStoreRepository mockRepository;

  final tProductEntity = Product(
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
          (_) async => Right<Failure, List<Product>>([tProductEntity]),
        );
        // Act
        final result = await useCase();

        // Assert
        expect(result.isRight, true);
      },
    );

    test(
      ' Debe devolver Right con una lista vacía cuando el repositorio devuelve una lista vacia',
      () async {
        // Arrange
        when(
          mockRepository.getProducts(),
        ).thenAnswer((_) async => Right<Failure, List<Product>>([]));

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


}
