import 'package:go_router/go_router.dart';
import 'data/models/game_mode.dart';
import 'data/repositories/firebase_sync_repository.dart';
import 'data/repositories/word_repository.dart';
import 'features/achievements/screens/achievements_screen.dart';
import 'features/game/screens/game_screen.dart';
import 'features/home/screens/home_screen.dart';
import 'features/leaderboard/screens/leaderboard_screen.dart';
import 'features/settings/screens/settings_screen.dart';
import 'features/stats/screens/stats_screen.dart';

GoRouter buildRouter({
  required WordRepository wordRepository,
  required FirebaseSyncRepository? firebaseSyncRepository,
}) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
      GoRoute(
        path: '/game/daily',
        builder: (context, state) => const GameScreen(mode: GameMode.daily),
      ),
      GoRoute(
        path: '/game/practice',
        builder: (context, state) => const GameScreen(mode: GameMode.practice),
      ),
      GoRoute(
        path: '/game/timed',
        builder: (context, state) => const GameScreen(mode: GameMode.timed),
      ),
      GoRoute(path: '/stats', builder: (context, state) => const StatsScreen()),
      GoRoute(path: '/achievements', builder: (context, state) => const AchievementsScreen()),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/leaderboard',
        builder: (context, state) => LeaderboardScreen(
          wordRepository: wordRepository,
          firebaseSyncRepository: firebaseSyncRepository,
        ),
      ),
    ],
  );
}
