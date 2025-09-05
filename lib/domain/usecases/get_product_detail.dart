import 'package:either_dart/either.dart';

import '../../core/errors/failures.dart';
import '../../data/models/product.dart';
import '../repositories/fake_store_repository.dart';

class GetProductDetail {
  final FakeStoreRepository repository;

  GetProductDetail(this.repository);

  Future<Either<Failure, Product>> call(int idProduct) async {
    return await repository.getProductDetail(idProduct);
  }
}
