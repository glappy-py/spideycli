import 'dart:io';

void main(List<String> args) {
  try {
    if (args[0] == "help") {
      help();
    }
  } catch (e) {
    print("");
    print("use spidey help to get a list of valid commands");
  }
}

void help() {
  print("help panel will fill in info later");
}
