import 'package:either_dart/either.dart';
import 'package:fake_store_get_request/fake_store_get_request.dart';

import '../../core/errors/failures.dart';
import '../repositories/fake_store_repository.dart';

class GetProductDetail {
  final FakeStoreRepository repository;

  GetProductDetail(this.repository);

  Future<Either<Failure, Product>> call(int idProduct) async {
    return await repository.getProductDetail(idProduct);
  }
}
