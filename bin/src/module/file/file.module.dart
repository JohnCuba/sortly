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

  static String _buildFileNameFromDate(DateTime dateTime) {
    return '${dateTime.toIso8601String().substring(0, 10)}_${DateTime.now().millisecondsSinceEpoch.toString().substring(6)}';
  }

  static String _getFileName(File file) {
    return file.path.substring(file.path.lastIndexOf('/') + 1);
  }

  static Future<List<File>> getFilesList(String path) {
    final dir = Directory(path);
    return dir
        .list(recursive: true, followLinks: false)
        .where(_checkSupportedFormat)
        .map((event) => File(event.path))
        .toList();
  }

  static Future<void> operateFile(
      File file, String rootPath, String newPath, String newName) async {
    if (file.path == '$newPath/$newName') return;

    final List<String> neededDirs = newPath
        .replaceAll(rootPath, '')
        .split('/')
        .where((path) => path.isNotEmpty)
        .toList();

    if (neededDirs.isNotEmpty) {
      for (final (index, _) in neededDirs.indexed) {
        final currPath = neededDirs.sublist(0, index + 1).join('/');
        if (!(await Directory('$rootPath/$currPath').exists())) {
          await Directory('$rootPath/$currPath').create();
        }
      }
    }

    await file.rename('$newPath/$newName');
  }

  static String calculatePath(
      {required String rootPath,
      required File file,
      MetaData? metaData,
      required SortDepth depth,
      bool enabled = false}) {
    if (!enabled || metaData?.date == null) {
      return file.path.substring(0, file.path.lastIndexOf('/'));
    }

    final path = p.join(
        rootPath,
        metaData!.date!.year.toString(),
        depth == SortDepth.month ? metaData.date!.month.toString() : null,
        depth == SortDepth.day ? metaData.date!.day.toString() : null);
    final pathDirectory = Directory(path);
    return pathDirectory.path;
  }

  static String calculateName(
      {required File file, required MetaData? metaData, bool enabled = false}) {
    final name = _getFileName(file);
    if (!enabled || metaData?.date == null) return name;

    return _buildFileNameFromDate(metaData!.date!) +
        name.substring(name.lastIndexOf('.'));
  }
}
