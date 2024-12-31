import 'dart:io';
import 'dart:math';

import 'package:hive_ce/hive.dart';
import 'package:path/path.dart' as path;

/// Initializes a [Hive] in a temporary directory.
///
/// Be sure to run [tearDownTestHive] once your test has completed.
Future<void> setUpTestHive() async {
  final tempDir = await _getTempDir();
  Hive.init(tempDir.path);
}

/// Deletes the temporary [Hive].
Future<void> tearDownTestHive() async {
  await Hive.deleteFromDisk();
}

/// Returns a temporary directory in which a Hive can be initialized
Future<Directory> _getTempDir() async {
  final random = Random();
  final tempPath = path.join(
    Directory.current.path,
    '.dart_tool',
    'test',
    'tmp',
  );

  final name = random.nextInt(pow(2, 32) as int);
  final dir = Directory(path.join(tempPath, '${name}_tmp'));
  if (dir.existsSync()) await dir.delete(recursive: true);

  await dir.create(recursive: true);
  return dir;
}
