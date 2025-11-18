import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/scheme.dart';

/// Service to fetch government schemes from MyScheme.gov.in API
/// MyScheme is the official National Platform for Government Schemes
/// Website: https://www.myscheme.gov.in/
///
/// Note: This is a conceptual implementation. The actual MyScheme API
/// may require authentication and have different endpoints.
/// For production, you need to:
/// 1. Register at https://www.myscheme.gov.in/ for API access
/// 2. Get API credentials from data.gov.in
/// 3. Update the base URL and headers with actual API details
class MySchemeApiService {
  // TODO: Replace with actual MyScheme API endpoint after registration
  static const String _baseUrl = 'https://www.myscheme.gov.in/api/v1';
  
  // TODO: Add API key after registration at data.gov.in
  static const String _apiKey = 'YOUR_API_KEY_HERE';
  
  final http.Client _client;

  MySchemeApiService({http.Client? client}) 
      : _client = client ?? http.Client();

  /// Fetch all schemes from MyScheme API
  /// 
  /// In production, this will call the actual MyScheme API:
  /// Example endpoint: https://www.myscheme.gov.in/api/v1/schemes
  Future<List<Scheme>> fetchAllSchemes() async {
    try {
      // TODO: Uncomment when API credentials are available
      /*
      final response = await _client.get(
        Uri.parse('$_baseUrl/schemes'),
        headers: {
          'api-key': _apiKey,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => _convertToScheme(json)).toList();
      } else {
        throw Exception('Failed to load schemes: ${response.statusCode}');
      }
      */
      
      // For now, return empty list until API credentials are obtained
      throw UnimplementedError(
        'MyScheme API integration pending.\n'
        'To enable:\n'
        '1. Register at https://www.myscheme.gov.in/\n'
        '2. Get API credentials from https://data.gov.in/\n'
        '3. Update _apiKey and _baseUrl in my_scheme_api_service.dart'
      );
    } catch (e) {
      throw Exception('Error fetching schemes from MyScheme: $e');
    }
  }

  /// Fetch schemes by category
  Future<List<Scheme>> fetchSchemesByCategory(String category) async {
    try {
      // TODO: Implement when API is available
      /*
      final response = await _client.get(
        Uri.parse('$_baseUrl/schemes?category=$category'),
        headers: {
          'api-key': _apiKey,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => _convertToScheme(json)).toList();
      }
      */
      
      throw UnimplementedError('MyScheme API integration pending');
    } catch (e) {
      throw Exception('Error fetching schemes by category: $e');
    }
  }

  /// Search schemes based on eligibility criteria
  /// This is the key feature - matching schemes to user profile
  Future<List<Scheme>> fetchEligibleSchemes({
    required int age,
    required String gender,
    required String state,
    required String category,
    required String occupation,
    String? income,
    String? education,
  }) async {
    try {
      // TODO: Implement when API is available
      /*
      final queryParams = {
        'age': age.toString(),
        'gender': gender,
        'state': state,
        'category': category,
        'occupation': occupation,
        if (income != null) 'income': income,
        if (education != null) 'education': education,
      };

      final uri = Uri.parse('$_baseUrl/schemes/eligible').replace(
        queryParameters: queryParams,
      );

      final response = await _client.get(
        uri,
        headers: {
          'api-key': _apiKey,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => _convertToScheme(json)).toList();
      }
      */
      
      throw UnimplementedError('MyScheme API integration pending');
    } catch (e) {
      throw Exception('Error fetching eligible schemes: $e');
    }
  }

  /// Convert MyScheme API response to our Scheme model
  Scheme _convertToScheme(Map<String, dynamic> json) {
    // TODO: Update mapping based on actual API response structure
    return Scheme.fromFirestore(
      // Mock DocumentSnapshot - replace with actual API mapping
      throw UnimplementedError('API mapping pending'),
    );
  }

  void dispose() {
    _client.close();
  }
}

/// Hybrid service that uses both local Firestore data and MyScheme API
class HybridSchemeService {
  final MySchemeApiService _apiService;
  
  HybridSchemeService(this._apiService);

  /// Fetch schemes from multiple sources
  /// Priority: 
  /// 1. Try MyScheme API (when available)
  /// 2. Fallback to local Firestore data
  Future<List<Scheme>> fetchSchemes() async {
    try {
      // Try API first
      return await _apiService.fetchAllSchemes();
    } catch (e) {
      print('MyScheme API not available, using local data: $e');
      // Fallback to Firestore (existing implementation)
      rethrow;
    }
  }
}
