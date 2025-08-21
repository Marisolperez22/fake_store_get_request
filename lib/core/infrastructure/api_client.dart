import 'dart:convert';

import 'package:http/http.dart' as http;


class ApiClient {
  final http.Client _client;

  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  Future<dynamic> get(String url) async {
    final response = await _client.get(Uri.parse(url));

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(response.body);
    } else {
      throw ServerException(message: 'Error en GET $url');
    }
  }

  Future<dynamic> post(String url, {Map<String, dynamic>? body}) async {
    final response = await _client.post(
      Uri.parse(url),
      body: body,
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(response.body);
    } else {
      throw ServerException(message: 'Error en la petición POST: $url');
    }
  }
}

class ServerException implements Exception {
  final String message;
  ServerException({required this.message});
}
