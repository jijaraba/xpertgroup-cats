import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static String get baseUrl => dotenv.env['CAT_API_BASE_URL'] ?? 'https://api.thecatapi.com/v1';
  static String get apiKey => dotenv.env['CAT_API_KEY'] ?? '';
  
  // Endpoints
  static const String breeds = '/breeds';
  static const String images = '/images/search';
  static const String votes = '/votes';
  
  // Headers
  static Map<String, String> get headers => {
    'x-api-key': apiKey,
    'Content-Type': 'application/json',
  };
}
