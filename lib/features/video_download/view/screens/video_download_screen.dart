import 'package:downlista/core/utils/responsive_utils.dart';
import 'package:downlista/features/video_download/viewmodel/video_download_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class VideoDownloadScreen extends ConsumerStatefulWidget {
  const VideoDownloadScreen({super.key});

  @override
  ConsumerState<VideoDownloadScreen> createState() =>
      _VideoDownloadScreenState();
}

class _VideoDownloadScreenState extends ConsumerState<VideoDownloadScreen> {
  final TextEditingController _urlController = TextEditingController();

  void _downloadVideo() {
    if (_urlController.text.isNotEmpty) {
      ref
          .read(videoDownloadViewModelProvider.notifier)
          .downloadVideo(_urlController.text.trim());
    }
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final onSurfaceColor = theme.colorScheme.onSurface;
    final double paddingScaleValue = ResponsiveUtils.paddingScale(context);
    final double fontScaleValue = ResponsiveUtils.fontScale(context);
    final double spacingScaleValue = ResponsiveUtils.spacingScale(context);

    return Scaffold(
      appBar:
          AppBar(title: Text('Video Downloader', style: GoogleFonts.poppins())),
      body: Padding(
        padding: EdgeInsets.all(16.0 * paddingScaleValue),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter Video URL',
              style: GoogleFonts.poppins(
                fontSize: 18 * fontScaleValue,
                fontWeight: FontWeight.bold,
                color: onSurfaceColor,
              ),
            ),
            SizedBox(height: 12 * spacingScaleValue),
            TextFormField(
              controller: _urlController,
              decoration: InputDecoration(
                hintText: 'Paste video URL here...',
                border: const OutlineInputBorder(),
                prefixIcon: Icon(Icons.link, color: primaryColor),
              ),
            ),
            SizedBox(height: 20 * spacingScaleValue),
            ElevatedButton(
              onPressed: _downloadVideo,
              child: Text('Download', style: GoogleFonts.poppins()),
            ),
            SizedBox(height: 20 * spacingScaleValue),
            ref.watch(videoDownloadViewModelProvider).when(
                  data: (model) {
                    if (model?.downloadPath != null) {
                      return Text(
                        'Download ready at: ${model!.downloadPath}',
                        style: GoogleFonts.poppins(color: onSurfaceColor),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                  loading: () => const CircularProgressIndicator(),
                  error: (error, st) {
                    debugPrint(error.toString());
                    return
                        // =>
                        Text('Error: $error',
                            style: GoogleFonts.poppins(color: Colors.red));
                  },
                ),
          ],
        ),
      ),
    );
  }
}
