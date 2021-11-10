import 'package:http/http.dart' as http;
import 'dart:io';

void main(List<String> args) {
  http
      .get(Uri.https("raw.githubusercontent.com",
          "/glappy-py/SpideyCLI-BUILD-/main/version.txt"))
      .then((response) async {
    String latestVersion = response.body.split("\n")[0];
    // Use this for development test
    // String currentVersion = File("version.txt").readAsLinesSync()[0];

    // Use this for production build
    String currentVersion = File(
            Platform.resolvedExecutable.split("spidey.exe")[0] + '/version.txt')
        .readAsLinesSync()[0];
    if (latestVersion[0] != currentVersion[0]) {
      print(
          'SpideyCLI update available : v$latestVersion . You are currently using $currentVersion . run \'spideyupdate\' to update SpideyCLI to the latest version');
    }
  });
}
