import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class ApiService {
  final String _baseUrl = ApiConfig.baseUrl;
  final String _user = ApiConfig.user;
  final String _pass = ApiConfig.pass;

  // Get authentication headers
  Map<String, String> _getHeaders() {
    String basicAuth = 'Basic ${base64Encode(utf8.encode('$_user:$_pass'))}';
    return {
      'Authorization': basicAuth,
      'Content-Type': 'application/json',
    };
  }

  // Generic GET request
  Future<dynamic> get(String endpoint) async {
    final uri = Uri.http(_baseUrl, endpoint);
    try {
      final response = await http.get(uri, headers: _getHeaders());
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error in GET request: $e');
    }
  }

  // Generic POST request
  Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    final uri = Uri.http(_baseUrl, endpoint);
    try {
      final response = await http.post(
        uri,
        headers: _getHeaders(),
        body: json.encode(data),
      );
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to post data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error in POST request: $e');
    }
  }
}
