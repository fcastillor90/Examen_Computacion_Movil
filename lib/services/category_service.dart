import '../config/api_config.dart';
import '../models/category_model.dart';
import 'api_service.dart';

class CategoryService {
  final ApiService _apiService = ApiService();

  // Get all categories
  Future<List<Category>> getCategories() async {
    try {
      final response = await _apiService.get(ApiConfig.categoryList);
      
      if (response != null && response['status'] == 'ok' && response['data'] != null) {
        List<dynamic> data = response['data'];
        return data.map((json) => Category.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      throw Exception('Failed to get categories: $e');
    }
  }

  // Add a new category
  Future<bool> addCategory(Category category) async {
    try {
      final response = await _apiService.post(
        ApiConfig.categoryAdd, 
        category.toAddJson()
      );
      
      return response != null && response['status'] == 'ok';
    } catch (e) {
      throw Exception('Failed to add category: $e');
    }
  }

  // Update an existing category
  Future<bool> updateCategory(Category category) async {
    try {
      final response = await _apiService.post(
        ApiConfig.categoryEdit, 
        category.toJson()
      );
      
      return response != null && response['status'] == 'ok';
    } catch (e) {
      throw Exception('Failed to update category: $e');
    }
  }

  // Delete a category
  Future<bool> deleteCategory(int id) async {
    try {
      final response = await _apiService.post(
        ApiConfig.categoryDelete, 
        {'category_id': id}
      );
      
      return response != null && response['status'] == 'ok';
    } catch (e) {
      throw Exception('Failed to delete category: $e');
    }
  }
}
