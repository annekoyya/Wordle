import 'package:flutter/material.dart';
import '../../../data/repositories/firebase_sync_repository.dart';
import '../../../data/repositories/word_repository.dart';

/// Requires Firebase to be configured (see README "Firebase Setup").
/// If it isn't, this screen shows a friendly message instead of crashing.
class LeaderboardScreen extends StatelessWidget {
  final WordRepository wordRepository;
  final FirebaseSyncRepository? firebaseSyncRepository;

  const LeaderboardScreen({
    super.key,
    required this.wordRepository,
    required this.firebaseSyncRepository,
  });

  @override
  Widget build(BuildContext context) {
    final sync = firebaseSyncRepository;
    final puzzleNumber = wordRepository.dailyPuzzleNumber();

    return Scaffold(
      appBar: AppBar(title: Text('Leaderboard · Day $puzzleNumber')),
      body: sync == null
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Leaderboard requires Firebase to be configured.\n'
                  'Run `flutterfire configure` and rebuild the app.',
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : StreamBuilder<List<Map<String, dynamic>>>(
              stream: sync.watchLeaderboard(puzzleNumber),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final entries = snapshot.data!;
                if (entries.isEmpty) {
                  return const Center(child: Text('No entries yet today. Be the first!'));
                }
                return ListView.builder(
                  itemCount: entries.length,
                  itemBuilder: (context, index) {
                    final e = entries[index];
                    return ListTile(
                      leading: CircleAvatar(child: Text('${index + 1}')),
                      title: Text(e['displayName'] ?? 'Anonymous'),
                      trailing: Text('${e['guessCount']} guesses · ${e['timeTakenSeconds']}s'),
                    );
                  },
                );
              },
            ),
    );
  }
}
