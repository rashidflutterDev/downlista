import 'package:downlista/core/models/app_failure.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';

final httpProvider = Provider<http.Client>((ref) {
  return http.Client();
});

final videoDownloadRepositoryProvider =
    Provider<VideoDownloadRepository>((ref) {
  return VideoDownloadRepository(httpClient: ref.watch(httpProvider));
});

class VideoDownloadRepository {
  final http.Client _httpClient;
  final String _apiKey = '1b5bb662eamsh110cdca03efa6p132479jsn76102bf53807';
  final String _apiHost = 'rapidapi.com';

  VideoDownloadRepository({required http.Client httpClient})
      : _httpClient = httpClient;

  Future<Either<AppFailure, String>> downloadVideo(String url) async {
    try {
      final response = await _httpClient.post(
        Uri.parse('https://$_apiHost/post_download'),
        headers: {
          'X-RapidAPI-Key': _apiKey,
          'X-RapidAPI-Host': _apiHost,
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'url': url,
        },
      );

      if (response.statusCode == 200) {
        return right(response.body);
      } else {
        return left(
            AppFailure('Failed to download video: ${response.statusCode}'));
      }
    } catch (e) {
      return left(AppFailure(e.toString()));
    }
  }
}
