// convert_words.dart
// Run with: dart convert_words.dart

import 'dart:convert';
import 'dart:io';

void main() {
  // Read the current file
  final inputFile = File('assets/words/large_word_list.json');
  final content = inputFile.readAsStringSync();
  
  // Split by lines, filter empty lines, convert to uppercase
  final words = content
      .split('\n')
      .where((line) => line.trim().isNotEmpty)
      .map((word) => word.trim().toUpperCase())
      .toList();
  
  // Filter to only 5-letter words
  final fiveLetterWords = words
      .where((word) => word.length == 5 && RegExp(r'^[A-Z]+$').hasMatch(word))
      .toList();
  
  // Write as proper JSON
  final outputFile = File('assets/words/large_word_list_fixed.json');
  outputFile.writeAsStringSync(jsonEncode(fiveLetterWords));
  
  print('Converted ${fiveLetterWords.length} 5-letter words!');
  print('First 10 words: ${fiveLetterWords.take(10).join(', ')}');
}