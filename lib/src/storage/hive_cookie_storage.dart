import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:hive_ce/hive.dart';

/// A cookie storage implementation using Hive with optional encryption support.
/// This storage is used by the [CookieJar] to store cookies.
class HiveCookieStorage implements Storage {
  /// Initialize the cookie storage with an optional [encryptionCipher].
  HiveCookieStorage({
    this.boxName,
    this.encryptionCipher,
  }) : fileStorageDir = null;

  /// If you were using [FileStorage] before, you can migrate to
  /// [HiveCookieStorage] by providing the [fileStorageDir] where the cookies
  /// are stored in the [FileStorage].
  HiveCookieStorage.migrateFromFileStorage({
    required this.fileStorageDir,
    this.boxName,
    this.encryptionCipher,
  });

  /// The Hive box to store cookies.
  Box<String>? _hiveBox;

  /// Optional box name for the Hive box.
  String? boxName;

  /// Optional encryption cipher to use with Hive.
  final HiveCipher? encryptionCipher;

  /// If [fileStorageDir] is provided, the cookie storage will be migrated
  /// from the [FileStorage] to [HiveCookieStorage].
  final String? fileStorageDir;

  @override
  Future<void> init(bool persistSession, bool ignoreExpires) async {
    await _openBox();
    await _migrateToHive(persistSession, ignoreExpires);
  }

  /// Migrates the cookies from the [fileStorageDir] to the Hive box.
  Future<void> _migrateToHive(bool persistSession, bool ignoreExpires) async {
    if (fileStorageDir == null) return;

    var baseDir = fileStorageDir?.replaceAll(r'\', '/') ?? '.cookies/4/';
    if (!baseDir.endsWith('/')) {
      baseDir += '/';
    }

    final sb = StringBuffer(baseDir)
      ..write('ie${ignoreExpires ? 1 : 0}')
      ..write('_ps${persistSession ? 1 : 0}')
      ..write('/');
    final directoryPath = sb.toString();

    final directory = Directory(directoryPath);
    final exists = directory.existsSync();
    if (!exists) return;

    final dirs = directory.listSync();

    for (final dir in dirs) {
      if (dir is File) {
        final key = dir.path.split('/').last;
        final value = await dir.readAsString();
        await write(key, value);
      }
    }

    // Migration completed, deleting the old directory.
    await directory.delete(recursive: true);
  }

  @override
  Future<String?> read(String key) async {
    final box = await _openBox();
    return box.get(key);
  }

  @override
  Future<void> write(String key, String value) async {
    final box = await _openBox();
    await box.put(key, value);
  }

  @override
  Future<void> delete(String key) async {
    final box = await _openBox();
    await box.delete(key);
  }

  @override
  Future<void> deleteAll(List<String> keys) async {
    final box = await _openBox();
    await box.clear();
  }

  /// Opens the Hive box for storing cookies.
  Future<Box<String>> _openBox() async {
    _hiveBox ??= await Hive.openBox<String>(
      boxName ?? 'cookie_box',
      encryptionCipher: encryptionCipher,
    );
    return Future.value(_hiveBox);
  }
}
