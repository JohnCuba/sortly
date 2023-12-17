import 'dart:io';

import 'package:exif/exif.dart' as exif;
import 'package:sortly/entities/meta_data.dart';
import 'get_created_date.dart';

Future<MetaData> getFileMetaData(File file) async {
  final exifData = await exif.readExifFromFile(file);

  return MetaData(date: getCreatedDateTime(exifData));
}
