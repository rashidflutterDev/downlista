// lib/providers/download_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/download_state.dart';
import '../services/download_service.dart';

final downloadProvider =
    StateNotifierProvider<DownloadState, DownloadProgress>((ref) {
  return DownloadState();
});

final downloadServiceProvider = Provider<DownloadService>((ref) {
  return DownloadService();
});
