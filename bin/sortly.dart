import 'package:args/args.dart';

import 'src/app/app.dart';
import 'src/config/sort_depth.dart';

const String version = '0.0.1';

final app = App();

ArgParser buildParser() {
  return ArgParser()
    ..addOption('path', abbr: 'p', callback: app.setPath, defaultsTo: './')
    ..addCommand('read')
    ..addCommand('rename')
    ..addCommand(
        'sort',
        ArgParser()
          ..addOption('dept',
              abbr: 'd',
              allowed: SortDepth.values.map((e) => e.name),
              callback: app.setDepth));
}

void main(List<String> arguments) {
  final ArgParser argParser = buildParser();

  try {
    final ArgResults results = argParser.parse(arguments);

    if (results.command != null) {
      switch (results.command!.name) {
        case 'read':
          {
            app.doRead();
            return;
          }
        case 'rename':
          {
            app.doRename();
            return;
          }
        case 'sort':
          {
            app.doSort();
            return;
          }
      }
    }
  } on FormatException catch (e) {
    // Print usage information if an invalid argument was provided.
    print(e.message);
    print('');
  }
}
