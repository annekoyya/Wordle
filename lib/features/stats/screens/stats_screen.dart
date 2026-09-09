import 'package:flutter/material.dart';
import '../../../data/models/stats.dart';
import '../../../data/repositories/stats_repository.dart';
import '../widgets/distribution_bar.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  final _repository = StatsRepository();
  Stats? _stats;

  @override
  void initState() {
    super.initState();
    _repository.load().then((s) => setState(() => _stats = s));
  }

  @override
  Widget build(BuildContext context) {
    final stats = _stats;
    return Scaffold(
      appBar: AppBar(title: const Text('Statistics')),
      body: stats == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _StatBox(label: 'Played', value: '${stats.gamesPlayed}'),
                      _StatBox(label: 'Win %', value: '${(stats.winRate * 100).round()}'),
                      _StatBox(label: 'Streak', value: '${stats.currentStreak}'),
                      _StatBox(label: 'Max Streak', value: '${stats.maxStreak}'),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text('Guess Distribution', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ...List.generate(6, (i) {
                    final maxCount = stats.guessDistribution.isEmpty
                        ? 0
                        : stats.guessDistribution.reduce((a, b) => a > b ? a : b);
                    return DistributionBar(
                      guessNumber: i + 1,
                      count: stats.guessDistribution[i],
                      maxCount: maxCount,
                    );
                  }),
                ],
              ),
            ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  const _StatBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
