import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service that fetches word definitions from the Free Dictionary API
class DictionaryService {
  static const String _baseUrl = 'https://api.dictionaryapi.dev/api/v2/entries/en/';
  
  /// Fetch definition for a single word
  static Future<String?> fetchDefinition(String word) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl${word.toLowerCase()}'),
      ).timeout(const Duration(seconds: 5));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        if (data.isNotEmpty) {
          final firstEntry = data[0];
          final meanings = firstEntry['meanings'] as List;
          
          if (meanings.isNotEmpty) {
            final definitions = meanings[0]['definitions'] as List;
            if (definitions.isNotEmpty) {
              return definitions[0]['definition'] as String;
            }
          }
        }
      }
      return null;
    } catch (e) {
      // Offline or API error
      return null;
    }
  }
}