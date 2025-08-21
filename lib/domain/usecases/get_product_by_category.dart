import 'package:either_dart/either.dart';

import '../../core/errors/failures.dart';
import '../../data/models/product.dart';
import '../repositories/fake_store_repository.dart';

class GetProductByCategory {
  final FakeStoreRepository repository;

  GetProductByCategory(this.repository);

  Future<Either<Failure, List<Product>>> call(String category) async {
    return await repository.getProductByCategory(category);
  }
}
