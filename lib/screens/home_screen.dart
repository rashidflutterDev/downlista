// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/download_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncValue = ref.watch(downloadProvider);
    final TextEditingController urlController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('TikTok Video Downloader'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: urlController,
                      decoration: const InputDecoration(
                        labelText: 'Enter TikTok Video URL',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.link),
                        hintText: 'Enter tiktok video url',
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: asyncValue.isLoading
                            ? null
                            : () {
                                final url = urlController.text.trim();
                                // print('DEBUG: User entered URL: $url');

                                if (url.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('Please enter a TikTok URL'),
                                      backgroundColor: Colors.orange,
                                    ),
                                  );
                                  return;
                                }

                                if (!_isValidTikTokUrl(url)) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Please enter a valid TikTok URL'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return;
                                }

                                final downloadService =
                                    ref.read(downloadServiceProvider);
                                downloadService.downloadVideo(url, (state) {
                                  ref
                                      .read(downloadProvider.notifier)
                                      .updateState(state);
                                });
                              },
                        icon: asyncValue.isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : const Icon(Icons.download),
                        label: Text(
                          asyncValue.isLoading
                              ? 'Downloading...'
                              : 'Download Video',
                          style: const TextStyle(fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade700,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Icon(
                      asyncValue.when(
                        data: (path) => path.isEmpty
                            ? Icons.cloud_download_outlined
                            : Icons.check_circle_outline,
                        loading: () => Icons.hourglass_empty,
                        error: (_, __) => Icons.error_outline,
                      ),
                      size: 48,
                      color: asyncValue.when(
                        data: (path) =>
                            path.isEmpty ? Colors.grey : Colors.green,
                        loading: () => Colors.blue,
                        error: (_, __) => Colors.red,
                      ),
                    ),
                    const SizedBox(height: 12),
                    asyncValue.when(
                      data: (path) {
                        if (path.isEmpty) {
                          return const Text(
                            'Ready to download!',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          );
                        } else {
                          return Column(
                            children: [
                              const Text(
                                'Video downloaded successfully!',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Saved to: ${_getFileName(path)}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              TextButton.icon(
                                onPressed: () {
                                  // Reset state for next download
                                  ref
                                      .read(downloadProvider.notifier)
                                      .updateState(const AsyncValue.data(''));
                                  urlController.clear();
                                },
                                icon: const Icon(Icons.refresh),
                                label: const Text('Download Another'),
                              ),
                            ],
                          );
                        }
                      },
                      loading: () => const Column(
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 12),
                          Text(
                            'Downloading video...',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                      error: (error, stack) => Column(
                        children: [
                          Text(
                            'Error: ${error.toString()}',
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          TextButton.icon(
                            onPressed: () {
                              // Reset state to try again
                              ref
                                  .read(downloadProvider.notifier)
                                  .updateState(const AsyncValue.data(''));
                            },
                            icon: const Icon(Icons.refresh),
                            label: const Text('Try Again'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Note: Make sure you have permission to download the video and comply with TikTok\'s terms of service.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  bool _isValidTikTokUrl(String url) {
    return true;
    // Basic TikTok URL validation
    // final tiktokRegex = RegExp(
    //   r'^https?://(www\.)?(tiktok\.com|vm\.tiktok\.com)',
    //   caseSensitive: false,
    // );
    // return tiktokRegex.hasMatch(url);
  }

  String _getFileName(String path) {
    return path.split('/').last;
  }
}
