import 'package:either_dart/either.dart';

import '../../data/models/cart.dart';
import '../../data/models/product.dart';
import '../../core/errors/failures.dart';
import '../../data/models/login_response.dart';

abstract class FakeStoreRepository {
  Future<Either<Failure, List<String>>> getCategories();
  Future<Either<Failure, List<Product>>> getProducts();
  Future<Either<Failure, Product>> getProductDetail(int productId);
  Future<Either<Failure, Cart>> getUserCart(int idUser);


  Future<Either<Failure, List<Product>>> getProductByCategory(String category);
  Future<Either<Failure, LoginResponse>> login(
    String username,
    String password,
  );
}
