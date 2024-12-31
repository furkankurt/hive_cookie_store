import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:hive_cookie_store/src/helper/encryption_helper.dart';
import 'package:mocktail/mocktail.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  group('EncryptionHelper', () {
    late MockFlutterSecureStorage mockStorage;
    const key = 'testKey';

    setUpAll(TestWidgetsFlutterBinding.ensureInitialized);

    setUp(() {
      mockStorage = MockFlutterSecureStorage();
    });

    test('should generate a new HiveCipher when key does not exist', () async {
      when(() => mockStorage.read(key: key)).thenAnswer((_) async => null);
      when(
        () => mockStorage.write(key: key, value: any<String>(named: 'value')),
      ).thenAnswer((_) async {});

      final cipher = await EncryptionHelper.generateCipher(
        key: key,
        storage: mockStorage,
      );

      expect(cipher, isA<HiveAesCipher>());
      verify(() => mockStorage.read(key: key)).called(1);
      verify(
        () => mockStorage.write(key: key, value: any<String>(named: 'value')),
      ).called(1);
    });

    test('should return existing HiveCipher when key exists', () async {
      final secureKey = Hive.generateSecureKey();
      final encodedKey = base64UrlEncode(secureKey);
      when(() => mockStorage.read(key: key))
          .thenAnswer((_) async => encodedKey);

      final cipher = await EncryptionHelper.generateCipher(
        key: key,
        storage: mockStorage,
      );

      expect(cipher, isA<HiveAesCipher>());
      verify(() => mockStorage.read(key: key)).called(1);
      verifyNever(
        () => mockStorage.write(key: key, value: any<String>(named: 'value')),
      );
    });

    test(
        'should create a new instance of FlutterSecureStorage '
        'when not provided', () async {
      final secureKey = Hive.generateSecureKey();
      final encodedKey = base64UrlEncode(secureKey);
      FlutterSecureStorage.setMockInitialValues({});

      // Mock the default FlutterSecureStorage instance
      final defaultStorage = MockFlutterSecureStorage();
      when(() => defaultStorage.read(key: key))
          .thenAnswer((_) async => encodedKey);

      final cipher = await EncryptionHelper.generateCipher(
        key: key,
      );

      expect(cipher, isA<HiveAesCipher>());
    });
  });
}
