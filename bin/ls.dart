import 'dart:io';

void main(List<String> args) {
  print("");
  for (FileSystemEntity item in Directory.current.listSync()) {
    print(item);
  }
}
