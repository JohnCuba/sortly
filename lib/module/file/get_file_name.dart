import 'dart:io';

String getFileName(File file) {
  return file.path.substring(file.path.lastIndexOf('/') + 1);
}
