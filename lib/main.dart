import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'app_router.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/settings_controller.dart';
import 'data/repositories/firebase_sync_repository.dart';
import 'data/repositories/settings_repository.dart';
import 'data/repositories/word_repository.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final wordRepository = WordRepository();
  await wordRepository.load();

  final settingsController = SettingsController(SettingsRepository());
  await settingsController.load();

  // Firebase is optional: if it hasn't been configured yet (see
  // firebase_options.dart / README "Firebase Setup"), the app still
  // runs fully offline with local persistence only.
  FirebaseSyncRepository? firebaseSyncRepository;
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    firebaseSyncRepository = FirebaseSyncRepository();
    await firebaseSyncRepository.signInAnonymously();
  } catch (e) {
    debugPrint('Firebase not configured - running in local-only mode. ($e)');
    firebaseSyncRepository = null;
  }

  runApp(WordlexApp(
    wordRepository: wordRepository,
    settingsController: settingsController,
    firebaseSyncRepository: firebaseSyncRepository,
  ));
}

class WordlexApp extends StatelessWidget {
  final WordRepository wordRepository;
  final SettingsController settingsController;
  final FirebaseSyncRepository? firebaseSyncRepository;

  const WordlexApp({
    super.key,
    required this.wordRepository,
    required this.settingsController,
    required this.firebaseSyncRepository,
  });

  @override
  Widget build(BuildContext context) {
    final router = buildRouter(
      wordRepository: wordRepository,
      firebaseSyncRepository: firebaseSyncRepository,
    );

    return MultiProvider(
      providers: [
        Provider<WordRepository>.value(value: wordRepository),
        Provider<FirebaseSyncRepository?>.value(value: firebaseSyncRepository),
        ChangeNotifierProvider<SettingsController>.value(value: settingsController),
      ],
      child: Consumer<SettingsController>(
        builder: (context, settings, _) {
          return MaterialApp.router(
            title: 'WordleX',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            routerConfig: router,
          );
        },
      ),
    );
  }
}
