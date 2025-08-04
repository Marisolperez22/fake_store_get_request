import 'package:either_dart/either.dart';

import '../../core/errors/failures.dart';
import '../repositories/fake_store_repository.dart';

class GetCategories {
  final FakeStoreRepository repository;

  GetCategories(this.repository);

  Future<Either<Failure, List<String>>> call() async {
    return await repository.getCategories();
  }
}
