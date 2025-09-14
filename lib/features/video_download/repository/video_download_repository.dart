import 'dart:convert';
import 'package:downlista/core/models/app_failure.dart';
import 'package:flutter/foundation.dart';
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
  final String _apiKey = '1b5bb662eamsh11110cdca03efa6p132479jsn76102bf53807';
  final String _apiHost = 'snap-video3.p.rapidapi.com';

  VideoDownloadRepository({required http.Client httpClient})
      : _httpClient = httpClient;

  Future<Either<AppFailure, String>> downloadVideo(String videoUrl) async {
    try {
      final response = await _httpClient.post(
        Uri.parse(
          'https://snap-video3.p.rapidapi.com/download',
        ),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'X-RapidAPI-Key':
              '1b5bb662eamsh11110cdca03efa6p132479jsn76102bf53807',
          'X-RapidAPI-Host': 'snap-video3.p.rapidapi.com',
        },
        body: {'url': videoUrl},
      );

      if (response.statusCode == 200) {
        debugPrint('Video downloaded successfully ${response.body}');
        return right(response.body);
      } else {
        debugPrint(
            'Failed POST: ${response.statusCode} | body=${response.body}');
        return left(AppFailure(
            'Failed to download video: ${response.statusCode} ${response.reasonPhrase}'));
      }
    } catch (e, st) {
      debugPrint('Error downloading video: $e\n$st');
      return left(AppFailure(e.toString()));
    }
  }
}
