import 'dart:io';

void main(List<String> args) {
  if (args[0].split(" ")[args[0].split(" ").length - 1].contains(".")) {
    File file = File(Directory.current.path + "/" + args[0]);
    if (file.existsSync()) {
      print("This file already exists");
    } else {
      file.create();
    }
  } else {
    Directory directory = Directory(Directory.current.path + "/" + args[0]);
    if (directory.existsSync()) {
      print("This directory already exists");
    } else {
      directory.create();
    }
  }
}
