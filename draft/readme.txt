# Under the hood



Each `PrefItem` relies on a `PrefsStorage` that actually stores data.

``` dart

final itemInSharedPreferences = PrefItem<int>(SharedPrefsStorage(), ...);

final itemInRam = PrefItem<int>(RamPrefsStorage(), ...);

final itemInFile = PrefItem<int>(CustomJsonPrefsStorage(), ...);

```

Normally same instance of `PrefsStorage` is used by multiple `PrefItem` objects:

```dart

final storage = SharedPrefsStorage();

final a = PrefItem<String>(storage, "nameA");
final b = PrefItem<double>(storage, "nameB");

```

- `SharedPrefsStorage` stores preferences in platform-dependent [shared_preferences](https://pub.dev/packages/shared_preferences)

- `RamPrefsStorage` stores preferences in RAM. This class is mostly useful for testing

- `PrefsStorage` is an abstract base class describing a storage. A descendant should be able of reading and writing
named values of types `int`, `double`, `String`, `StringList` and `DateTime`




