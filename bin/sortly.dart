import 'package:args/args.dart';

import 'src/app/app.dart';

const String version = '0.0.1';

final app = App();

ArgParser buildParser() {
  return ArgParser()
    ..addOption('path', abbr: 'p', callback: app.setPath)
    ..addCommand('read')
    ..addCommand('rename');
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
      }
    }
  } on FormatException catch (e) {
    // Print usage information if an invalid argument was provided.
    print(e.message);
    print('');
  }
}
