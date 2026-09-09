import 'package:flutter/foundation.dart';
import '../../data/repositories/settings_repository.dart';
import 'app_colors.dart';

class SettingsController extends ChangeNotifier {
  final SettingsRepository _repository;

  bool isDarkMode = true;
  bool useColorblindPalette = false;
  bool hardMode = false;

  SettingsController(this._repository);

  TileColors get tileColors => useColorblindPalette ? TileColors.colorblind : TileColors.classic;

  Future<void> load() async {
    final values = await _repository.load();
    isDarkMode = values['darkMode']!;
    useColorblindPalette = values['colorblind']!;
    hardMode = values['hardMode']!;
    notifyListeners();
  }

  Future<void> toggleDarkMode(bool value) async {
    isDarkMode = value;
    notifyListeners();
    await _repository.setDarkMode(value);
  }

  Future<void> toggleColorblind(bool value) async {
    useColorblindPalette = value;
    notifyListeners();
    await _repository.setColorblind(value);
  }

  Future<void> toggleHardMode(bool value) async {
    hardMode = value;
    notifyListeners();
    await _repository.setHardMode(value);
  }
}
