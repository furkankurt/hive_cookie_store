import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_cookie_store/src/storage/hive_cookie_storage.dart';
import 'package:mocktail/mocktail.dart';

import '../../helper/hive_helper.dart';

class MockBox extends Mock implements Box<String> {}

class MockDirectory extends Mock implements Directory {}

class MockFile extends Mock implements File {}

void main() {
  setUpAll(() async => setUpTestHive());
  tearDownAll(() async => tearDownTestHive());

  group('HiveCookieStorage', () {
    late HiveCookieStorage storage;

    setUp(() async {
      storage = HiveCookieStorage(boxName: 'testBox');
    });

    test('should open box when initialized', () async {
      await storage.init(true, true);

      final isOpen = Hive.isBoxOpen('testBox');

      expect(isOpen, true);
    });

    test('should write and read value', () async {
      await storage.write('key', 'value');
      final result = await storage.read('key');

      expect(result, 'value');
    });

    test('should delete value', () async {
      await storage.write('key', 'value');
      await storage.delete('key');

      final result = await storage.read('key');

      expect(result, null);
    });

    test('should delete all values', () async {
      await storage.write('key', 'value');
      await storage.write('key2', 'value2');
      await storage.deleteAll([]);

      final result = await storage.read('key');
      final result2 = await storage.read('key2');

      expect(result, null);
      expect(result2, null);
    });
  });

  group('HiveCookieStorage Migration', () {
    late HiveCookieStorage storage;
    const cookieContent = '{"name":"cookie"}';

    setUp(() async {
      storage = HiveCookieStorage.migrateFromFileStorage(
        fileStorageDir: 'test/fixtures',
        boxName: 'testBox',
      );

      Directory('test/fixtures/ie1_ps1').createSync(recursive: true);
      final cookieFile = File('test/fixtures/ie1_ps1/example.com');
      await cookieFile.writeAsString(cookieContent);
    });

    tearDown(() {
      Directory('test/fixtures/ie1_ps1').delete(recursive: true).ignore();
    });

    test('should migrate if the directory exists', () async {
      await storage.init(true, true);

      final result = await storage.read('example.com');

      expect(result, cookieContent);
    });

    test('should remove the directory after migration', () async {
      await storage.init(true, true);

      final directory = Directory('test/fixtures/ie1_ps1');
      final exists = directory.existsSync();

      expect(exists, false);
    });

    test('should not migrate if the directory does not exist', () async {
      final storage = HiveCookieStorage.migrateFromFileStorage(
        fileStorageDir: 'test/fixtures/example',
        boxName: 'emptyBox',
      );

      await storage.init(true, true);

      final result = await storage.read('example.com');

      expect(result, null);
    });
  });
}
