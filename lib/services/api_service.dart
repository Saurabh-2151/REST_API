import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'https://fakestoreapi.com/products';

  Future<List<dynamic>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load products: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  Future<Map<String, dynamic>> addProduct(Map<String, dynamic> newProduct) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(newProduct),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to add product: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error adding product: $e');
    }
  }

  Future<Map<String, dynamic>> updateProduct(int productId, Map<String, dynamic> updatedProduct) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$productId'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(updatedProduct),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to update product: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error updating product: $e');
    }
  }

  Future<void> deleteProduct(int productId) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$productId'));

      if (response.statusCode != 200) {
        throw Exception('Failed to delete product: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error deleting product: $e');
    }
  }
}
