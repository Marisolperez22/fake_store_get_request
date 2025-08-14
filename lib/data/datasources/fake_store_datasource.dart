import 'package:fake_store_get_request/data/models/product.dart';

import '../../core/infrastructure/api_client.dart';
import '../models/login_response.dart';

abstract class FakeStoreDataSource {
  Future<List<Product>> getProducts();
  Future<List<String>> getCategories();
  Future<Product> getProductDetail(int productId);
  // Future<LoginResponse> login(String username, String password);

  // Future<List<Map<String, dynamic>>> getUsers();

  // Future<void> signUp(Map<String, dynamic> request);
  // Future<List<Map<String, dynamic>>> getUserCart(int idUser);
  // Future<List<Map<String, dynamic>>> getProductByCategory(String category);
}

class FakeStoreRemoteDataSource implements FakeStoreDataSource {
  final ApiClient apiClient;
  static const String _baseUrl = 'https://fakestoreapi.com';

  FakeStoreRemoteDataSource({ApiClient? apiClient})
    : apiClient = apiClient ?? ApiClient();

  @override
  Future<List<Product>> getProducts() async {
    final data = await apiClient.get('$_baseUrl/products');
    return (data as List).map((json) => Product.fromJson(json)).toList();
  }

  @override
  Future<List<String>> getCategories() async {
    final data = await apiClient.get('$_baseUrl/products/categories');
    return (data as List).cast<String>();
  }

  @override
  Future<Product> getProductDetail(int productId) async {
    final data = await apiClient.get('$_baseUrl/products/$productId');
    return Product.fromJson(data);
  }

  //   @override
  //   Future<LoginResponse> login(String username, String password) async {
  //  final data = await apiClient.get('$_baseUrl/auth/login');
  //     return Product.fromJson(data);
  //   }

  // @override
  // Future<List<Map<String, dynamic>>> getProductByCategory(String category) {
  //   // TODO: implement getProductByCategory
  //   throw UnimplementedError();
  // }

  // @override
  // Future<List<Map<String, dynamic>>> getUserCart(int idUser) {
  //   // TODO: implement getUserCart
  //   throw UnimplementedError();
  // }

  // @override
  // Future<List<Map<String, dynamic>>> getUsers() {
  //   // TODO: implement getUsers
  //   throw UnimplementedError();
  // }

  // @override
  // Future<void> signUp(Map<String, dynamic> request) {
  //   // TODO: implement signUp
  //   throw UnimplementedError();
  // }
}
