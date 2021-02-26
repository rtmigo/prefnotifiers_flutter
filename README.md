This library represents [shared_preferences](https://pub.dev/packages/shared_preferences) as `ValueNotifier` objects.

It fits in well with the paradigm of data models. Models make data readily available to widgets.


## Why use PrefItem?

Suppose, we have parameter, that can be read with [shared_preferences](https://pub.dev/packages/shared_preferences) like that:

```dart
final prefs = await SharedPreferences.getInstance();
int paramValue = await prefs.getInt("TheParameter");
```

There are two lines of problem:

- This code is asynchronous. We cannot use such code directly when building a widget

- `paramValue` poorly models the stored parameter. For example, we can change `paramValue`, but the parameter will remain unchanged

Instead, we suggest using the new `PrefItem` class for accessing the parameter:

```dart
final param = PrefItem<int>(SharedPrefsStorage(), "TheParameter");
```

- `param` object can be used as the only representation of `"TheParameter"` in the whole program
- `param.value` allows indirectly read and write the shared preference value without getting out of sync
- `Widget build(_)` methods can access value without relying on `FutureBuilder`
- `param.addListener` makes it possible to track changes of the value

## How to use PrefItem?

PrefItem serves as a **model** for an individual parameter stored in shared preferences.

`PrefItem.value` provides *"the best value we have for the moment"*. The actual read/write operations happen asynchronously in background.

### Create PrefItem

```dart
final param = PrefItem<int>(SharedPrefsStorage(), "TheParameter");
```

### Read PrefItem value

Reading is is not finished yet. But we already can access `param.value`. By default, it returns `null`.
We can use it in synchronous code:

```dart
Widget build(BuildContext context) {
    if (param.value==null)
        return Text("Not initialized yet");
    else
        return Text("Value is ${param.value}");
}
```

Since `PrefItem` inherits from the `ValueNotifier` class, we can automatically rebuild the widget when the `param` will be available:

```dart
Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: param,
        builder: (BuildContext context, int value, Widget child) {
            if (value==null)
                return Text("Not initialized yet");
            else
                return Text("Value is $value");
        });
}
```

### Write PrefItem value

The code above will also rebuild the widget when value is changed. Let's change the value in a button callback:

```dart
onTap: () {
    // param.value is 3, shared preferences value is 3

    param.value += 1;
    param.value += 1;

    // param.value changed to 5.
    // The widget will rebuild momentarily (i.e. on the next frame)
    //
    // Shared preferences still contain value 3. But asynchronous writing
    // already started. It will rewrite value in a few milliseconds
}
```

## What is PrefsStorage?

Each `PrefItem` relies on a `PrefsStorage` that actually stores data.

```dart

final keptInSharedPreferences = PrefItem<int>(SharedPrefsStorage(), ...);

final keptInRam = PrefItem<int>(RamPrefsStorage(), ...);

final keptInFile = PrefItem<int>(CustomJsonPrefsStorage(), ...);

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




