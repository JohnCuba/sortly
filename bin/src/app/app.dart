import 'dart:io';

import 'package:dart_console/dart_console.dart';
import 'package:path/path.dart' as p;
import 'dart:math' as m;

import '../config/sort_depth.dart';
import '../module/file/file.module.dart';
import '../module/meta_data/meta_data.module.dart';

class App {
  final console = Console();

  String _rootPath = '';
  SortDepth _depth = SortDepth.year;
  bool _doRename = false;
  bool _doSort = false;
  bool _preview = false;

  List<File> filesList = [];
  int offset = 0;
  int get filesPerPageCount => console.windowHeight - 6;

  void setPath(String? path) {
    if (path == null) {
      throw 'Path was not provided';
    }
    if (path.endsWith('/')) {
      _rootPath = p.canonicalize(path.substring(0, path.length - 1));
    } else {
      _rootPath = p.canonicalize(path);
    }
  }

  void setDepth(String? selectedDepth) {
    if (selectedDepth == null) {
      throw 'Depth was not provided';
    }

    _depth = SortDepth.values.firstWhere((e) => e.name == selectedDepth);
  }

  void _renderHeader(int filesCount) {
    console.writeLine(
        'In $_rootPath files finded: $filesCount', TextAlignment.center);
    console.writeLine('');
  }

  void _renderPlaceholderEmpty() {
    console.setForegroundColor(ConsoleColor.red);
    console.writeLine('Files not found', TextAlignment.center);
    console.showCursor();
  }

  Future<void> _renderEntity(File file, int index, int filesCount) async {
    final MetaData? fileMetaData =
        _preview ? await MetaDataModule.getFileMetaData(file) : null;
    final calculatedPath = FileModule.calculatePath(
        enabled: _doSort,
        rootPath: _rootPath,
        file: file,
        metaData: fileMetaData,
        depth: _depth);
    final calculatedName = FileModule.calculateName(
        enabled: _doRename, file: file, metaData: fileMetaData);

    final previewSeparator = _preview ? ' -> ' : '';
    final previewPath = _preview ? '$calculatedPath/$calculatedName' : '';
    final mainString =
        '${index + 1}) ${file.path}$previewSeparator$previewPath';
    final scrollBar = ((index + 1) - offset) ==
            m.max(1, (filesPerPageCount * offset / filesCount)).round()
        ? '|'
        : ' ';
    final offsetString =
        ' ' * (console.windowWidth - mainString.length - scrollBar.length - 1);
    console.writeLine('$mainString$offsetString $scrollBar');
  }

  void _renderFooter() {
    console.writeLine('to scroll - use arrows', TextAlignment.center);
    console.write(' ' * ((console.windowWidth - 51) / 2).round());
    console.write(_preview ? '[x]' : '[ ]');
    console.write(' Preview');
    console.write('    ');
    console.write(_doRename ? '[x]' : '[ ]');
    console.write(' Rename');
    console.write('    ');
    console.write(_doSort ? '[x]' : '[ ]');
    console.write('Sort');
    console.write('    ');
    console.write('Sort depth: ${_depth.name}');
  }

  Future<void> fetchFilesList() async {
    filesList = await FileModule.getFilesList(_rootPath);
  }

  Future<void> _listenControl() async {
    final pressedKey = console.readKey();

    switch (pressedKey.controlChar) {
      case (ControlCharacter.arrowDown):
        offset = m.min(offset + 1,
            filesList.length - m.min(filesPerPageCount, filesList.length));
      case (ControlCharacter.arrowUp):
        offset = m.max(offset - 1, 0);
      case (ControlCharacter.arrowRight):
        offset = m.min(offset + filesPerPageCount,
            filesList.length - m.min(filesPerPageCount, filesList.length));
      case (ControlCharacter.arrowLeft):
        offset = m.max(offset - filesPerPageCount, 0);
      case (ControlCharacter.ctrlR):
        _doRename = !_doRename;
      case (ControlCharacter.ctrlS):
        _doSort = !_doSort;
      case (ControlCharacter.ctrlP):
        _preview = !_preview;
      case (ControlCharacter.ctrlO):
        await operate(filesList);
        await fetchFilesList();
        break;
      case (ControlCharacter.ctrlD):
        final currentIndex = SortDepth.values.indexOf(_depth);
        _depth = SortDepth.values[
            currentIndex + 1 < SortDepth.values.length ? currentIndex + 1 : 0];
      default:
        console.showCursor();
        return;
    }
  }

  void init() async {
    await fetchFilesList();
    console.hideCursor();

    final int filesPerPageCount = console.windowHeight - 6;

    if (filesList.isEmpty) {
      _renderPlaceholderEmpty();
      return;
    }

    while (offset <= filesList.length) {
      console.clearScreen();
      _renderHeader(filesList.length);

      for (int index = 0 + offset;
          index < m.min(filesPerPageCount + offset, filesList.length);
          index++) {
        await _renderEntity(filesList[index], index, filesList.length);
      }

      _renderFooter();

      await _listenControl();
    }
  }

  Future<void> operate(List<File> filesList) async {
    for (final (_, file) in filesList.indexed) {
      final MetaData fileMetaData = await MetaDataModule.getFileMetaData(file);
      final calculatedPath = FileModule.calculatePath(
          enabled: _doSort,
          rootPath: _rootPath,
          file: file,
          metaData: fileMetaData,
          depth: _depth);
      final calculatedName = FileModule.calculateName(
          enabled: _doRename, file: file, metaData: fileMetaData);
      await FileModule.operateFile(
          file, _rootPath, calculatedPath, calculatedName);
    }
  }
}
