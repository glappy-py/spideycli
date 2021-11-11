import 'dart:convert';
import 'dart:io';

void main(List<String> args) async {
  List ignoredFiles = json.decode(File("buildconfig.json").readAsStringSync());
  for (FileSystemEntity item in Directory("A:\\spideycli\\bin").listSync()) {
    String fileName = item.path.split("A:\\spideycli\\bin\\")[1];
    if (fileName.contains(".dart")) {
      bool isValid = true;
      for (String ignore in ignoredFiles) {
        if (fileName == ignore) {
          isValid = false;
          break;
        }
      }
      if (isValid) {
        await Process.run(
            "dart",
            [
              "compile",
              "exe",
              "--output",
              "A:\\spideycli\\test\\" + fileName.split(".dart")[0] + ".exe",
              fileName
            ],
            runInShell: true);
        print(fileName.split(".dart")[0] + ".exe");
      }
    } else {
      bool isValid = true;
      for (String ignore in ignoredFiles) {
        if (fileName == ignore) {
          isValid = false;
          break;
        }
      }
      if (isValid) {
        File(item.path).copy("A:\\spideycli\\test\\" + fileName);
        print(fileName);
      }
    }
  }
}
