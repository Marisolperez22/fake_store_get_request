import 'package:either_dart/either.dart';
import 'package:fake_store_get_request/data/models/product.dart';

import '../../core/errors/failures.dart';
import '../repositories/fake_store_repository.dart';

class GetProducts {
  final FakeStoreRepository repository;

  GetProducts(this.repository);

  Future<Either<Failure, List<Product>>> call() async {
    return await repository.getProducts();
  }
}
