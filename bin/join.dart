import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

// Use this when compiling production build
File meetingsFile =
    File(Platform.resolvedExecutable.split("join.exe")[0] + '/meetings.json');

// Use this for development test
// File meetingsFile = File('meetings.json');

List? fileContent;
void main(List<String> args) async {
  http
      .get(Uri.https("raw.githubusercontent.com",
          "/glappy-py/SpideyCLI-BUILD-/main/version.txt"))
      .then((response) async {
    String latestVersion = response.body.split("\n")[0];
    // Use this for development test
    // String currentVersion = File("version.txt").readAsLinesSync()[0];

    // Use this for production build
    String currentVersion =
        File(Platform.resolvedExecutable.split("join.exe")[0] + '/version.txt')
            .readAsLinesSync()[0];
    if (latestVersion[0] != currentVersion[0]) {
      print(
          'SpideyCLI update available : v$latestVersion . You are currently using $currentVersion . run \'spideyupdate\' to update SpideyCLI to the latest version');
    }
  });
  fileContent = json.decode(await meetingsFile.readAsString());
  try {
    if (args[0] == "new") {
      newMeetingEntry(fileContent!);
    } else if (args[0] == "remove") {
      removeMeetingEntry(args, fileContent!);
    } else if (args[0] == "list") {
      listMeetings(fileContent!);
    } else {
      join(args, fileContent!);
    }
  } catch (e) {
    print("");
    print("use spidey help to get a list of valid commands");
  }
}

void syncData() {
  meetingsFile.writeAsString(json.encode(fileContent));
}

void newMeetingEntry(List fileContent) {
  print("meeting platform (gmeet/zoom) :");
  String meetingPlatform = stdin.readLineSync() ?? "";
  if (meetingPlatform == "gmeet") {
    print("meeting name: ");
    String meetingName = stdin.readLineSync() ?? "";
    if (meetingName.split(" ").length > 1) {
      print("try again. Meeting names should not contain spaces");
      newMeetingEntry(fileContent);
    } else if (meetingName == "") {
      print("try again. Meeting names cannot be empty");
      newMeetingEntry(fileContent);
    } else {
      print("meeting ID: ");
      String meetingId = stdin.readLineSync() ?? "";
      if (meetingId.split(" ").length > 1) {
        print("try again. Meeting IDs should not contain spaces");
        newMeetingEntry(fileContent);
      } else if (meetingId == "") {
        print("try again. Meeting IDs cannot be empty");
        newMeetingEntry(fileContent);
      } else {
        print("");
        print('New meeting entry for "$meetingName" successfully added ');
        fileContent.add({"name": meetingName, "id": meetingId});
        syncData();
      }
    }
  } else if (meetingPlatform == "zoom") {
    print("meeting name: ");
    String meetingName = stdin.readLineSync() ?? "";
    if (meetingName.split(" ").length > 1) {
      print("try again. Meeting names should not contain spaces");
      newMeetingEntry(fileContent);
    } else if (meetingName == "") {
      print("try again. Meeting names cannot be empty");
      newMeetingEntry(fileContent);
    } else {
      print("meeting ID: ");
      String meetingId = stdin.readLineSync() ?? "";
      if (meetingId.split(" ").length > 1) {
        print("try again. Meeting IDs should not contain spaces");
        newMeetingEntry(fileContent);
      } else if (meetingId == "") {
        print("try again. Meeting IDs cannot be empty");
        newMeetingEntry(fileContent);
      } else {
        print("meeting password: ");
        String meetingPass = stdin.readLineSync() ?? "";
        if (meetingPass.split(" ").length > 1) {
          print("try again. Meeting passes should not contain spaces");
          newMeetingEntry(fileContent);
        } else if (meetingPass == "") {
          print("try again. Meeting passes cannot be empty");
          newMeetingEntry(fileContent);
        } else {
          print("");
          print('New meeting entry for "$meetingName" successfully added ');
          fileContent
              .add({"name": meetingName, "id": meetingId, "pass": meetingPass});
          syncData();
        }
      }
    }
  } else {
    print("you need to provide a meeting platform (gmeet/zoom). Try again");
  }
}

void removeMeetingEntry(List<String> args, List fileContent) {
  bool removed = false;
  listMeetings(fileContent);
  print("");
  print("specify the name of the meeting entry you want to remove");
  print("meeting name: ");
  String meetingName = stdin.readLineSync() ?? "";
  for (var item in fileContent) {
    if (item['name'] == meetingName) {
      fileContent.removeAt(fileContent.indexOf(item));
      removed = true;
      print("");
      print('meeting entry with name "$meetingName" was successfully removed');
    }
  }
  if (!removed) {
    print("meeting entry with that name was not found");
  }
}

void join(List<String> args, List fileContent) {
  bool validMeeting = false;
  try {
    for (var item in fileContent) {
      if (item['name'] == args[0]) {
        if (item['id'].toString().contains("-")) {
          joinGMeeting(item['id'], item['name']);
        } else {
          joinZoomMeeting(item['name'], item['id'], item['pass']);
        }
        validMeeting = true;
      }
    }
  } catch (e) {
    print("enter the name of the meeting you want to join");
    String meetingName = stdin.readLineSync() ?? "";
    for (var item in fileContent) {
      if (item['name'] == meetingName) {
        if (item['id'].toString().contains("-")) {
          joinGMeeting(item['id'], item['name']);
        } else {
          joinZoomMeeting(item['name'], item['id'], item['pass']);
        }
        validMeeting = true;
      }
    }
  }
  if (!validMeeting) {
    print('no meeting entries with name were found');
  }
}

void joinGMeeting(String meetingId, String meetingName) {
  print("joining " + meetingName);
  Process.run('start', ["https://meet.google.com/" + meetingId],
      runInShell: true);
}

void joinZoomMeeting(String meetingName, String meetingId, String meetingPass) {
  print("joining " + meetingName);
  Process.run('start',
      ["zoommtg://zoom.us/join?zc=0^&confno=$meetingId^&pwd=$meetingPass"],
      runInShell: true);
}

void listMeetings(List fileContent) async {
  print("");
  int counter = 1;
  for (var item in fileContent) {
    print(counter.toString() + ". " + item['name'] + ": " + item['id']);
    counter++;
  }
}
