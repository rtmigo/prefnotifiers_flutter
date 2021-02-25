# prefnotifiers

This library helps to wrap individual [shared_preferences](https://pub.dev/packages/shared_preferences) into
`ValueNotifier` objects.

This fits well into the paradigm of data models. Models make data readily available to widgets.


## Why turn preferences into objects?

Suppose, we have parameter, that can be read with [shared_preferences](https://pub.dev/packages/shared_preferences) like that:

```dart
final prefs = await SharedPreferences.getInstance();
int paramValue = await prefs.getInt("TheParameter");
```

There are two lines of problem:

- This code is asynchronous. We cannot use such code directly when building a widget

- The same data is now represented by two entities: the `paramValue` variable and
the real storage. There is a risk that after updating one thing, we will forget to update another and get out of sync

We suggest using the new `PrefItem` class for accessing "TheParameter":

```dart
final param = PrefItem<int>(SharedPrefsStorage(), "TheParameter");
```

- `param` object can be used as the only representation of `"TheParameter"` in the whole program
- `param.value` allows indirectly read and write the shared preference value
- synchronous `Widget build(_)` methods can access value immediately
- `param.addListener` makes it possible to track changes of the value


## PrefItem

PrefItem serves as a **model** for an individual parameter stored in shared preferences.

`PrefItem.value` provides *"the best value we have for the moment"*. The actual read/write operations happen asynchronously in background.

```dart
final param = PrefItem<int>(SharedPrefsStorage(), "TheParameter");
```

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

## PrefsStorage

Each `PrefItem` relies on a `PrefsStorage` that actually stores the values. The way the data is stored depends on which object is passed
 to the `PrefItem` constructor.

```dart

final keptInSharedPreferences = PrefItem<int>(SharedPrefsStorage(), ...);

final keptInRam = PrefItem<String>(RamPrefsStorage(), ...);

final keptInFile = PrefItem<String>(CustomJsonPrefsStorage(), ...);

```

But usually the same instance of `PrefsStorage` shared between multiple `PrefItem` objects:

```dart

final storage = inTestingMode ? RamPrefsStorage() : SharedPrefsStorage();

final a = PrefItem<String>(storage, "nameA");
final b = PrefItem<double>(storage, "nameB");

```

- `SharedPrefsStorage` stores preferences in platform-dependent [shared_preferences](https://pub.dev/packages/shared_preferences)

- `RamPrefsStorage` stores preferences in RAM. This class is mostly useful for testing

- `PrefsStorage` is an abstract base class describing a storage. A descendant should be able of reading and writing
named values of types `int`, `double`, `String`, `StringList` and `DateTime`




