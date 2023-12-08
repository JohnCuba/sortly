import 'dart:io';

import '../../config/supported_formats.dart';

class FileModule {
  static bool _checkIsVisible(String path) {
    final fileNameStartIndex = path.lastIndexOf('/');
    return path[fileNameStartIndex + 1] != '.';
  }

  static bool _checkSupportedFormat(FileSystemEntity event) {
    return SupportedFormats.values.any((format) =>
        _checkIsVisible(event.path) && event.path.endsWith(format.name));
  }

  static Future<List<File>> getFilesList(String path) {
    final dir = Directory(path);
    return dir
        .list(recursive: true, followLinks: false)
        .where(_checkSupportedFormat)
        .map((event) => File(event.path))
        .toList();
  }
}
