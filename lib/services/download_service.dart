// lib/services/download_service.dart

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

class DownloadService {
  Future<void> downloadVideo(
      String tiktokUrl, void Function(AsyncValue<String>) updateState) async {
    updateState(const AsyncValue.loading());
    try {
      print('DEBUG: Starting video download for URL: $tiktokUrl');

      // Step 1: Call RapidAPI to get video details
      print('DEBUG: Calling RapidAPI to fetch video details...');
      final apiResponse = await http.get(
        Uri.parse(
          'https://tiktok-download-without-watermark.p.rapidapi.com/analysis?url=$tiktokUrl&hd=1',
        ),
        headers: {
          'X-RapidAPI-Key':
              '1b5bb662eamsh11110cdca03efa6p132479jsn76102bf53807', // Replace with your key
          'X-RapidAPI-Host': 'tiktok-download-without-watermark.p.rapidapi.com',
        },
      );

      print('DEBUG: API Response Status Code: ${apiResponse.statusCode}');
      print('DEBUG: API Response Body: ${apiResponse.body}');

      if (apiResponse.statusCode != 200) {
        throw Exception('Failed to fetch video URL: ${apiResponse.statusCode}');
      }

      final data = (apiResponse.body.isNotEmpty)
          ? jsonDecode(apiResponse.body)['data'] as Map<String, dynamic>
          : {};
      final videoUrl = data['hdplay'] ?? data['play'];

      print('DEBUG: Extracted video URL: $videoUrl');

      if (videoUrl == null) {
        throw Exception('No downloadable video URL found');
      }

      // Step 2: Request appropriate storage permission based on Android version
      if (Platform.isAndroid) {
        print('DEBUG: Requesting storage permissions for Android...');
        bool hasPermission = await _requestStoragePermission();
        if (!hasPermission) {
          throw Exception(
              'Storage permission denied. Please grant storage permission in app settings.');
        }
        print('DEBUG: Storage permission granted');
      }

      // Step 3: Get download path
      print('DEBUG: Getting download directory...');
      Directory? dir;
      if (Platform.isAndroid) {
        // Try to get the Downloads directory first, fall back to external storage
        try {
          dir = Directory('/storage/emulated/0/Download');
          if (!await dir.exists()) {
            print(
                'DEBUG: Downloads directory not accessible, using external storage');
            dir = await getExternalStorageDirectory();
          }
        } catch (e) {
          print('DEBUG: Error accessing Downloads directory: $e');
          dir = await getExternalStorageDirectory();
        }
      } else {
        dir = await getApplicationDocumentsDirectory();
      }

      if (dir == null) {
        throw Exception('Could not access storage directory');
      }

      print('DEBUG: Download directory: ${dir.path}');

      final fileName =
          'tiktok_video_${DateTime.now().millisecondsSinceEpoch}.mp4';
      final filePath = '${dir.path}/$fileName';
      print('DEBUG: Full file path: $filePath');

      // Step 4: Download the video
      print('DEBUG: Starting video download from: $videoUrl');
      final videoResponse = await http.get(Uri.parse(videoUrl));

      print(
          'DEBUG: Video download response status: ${videoResponse.statusCode}');
      print('DEBUG: Video file size: ${videoResponse.bodyBytes.length} bytes');

      if (videoResponse.statusCode == 200) {
        final file = File(filePath);
        await file.writeAsBytes(videoResponse.bodyBytes);
        print('DEBUG: Video saved successfully at: $filePath');

        // Verify file was created
        if (await file.exists()) {
          final fileSize = await file.length();
          print('DEBUG: Verified file exists with size: $fileSize bytes');
          updateState(AsyncValue.data(filePath));
        } else {
          throw Exception('File was not created successfully');
        }
      } else {
        throw Exception(
            'Failed to download video: ${videoResponse.statusCode}');
      }
    } catch (e, stackTrace) {
      print('DEBUG: Error occurred: $e');
      print('DEBUG: Stack trace: $stackTrace');
      updateState(AsyncValue.error(e, stackTrace));
    }
  }

  Future<bool> _requestStoragePermission() async {
    try {
      // Get Android version
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      final sdkInt = androidInfo.version.sdkInt;

      print('DEBUG: Android SDK version: $sdkInt');

      if (sdkInt >= 33) {
        // Android 13+ (API level 33+) - Use scoped storage
        print('DEBUG: Using scoped storage for Android 13+');

        // For Android 13+, we don't need WRITE_EXTERNAL_STORAGE permission
        // We can write to app-specific external storage without permission
        // Or request MANAGE_EXTERNAL_STORAGE for broader access

        final manageStorageStatus =
            await Permission.manageExternalStorage.status;
        print('DEBUG: Manage external storage status: $manageStorageStatus');

        if (manageStorageStatus.isGranted) {
          return true;
        }

        // Request manage external storage permission
        final result = await Permission.manageExternalStorage.request();
        print('DEBUG: Manage external storage request result: $result');

        if (result.isGranted) {
          return true;
        }

        // If manage external storage is denied, we can still use app-specific directory
        print('DEBUG: Using app-specific external storage directory');
        return true;
      } else if (sdkInt >= 30) {
        // Android 11-12 (API level 30-32)
        print('DEBUG: Using storage permissions for Android 11-12');

        final storageStatus = await Permission.storage.status;
        print('DEBUG: Storage permission status: $storageStatus');

        if (storageStatus.isGranted) {
          return true;
        }

        final result = await Permission.storage.request();
        print('DEBUG: Storage permission request result: $result');
        return result.isGranted;
      } else {
        // Android 10 and below
        print(
            'DEBUG: Using legacy storage permissions for Android 10 and below');

        final storageStatus = await Permission.storage.status;
        print('DEBUG: Storage permission status: $storageStatus');

        if (storageStatus.isGranted) {
          return true;
        }

        final result = await Permission.storage.request();
        print('DEBUG: Storage permission request result: $result');
        return result.isGranted;
      }
    } catch (e) {
      print('DEBUG: Error requesting storage permission: $e');
      return false;
    }
  }
}
