// lib/features/download/download_state.dart
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
