import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('WordleX'), centerTitle: true),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('WordleX', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              const Text('Guess the word. Beat the streak.', style: TextStyle(fontSize: 14)),
              const SizedBox(height: 40),
              _MenuButton(label: 'Daily Puzzle', icon: Icons.today, onTap: () => context.go('/game/daily')),
              const SizedBox(height: 12),
              _MenuButton(label: 'Practice Mode', icon: Icons.refresh, onTap: () => context.go('/game/practice')),
              const SizedBox(height: 12),
              _MenuButton(label: 'Timed Mode', icon: Icons.timer, onTap: () => context.go('/game/timed')),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(icon: const Icon(Icons.bar_chart), onPressed: () => context.go('/stats'), tooltip: 'Stats'),
                  IconButton(icon: const Icon(Icons.emoji_events), onPressed: () => context.go('/achievements'), tooltip: 'Achievements'),
                  IconButton(icon: const Icon(Icons.leaderboard), onPressed: () => context.go('/leaderboard'), tooltip: 'Leaderboard'),
                  IconButton(icon: const Icon(Icons.settings), onPressed: () => context.go('/settings'), tooltip: 'Settings'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _MenuButton({required this.label, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240,
      child: ElevatedButton.icon(
        icon: Icon(icon),
        label: Text(label),
        onPressed: onTap,
        style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
      ),
    );
  }
}
