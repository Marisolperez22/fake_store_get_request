import 'package:either_dart/either.dart';
import 'package:fake_store_get_request/core/errors/failures.dart';
import 'package:fake_store_get_request/domain/repositories/fake_store_repository.dart';
import 'package:fake_store_get_request/domain/usecases/get_categories.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_products_test.mocks.dart';

void setupCategoryDummies() {
  provideDummy<Either<Failure, List<String>>>(Right([]));

  provideDummy<ServerFailure>(ServerFailure(500));
  provideDummy<NetworkFailure>(NetworkFailure());
  provideDummy<TimeOutFailure>(TimeOutFailure());
  provideDummy<AnotherFailure>(AnotherFailure());
  provideDummy<DataNull>(DataNull());
}

@GenerateMocks([FakeStoreRepository])
void main() {
  late GetCategories useCase;
  late MockFakeStoreRepository mockRepository;

  final tCategories = ['electronics', 'jewelery', 'men\'s clothing'];
  final tServerFailure = ServerFailure(404);
  final tNetworkFailure = NetworkFailure();

  setUp(() {
    setupCategoryDummies();

    mockRepository = MockFakeStoreRepository();
    useCase = GetCategories(mockRepository);
  });

  tearDown(() {
    reset(mockRepository);
  });

  group('Casos de exito', () {
    test('Debe retornar Right en la lista de categorías', () async {
      // Arrange
      when(
        mockRepository.getCategories(),
      ).thenAnswer((_) async => Right(tCategories));

      // Act
      final result = await useCase();

      // Assert
      expect(result.isRight, true);
      expect(result.right, tCategories);
      verify(mockRepository.getCategories());
      verifyNoMoreInteractions(mockRepository);
    });

    test(
      'Debe retornar Right con una lista vacía cuando el repositorio retorna una lista vací',
      () async {
        // Arrange
        when(mockRepository.getCategories()).thenAnswer((_) async => Right([]));

        // Act
        final result = await useCase();

        // Assert
        expect(result.isRight, true);
        expect(result.right, isEmpty);
      },
    );
  });

  group('Casos de fallo', () {
    test('DEbe retonar Left con ServerFailure', () async {
      // Arrange
      when(
        mockRepository.getCategories(),
      ).thenAnswer((_) async => Left(tServerFailure));

      // Act
      final result = await useCase();

      // Assert
      expect(result.isLeft, true);
      expect(result.left, tServerFailure);
    });

    test('DEbe retonar Left con NetworkFailure', () async {
      // Arrange
      when(
        mockRepository.getCategories(),
      ).thenAnswer((_) async => Left(tNetworkFailure));

      // Act
      final result = await useCase();

      // Assert
      expect(result.isLeft, true);
      expect(result.left, tNetworkFailure);
    });

    test('Debe retonar Left con TimeOutFailure', () async {
      // Arrange
      final tFailure = TimeOutFailure();
      when(
        mockRepository.getCategories(),
      ).thenAnswer((_) async => Left(tFailure));

      // Act
      final result = await useCase();

      // Assert
      expect(result.isLeft, true);
      expect(result.left, tFailure);
    });

    test('Debe retonar Left con DataNull', () async {
      // Arrange
      final tFailure = DataNull();
      when(
        mockRepository.getCategories(),
      ).thenAnswer((_) async => Left(tFailure));

      // Act
      final result = await useCase();

      // Assert
      expect(result.isLeft, true);
      expect(result.left, isA<DataNull>());
    });
  });

  group('Casos aislados', () {
    test('Debe llamar el repositorio solo una vez', () async {
      // Arrange
      when(
        mockRepository.getCategories(),
      ).thenAnswer((_) async => Right(tCategories));

      // Act
      await useCase();

      // Assert
      verify(mockRepository.getCategories()).called(1);
    });
  });
}
