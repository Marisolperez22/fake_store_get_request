import 'package:fake_store_get_request/data/models/cart.dart';
import 'package:fake_store_get_request/domain/entities/cart_entity.dart';
import 'package:fake_store_get_request/domain/usecases/get_user_cart.dart';

import '../../dummies.dart';
import 'get_products_test.mocks.dart';

import 'package:mockito/mockito.dart';
import 'package:either_dart/either.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_store_get_request/core/errors/failures.dart';
import 'package:fake_store_get_request/domain/repositories/fake_store_repository.dart';

@GenerateNiceMocks([MockSpec<FakeStoreRepository>()])
void main() {
  late GetUserCart usecase;
  late MockFakeStoreRepository mockRepository;

  final tCart = Cart(
    id: 1,
    userId: 1,
    date: '2020-03-02T00:00:00.000Z',
    products: [
      CartProductsEntity(productId: 1, quantity: 4),
      CartProductsEntity(productId: 2, quantity: 1),
      CartProductsEntity(productId: 3, quantity: 6),
    ],
  );

  final tFailure = ServerFailure(401);

  setUp(() {
    setupDummies();

    mockRepository = MockFakeStoreRepository();
    usecase = GetUserCart(mockRepository);
  });

  group('GetUserCart', () {
    test('debería ser una instancia de GetUserCart', () {
      expect(usecase, isA<GetUserCart>());
    });

    test(
      'debería retornar el carrito cuando el repository tiene éxito',
      () async {
        when(
          mockRepository.getUserCart(any),
        ).thenAnswer((_) async => Right(tCart));

        final result = await usecase(1);

        expect(result.isRight, true);
        expect(result, isA<Right<Failure, Cart>>());

        result.fold((failure) => fail('No debería retornar failure'), (cart) {
          expect(cart, tCart);
          expect(cart.id, 1);
          expect(cart.userId, 1);
          expect(cart.products?.length, 3);
          expect(cart.products?[0].productId, 1);
          expect(cart.products?[0].quantity, 4);
        });
      },
    );

    test('debería retornar Failure cuando el repository falla', () async {
      when(
        mockRepository.getUserCart(any),
      ).thenAnswer((_) async => Left(tFailure));

      final result = await usecase(1);

      expect(result.isLeft, true);
      expect(result, isA<Left<Failure, Cart>>());

      result.fold((failure) {
        expect(failure, tFailure);
        expect(failure, isA<ServerFailure>());
      }, (cart) => fail('No debería retornar carrito'));
    });

    test('debería funcionar con diferentes IDs de usuario', () async {
      final testCarts = [
        Cart(
          id: 1,
          userId: 1,
          date: '',
          products: [CartProductsEntity(productId: 1, quantity: 2)],
        ),
        Cart(
          id: 2,
          userId: 2,
          date: '',
          products: [CartProductsEntity(productId: 2, quantity: 3)],
        ),
        Cart(
          id: 3,
          userId: 3,
          date: '',
          products: [CartProductsEntity(productId: 3, quantity: 1)],
        ),
      ];

      for (int i = 0; i < testCarts.length; i++) {
        final cart = testCarts[i];
        final userId = i + 1;

        when(
          mockRepository.getUserCart(userId),
        ).thenAnswer((_) async => Right(cart));

        final result = await usecase(userId);

        expect(result.isRight, true);
        result.fold(
          (failure) =>
              fail('No debería retornar failure para el usuario $userId'),
          (returnedCart) {
            expect(returnedCart, cart);
            expect(returnedCart.userId, userId);
          },
        );
      }
    });

    test('debería manejar correctamente el caso de carrito vacío', () async {
      final emptyCart = Cart(id: 1, userId: 1, date: '', products: []);

      when(
        mockRepository.getUserCart(1),
      ).thenAnswer((_) async => Right(emptyCart));

      final result = await usecase(1);

      expect(result.isRight, true);
      result.fold(
        (failure) => fail('No debería retornar failure para carrito vacío'),
        (cart) {
          expect(cart.products?.isEmpty, true);
          expect(cart.userId, 1);
        },
      );
    });

    test('debería manejar carritos con múltiples productos', () async {
      final cartWithMultipleProducts = Cart(
        id: 1,
        userId: 1,
        date: '',
        products: [
          CartProductsEntity(productId: 1, quantity: 4),
          CartProductsEntity(productId: 2, quantity: 2),
          CartProductsEntity(productId: 3, quantity: 1),
          CartProductsEntity(productId: 4, quantity: 3),
        ],
      );

      when(
        mockRepository.getUserCart(1),
      ).thenAnswer((_) async => Right(cartWithMultipleProducts));

      final result = await usecase(1);

      expect(result.isRight, true);
      result.fold((failure) => fail('No debería retornar failure'), (cart) {
        expect(cart.products?.length, 4);
        expect(cart.products?[0].quantity, 4);
        expect(cart.products?[1].productId, 2);
        expect(cart.products?[3].quantity, 3);
      });
    });
  });
}
