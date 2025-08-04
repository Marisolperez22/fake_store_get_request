import '../../core/infrastructure/api_client.dart';

abstract class FakeStoreDataSource {
  Future<List<String>> getCategories();
  Future<List<Map<String, dynamic>>> getProducts();

  // Future<List<Map<String, dynamic>>> getUsers();
  // Future<void> signUp(Map<String, dynamic> request);
  // Future<List<Map<String, dynamic>>> getUserCart(int idUser);
  // Future<Map<String, dynamic>> getProductDetail(int productId);
  // Future<Map<String, dynamic>> login(String username, String password);
  // Future<List<Map<String, dynamic>>> getProductByCategory(String category);
}

class FakeStoreRemoteDataSource implements FakeStoreDataSource {
  final ApiClient apiClient;
  static const String _baseUrl = 'https://fakestoreapi.com';

  FakeStoreRemoteDataSource({required this.apiClient});

  @override
  Future<List<Map<String, dynamic>>> getProducts() async {
    final response = await apiClient.get('$_baseUrl/products');
    return List<Map<String, dynamic>>.from(response);
  }

  @override
  Future<List<String>> getCategories() async {
    final response = await apiClient.get('$_baseUrl/products/categories');
    return List<String>.from(response);
  }

  // @override
  // Future<Map<String, dynamic>> getProductDetail(int productId) async {
  //   final response = await apiClient.get('$_baseUrl/products/$productId');
  //   return Map<String, dynamic>.from(response);
  // }

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
  // Future<Map<String, dynamic>> login(String username, String password) {
  //   // TODO: implement login
  //   throw UnimplementedError();
  // }

  // @override
  // Future<void> signUp(Map<String, dynamic> request) {
  //   // TODO: implement signUp
  //   throw UnimplementedError();
  // }
}
