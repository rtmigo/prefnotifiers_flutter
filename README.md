# prefnotifiers

This library makes it easy to use [shared_preferences](https://pub.dev/packages/shared_preferences) with
state management libraries like [provider](https://pub.dev/packages/provider) or `ValueListenableBuilder` widgets.

## PrefItem

PrefItem serves as a **model** for an individual parameter stored in shared preferences. Although I/O operations on
shared preferences are asynchronous, the `PrefItem.value` is always available for synchronous calls.
It provides *"the best value we have for the moment"*. The actual read/write operations happen in background.

Suppose, we have parameter named *TheParameter* is the shared preferences.

Let's declare the model for this parameter:

```dart
final theParameter = PrefItem<int>(storage, "TheParameter");
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

`PrefsStorage` is an abstract base class describing a storage. The storage should read and write named parameters
of types `int`, `double`, `String`, `StringList` and `DateTime`.

`SharedPrefsStorage` stores preferences in platform-dependent [shared_preferences](https://pub.dev/packages/shared_preferences).

`RamPrefsStorage` stores preferences in RAM. This class is mostly useful for testing.

```dart
final storage = inTestingMode ? RamPrefsStorage() : SharedPrefsStorage();
```

Other implementations can be made for keeping preferences in files or SQLite databases.

