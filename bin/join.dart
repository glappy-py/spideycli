import 'dart:convert';
import 'dart:io';

File meetingsFile = File('meetings.json');
List? fileContent;
void main(List<String> args) async {
  fileContent = json.decode(await meetingsFile.readAsString());
  try {
    if (args[0] == "new") {
      newMeetingEntry(fileContent!);
    } else if (args[0] == "remove") {
      removeMeetingEntry(args, fileContent!);
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
}

void removeMeetingEntry(List<String> args, List fileContent) {
  bool removed = false;
  try {
    for (var item in fileContent) {
      if (item['name'] == args[1]) {
        fileContent.removeAt(fileContent.indexOf(item));
        removed = true;
        print("");
        print('meeting entry was successfully removed');
      }
    }
  } catch (e) {
    print("");
    print("specify the name of the meeting entry you want to remove");
    print("meeting name: ");
    String meetingName = stdin.readLineSync() ?? "";
    for (var item in fileContent) {
      if (item['name'] == meetingName) {
        fileContent.removeAt(fileContent.indexOf(item));
        removed = true;
        print("");
        print(
            'meeting entry with name "$meetingName" was successfully removed');
      }
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
        joinMeeting(item['id'], item['name']);
        validMeeting = true;
      }
    }
  } catch (e) {
    print("enter the name of the meeting you want to join");
    String meetingName = stdin.readLineSync() ?? "";
    for (var item in fileContent) {
      if (item['name'] == meetingName) {
        joinMeeting(item['id'], item['name']);
        validMeeting = true;
      }
    }
  }
  if (!validMeeting) {
    print('no meeting entries with name were found');
  }
}

void joinMeeting(String meetingId, String meetingName) {
  print("joining " + meetingName);
  Process.run('start', ["https://meet.google.com/" + meetingId],
      runInShell: true);
}
