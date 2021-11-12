import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<String> getFilePath(String name) async {
  Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
  String appDocumentsPath = appDocumentsDirectory.path;
  String filePath = '$appDocumentsPath/$name';
  print(filePath);
  return filePath;
}

void saveFile(String name, String data) async {
  File file = File(await getFilePath(name));
  file.writeAsString(data);
}
