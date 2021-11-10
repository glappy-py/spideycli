import 'package:filepicker_windows/filepicker_windows.dart';
import 'package:http/http.dart' as http;
import 'package:archive/archive.dart';
import 'dart:io';

void main() {
  final directory = DirectoryPicker();
  final result = directory.getDirectory();
  if (result != null) {
    print("Installing SpideyCLI on your system");
    Process.run("setx",
        ["/M", "path", Platform.environment['PATH']! + result.path + ";"]);
    install(result.path);
  }
}

void install(String path) {
  print(
      "please do not close the terminal until installing is finished, or you may have to reinstall spideyCLI");
  print("");
  print("downloading packages...");
  http
      .get(Uri.https("www.github.com",
          "/glappy-py/SpideyCLI-BUILD-/releases/download/installer/package.zip"))
      .then((response) async {
    print("installng SpideyCLI...");
    await File(Platform.resolvedExecutable.split("spideycli installer.exe")[0] +
            '\\package.zip')
        .writeAsBytes(response.bodyBytes);
    // Read the Zip file from disk.
    final bytes = File(
            Platform.resolvedExecutable.split("spideycli installer.exe")[0] +
                '\\package.zip')
        .readAsBytesSync();

    // Decode the Zip file
    final archive = ZipDecoder().decodeBytes(bytes);

    // Extract the contents of the Zip archive to disk.
    for (final file in archive) {
      final filename = file.name;
      if (file.isFile) {
        final data = file.content as List<int>;
        File(path + '/' + filename)
          ..createSync(recursive: true)
          ..writeAsBytesSync(data);
      } else {
        Directory(path + '/' + filename).create(recursive: true);
      }
    }
    File(Platform.resolvedExecutable.split("spideycli installer.exe")[0] +
            '/package.zip')
        .deleteSync();
    print("installation was successfull");
    sleep(Duration(seconds: 3));
  });
}
