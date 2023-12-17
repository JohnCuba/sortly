import 'package:args/args.dart';

import 'src/app/app.dart';
import 'package:sortly/config/sort_depth.dart';

const String version = '0.1.0';

final app = App();

ArgParser buildParser() {
  return ArgParser()
    ..addOption('path',
        abbr: 'p', callback: app.setPath, mandatory: false, defaultsTo: './')
    ..addOption('rename',
        abbr: 'r', callback: app.toggleRename, mandatory: false)
    ..addOption('sort', abbr: 's', callback: app.toggleSort, mandatory: false)
    ..addOption('dept',
        abbr: 'd',
        mandatory: false,
        defaultsTo: SortDepth.year.name,
        allowed: SortDepth.values.map((e) => e.name),
        callback: app.setDepth);
}

void main(List<String> arguments) {
  final ArgParser argParser = buildParser();

  try {
    argParser.parse(arguments);

    app.init();
  } on FormatException catch (e) {
    // Print usage information if an invalid argument was provided.
    print(e.message);
    print('');
  }
}
