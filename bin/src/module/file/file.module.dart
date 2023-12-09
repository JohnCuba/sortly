import 'dart:io';
import 'package:path/path.dart' as p;

import '../../config/sort_depth.dart';
import '../../config/supported_formats.dart';
import '../meta_data/meta_data.module.dart';

class FileModule {
  static bool _checkIsVisible(String path) {
    final fileNameStartIndex = path.lastIndexOf('/');
    return path[fileNameStartIndex + 1] != '.';
  }

  static bool _checkSupportedFormat(FileSystemEntity event) {
    return SupportedFormats.values.any((format) =>
        _checkIsVisible(event.path) && event.path.endsWith(format.name));
  }

  static String getFileName(File file) {
    return file.path.substring(file.path.lastIndexOf('/'));
  }

  static Future<List<File>> getFilesList(String path) {
    final dir = Directory(path);
    return dir
        .list(recursive: true, followLinks: false)
        .where(_checkSupportedFormat)
        .map((event) => File(event.path))
        .toList();
  }

  static Future<void> renameFile(File file, String newName) async {
    final path = file.path.substring(0, file.path.lastIndexOf('/') + 1);
    final fileName = newName + file.path.substring(file.path.lastIndexOf('.'));
    await file.rename(path + fileName);
  }

  static Future<void> sortFile(
      String rootPath, File file, MetaData metaData, SortDepth depth) async {
    if (metaData.date == null) return;

    final path = p.join(
        rootPath,
        metaData.date!.year.toString(),
        depth == SortDepth.month ? metaData.date!.month.toString() : null,
        depth == SortDepth.day ? metaData.date!.day.toString() : null);
    final pathDirectory = Directory(path);
    await pathDirectory.create();
    file.rename(pathDirectory.path + getFileName(file));
  }
}
