import 'package:http/http.dart' as http;
import 'package:archive/archive.dart';
import 'dart:io';
import 'dart:convert';

void main(List<String> args) async {
  http
      .get(Uri.https("raw.githubusercontent.com",
          "/glappy-py/SpideyCLI-BUILD-/main/version.txt"))
      .then((response) async {
    String latestVersion = response.body.split("\n")[0];
    // Use this for development test
    // String currentVersion = File("version.txt").readAsLinesSync()[0];

    // Use this for production build
    String currentVersion = File(
            Platform.resolvedExecutable.split("spideyupdate.exe")[0] +
                '/version.txt')
        .readAsLinesSync()[0];
    if (latestVersion != currentVersion) {
      print("update available : " + latestVersion);
      update();
      await File(Platform.resolvedExecutable.split("spideyupdate.exe")[0] +
              '/version.txt')
          .writeAsString(latestVersion);
    } else {
      print(
          "you are current using the latest version of SpideyCLI. Do you want to force update (y/n) : ");
      if (stdin.readLineSync()?[0] == "y") {
        update();
        await File(Platform.resolvedExecutable.split("spideyupdate.exe")[0] +
                '/version.txt')
            .writeAsString(latestVersion);
      }
    }
  });
}

void update() {
  print(
      "WARNING : do not close the terminal until updates are finished, or you may have to reinstall spideyCLI");
  print("""

MMMMMMMMMMMMWNWNXWMMMMMMMMMMMMMMNXWNNWMMMMMMMMMMMM
MMMMMMMMMMMXk0XkOWMMMMMMMMMMMMMMNkOXOOWMMMMMMMMMMM
MMMMMMMMMMXoxXdoXMMMMMMMMMMMMMMMMOlOKoxNMMMMMMMMMM
MMMMMMMMMNllKk;xWMMMMMMMMMMMMMMMMNl:KO:xWMMMMMMMMM
MMMMMMMMWx;kK;,0MMMMMMMMMMMMMMMMMMx.oXo;0MMMMMMMMM
MMMMMMMMK;;Kd.:XMMWWWMMMMMMMMWWMMMO.'0k'lNMMMMMMMM
MMMMMMMWd.cXx.'ldoolokO0K0OOdlooodc.,00,'OMMMMMMMM
MMMMMMMK; cKOo::;,,;.. .... .,;,;:::dKO, lWMMMMMMM
MMMMMMMXo..:coddc;;,.        .;;;lxdlc,.'xWMMMMMMM
MMMMMMMMWKOXWXx:;ll,.       ..;lc;lONNK0XWMMMMMMMM
MMMMMMMMMMW0o:cxd;'co.      ;o;'cxd:cxKWMMMMMMMMMM
MMMMMMWNKdc:o0WWl '00'      :Xx..kMNkl:lkXNWMMMMMM
MMMMMNo'':kXWMMNc ,KNc     .xWx..xMMMWKd;';kWMMMMM
MMMMMNc :XMMMMMNc ;KMO.    ;XMk..xMMMMMMO'.xMMMMMM
MMMMMWd.:NMMMMMWl ;XMNo   .kMMO..kMMMMMM0'.OMMMMMM
MMMMMMO.,KMMMMMWo ;XMMXo:cxWMMO..OMMMMMMk.;XMMMMMM
MMMMMMX:'OMMMMMMx.;XMMMWWWMMMMO.'0MMMMMWo.dWMMMMMM
MMMMMMMk,dWMMMMM0',KMMMMMMMMMMk.:NMMMMMX:;KMMMMMMM
MMMMMMMNocKMMMMMNc,0MMMMMMMMMMx'dWMMMMMk:kMMMMMMMM
MMMMMMMMXoxWMMMMMx;kMMMMMMMMMWl;KMMMMMXoxWMMMMMMMM
MMMMMMMMMKxKMMMMMXcoWMMMMMMMMKcdWMMMMWOkNMMMMMMMMM
MMMMMMMMMMXXWMMMMMOl0MMMMMMMWxlKMMMMMNKNMMMMMMMMMM
MMMMMMMMMMMMMMMMMMWkkNMMMMMMKx0MMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMNKXWMMMMWKKWMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMWWWMMMMWWMMMMMMMMMMMMMMMMMMMMM""");
  print("downloading updates...");
  http
      .get(Uri.https("www.github.com",
          "/glappy-py/SpideyCLI-BUILD-/releases/download/update/package.zip"))
      .then((response) async {
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
  });
}
