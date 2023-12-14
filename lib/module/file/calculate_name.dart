import 'dart:io';

import 'package:sortly/entities/meta_data.dart';
import 'package:sortly/module/file/build_date_name.dart';
import 'package:sortly/module/file/get_file_name.dart';

String calculateName(
    {required File file, required MetaData? metaData, bool enabled = false}) {
  final name = getFileName(file);
  if (!enabled || metaData?.date == null) return name;

  return buildDateName(metaData!.date!) + name.substring(name.lastIndexOf('.'));
}
