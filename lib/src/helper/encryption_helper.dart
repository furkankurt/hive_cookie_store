import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';

/// A helper class to generate a [HiveCipher] for encryption.
abstract class EncryptionHelper {
  const EncryptionHelper._();

  /// Helper method to generate a [HiveCipher] for encryption using the
  /// [FlutterSecureStorage] package with the given [key].
  ///
  /// If the [storage] is not provided, a new instance of [FlutterSecureStorage]
  /// will be created.
  ///
  /// The generated [HiveCipher] will be stored in the secure [storage]
  /// with the given [key] and returned.
  static Future<HiveCipher> generateCipher({
    required String key,
    FlutterSecureStorage? storage,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    final localStorage = storage ?? const FlutterSecureStorage();
    final encryptionKeyString = await localStorage.read(
      key: key,
      iOptions: iOptions,
      aOptions: aOptions,
      lOptions: lOptions,
      webOptions: webOptions,
      mOptions: mOptions,
      wOptions: wOptions,
    );
    // If the encryption key is not found, generate a new one and store it.
    if (encryptionKeyString == null) {
      final secureKey = Hive.generateSecureKey();
      await localStorage.write(
        key: key,
        value: base64UrlEncode(secureKey),
        iOptions: iOptions,
        aOptions: aOptions,
        lOptions: lOptions,
        webOptions: webOptions,
        mOptions: mOptions,
        wOptions: wOptions,
      );
      return HiveAesCipher(secureKey);
    }
    final decodedKey = base64Url.decode(encryptionKeyString);
    return HiveAesCipher(decodedKey);
  }
}
