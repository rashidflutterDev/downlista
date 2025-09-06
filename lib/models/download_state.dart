// lib/models/download_state.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

class DownloadState extends StateNotifier<AsyncValue<String>> {
  DownloadState() : super(const AsyncValue.data(''));

  void updateState(AsyncValue<String> newState) {
    state = newState;
  }
}
