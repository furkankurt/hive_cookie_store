import 'package:cookie_jar/cookie_jar.dart';
import 'package:hive_cookie_store/hive_cookie_store.dart';

Future<void> main() async {
  final cipher = await EncryptionHelper.generateCipher(key: 'testKey');

  final storage = HiveCookieStorage(
    boxName: 'box',
    encryptionCipher: cipher,
  );

  //? use the storage with the [HiveCookieJar]

  final jar = HiveCookieJar(
    storage: storage,
    ignoreExpires: true,
  );

  //? or use the storage directly with the [PersistCookieJar]

  final persistJar = PersistCookieJar(
    storage: storage,
    ignoreExpires: true,
  );
}
