import 'package:exif/exif.dart' as exif;

DateTime? getCreatedDateTime(Map<String, exif.IfdTag> exifData) {
  final dateTimeExp = RegExp(
      r'^(?<year>\d{4}):(?<month>\d{2}):(?<day>\d{2}) (?<time>\d{2}:\d{2}:\d{2})');

  final imageTimeOffsetString = (exifData['EXIF OffsetTime'] ??
      exifData['EXIF OffsetTimeOriginal'] ??
      exifData['EXIF OffsetTimeDigitized'] ??
      '');
  final imageDateTimeString = (exifData['Image DateTime'] ??
      exifData['EXIF DateTimeOriginal'] ??
      exifData['EXIF DateTimeDigitized']);

  if (imageDateTimeString == null ||
      imageDateTimeString.toString().trim().isEmpty) {
    return null;
  }

  final match = dateTimeExp.firstMatch(imageDateTimeString.printable);

  final year = match?.group(1) ?? DateTime.now().year.toString();
  final month =
      match?.group(2) ?? DateTime.now().month.toString().padLeft(2, '0');
  final day = match?.group(3) ?? DateTime.now().day.toString().padLeft(2, '0');
  final time = match?.group(4) ?? '00:00:00';

  return DateTime.parse('$year-$month-${day}T$time$imageTimeOffsetString');
}
