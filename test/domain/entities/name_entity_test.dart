import 'package:fake_store_get_request/domain/entities/name_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('NameEntity', () {
    test('debe almacenar firstname y lastname correctamente', () {
      final name = NameEntity(firstname: "Marisol", lastname: "Perez");

      expect(name.firstname, "Marisol");
      expect(name.lastname, "Perez");
    });
  });
}
