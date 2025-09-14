import 'package:downlista/features/video_download/models/video_download_model.dart';
import 'package:downlista/features/video_download/repository/video_download_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final videoDownloadViewModelProvider = StateNotifierProvider<
    VideoDownloadViewModel, AsyncValue<VideoDownloadModel?>>((ref) {
  return VideoDownloadViewModel(ref: ref);
});

class VideoDownloadViewModel
    extends StateNotifier<AsyncValue<VideoDownloadModel?>> {
  final Ref _ref;

  VideoDownloadViewModel({required Ref ref})
      : _ref = ref,
        super(const AsyncValue.data(null));

  Future<void> downloadVideo(String url) async {
    state = const AsyncValue.loading();
    final result =
        await _ref.read(videoDownloadRepositoryProvider).downloadVideo(url);
    result.fold(
      (failure) =>
          state = AsyncValue.error(failure.message, StackTrace.current),
      (downloadPath) {
        final updatedModel = VideoDownloadModel(
          url: url,
          isDownloading: false,
          downloadPath: downloadPath,
        ).copyWith();
        state = AsyncValue.data(updatedModel);
      },
    );
  }
}
