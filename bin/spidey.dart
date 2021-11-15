import 'package:archive/archive.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

void main(List<String> args) {
  // Use this for development test
  String currentVersion = File("version.txt").readAsLinesSync()[0];

  // Use this for production build
  // String currentVersion =
  //     File(Platform.resolvedExecutable.split("spidey.exe")[0] + '/version.txt')
  //         .readAsLinesSync()[0];
  http
      .get(Uri.https("raw.githubusercontent.com",
          "/glappy-py/SpideyCLI-BUILD-/main/version.txt"))
      .then((response) async {
    String latestVersion = response.body.split("\n")[0];
    if (latestVersion != currentVersion) {
      print(
          'SpideyCLI update available : v$latestVersion . You are currently using $currentVersion . run \'spideyupdate\' to update SpideyCLI to the latest version');
    }
  });
  try {
    if (args[0] == "help") {
      help();
    } else if (args[0] == "-v") {
      print(currentVersion);
    } else if (args[0] == "logo") {
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
    } else {
      print("");
      print(
          "That command does not exist. Use spidey help to get a list of valid commands");
    }
  } catch (e) {
    print("");
    print("use spidey help to get a list of valid commands");
  }
}

void help() {
  print("""
  
  spidey help  -  display this help panel

  spideyupdate  -  update SpideyCLI. NOTE : there's no space between spidey and update (it's 'spideyupdate')

  spidey logo  -  display the spidey logo. That's it

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
