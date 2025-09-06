// lib/services/download_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import '../models/download_state.dart';

class DownloadService {
  Future<void> downloadVideo(
      String tiktokUrl, void Function(DownloadProgress) updateProgress) async {
    try {
      // Step 1: Start fetching video details
      updateProgress(const DownloadProgress(
        status: DownloadStatus.fetching,
        message: 'Fetching video details...',
        progress: 0.1,
      ));

      print('DEBUG: Starting video download for URL: $tiktokUrl');

      // Call RapidAPI to get video details
      final apiResponse = await http.get(
        Uri.parse(
          'https://tiktok-download-without-watermark.p.rapidapi.com/analysis?url=$tiktokUrl&hd=1',
        ),
        headers: {
          'X-RapidAPI-Key':
              // '1b5bb662eamsh11110cdca03efa6p132479jsn76102bf53807',
              '58f8f3a841msha06b9e7847738bep132d02jsn2779b2309bc2',
          'X-RapidAPI-Host': 'tiktok-download-without-watermark.p.rapidapi.com',
        },
      );

      if (apiResponse.statusCode != 200) {
        throw Exception('Failed to fetch video details');
      }

      updateProgress(const DownloadProgress(
        status: DownloadStatus.fetching,
        message: 'Processing video URL...',
        progress: 0.3,
      ));

      final data = (apiResponse.body.isNotEmpty)
          ? jsonDecode(apiResponse.body)['data'] as Map<String, dynamic>
          : {};
      final videoUrl = data['hdplay'] ?? data['play'];

      if (videoUrl == null) {
        throw Exception('No downloadable video found');
      }

      // Step 2: Request storage permission
      updateProgress(const DownloadProgress(
        status: DownloadStatus.fetching,
        message: 'Checking permissions...',
        progress: 0.4,
      ));

      if (Platform.isAndroid) {
        bool hasPermission = await _requestStoragePermission();
        if (!hasPermission) {
          throw Exception('Storage permission required');
        }
      }

      // Step 3: Get download path
      updateProgress(const DownloadProgress(
        status: DownloadStatus.fetching,
        message: 'Preparing download...',
        progress: 0.5,
      ));

      Directory? dir;
      if (Platform.isAndroid) {
        try {
          dir = Directory('/storage/emulated/0/Download');
          if (!await dir.exists()) {
            dir = await getExternalStorageDirectory();
          }
        } catch (e) {
          dir = await getExternalStorageDirectory();
        }
      } else {
        dir = await getApplicationDocumentsDirectory();
      }

      if (dir == null) {
        throw Exception('Could not access storage');
      }

      final fileName =
          'tiktok_video_${DateTime.now().millisecondsSinceEpoch}.mp4';
      final filePath = '${dir.path}/$fileName';

      // Step 4: Download with progress tracking
      updateProgress(const DownloadProgress(
        status: DownloadStatus.downloading,
        message: 'Downloading video...',
        progress: 0.6,
      ));

      final request = http.Request('GET', Uri.parse(videoUrl));
      final response = await http.Client().send(request);

      if (response.statusCode == 200) {
        final file = File(filePath);
        final sink = file.openWrite();

        int downloaded = 0;
        final total = response.contentLength ?? 0;

        await for (var chunk in response.stream) {
          sink.add(chunk);
          downloaded += chunk.length;

          if (total > 0) {
            final progress = 0.6 + (downloaded / total) * 0.3;
            updateProgress(DownloadProgress(
              status: DownloadStatus.downloading,
              message:
                  'Downloading... ${((downloaded / total) * 100).toInt()}%',
              progress: progress,
            ));
          }
        }

        await sink.close();

        // Verify file creation
        if (await file.exists()) {
          updateProgress(DownloadProgress(
            status: DownloadStatus.completed,
            message: 'Download completed!',
            progress: 1.0,
            filePath: filePath,
          ));
        } else {
          throw Exception('Failed to save file');
        }
      } else {
        throw Exception('Download failed');
      }
    } catch (e) {
      print('DEBUG: Error occurred: $e');
      updateProgress(DownloadProgress(
        status: DownloadStatus.error,
        message: 'Download failed',
        error: e.toString(),
      ));
    }
  }

  Future<bool> _requestStoragePermission() async {
    try {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      final sdkInt = androidInfo.version.sdkInt;

      if (sdkInt >= 33) {
        final manageStorageStatus =
            await Permission.manageExternalStorage.status;
        if (manageStorageStatus.isGranted) {
          return true;
        }
        final result = await Permission.manageExternalStorage.request();
        if (result.isGranted) {
          return true;
        }
        return true; // Use app-specific directory
      } else {
        final storageStatus = await Permission.storage.status;
        if (storageStatus.isGranted) {
          return true;
        }
        final result = await Permission.storage.request();
        return result.isGranted;
      }
    } catch (e) {
      print('DEBUG: Error requesting storage permission: $e');
      return false;
    }
  }
}
