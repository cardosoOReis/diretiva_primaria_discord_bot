import 'dart:io';

import 'app_strings.dart' as app_strings;

void flush(List<String> directives) {
  final file = File(app_strings.fileName);
  file.writeAsStringSync(directives.join('\n'));
}
