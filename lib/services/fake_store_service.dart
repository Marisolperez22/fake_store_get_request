import 'dart:convert';

import 'package:fake_store_get_request/models/cart.dart';
import 'package:fake_store_get_request/models/user.dart';
import 'package:http/http.dart' as http;

import '../models/login_response.dart';
import '../models/product.dart';
import '../models/sing_up_request.dart';

class FakeStoreService {
  static const String _baseUrl = 'https://fakestoreapi.com';
  final http.Client client;

  // Constructor con cliente opcional (para testing)
  FakeStoreService({http.Client? client}) : client = client ?? http.Client();

  Future<List<Product>> getProducts() async {
    final response = await client.get(Uri.parse('$_baseUrl/products'));

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar productos');
    }
  }

  Future<Product> getProductDetail(int productId) async {
    final response = await client.get(
      Uri.parse('$_baseUrl/products/$productId'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return Product.fromJson(data);
    } else {
      throw Exception('Error al cargar detalle de producto');
    }
  }

  Future<LoginResponse> login(String username, String password) async {
    final response = await client.post(
      Uri.parse('$_baseUrl/auth/login'),
      body: {"username": username, "password": password},
    );

    if (response.statusCode == 200) {
      final token = LoginResponse.fromJson(jsonDecode(response.body));
      final users = await getUsers();
      final user = users.firstWhere(
        (user) => user.username == username,
        orElse: () => throw "Usuario no encontrado",
      );

      return LoginResponse(token: token.token, userId: user.id ?? 0);
    } else {
      throw 'Credenciales incorrectas';
    }
  }

  Future<List<String>> getCategories() async {
    final response = await client.get(
      Uri.parse('$_baseUrl/products/categories'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.cast<String>();
    } else {
      throw Exception('Error al cargar categorías');
    }
  }

  Future<List<Product>> getProductByCategory(String category) async {
    final response = await client.get(
      Uri.parse('$_baseUrl/products/category/$category'),
    );
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar productos');
    }
  }

  Future<List<User>> getUsers() async {
    final response = await client.get(Uri.parse('$_baseUrl/users'));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar usuarios');
    }
  }

  Future<List<Cart>> getUserCart(int idUser) async {
    final response = await client.get(Uri.parse('$_baseUrl/carts/$idUser'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> products = data['products'];
      return products.map((productJson) => Cart.fromJson(productJson)).toList();
    } else {
      throw Exception('Error al cargar el carrito del usuario');
    }
  }

    Future<void> signUp(SignupRequest request) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/users'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to sign up: ${response.body}');
    }
  }
}
