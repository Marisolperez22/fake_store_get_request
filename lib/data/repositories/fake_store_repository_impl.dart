import 'package:either_dart/either.dart';
import 'package:fake_store_get_request/domain/entities/product_entity.dart';

import '../../core/utils/utils.dart';
import '../../core/errors/failures.dart';
import '../datasources/fake_store_datasource.dart';
import '../../domain/repositories/fake_store_repository.dart';
import 'package:fake_store_get_request/data/models/product.dart';

class FakeStoreRepositoryImpl implements FakeStoreRepository {
  final FakeStoreDataSource dataSource;

  FakeStoreRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts() async {
    try {
      final productsJson = await dataSource.getProducts();
      final products = productsJson.map((e) => Product.fromJson(e)).toList();
      return Right(products.toEntityList());
    } catch (e) {
      return Utils.handleException(e);
    }
  }

  @override
  Future<Either<Failure, List<String>>> getCategories() async {
    try {
      final categories = await dataSource.getCategories();
      return Right(categories);
    } catch (e) {
      return Utils.handleException(e);
    }
  }

  // @override
  // Future<Product> getProductDetail(int productId) async {
  //   final product = await dataSource.getProductDetail(productId);
  //   return ProductModel.fromJson(product);
  // }

  // @override
  // Future<List<Product>> getProductByCategory(String category) {
  //   throw UnimplementedError();
  // }

  // @override
  // Future<List<Cart>> getUserCart(int idUser) {
  //   throw UnimplementedError();
  // }

  // @override
  // Future<List<User>> getUsers() {
  //   throw UnimplementedError();
  // }

  // @override
  // Future<LoginResponse> login(String username, String password) {
  //   throw UnimplementedError();
  // }

  // @override
  // Future<void> signUp(SignupRequest request) {
  //   throw UnimplementedError();
  // }
}
