import 'package:sortly/module/file/check_file_is_visible.dart';
import 'package:test/test.dart';

void main() {
  group('checkFileIsVisible', () {
    test('should pass regular file with externsion', () async {
      expect(checkFileIsVisible('./some/file.ext'), true);
    });

    test('should fire false on .DS_Store', () async {
      expect(checkFileIsVisible('./some/.DS_Store'), false);
    });
  });
}
