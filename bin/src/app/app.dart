import '../module/file/file.module.dart';
import '../module/meta_data/meta_data.module.dart';

class App {
  String rootPath = '';

  setPath(String? path) {
    if (path == null) {
      throw 'Path was not provided';
    }

    rootPath = path;
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
}
