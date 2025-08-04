import 'package:either_dart/either.dart';
import 'package:fake_store_get_request/domain/entities/product_entity.dart';

import '../../core/errors/failures.dart';
import '../repositories/fake_store_repository.dart';

class GetProducts {
  final FakeStoreRepository repository;

  GetProducts(this.repository);

  Future<Either<Failure, List<ProductEntity>>> call() async {
    return await repository.getProducts();
  }
}
