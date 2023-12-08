import '../module/file/file.module.dart';

class App {
  String rootPath = '';

  setPath(String? path) {
    if (path == null) {
      throw 'Path was not provided';
    }

    rootPath = path;
  }

  doRead() async {
    final filesList = await FileModule.getFilesList(rootPath);
    print('Finded files: ${filesList.length}');
    filesList
        .map((e) => e.path.substring(e.path.lastIndexOf('/') + 1))
        .forEach(print);
  }
}
