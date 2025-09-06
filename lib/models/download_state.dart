// lib/models/download_state.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum DownloadStatus {
  idle,
  fetching,
  downloading,
  completed,
  error,
}

class DownloadProgress {
  final DownloadStatus status;
  final String message;
  final double progress;
  final String? filePath;
  final String? error;

  const DownloadProgress({
    required this.status,
    required this.message,
    this.progress = 0.0,
    this.filePath,
    this.error,
  });

  DownloadProgress copyWith({
    DownloadStatus? status,
    String? message,
    double? progress,
    String? filePath,
    String? error,
  }) {
    return DownloadProgress(
      status: status ?? this.status,
      message: message ?? this.message,
      progress: progress ?? this.progress,
      filePath: filePath ?? this.filePath,
      error: error ?? this.error,
    );
  }
}

class DownloadState extends StateNotifier<DownloadProgress> {
  DownloadState()
      : super(const DownloadProgress(
          status: DownloadStatus.idle,
          message: 'Ready to download',
        ));

  void updateProgress(DownloadProgress progress) {
    state = progress;
  }

  void reset() {
    state = const DownloadProgress(
      status: DownloadStatus.idle,
      message: 'Ready to download',
    );
  }
}
