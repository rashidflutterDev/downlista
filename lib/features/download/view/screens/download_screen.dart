import 'package:downlista/core/utils/responsive_utils.dart';
import 'package:downlista/features/download/download_state.dart';
import 'package:downlista/features/download/viewmodel/download_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/download_progress_widget.dart';

class DownloadScreen extends ConsumerStatefulWidget {
  const DownloadScreen({super.key});

  @override
  ConsumerState<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends ConsumerState<DownloadScreen> {
  final TextEditingController _urlController = TextEditingController();

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  void _startDownload() {
    final viewModel = ref.read(downloadViewModelProvider.notifier);
    viewModel.downloadVideo(_urlController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final downloadState = ref.watch(downloadViewModelProvider);

    final double paddingScale = ResponsiveUtils.paddingScale(context);
    final double fontScale = ResponsiveUtils.fontScale(context);
    final double spacingScale = ResponsiveUtils.spacingScale(context);
    final double componentScale = ResponsiveUtils.componentScale(context);

    ref.listen<AsyncValue<DownloadProgress>>(downloadViewModelProvider,
        (previous, next) {
      next.when(
        data: (_) {},
        loading: () {},
        error: (error, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                error.toString(),
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 14 * fontScale,
                ),
              ),
              backgroundColor: colorScheme.error,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8 * componentScale),
              ),
            ),
          );
        },
      );
    });

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'TikTok Downloader',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 20 * fontScale,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20 * paddingScale),
            child: Column(
              children: [
                // Header Section
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(24 * paddingScale),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(16 * componentScale),
                    boxShadow: [
                      BoxShadow(
                        color: theme.shadowColor.withOpacity(0.05),
                        blurRadius: 10 * componentScale,
                        offset: Offset(0, 2 * componentScale),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.video_library_outlined,
                        size: 48 * componentScale,
                        color: colorScheme.primary,
                      ),
                      SizedBox(height: 12 * spacingScale),
                      Text(
                        'Download TikTok Videos',
                        style: GoogleFonts.poppins(
                          fontSize: 20 * fontScale,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: 8 * spacingScale),
                      Text(
                        'Paste your TikTok URL below to download',
                        style: GoogleFonts.poppins(
                          fontSize: 14 * fontScale,
                          color: colorScheme.onSurface.withOpacity(0.6),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24 * spacingScale),
                // URL Input Section
                Container(
                  padding: EdgeInsets.all(20 * paddingScale),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(16 * componentScale),
                    boxShadow: [
                      BoxShadow(
                        color: theme.shadowColor.withOpacity(0.05),
                        blurRadius: 10 * componentScale,
                        offset: Offset(0, 2 * componentScale),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _urlController,
                        decoration: InputDecoration(
                          labelText: 'TikTok URL',
                          hintText:
                              'https://www.tiktok.com/@username/video/...',
                          prefixIcon:
                              Icon(Icons.link, color: colorScheme.primary),
                          border: theme.inputDecorationTheme.border,
                          enabledBorder:
                              theme.inputDecorationTheme.enabledBorder,
                          focusedBorder:
                              theme.inputDecorationTheme.focusedBorder,
                          filled: true,
                          fillColor:
                              isDark ? Colors.grey[800] : Colors.grey[100],
                        ),
                        maxLines: 2,
                        enabled: downloadState.value?.status !=
                                DownloadStatus.downloading &&
                            downloadState.value?.status !=
                                DownloadStatus.fetching,
                      ),
                      SizedBox(height: 16 * spacingScale),
                      SizedBox(
                        width: double.infinity,
                        height: 54 * componentScale,
                        child: ElevatedButton(
                          onPressed: downloadState.value?.status ==
                                      DownloadStatus.idle ||
                                  downloadState.value?.status ==
                                      DownloadStatus.completed ||
                                  downloadState.value?.status ==
                                      DownloadStatus.error
                              ? _startDownload
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.primary,
                            foregroundColor: colorScheme.onPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(12 * componentScale),
                            ),
                          ),
                          child: downloadState.when(
                            data: (progress) => _buildButtonContent(
                                progress, fontScale, componentScale),
                            loading: () => _buildButtonContent(
                                const DownloadProgress(
                                  status: DownloadStatus.fetching,
                                  message: 'Fetching...',
                                ),
                                fontScale,
                                componentScale),
                            error: (_, __) => _buildButtonContent(
                                const DownloadProgress(
                                  status: DownloadStatus.error,
                                  message: 'Error',
                                ),
                                fontScale,
                                componentScale),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24 * spacingScale),
                // Progress Section
                DownloadProgressWidget(
                  downloadState: downloadState,
                  urlController: _urlController,
                ),
                SizedBox(height: 16 * spacingScale),
                // Footer Note
                Text(
                  'Please ensure you have permission to download the video and comply with TikTok\'s terms of service.',
                  style: GoogleFonts.poppins(
                    fontSize: 12 * fontScale,
                    color: colorScheme.onSurface.withOpacity(0.5),
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButtonContent(
      DownloadProgress progress, double fontScale, double componentScale) {
    switch (progress.status) {
      case DownloadStatus.fetching:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 20 * componentScale,
              height: 20 * componentScale,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            SizedBox(width: 12 * componentScale),
            Text(
              'Fetching...',
              style: GoogleFonts.poppins(fontSize: 16 * fontScale),
            ),
          ],
        );
      case DownloadStatus.downloading:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 20 * componentScale,
              height: 20 * componentScale,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                value: progress.progress,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            SizedBox(width: 12 * componentScale),
            Text(
              'Downloading...',
              style: GoogleFonts.poppins(fontSize: 16 * fontScale),
            ),
          ],
        );
      default:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.download, size: 20 * componentScale),
            SizedBox(width: 8 * componentScale),
            Text(
              'Download Video',
              style: GoogleFonts.poppins(fontSize: 16 * fontScale),
            ),
          ],
        );
    }
  }
}
