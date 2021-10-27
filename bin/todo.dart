import 'dart:convert';
import 'dart:io';

// Use this when compiling production build
File tasksFile = File(
    Platform.script.toString().split("file:///")[1].split("todo.exe")[0] +
        '/tasks.json');

// use this for development test
// File tasksFile = File('tasks.json');

List? fileContent;
void main(List<String> args) async {
  fileContent = json.decode(await tasksFile.readAsString());
  try {
    if (args[0] == "list") {
      listTodo(fileContent!);
    } else if (args[0] == "done") {
      removeTodo(args, fileContent!);
    } else {
      addTodo(args, fileContent!);
    }
  } catch (e) {
    print("");
    print("use spidey help to get a list of valid commands");
  }
}

void syncData() {
  tasksFile.writeAsString(json.encode(fileContent));
}

void addTodo(List<String> args, List fileContent) async {
  fileContent.add(args[0]);
  syncData();
  print("");
  print("added new task: " + args[0]);
}

void listTodo(List fileContent) async {
  print("");
  int counter = 1;
  for (var item in fileContent) {
    print(counter.toString() + ". " + item);
    counter++;
  }
}

void removeTodo(List<String> args, List fileContent) async {
  List parsedArgs = [];
  for (var item in args) {
    parsedArgs.add(item);
  }
  parsedArgs.removeAt(0);
  if (parsedArgs.isEmpty) {
    listTodo(fileContent);
    print("try again and specify the task no. to remove");
  } else {
    try {
      int index = int.parse(parsedArgs[0]) - 1;
      print("removed: " + fileContent[index]);
      fileContent.removeAt(index);
      syncData();
    } catch (e) {
      print("specify the task no. not the task");
    }
  }
}
