import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/guess_result.dart';

/// Persists the in-progress DAILY game so closing the app mid-game
/// doesn't lose progress. Practice/Timed modes are intentionally not
/// persisted (they're meant to be replayable/ephemeral).
class GameStateRepository {
  static const _key = 'daily_game_state';

  Future<void> save({
    required String dateKey,
    required List<GuessResult> guesses,
    required String status,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final data = {
      'date': dateKey,
      'status': status,
      'guesses': guesses.map((g) => g.toJson()).toList(),
    };
    await prefs.setString(_key, jsonEncode(data));
  }

  /// Returns null if there's no saved state or if it's from a previous day.
  Future<Map<String, dynamic>?> load(String dateKey) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return null;
    final data = jsonDecode(raw) as Map<String, dynamic>;
    if (data['date'] != dateKey) return null;
    return data;
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
