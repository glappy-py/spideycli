import 'dart:io';

void main(List<String> args) {
  print("");
  Directory(Directory.current.absolute.path).list().forEach((element) {
    print("    " +
        element.uri.toString().split(Directory.current.uri.toString())[1]);
  });
}
