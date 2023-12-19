import 'package:sortly/module/file/build_date_name.dart';
import 'package:test/test.dart';

void main() {
  group('buildDateName', () {
    test('should build string from date', () async {
      expect(
          buildDateName(DateTime(2023, 07, 23)).substring(0, 10), '2023-07-23');
    });
  });
}
