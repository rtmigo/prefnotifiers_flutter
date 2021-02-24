# prefnotifiers

This library makes it easy to use [shared_preferences](https://pub.dev/packages/shared_preferences) with
state management libraries like [provider](https://pub.dev/packages/provider) or `ValueListenableBuilder` widgets.

## PrefItem

PrefItem serves as a **model** for an individual parameter stored in shared preferences. Although I/O operations on
shared preferences are asynchronous, the `PrefItem.value` is always available for synchronous calls.
It provides *"the best value we have for the moment"*. The actual read/write operations happen in background.

Suppose, we have parameter, that can be read with [shared_preferences](https://pub.dev/packages/shared_preferences) like that:

```dart
final prefs = await SharedPreferences.getInstance();
var currentValue = await prefs.getInt("TheParameter");
```

There are two lines of problem. First, the same data is now represented by two entities: the `currentValue` variable and
the real storage. We can change the `currentValue`, forgetting that the storage will not be affected.

But l
Let's declare the model for this parameter:

```dart
final theParameter = PrefItem<int>(SharedPrefsStorage(), "TheParameter");
```

Reading is is not finished yet. But we already can access `theParameter.value`. By default, it returns `null`.
We can use it in synchronous code:

```dart
Widget build(BuildContext context) {
    if (theParameter.value==null)
        return Text("Not initialized yet");
    else
        return Text("Value is ${theParameter.value}");
}
```

Since `PrefItem` inherits from the `ValueNotifier` class, we can automatically rebuild the widget when the `theParameter` will be available:

```dart
Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: theParameter,
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
    // myParameter.value is 3, shared prefs is 3

    myParameter.value += 1;
    myParameter.value += 1;

    // myParameter.value changed to 5.
    // The widget will rebuild momentarily (i.e. on the next frame)
    //
    // Shared preferences still contain value 3. But asynchronous writing
    // already started. It will rewrite value in a few milliseconds
}
```

## PrefsStorage

Each `PrefItem` relies on a `PrefsStorage` that actually stores the values.  Where and how the data is stored depends
on which object is passed to the `PrefItem` constructor.

```dart

final keptInSharedPreferences = PrefItem<int>(SharedPrefsStorage(), ...);

final keptInRam = PrefItem<String>(RamPrefsStorage(), ...);

final keptInFile = PrefItem<String>(CustomJsonPrefsStorage(), ...);

```

But usually the same instance of `PrefsStorage` shared between multiple `PrefItem` objects:

```dart

final storage = inTestingMode ? RamPrefsStorage() : SharedPrefsStorage();

final param1 =  PrefItem<String>(storage, "param1");
final param2 =  PrefItem<double>(storage, "param2");

```

- `PrefsStorage` is an abstract base class describing a storage. A descendant should be able of reading and writing
named values of types `int`, `double`, `String`, `StringList` and `DateTime`.

- `SharedPrefsStorage` stores preferences in platform-dependent [shared_preferences](https://pub.dev/packages/shared_preferences).

- `RamPrefsStorage` stores preferences in RAM. This class is mostly useful for testing.





