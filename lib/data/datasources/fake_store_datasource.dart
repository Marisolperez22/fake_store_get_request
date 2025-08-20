import 'package:fake_store_get_request/data/models/product.dart';

import '../../core/infrastructure/api_client.dart';
import '../models/cart.dart';
import '../models/login_response.dart';

abstract class FakeStoreDataSource {
  Future<List<Product>> getProducts();
  Future<List<String>> getCategories();
  Future<Cart> getUserCart(int idUser);
  Future<Product> getProductDetail(int productId);
  Future<List<Product>> getProductByCategory(String category);
  Future<LoginResponse> login(String username, String password);
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

  @override
  Future<LoginResponse> login(String username, String password) async {
    final data = await apiClient.post(
      '$_baseUrl/auth/login',
      body: {'username': username, 'password': password},
    );

    return LoginResponse.fromJson(data);
  }

  @override
  Future<List<Product>> getProductByCategory(String category) async {
    final data = await apiClient.get('$_baseUrl/products/category/$category');
    return (data as List).map((json) => Product.fromJson(json)).toList();
  }

  @override
  Future<Cart> getUserCart(int idUser) async {
    final data = await apiClient.get('$_baseUrl/carts/$idUser');
    return Cart.fromJson(data);
  }
}
