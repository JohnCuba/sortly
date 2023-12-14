bool checkFileIsVisible(String path) {
  final fileNameStartIndex = path.lastIndexOf('/');
  return path[fileNameStartIndex + 1] != '.';
}
