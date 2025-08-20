import 'dart:convert';

import 'package:fake_store_get_request/data/models/cart.dart';
import 'package:fake_store_get_request/data/models/user.dart';
import 'package:http/http.dart' as http;

import '../core/infrastructure/api_client.dart';
import '../data/models/product.dart';
import '../data/models/login_response.dart';
import '../data/models/sing_up_request.dart';

class FakeStoreService {
  final ApiClient apiClient;
  static const String _baseUrl = 'https://fakestoreapi.com';

  FakeStoreService({ApiClient? apiClient})
    : apiClient = apiClient ?? ApiClient();

  Future<List<Product>> getProducts() async {
    final data = await apiClient.get('$_baseUrl/products');
    return (data as List).map((json) => Product.fromJson(json)).toList();
  }

  Future<Product> getProductDetail(int productId) async {
    final data = await apiClient.get('$_baseUrl/products/$productId');
    return Product.fromJson(data);
  }

  // Future<LoginResponse> login(String username, String password) async {
  //   final response = await client.post(
  //     Uri.parse('$_baseUrl/auth/login'),
  //     body: {"username": username, "password": password},
  //   );

  //   if (response.statusCode == 200) {
  //     final token = LoginResponse.fromJson(jsonDecode(response.body));
  //     final users = await getUsers();
  //     final user = users.firstWhere(
  //       (user) => user.username == username,
  //       orElse: () => throw "Usuario no encontrado",
  //     );

  //     return LoginResponse(token: token.token, userId: user.id ?? 0);
  //   } else {
  //     throw 'Credenciales incorrectas';
  //   }
  // }

  Future<LoginResponse> login(String username, String password) async {
    final data = await apiClient.post(
      '$_baseUrl/auth/login',
      body: {'username': username, 'password': password},
    );
    return LoginResponse.fromJson(data);
  }

  Future<List<String>> getCategories() async {
    final data = await apiClient.get('$_baseUrl/products/categories');
    return (data as List).cast<String>();
  }

  Future<List<Product>> getProductByCategory(String category) async {
    final data = await apiClient.get('$_baseUrl/products/category/$category');
    return (data as List).map((json) => Product.fromJson(json)).toList();
  }

  // Future<List<User>> getUsers() async {
  //   final response = await client.get(Uri.parse('$_baseUrl/users'));
  //   if (response.statusCode == 200) {
  //     final List data = json.decode(response.body);
  //     return data.map((json) => User.fromJson(json)).toList();
  //   } else {
  //     throw Exception('Error al cargar usuarios');
  //   }
  // }

  Future<Cart> getUserCart(int idUser) async {
    final data = await apiClient.get('$_baseUrl/carts/$idUser');
    return Cart.fromJson(data);
  }
}

  // Future<void> signUp(SignupRequest request) async {
  //   final response = await http.post(
  //     Uri.parse('$_baseUrl/users'),
  //     headers: {'Content-Type': 'application/json'},
  //     body: jsonEncode(request.toJson()),
  //   );

  //   if (response.statusCode != 200) {
  //     throw Exception('Failed to sign up: ${response.body}');
  //   }
  // }

