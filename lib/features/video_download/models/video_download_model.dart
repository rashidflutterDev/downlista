import 'package:fpdart/fpdart.dart';

class VideoDownloadModel {
  final String url;
  final bool isDownloading;
  final String? downloadPath;

  VideoDownloadModel({
    required this.url,
    this.isDownloading = false,
    this.downloadPath,
  });

  VideoDownloadModel copyWith({
    String? url,
    bool? isDownloading,
    String? downloadPath,
  }) {
    return VideoDownloadModel(
      url: url ?? this.url,
      isDownloading: isDownloading ?? this.isDownloading,
      downloadPath: downloadPath ?? this.downloadPath,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'url': url,
      'isDownloading': isDownloading,
      'downloadPath': downloadPath,
    };
  }

  factory VideoDownloadModel.fromMap(Map<String, dynamic> map) {
    return VideoDownloadModel(
      url: map['url'] ?? '',
      isDownloading: map['isDownloading'] ?? false,
      downloadPath: map['downloadPath'],
    );
  }
}
