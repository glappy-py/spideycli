import 'package:archive/archive.dart';
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
    if (latestVersion != currentVersion) {
      print(
          'SpideyCLI update available : v$latestVersion . You are currently using $currentVersion . run \'spideyupdate\' to update SpideyCLI to the latest version');
    }
  });
  try {
    if (args[0] == "help") {
      help();
    } else if (args[0] == "-v") {
      // For development test
      // print(File("version.txt").readAsStringSync().split("\n")[0]);
      // For production build
      print(File(Platform.resolvedExecutable.split("spidey.exe")[0] +
              '/version.txt')
          .readAsLinesSync()[0]);
    } else {
      print("");
      print("use spidey help to get a list of valid commands");
    }
  } catch (e) {
    print("");
    print("use spidey help to get a list of valid commands");
  }
}

void help() {
  print(
      """
  
  spidey help  -  display this help panel

  spideyupdate  -  update SpideyCLI. NOTE : there's no space between spidey and update (it's 'spideyupdate')

  spidey -v  -  show the version of SpideyCLI you are currently using

  join new  -  create a new meeting entry (gmeet/zoom)
  
  join remove  -  remove a meeting entry from saved meetings
  
  join list  -  display a list saved meeting entries
  
  join [meeting name]  -  join the meeting with the specified meeting name
  
  todo [task]  -  add a task to SpideyTasks todo list
  
  todo done [task index]  -  remove a listed task from the todo list
  
  todo list  -  display a list of uncompleted tasks from the todo list
  
  touch [directory name]  -  create an empty directory with the directory name, if the name contains extensions such as .txt, .js, .java then it creates a file with the specified name and extension.

  ls  -  displays a list of all the contents of the current directory. Similar to 'ls' command in bash""");
}
