import 'package:flutter/services.dart';

class TextReader {
  static Future<String> loadAsset(String assetPath) async {
    try {
      return await rootBundle.loadString(assetPath);
    } catch (e) {
      throw Exception('Failed to load asset: $assetPath - Error: $e');
    }
  }

  static Future<Map<String, String>> loadAssets(
    Map<String, String> assetPaths,
  ) async {
    try {
      final Map<String, String> result = {};
      final futures = <Future<void>>[];

      for (final entry in assetPaths.entries) {
        futures.add(
          loadAsset(entry.value).then((content) {
            result[entry.key] = content;
          }),
        );
      }

      await Future.wait(futures);
      return result;
    } catch (e) {
      throw Exception('Failed to load multiple assets - Error: $e');
    }
  }
}
