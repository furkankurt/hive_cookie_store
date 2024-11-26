import 'package:cookie_jar/cookie_jar.dart';
import 'package:hive_cookie_store/hive_cookie_store.dart';

/// {@template hive_cookie_store}
/// A cookie storage implementation using Hive with optional encryption support.
/// {@endtemplate}
class HiveCookieJar extends PersistCookieJar {
  /// {@macro hive_cookie_store}
  HiveCookieJar({
    required HiveCookieStorage storage,
    super.persistSession,
    super.ignoreExpires,
    super.deleteHostCookiesWhenLoadFailed,
  }) : super(storage: storage);
}
