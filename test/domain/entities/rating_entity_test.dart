import 'package:flutter_test/flutter_test.dart';
import 'package:fake_store_get_request/domain/entities/rating_entity.dart';

void main() {
  group('RatingEntity', () {
    test('Debe crear la entidad con valores correctos', () {
      final rating = RatingEntity(rate: 4.5, count: 120);

      expect(rating.rate, 4.5);
      expect(rating.count, 120);
    });

    test('Debe permitir valores nulos', () {
      final rating = RatingEntity();

      expect(rating.rate, isNull);
      expect(rating.count, isNull);
    });

    test('Dos instancias con mismos valores no son iguales por defecto', () {
      final r1 = RatingEntity(rate: 4.5, count: 120);
      final r2 = RatingEntity(rate: 4.5, count: 120);

      expect(r1 == r2, isFalse); // porque no sobrescribiste ==
    });
  });
}
