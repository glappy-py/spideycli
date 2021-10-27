import 'dart:convert';
import 'dart:io';

File tasksFile = File('tasks.txt');
List? fileContent;
void main(List<String> args) async {
  fileContent = json.decode(await tasksFile.readAsString());
  try {
    if (args[0] == "new") {
      addTodo(args, fileContent!);
    } else if (args[0] == "list") {
      listTodo(fileContent!);
    } else if (args[0] == "done") {
      removeTodo(args, fileContent!);
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
  fileContent.add(args[1]);
  syncData();
  print("");
  print("added new task: " + args[1]);
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
