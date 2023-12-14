import 'dart:io';
import 'package:path/path.dart' as p;

import 'package:sortly/config/sort_depth.dart';
import 'package:sortly/entities/meta_data.dart';

String calculatePath(
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
      depth == SortDepth.month || depth == SortDepth.day
          ? metaData.date!.month.toString()
          : null,
      depth == SortDepth.day ? metaData.date!.day.toString() : null);
  final pathDirectory = Directory(path);
  return pathDirectory.path;
}
