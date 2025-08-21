import 'package:either_dart/either.dart';
import 'package:fake_store_get_request/data/models/login_response.dart';

import '../../core/errors/failures.dart';
import '../repositories/fake_store_repository.dart';

class Login {
  final FakeStoreRepository repository;

  Login(this.repository);

  Future<Either<Failure, LoginResponse>> call(
    String username,
    String password,
  ) async {
    return await repository.login(username, password);
  }
}
