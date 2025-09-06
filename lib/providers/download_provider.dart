// lib/providers/download_provider.dart

import 'package:downlista/models/download_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/download_service.dart';

final downloadProvider =
    StateNotifierProvider<DownloadState, AsyncValue<String>>((ref) {
  return DownloadState()..updateState(const AsyncValue.data(''));
});

final downloadServiceProvider = Provider<DownloadService>((ref) {
  return DownloadService();
});
