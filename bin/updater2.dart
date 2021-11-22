import 'dart:io';
import 'package:archive/archive.dart';

void main(List<String> args) {
  final bytes = File(Platform.resolvedExecutable.split("updater2.exe")[0] +
          '\\package.zip')
      .readAsBytesSync();

  // Decode the Zip file
  final archive = ZipDecoder().decodeBytes(bytes);
  for (final file in archive) {
    if (file.name == "updater.exe") {
      print("updater mil gaya franks");
      final data = file.content as List<int>;
      File(Platform.resolvedExecutable.split("updater2.exe")[0] +
          '/' +
          file.name)
        ..createSync(recursive: true)
        ..writeAsBytesSync(data);
    }
  }
  File(Platform.resolvedExecutable.split("updater2.exe")[0] + '/package.zip')
      .deleteSync();
  sleep(Duration(seconds: 5));
}
