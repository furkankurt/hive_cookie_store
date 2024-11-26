// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_cookie_store/hive_cookie_store.dart';
import 'package:mocktail/mocktail.dart';

class MockHiveCookieStorage extends Mock implements HiveCookieStorage {}

void main() {
  group('HiveCookieJar', () {
    late MockHiveCookieStorage mockStorage;

    setUp(() {
      mockStorage = MockHiveCookieStorage();
    });

    test('can be instantiated', () {
      expect(
        HiveCookieJar(storage: mockStorage),
        isNotNull,
      );
    });

    test('initializes with given storage', () {
      final jar = HiveCookieJar(storage: mockStorage);
      expect(jar.storage, equals(mockStorage));
    });

    test('persists session when persistSession is true', () {
      final jar = HiveCookieJar(
        storage: mockStorage,
      );
      expect(jar.persistSession, isTrue);
    });

    test('ignores expires when ignoreExpires is true', () {
      final jar = HiveCookieJar(
        storage: mockStorage,
        ignoreExpires: true,
      );
      expect(jar.ignoreExpires, isTrue);
    });

    test(
        'deletes host cookies when load fails '
        'when deleteHostCookiesWhenLoadFailed is true', () {
      final jar = HiveCookieJar(
        storage: mockStorage,
      );
      expect(jar.deleteHostCookiesWhenLoadFailed, isTrue);
    });
  });
}
