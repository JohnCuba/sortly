import 'dart:io';

Future<void> operateFile(
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
