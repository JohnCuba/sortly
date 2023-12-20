import 'dart:io';

import 'package:sortly/entities/meta_data.dart';
import 'package:sortly/module/file/calculate_name.dart';
import 'package:test/test.dart';

void main() {
  group('calculateName', () {
    test('should return changed file name from meta data', () {
      final testFile = File('random_file_name.jpeg');
      final testMetaData = MetaData(date: DateTime(2018, 10, 14));
      final expectedName = '2018-10-14';

      expect(
          calculateName(file: testFile, metaData: testMetaData, enabled: true)
              // Remove uid path of name
              .substring(0, 10),
          expectedName);
    });

    test('should return original file name when meta data not provided', () {
      final testFile = File('random_file_name.jpeg');
      final expectedName = 'random_file_name.jpeg';

      expect(calculateName(file: testFile, metaData: null, enabled: true),
          expectedName);
    });

    test('should return original file name when flag enabled - off', () {
      final testFile = File('random_file_name.jpeg');
      final testMetaData = MetaData(date: DateTime(2018, 10, 14));
      final expectedName = 'random_file_name.jpeg';

      expect(
          calculateName(file: testFile, metaData: testMetaData, enabled: false),
          expectedName);
    });

    test(
        'should return original file name when flag enabled - off & metadata not provided',
        () {
      final testFile = File('random_file_name.jpeg');
      final expectedName = 'random_file_name.jpeg';

      expect(calculateName(file: testFile, metaData: null, enabled: false),
          expectedName);
    });
  });
}
