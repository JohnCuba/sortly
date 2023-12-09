import '../config/sort_depth.dart';
import '../module/file/file.module.dart';
import '../module/meta_data/meta_data.module.dart';

class App {
  String rootPath = '';
  SortDepth depth = SortDepth.year;

  setPath(String? path) {
    if (path == null) {
      throw 'Path was not provided';
    }
    if (path.endsWith('/')) {
      rootPath = path.substring(0, path.length - 1);
    } else {
      rootPath = path;
    }
  }

  void setDepth(String? selectedDepth) {
    if (selectedDepth == null) {
      throw 'Depth was not provided';
    }

    depth = SortDepth.values.firstWhere((e) => e.name == selectedDepth);
  }

  String _buildFileNameFromDate(DateTime dateTime) {
    return '${dateTime.toIso8601String().substring(0, 10)}_${DateTime.now().millisecondsSinceEpoch.toString().substring(6)}';
  }

  doRead() async {
    final filesList = await FileModule.getFilesList(rootPath);
    print('Finded files: ${filesList.length}');
    filesList
        .map((e) => e.path.substring(e.path.lastIndexOf('/') + 1))
        .forEach(print);
  }

  doRename() async {
    final filesList = await FileModule.getFilesList(rootPath);
    filesList.forEach((element) async {
      final fileMetaData = await MetaDataModule.getFileMetaData(element);
      if (fileMetaData.date != null) {
        await FileModule.renameFile(
            element, _buildFileNameFromDate(fileMetaData.date!));
      }
    });
  }

  doSort() async {
    final filesList = await FileModule.getFilesList(rootPath);
    filesList.forEach((file) async {
      final fileMetaData = await MetaDataModule.getFileMetaData(file);
      FileModule.sortFile(rootPath, file, fileMetaData, depth);
    });
  }
}
