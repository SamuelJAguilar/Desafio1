import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost:3000';
  
  final http.Client client;

  ApiService({required this.client});

  // Método genérico para GET requests
  Future<dynamic> get(String endpoint) async {
    final response = await client.get(Uri.parse('$baseUrl$endpoint'));
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }

  // Método genérico para POST requests
  Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    final response = await client.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    
    if (response.statusCode == 201 || response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create: ${response.statusCode}');
    }
  }

  // Método genérico para PUT requests
  Future<dynamic> put(String endpoint, Map<String, dynamic> data) async {
    final response = await client.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to update: ${response.statusCode}');
    }
  }

  // Método genérico para DELETE requests
  Future<dynamic> delete(String endpoint) async {
    final response = await client.delete(Uri.parse('$baseUrl$endpoint'));
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to delete: ${response.statusCode}');
    }
  }
}