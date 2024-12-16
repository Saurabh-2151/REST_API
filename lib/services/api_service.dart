import 'dart:convert';
import 'package:dio/dio.dart';

class ApiService {
  final String baseUrl = 'https://fakestoreapi.com/products';
  final Dio dio;

  ApiService() : dio = Dio();

  Future<List<dynamic>> fetchProducts() async {
    try {
      final response = await dio.get(baseUrl);

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to load products: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  Future<Map<String, dynamic>> addProduct(Map<String, dynamic> newProduct) async {
    try {
      final response = await dio.post(
        baseUrl,
        options: Options(headers: {'Content-Type': 'application/json'}),
        data: json.encode(newProduct),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        throw Exception('Failed to add product: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Error adding product: $e');
    }
  }

  Future<Map<String, dynamic>> updateProduct(int productId, Map<String, dynamic> updatedProduct) async {
    try {
      final response = await dio.put(
        '$baseUrl/$productId',
        options: Options(headers: {'Content-Type': 'application/json'}),
        data: json.encode(updatedProduct),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to update product: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Error updating product: $e');
    }
  }

  Future<void> deleteProduct(int productId) async {
    try {
      final response = await dio.delete('$baseUrl/$productId');

      if (response.statusCode != 200) {
        throw Exception('Failed to delete product: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Error deleting product: $e');
    }
  }
}
