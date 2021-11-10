import 'package:http/http.dart' as http;
import 'package:archive/archive.dart';
import 'dart:io';
import 'dart:convert';

void main(List<String> args) async {
  http
      .get(Uri.https("raw.githubusercontent.com",
          "/glappy-py/SpideyCLI-BUILD-/main/version.txt"))
      .then((response) async {
    String latestVersion = response.body;
    // Use this for development test
    String currentVersion =
        File("version.txt").readAsStringSync().split("\n")[0];
    if (latestVersion != currentVersion) {
      print("update available : " + latestVersion);
      update();
    } else {
      print(
          "you are current using the latest version of SpideyCLI. Do you want to force update (y/n) : ");
      if (stdin.readLineSync()?[0] == "y") {
        update();
      }
    }
  });
}

void update() {
  // String updateorigin =
  //     await File("updateorigin.txt").readAsStringSync().split("\n")[0];
  String updateorigin = File(
          Platform.resolvedExecutable.split("spideyupdate.exe")[0] +
              '/updateorigin.txt')
      .readAsStringSync()
      .split("\n")[0];
  print(
      "WARNING : do not close the terminal until updates are finished, or you may have to reinstall spideyCLI");
  print("");
  print("downloading updates...");
  http.get(Uri.https("www.github.com", updateorigin)).then((response) async {
    print("installing updates...");
    await File(Platform.resolvedExecutable.split("spideyupdate.exe")[0] +
            '\\package.zip')
        .writeAsBytes(response.bodyBytes);
    // Read the Zip file from disk.
    final bytes = File(
            Platform.resolvedExecutable.split("spideyupdate.exe")[0] +
                '\\package.zip')
        .readAsBytesSync();

    // Decode the Zip file
    final archive = ZipDecoder().decodeBytes(bytes);

    // Extract the contents of the Zip archive to disk.
    for (final file in archive) {
      final filename = file.name;
      if (file.isFile) {
        final data = file.content as List<int>;
        File(Platform.resolvedExecutable.split("spideyupdate.exe")[0] +
            '/' +
            filename)
          ..createSync(recursive: true)
          ..writeAsBytesSync(data);
      } else {
        Directory(Platform.resolvedExecutable.split("spideyupdate.exe")[0] +
                '/' +
                filename)
            .create(recursive: true);
      }
    }
    File package = File(
        Platform.resolvedExecutable.split("spideyupdate.exe")[0] +
            '/package.zip');
    package.deleteSync();
    // Use this when compiling production build
    File removeLog = File(
        Platform.resolvedExecutable.split("spideyupdate.exe")[0] +
            '/removelog.json');
    if (removeLog.existsSync()) {
      for (String item in json.decode(removeLog.readAsStringSync())) {
        File file = File(
            Platform.resolvedExecutable.split("spideyupdate.exe")[0] +
                '/$item');
        if (file.existsSync()) {
          file.deleteSync();
        }
      }
      removeLog.deleteSync();
    }
    print("update was successfull");
    sleep(Duration(seconds: 3));
  });
}
