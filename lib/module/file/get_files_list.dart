import 'dart:io';

import 'check_format_is_supported.dart';

Future<List<File>> getFilesList(String path) {
  final dir = Directory(path);
  return dir
      .list(recursive: true, followLinks: false)
      .where(checkFormatIdSupported)
      .map((event) => File(event.path))
      .toList();
}
