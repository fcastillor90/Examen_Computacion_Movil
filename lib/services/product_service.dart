import '../config/api_config.dart';
import '../models/product_model.dart';
import 'api_service.dart';

class ProductService {
  final ApiService _apiService = ApiService();

  // Get all products
  Future<List<Product>> getProducts() async {
    try {
      final response = await _apiService.get(ApiConfig.productList);
      
      if (response != null && response['status'] == 'ok' && response['data'] != null) {
        List<dynamic> data = response['data'];
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      throw Exception('Failed to get products: $e');
    }
  }

  // Add a new product
  Future<bool> addProduct(Product product) async {
    try {
      final response = await _apiService.post(
        ApiConfig.productAdd, 
        product.toAddJson()
      );
      
      return response != null && response['status'] == 'ok';
    } catch (e) {
      throw Exception('Failed to add product: $e');
    }
  }

  // Update an existing product
  Future<bool> updateProduct(Product product) async {
    try {
      final response = await _apiService.post(
        ApiConfig.productEdit, 
        product.toJson()
      );
      
      return response != null && response['status'] == 'ok';
    } catch (e) {
      throw Exception('Failed to update product: $e');
    }
  }

  // Delete a product
  Future<bool> deleteProduct(int id) async {
    try {
      final response = await _apiService.post(
        ApiConfig.productDelete, 
        {'product_id': id}
      );
      
      return response != null && response['status'] == 'ok';
    } catch (e) {
      throw Exception('Failed to delete product: $e');
    }
  }
}
