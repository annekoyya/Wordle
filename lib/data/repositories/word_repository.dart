import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'remote_word_list_service.dart';

class WordRepository {
  final RemoteWordListService _remoteService;

  List<String> _answers = [];
  List<String> _validGuesses = [];
  Map<String, String>? _definitions;

  WordRepository({RemoteWordListService? remoteService})
      : _remoteService = remoteService ?? RemoteWordListService();

  Future<void> load() async {
    // 1. Always load the bundled lists first - guarantees the game works
    //    fully offline even on a fresh install with no network access.
    final answersJson = await rootBundle.loadString('assets/words/answers.json');
    final guessesJson = await rootBundle.loadString('assets/words/valid_guesses.json');
    final defsJson = await rootBundle.loadString('assets/words/definitions.json');

    _answers = List<String>.from(jsonDecode(answersJson));
    _validGuesses = List<String>.from(jsonDecode(guessesJson));
    _definitions = Map<String, String>.from(jsonDecode(defsJson));

    // 2. Layer in any previously-downloaded word list from disk, if present.
    //    This is what lets the vocabulary grow past the bundled JSON.
    final cached = await _remoteService.loadCached();
    if (cached != null && cached.isNotEmpty) {
      final merged = {..._answers, ...cached}.toList();
      _answers = merged;
      _validGuesses = {..._validGuesses, ...cached}.toList();
    }
  }

  /// Call from Settings ("Update Word List" button). Downloads a fresh
  /// batch of words and merges them in immediately - no app restart needed.
  Future<bool> refreshWordListFromRemote() async {
    final success = await _remoteService.refresh();
    if (success) {
      final cached = await _remoteService.loadCached();
      if (cached != null) {
        _answers = {..._answers, ...cached}.toList();
        _validGuesses = {..._validGuesses, ...cached}.toList();
      }
    }
    return success;
  }

  Future<DateTime?> wordListLastUpdated() => _remoteService.lastUpdated();

  bool isValidGuess(String word) =>
      _validGuesses.contains(word.toUpperCase()) || _answers.contains(word.toUpperCase());

  String? definitionFor(String word) => _definitions?[word.toUpperCase()];

  String dailyWord({DateTime? forDate}) {
    final date = forDate ?? DateTime.now();
    final epoch = DateTime(2024, 1, 1);
    final daysSinceEpoch = date.difference(epoch).inDays;
    final index = daysSinceEpoch % _answers.length;
    return _answers[index];
  }

  int dailyPuzzleNumber({DateTime? forDate}) {
    final date = forDate ?? DateTime.now();
    final epoch = DateTime(2024, 1, 1);
    return date.difference(epoch).inDays;
  }

  String randomWord() {
    final index = DateTime.now().microsecondsSinceEpoch % _answers.length;
    return _answers[index];
  }

  int get wordCount => _answers.length;
}