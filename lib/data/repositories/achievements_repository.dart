import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Stores just the set of unlocked achievement IDs; the full Achievement
/// objects (title/description) live in the static kAllAchievements list.
class AchievementsRepository {
  static const _key = 'unlocked_achievements';

  Future<Set<String>> loadUnlockedIds() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return {};
    return Set<String>.from(jsonDecode(raw));
  }

  Future<void> saveUnlockedIds(Set<String> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(ids.toList()));
  }
}
