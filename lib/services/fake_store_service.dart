import 'package:either_dart/either.dart';
import 'package:fake_store_get_request/data/models/cart.dart';
import 'package:fake_store_get_request/domain/usecases/get_categories.dart';
import 'package:fake_store_get_request/domain/usecases/get_product_by_category.dart';
import 'package:fake_store_get_request/domain/usecases/get_product_detail.dart';
import 'package:fake_store_get_request/domain/usecases/get_products.dart';
import 'package:fake_store_get_request/domain/usecases/get_user_cart.dart';
import 'package:fake_store_get_request/domain/usecases/login.dart';

import '../data/datasources/fake_store_datasource.dart';
import '../data/models/product.dart';
import '../data/models/login_response.dart';
import '../data/repositories/fake_store_repository_impl.dart';

class FakeStoreService {
  final GetProducts getProductsUsecase;
  final GetProductDetail getProductDetailUsecase;
  final Login loginUsecase;
  final GetCategories getCategoriesUsecase;
  final GetProductByCategory getProductsByCategoryUsecase;
  final GetUserCart getUserCartUsecase;

  FakeStoreService({String? baseUrl})
      : getProductsUsecase = GetProducts(
            FakeStoreRepositoryImpl(dataSource: FakeStoreRemoteDataSource())),
        getProductDetailUsecase = GetProductDetail(
            FakeStoreRepositoryImpl(dataSource: FakeStoreRemoteDataSource())),
        loginUsecase =
            Login(FakeStoreRepositoryImpl(dataSource: FakeStoreRemoteDataSource())),
        getCategoriesUsecase = GetCategories(
            FakeStoreRepositoryImpl(dataSource: FakeStoreRemoteDataSource())),
        getProductsByCategoryUsecase = GetProductByCategory(
            FakeStoreRepositoryImpl(dataSource: FakeStoreRemoteDataSource())),
        getUserCartUsecase = GetUserCart(
            FakeStoreRepositoryImpl(dataSource: FakeStoreRemoteDataSource()));

  FakeStoreService.test({
    required this.getProductsUsecase,
    required this.getProductDetailUsecase,
    required this.loginUsecase,
    required this.getCategoriesUsecase,
    required this.getProductsByCategoryUsecase,
    required this.getUserCartUsecase,
  });

  Future<List<Product>> getProducts() async {
    final result = await getProductsUsecase();
    return handleEither(result);
  }

  Future<Product> getProductDetail(int productId) async {
    final result = await getProductDetailUsecase(productId);
    return handleEither(result);
  }

  Future<LoginResponse> login(String username, String password) async {
    final result = await loginUsecase(username, password);
    return handleEither(result);
  }

  Future<List<String>> getCategories() async {
    final result = await getCategoriesUsecase();
    return handleEither(result);
  }

  Future<List<Product>> getProductsByCategory(String category) async {
    final result = await getProductsByCategoryUsecase(category);
    return handleEither(result);
  }

  Future<Cart> getUserCart(int userId) async {
    final result = await getUserCartUsecase(userId);
    return handleEither(result);
  }

  T handleEither<E, T>(Either<E, T> either) {
    return either.fold(
      (failure) => throw mapFailureToException(failure),
      (success) => success,
    );
  }

  Exception mapFailureToException(failure) {
    if (failure is String) {
      return Exception(failure);
    } else if (failure is Exception) {
      return failure;
    } else {
      return Exception('An unexpected error occurred');
    }
  }
}

