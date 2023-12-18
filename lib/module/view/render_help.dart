import 'dart:io';

void renderHelp() {
  stdout.writeAll([
    'This is Sortly \n',
    '\n',
    'Options:\n',
    '-p, --path         Path to the photos root path\n',
    '-r, --rename       Rename your photos to parsed data like 2018_12_23_****.jpg\n',
    '-s, --sort         Sort photos from original destination to path by depth like ./2018/12/23/\n',
    '-d, --depth        Depth of sorting year, month, day\n',
    'You can change all of these options after run by pres ctrl+[r/s/d]\n',
    '\n',
    'developed by John Cuba\n'
  ]);
}
