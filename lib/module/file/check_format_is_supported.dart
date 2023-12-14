import 'dart:io';
import 'package:sortly/config/supported_formats.dart';

import 'check_file_is_visible.dart';

bool checkFormatIdSupported(FileSystemEntity event) {
  return SupportedFormats.values.any((format) =>
      checkFileIsVisible(event.path) && event.path.endsWith(format.name));
}
