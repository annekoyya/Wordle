import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/settings_controller.dart';
import '../../../data/repositories/word_repository.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsController>();
    final wordRepo = context.watch<WordRepository>();
    
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          // Dark Mode
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: settings.isDarkMode,
            onChanged: settings.toggleDarkMode,
          ),
          
          // Colorblind Mode
          SwitchListTile(
            title: const Text('Colorblind-Friendly Palette'),
            subtitle: const Text('Uses orange/blue instead of green/yellow'),
            value: settings.useColorblindPalette,
            onChanged: settings.toggleColorblind,
          ),
          
          // Hard Mode
          SwitchListTile(
            title: const Text('Hard Mode'),
            subtitle: const Text('Revealed hints must be used in later guesses'),
            value: settings.hardMode,
            onChanged: settings.toggleHardMode,
          ),
          
          const Divider(height: 32),
          
          // 📦 NEW: Word List Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Word List',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  '${wordRepo.wordCount} words available offline',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () async {
                    // Show loading snackbar
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Row(
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 12),
                            Text('Downloading more words...'),
                          ],
                        ),
                        duration: Duration(seconds: 30),
                      ),
                    );
                    
                    final success = await wordRepo.refreshWordListFromRemote();
                    
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            success 
                                ? '✅ Word list updated! ${wordRepo.wordCount} words now available'
                                : '❌ Could not update - check your internet connection',
                          ),
                          backgroundColor: success ? Colors.green : Colors.red,
                          duration: const Duration(seconds: 3),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.cloud_download),
                  label: const Text('Download More Words'),
                ),
                const SizedBox(height: 8),
                Text(
                  'Download additional 5-letter words from the internet. '
                  'Once downloaded, you can play offline with more words.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          
          const Divider(height: 32),
          
          // Last updated info
          FutureBuilder<DateTime?>(
            future: wordRepo.wordListLastUpdated(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                final updated = snapshot.data!;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'Last updated: ${_formatDate(updated)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[500],
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
  
  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}