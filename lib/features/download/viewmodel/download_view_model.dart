import 'package:downlista/features/download/download_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import '../repository/download_repository.dart';

final downloadViewModelProvider =
    StateNotifierProvider<DownloadViewModel, AsyncValue<DownloadProgress>>(
        (ref) {
  final repository = ref.watch(downloadRepositoryProvider);
  return DownloadViewModel(ref: ref, repository: repository);
});

final downloadRepositoryProvider = Provider<DownloadRepository>((ref) {
  return DownloadRepository();
});

class DownloadViewModel extends StateNotifier<AsyncValue<DownloadProgress>> {
  final Ref _ref;
  final DownloadRepository _repository;

  DownloadViewModel({
    required Ref ref,
    required DownloadRepository repository,
  })  : _ref = ref,
        _repository = repository,
        super(const AsyncValue.data(
          DownloadProgress(
            status: DownloadStatus.idle,
            message: 'Ready to download',
          ),
        ));

  void downloadVideo(String url) async {
    if (url.isEmpty) {
      state = AsyncValue.error('Please enter a TikTok URL', StackTrace.current);
      return;
    }

    if (!_isValidTikTokUrl(url)) {
      state = AsyncValue.error(
          'Please enter a valid TikTok URL', StackTrace.current);
      return;
    }

    state = const AsyncValue.loading();

    final res = await _repository.downloadVideo(url, (progress) {
      state = AsyncValue.data(progress);
    });

    res.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) => state = AsyncValue.data(r),
    );
  }

  void reset() {
    state = const AsyncValue.data(
      DownloadProgress(
        status: DownloadStatus.idle,
        message: 'Ready to download',
      ),
    );
  }

  bool _isValidTikTokUrl(String url) {
    final tiktokRegex = RegExp(
      r'^https?://(www\.)?(tiktok\.com|vm\.tiktok\.com)',
      caseSensitive: false,
    );
    return tiktokRegex.hasMatch(url);
  }
}
