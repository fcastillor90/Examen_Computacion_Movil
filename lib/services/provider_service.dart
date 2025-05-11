import '../config/api_config.dart';
import '../models/provider_model.dart';
import 'api_service.dart';

class ProviderService {
  final ApiService _apiService = ApiService();

  // Get all providers
  Future<List<Provider>> getProviders() async {
    try {
      final response = await _apiService.get(ApiConfig.providerList);
      
      if (response != null && response['status'] == 'ok' && response['data'] != null) {
        List<dynamic> data = response['data'];
        return data.map((json) => Provider.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      throw Exception('Failed to get providers: $e');
    }
  }

  // Add a new provider
  Future<bool> addProvider(Provider provider) async {
    try {
      final response = await _apiService.post(
        ApiConfig.providerAdd, 
        provider.toAddJson()
      );
      
      return response != null && response['status'] == 'ok';
    } catch (e) {
      throw Exception('Failed to add provider: $e');
    }
  }

  // Update an existing provider
  Future<bool> updateProvider(Provider provider) async {
    try {
      final response = await _apiService.post(
        ApiConfig.providerEdit, 
        provider.toJson()
      );
      
      return response != null && response['status'] == 'ok';
    } catch (e) {
      throw Exception('Failed to update provider: $e');
    }
  }

  // Delete a provider
  Future<bool> deleteProvider(int id) async {
    try {
      final response = await _apiService.post(
        ApiConfig.providerDelete, 
        {'provider_id': id}
      );
      
      return response != null && response['status'] == 'ok';
    } catch (e) {
      throw Exception('Failed to delete provider: $e');
    }
  }
}
