import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:localsend_app/util/native/channel/android_channel.dart';

Future<PickDirectoryResult?> getPickDirectoryResultFromPath(
    String directoryPath) async {
  final directory = Directory(directoryPath);
  bool directoryExists = await directory.exists();
  var tp = directory.statSync().type;
  bool isDirectory = tp == FileSystemEntityType.directory;
  if (directoryExists && isDirectory) {
    final uri = Uri.directory(directoryPath);
    final files = directory.listSync().whereType<File>().map((file) {
      return FileInfo(
        name: path.basename(file.path),
        size: file.lengthSync(),
        uri: Uri.file(file.path).toString(),
        lastModified: file.lastModifiedSync().millisecondsSinceEpoch,
      );
    }).toList();

    return PickDirectoryResult(
      directoryUri: uri.toString(),
      files: files,
    );
  } else {
    return null;
  }
}
