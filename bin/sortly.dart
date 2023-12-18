import 'package:args/args.dart';
import 'package:sortly/module/view/render_help.dart';

import 'src/app/app.dart';
import 'package:sortly/config/sort_depth.dart';

const String version = '0.1.0';

final app = App();

ArgParser buildParser() {
  return ArgParser()
    ..addCommand('help')
    ..addOption('path',
        abbr: 'p', callback: app.setPath, mandatory: false, defaultsTo: './')
    ..addFlag('rename', abbr: 'r', callback: app.toggleRename)
    ..addFlag('sort', abbr: 's', callback: app.toggleSort)
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
    final parsedArgs = argParser.parse(arguments);

    switch (parsedArgs.command?.name) {
      case 'help':
        renderHelp();
      default:
        app.init();
    }
  } on FormatException catch (e) {
    // Print usage information if an invalid argument was provided.
    print(e.message);
    print('');
  }
}
