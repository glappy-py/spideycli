import 'dart:convert';
import 'dart:io';

File meetingsFile = File('meetings.txt');
void main(List<String> args) async {
  List fileContent = json.decode(await meetingsFile.readAsString());
  print(fileContent[0]['ok']);
  try {
    if (args[0] == "new") {
      newMeetingEntry(fileContent);
    } else {}
  } catch (e) {
    print("");
    print("use spidey help to get a list of valid commands");
  }
}

void newMeetingEntry(List fileContent, [String? meetingName]) {
  print("meeting name: ");
  if (meetingName == null) {
    String meetingName = stdin.readLineSync() ?? "";
    if (meetingName.split(" ").length > 1) {
      print("try again. Meeting names should not contain spaces");
      newMeetingEntry(fileContent);
    } else if (meetingName == "") {
      print("try again. Meeting names cannot be empty");
    } else {
      print("meeting ID: ");
      String meetingId = stdin.readLineSync() ?? "";
      if (meetingId.split(" ").length > 1) {
        print("try again. Meeting IDs should not contain spaces");
        newMeetingEntry(fileContent);
      } else if (meetingId == "") {
        print("try again. Meeting IDs cannot be empty");
      } else {}
    }
  } else {
    print("meeting ID: ");
    String meetingId = stdin.readLineSync() ?? "";
    if (meetingId.split(" ").length > 1) {
      print("try again. Meeting IDs should not contain spaces");
      newMeetingEntry(fileContent);
    } else if (meetingId == "") {
      print("try again. Meeting IDs cannot be empty");
    } else {
      fileContent.add({meetingName: meetingId});
      // print(fileContent);
      meetingsFile.writeAsString(json.encode(fileContent));
    }
  }
}
