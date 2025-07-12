import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/login_response.dart';
import '../models/product.dart';

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
      final Map<String, dynamic> data = json.decode(response.body);
      return LoginResponse.fromJson(data);
    } else {
      throw Exception('Error al iniciar sesión');
    }
  }
}
