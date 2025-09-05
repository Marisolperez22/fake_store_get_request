import 'package:fake_store_get_request/domain/entities/login_response_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LoginResponseEntity', () {
    test('debe almacenar correctamente el token', () {
      final response = LoginResponseEntity(token: "fake_token_123");

      expect(response.token, "fake_token_123");
    });
  });
}
