import 'package:either_dart/either.dart';

import '../models/cart.dart';
import '../models/login_response.dart';
import '../../core/errors/failures.dart';
import '../datasources/fake_store_datasource.dart';
import '../../domain/repositories/fake_store_repository.dart';
import 'package:fake_store_get_request/data/models/product.dart';

class FakeStoreRepositoryImpl implements FakeStoreRepository {
  final FakeStoreDataSource dataSource;

  FakeStoreRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, List<Product>>> getProducts() async {
    try {
      final products = await dataSource.getProducts();
      return Right(products);
    } catch (e) {
      return const Left(AnotherFailure());
    }
  }

  @override
  Future<Either<Failure, List<String>>> getCategories() async {
    try {
      final categories = await dataSource.getCategories();
      return Right(categories);
    } catch (e) {
      return const Left(AnotherFailure());
    }
  }

  @override
  Future<Either<Failure, Cart>> getUserCart(int idUser) async {
    try {
      final cart = await dataSource.getUserCart(idUser);
      return Right(cart);
    } catch (e) {
      return const Left(AnotherFailure());
    }
  }

  @override
  Future<Either<Failure, Product>> getProductDetail(int productId) async {
    try {
      final productDetail = await dataSource.getProductDetail(productId);
      return Right(productDetail);
    } catch (e) {
      return const Left(AnotherFailure());
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getProductByCategory(
    String category,
  ) async {
    try {
      final productByCategory = await dataSource.getProductByCategory(category);
      return Right(productByCategory);
    } catch (e) {
      return const Left(AnotherFailure());
    }
  }

  @override
  Future<Either<Failure, LoginResponse>> login(
    String username,
    String password,
  ) async {
    try {
      final login = await dataSource.login(username, password);
      return Right(login);
    } catch (e) {
      return const Left(AnotherFailure());
    }
  }
}
