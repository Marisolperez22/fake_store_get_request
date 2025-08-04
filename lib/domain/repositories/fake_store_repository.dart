import 'package:either_dart/either.dart';

import '../../core/errors/failures.dart';
import '../entities/product_entity.dart';

abstract class FakeStoreRepository {
  Future<Either<Failure, List<String>>> getCategories();
  Future<Either<Failure, List<ProductEntity>>> getProducts();

  // Future<Either<Failure, List<User>>> getUsers();
  //   Future<Either<Failure, List<Cart>>> getUserCart(int idUser);
  //   Future<Either<Failure, void>> signUp(SignupRequest request);
  //   Future<Either<Failure, Product>> getProductDetail(int productId);
  //   Future<Either<Failure, List<Product>>> getProductByCategory(String category);
  //   Future<Either<Failure, LoginResponse>> login(
  //     String username,
  //     String password,
  //   );
}
