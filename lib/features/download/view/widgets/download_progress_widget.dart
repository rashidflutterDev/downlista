import 'package:downlista/core/utils/responsive_utils.dart';
import 'package:downlista/features/download/download_state.dart';
import 'package:downlista/features/download/viewmodel/download_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class DownloadProgressWidget extends ConsumerWidget {
  final AsyncValue<DownloadProgress> downloadState;
  final TextEditingController urlController;

  const DownloadProgressWidget({
    super.key,
    required this.downloadState,
    required this.urlController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final double fontScale = ResponsiveUtils.fontScale(context);
    final double spacingScale = ResponsiveUtils.spacingScale(context);
    final double componentScale = ResponsiveUtils.componentScale(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24 * spacingScale),
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
      child: downloadState.when(
        data: (progress) => _buildProgressContent(progress, ref, fontScale,
            spacingScale, componentScale, colorScheme),
        loading: () => _buildProgressContent(
            const DownloadProgress(
              status: DownloadStatus.fetching,
              message: 'Fetching...',
            ),
            ref,
            fontScale,
            spacingScale,
            componentScale,
            colorScheme),
        error: (_, __) => _buildProgressContent(
            const DownloadProgress(
              status: DownloadStatus.error,
              message: 'Error',
              error: 'An error occurred',
            ),
            ref,
            fontScale,
            spacingScale,
            componentScale,
            colorScheme),
      ),
    );
  }

  Widget _buildProgressContent(
    DownloadProgress progress,
    WidgetRef ref,
    double fontScale,
    double spacingScale,
    double componentScale,
    ColorScheme colorScheme,
  ) {
    switch (progress.status) {
      case DownloadStatus.idle:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_download_outlined,
              size: 64 * componentScale,
              color: colorScheme.onSurface.withOpacity(0.4),
            ),
            SizedBox(height: 16 * spacingScale),
            Text(
              'Ready to Download',
              style: GoogleFonts.poppins(
                fontSize: 18 * fontScale,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            SizedBox(height: 8 * spacingScale),
            Text(
              'Enter a TikTok URL above and tap download',
              style: GoogleFonts.poppins(
                fontSize: 14 * fontScale,
                color: colorScheme.onSurface.withOpacity(0.5),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        );
      case DownloadStatus.fetching:
      case DownloadStatus.downloading:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.download,
              size: 64 * componentScale,
              color: colorScheme.primary,
            ),
            SizedBox(height: 20 * spacingScale),
            Text(
              progress.message,
              style: GoogleFonts.poppins(
                fontSize: 16 * fontScale,
                fontWeight: FontWeight.w600,
                color: colorScheme.primary,
              ),
            ),
            SizedBox(height: 12 * spacingScale),
          ],
        );
      case DownloadStatus.completed:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(16 * spacingScale),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle,
                size: 64 * componentScale,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 20 * spacingScale),
            Text(
              'Download Complete!',
              style: GoogleFonts.poppins(
                fontSize: 20 * fontScale,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 12 * spacingScale),
            Text(
              'Video saved successfully',
              style: GoogleFonts.poppins(
                fontSize: 14 * fontScale,
                color: colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            if (progress.filePath != null) ...[
              SizedBox(height: 8 * spacingScale),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 12 * spacingScale,
                  vertical: 8 * spacingScale,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.onSurface.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8 * componentScale),
                ),
                child: Text(
                  _getFileName(progress.filePath!),
                  style: GoogleFonts.poppins(
                    fontSize: 12 * fontScale,
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
            SizedBox(height: 24 * spacingScale),
            ElevatedButton.icon(
              onPressed: () {
                ref.read(downloadViewModelProvider.notifier).reset();
                urlController.clear();
              },
              icon: Icon(Icons.refresh, size: 20 * componentScale),
              label: Text(
                'Download Another',
                style: GoogleFonts.poppins(fontSize: 16 * fontScale),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8 * componentScale),
                ),
              ),
            ),
          ],
        );
      case DownloadStatus.error:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(16 * spacingScale),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                size: 64 * componentScale,
                color: colorScheme.error,
              ),
            ),
            SizedBox(height: 20 * spacingScale),
            Text(
              'Download Failed',
              style: GoogleFonts.poppins(
                fontSize: 20 * fontScale,
                fontWeight: FontWeight.bold,
                color: colorScheme.error,
              ),
            ),
            SizedBox(height: 12 * spacingScale),
            Container(
              padding: EdgeInsets.all(12 * spacingScale),
              decoration: BoxDecoration(
                color: colorScheme.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8 * componentScale),
                border: Border.all(color: colorScheme.error.withOpacity(0.2)),
              ),
              child: Text(
                progress.error ?? 'Unknown error occurred',
                style: GoogleFonts.poppins(
                  fontSize: 14 * fontScale,
                  color: colorScheme.error,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 24 * spacingScale),
            ElevatedButton.icon(
              onPressed: () {
                ref.read(downloadViewModelProvider.notifier).reset();
              },
              icon: Icon(Icons.refresh, size: 20 * componentScale),
              label: Text(
                'Try Again',
                style: GoogleFonts.poppins(fontSize: 16 * fontScale),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.error,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8 * componentScale),
                ),
              ),
            ),
          ],
        );
    }
  }

  String _getFileName(String path) {
    return path.split('/').last;
  }
}
