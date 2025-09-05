import 'package:fake_store_get_request/domain/entities/cart_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CartEntity', () {
    test('debe crearse correctamente', () {
      final cart = CartEntity(
        id: 1,
        userId: 42,
        date: "2025-09-02",
        products: [
          CartProductsEntity(productId: 10, quantity: 2),
          CartProductsEntity(productId: 20, quantity: 5),
        ],
      );

      expect(cart.id, 1);
      expect(cart.userId, 42);
      expect(cart.date, "2025-09-02");
      expect(cart.products, isNotNull);
      expect(cart.products!.length, 2);

      final firstProduct = cart.products!.first;
      expect(firstProduct.productId, 10);
      expect(firstProduct.quantity, 2);
    });

    test('puede crear un carrito vacío', () {
      final cart = CartEntity();

      expect(cart.id, isNull);
      expect(cart.userId, isNull);
      expect(cart.date, isNull);
      expect(cart.products, isNull);
    });
  });

  group('CartProductsEntity', () {
    test('debe almacenar productId y quantity', () {
      final product = CartProductsEntity(productId: 99, quantity: 3);

      expect(product.productId, 99);
      expect(product.quantity, 3);
    });
  });
}
