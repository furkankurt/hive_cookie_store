# Hive Cookie Store

[![Pub Link][pub_badge]][pub_link]
![coverage_badge]
[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]

A cookie store implementation for the [cookie_jar][cookie_jar_link] package that uses Hive for persistence and encryption.
This package uses the [hive][hive_link] package to securely store and retrieve cookies from the local storage.

## Features 📋

- **Secure**: Cookies are encrypted and stored in the local storage.
- **Persistence**: Cookies are persisted across app restarts.
- **Customizable**: You can customize the encryption key and the encryption algorithm.
- **Efficient**: Hive is a fast and efficient NoSQL database.
- **Cross-platform**: Works on Android, iOS, macOS, Windows, Linux, and Web.

## Installation 💻

**❗ In order to start using Hive Cookie Store you must have the [Flutter SDK][flutter_install_link] installed on your machine.**

Install via `flutter pub add`:

```sh
dart pub add hive_cookie_store
```

## Usage 🚀

If you want to use the `HiveCookieStore` as a persistent cookie store for the `CookieJar` you can do so like this:

```dart
import 'package:hive_cookie_store/hive_cookie_store.dart';

Future<void> initPersistentCookieJar() {
  final cipher = await EncryptionHelper.generateCipher(key: 'testKey');

  final storage = HiveCookieStorage(
    boxName: 'box',
    encryptionCipher: cipher,
  );

  // use the storage with the [HiveCookieJar]

  final jar = HiveCookieJar(
    storage: storage,
    ignoreExpires: true,
  );

  // or use the storage directly with the [PersistCookieJar]

  final persistJar = PersistCookieJar(
    storage: storage,
    ignoreExpires: true,
  );

  //... use `jar` with your Http or Dio instance
}
```

---

## Contributing 🤝

To contribute the package, please follow these steps:

1. Fork the repository.

2. Create a new branch:
   ```bash
   git checkout -b feature-branch
   ```

3. Make your changes and commit them:
   ```bash
   git commit -m "Description of your changes"
   ```

4. Push to the branch:
   ```bash
   git push origin feature-branch
   ```

5. Create a pull request.

---

[flutter_install_link]: https://docs.flutter.dev/get-started/install
[github_actions_link]: https://docs.github.com/en/actions/learn-github-actions
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: LICENSE
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
[very_good_cli_link]: https://pub.dev/packages/very_good_cli
[very_good_coverage_link]: https://github.com/marketplace/actions/very-good-coverage
[very_good_ventures_link]: https://verygood.ventures
[very_good_ventures_link_light]: https://verygood.ventures#gh-light-mode-only
[very_good_ventures_link_dark]: https://verygood.ventures#gh-dark-mode-only
[very_good_workflows_link]: https://github.com/VeryGoodOpenSource/very_good_workflows
[coverage_badge]: coverage_badge.svg
[cookie_jar_link]: https://pub.dev/packages/cookie_jar
[hive_link]: https://pub.dev/packages/hive
[pub_badge]: https://img.shields.io/pub/v/hive_cookie_store.svg
[pub_link]: https://pub.dev/packages/hive_cookie_store
