import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';
import '../services/dictionary_service.dart';

/// Repository that manages word definitions with caching
class DictionaryRepository {
  static const String _cacheKey = 'definitions_cache';
  static const String _lastUpdatedKey = 'definitions_last_updated';
  
  /// Get definition for a word (checks: bundled → cache → API)
  static Future<String?> getDefinition(String word) async {
    final wordUpper = word.toUpperCase();
    
    // 1. Check bundled definitions.json first (always available offline)
    final bundled = await _getBundledDefinition(wordUpper);
    if (bundled != null) {
      return bundled;
    }
    
    // 2. Check SharedPreferences cache
    final cached = await _getCachedDefinition(wordUpper);
    if (cached != null) {
      return cached;
    }
    
    // 3. Fetch from API (requires internet)
    try {
      final definition = await DictionaryService.fetchDefinition(wordUpper);
      if (definition != null) {
        await _saveToCache(wordUpper, definition);
        return definition;
      }
    } catch (e) {
      // Silently fail - return null
    }
    
    return null;
  }
  
  /// Get definitions for multiple words at once
  static Future<Map<String, String?>> getDefinitions(List<String> words) async {
    final results = <String, String?>{};
    for (final word in words) {
      results[word] = await getDefinition(word);
    }
    return results;
  }
  
  /// Get from bundled definitions.json
  static Future<String?> _getBundledDefinition(String word) async {
    try {
      final jsonString = await rootBundle.loadString('assets/words/definitions.json');
      final definitions = Map<String, String>.from(jsonDecode(jsonString));
      return definitions[word];
    } catch (e) {
      return null;
    }
  }
  
  /// Get from cache
  static Future<String?> _getCachedDefinition(String word) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheJson = prefs.getString(_cacheKey);
      if (cacheJson != null) {
        final cache = Map<String, String>.from(jsonDecode(cacheJson));
        return cache[word];
      }
    } catch (e) {
      // Cache error
    }
    return null;
  }
  
  /// Save to cache
  static Future<void> _saveToCache(String word, String definition) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheJson = prefs.getString(_cacheKey);
      Map<String, String> cache = {};
      
      if (cacheJson != null) {
        cache = Map<String, String>.from(jsonDecode(cacheJson));
      }
      
      cache[word] = definition;
      
      // Limit cache size to prevent memory issues (keep last 500)
      if (cache.length > 500) {
        final keys = cache.keys.toList();
        for (int i = 0; i < cache.length - 500; i++) {
          cache.remove(keys[i]);
        }
      }
      
      await prefs.setString(_cacheKey, jsonEncode(cache));
      await prefs.setString(_lastUpdatedKey, DateTime.now().toIso8601String());
    } catch (e) {
      // Cache save error - ignore
    }
  }
  
  /// Get when cache was last updated
  static Future<DateTime?> getLastUpdated() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_lastUpdatedKey);
      if (raw == null) return null;
      return DateTime.tryParse(raw);
    } catch (e) {
      return null;
    }
  }
  
  /// Clear the cache (for debugging)
  static Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cacheKey);
    await prefs.remove(_lastUpdatedKey);
  }
}