import 'package:either_dart/either.dart';
import 'package:fake_store_get_request/data/models/cart.dart';

import '../../core/errors/failures.dart';
import '../repositories/fake_store_repository.dart';

class GetUserCart {
  final FakeStoreRepository repository;

  GetUserCart(this.repository);

  Future<Either<Failure, Cart>> call(int idUser) async {
    return await repository.getUserCart(idUser);
  }
}
