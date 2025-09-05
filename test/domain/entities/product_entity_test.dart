import 'package:flutter_test/flutter_test.dart';
import 'package:fake_store_get_request/domain/entities/product_entity.dart';
import 'package:fake_store_get_request/domain/entities/rating_entity.dart';

void main() {
  group('ProductEntity', () {
    final rating = RatingEntity(rate: 4.5, count: 120);

    final product1 = ProductEntity(
      id: 1,
      title: "Camisa",
      price: 19.99,
      image: "http://image.com/camisa.png",
      category: "Ropa",
      description: "Camisa de algodón manga larga",
      rating: rating,
    );

    final product2 = ProductEntity(
      id: 1,
      title: "Camisa",
      price: 19.99,
      image: "http://image.com/camisa.png",
      category: "Ropa",
      description: "Camisa de algodón manga larga",
      rating: rating,
    );

    test('props deben contener todos los campos', () {
      expect(
        product1.props,
        [1, "Camisa", 19.99, "http://image.com/camisa.png", "Ropa", "Camisa de algodón manga larga", rating],
      );
    });

    test('dos instancias con mismos valores deben ser iguales', () {
      expect(product1, equals(product2));
    });

    test('toString debe contener información relevante', () {
  final str = product1.toString();

  expect(str, contains("id: 1"));
  expect(str, contains("title: Camisa"));
  expect(str, contains("price: 19.99"));
  expect(str, contains("category: Ropa"));
  expect(str, contains("rating: Instance of 'RatingEntity'")); 
});

test('toString debe truncar la descripción a 20 caracteres', () {
  final longDesc = ProductEntity(
    id: 2,
    title: "Zapatos",
    price: 49.99,
    image: "http://image.com/zapatos.png",
    category: "Calzado",
    description: "Estos son unos zapatos muy cómodos y elegantes para toda ocasión",
    rating: rating,
  );

  final str = longDesc.toString();
  expect(str, contains("Estos son unos zapat...")); 
});
  });
}
