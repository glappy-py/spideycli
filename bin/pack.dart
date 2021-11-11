import 'dart:convert';
import 'dart:io';
import 'package:archive/archive_io.dart';

// This program is not related to SpideyCLI, I made this to automate the packing process, which is a step in releasing a/an update,install or release

void main(List<String> args) {
  final encoder = ZipFileEncoder();
  print("");
  if (args[0] == "update" || args[0] == "installer" || args[0] == "release") {
    List ignoredFiles =
        json.decode(File("packconfig.json").readAsStringSync())[args[0]];
    if (args[0] == "release") {
      encoder.create("A:\\spideycli\\build\\SpideyCLI.zip");
      print("");
      print("packing into SpideyCLI.zip for " + args[0]);
      print("");
    } else {
      encoder.create("A:\\spideycli\\build\\package.zip");
      print("");
      print("packing into package.zip for " + args[0]);
      print("");
    }
    for (FileSystemEntity item
        in Directory("A:\\spideycli\\build").listSync()) {
      bool isValid = true;
      for (var ignore in ignoredFiles) {
        if (item.path.split("A:\\spideycli\\build\\")[1] == ignore) {
          isValid = false;
          break;
        }
      }
      if (isValid) {
        print(item.path.split("A:\\spideycli\\build\\")[1]);
        encoder.addFile(File(item.path));
      }
    }
    encoder.close();
  }
}
