[![Pub Package](https://img.shields.io/pub/v/prefnotifiers.svg)](https://pub.dev/packages/prefnotifiers)
[![pub points](https://badges.bar/prefnotifiers/pub%20points)](https://pub.dev/packages/prefnotifiers/score)
[![Actions Status](https://github.com/rtmigo/prefnotifiers.flutter/workflows/ci%20test/badge.svg?branch=master)](https://github.com/rtmigo/prefnotifiers.flutter/actions)

# [prefnotifiers](https://github.com/rtmigo/prefnotifiers)

This library represents [shared_preferences](https://pub.dev/packages/shared_preferences) as `ValueNotifier` objects.

It fits in well with the paradigm of data models. Models make data readily available to widgets.

Reads and writes occur asynchronously in background.

## Why use PrefItem?

Suppose, we have parameter, that can be read with [shared_preferences](https://pub.dev/packages/shared_preferences) like that:

``` dart
final prefs = await SharedPreferences.getInstance();
int paramValue = await prefs.getInt("TheParameter");
```

There are two lines of problem:

- This code is asynchronous. We cannot use such code directly when building a widget
- The `paramValue` does not reflect the parameter changes

Instead, we suggest using the new `PrefItem` class for accessing the parameter:

``` dart
final pref = SharedPref<int>("TheParameter");
```

- `pref` object can be used as the only representation of `"TheParameter"` in the whole program
- `pref.value` allows indirectly read and write the shared preference value without getting out of sync
- `Widget build(_)` methods can access value without relying on `FutureBuilder`
- `pref.addListener` makes it possible to track changes of the value

## What is SharedPref?

`SharedPref` serves as a **model** for an individual parameter stored in shared preferences.

`SharedPref.value` provides **the best value we have for the moment**. The actual read/write operations happen asynchronously in background.

`SharedPref<int>` reads/writes an `int` value, `SharedPref<String>` reads/writes a `String` and so on.

## How to use SharedPref?

### Create SharedPref

```dart
final pref = SharedPref<int>("TheParameter");
```

:warning:

### Read SharedPref value

Reading is is not finished yet. But we already can access `pref.value`. By default, it returns `null`.
We can use it in synchronous code:

``` dart
Widget build(BuildContext context) {
    if (pref.value==null)
        return Text("Not initialized yet");
    else
        return Text("Value is ${pref.value}");
}
```

Since `SharedPref` inherits from the `ValueNotifier`, we can automatically 
rebuild the widget when the new value of `pref` will be available:

``` dart
Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: pref,
        builder: (BuildContext context, int value, Widget child) {
            if (value==null)
                return Text("Not initialized yet");
            else
                return Text("Value is $value");
        });
}
```

### Write SharedPref value

The code above will also rebuild the widget when value is changed. Let's change the value in a button callback:

``` dart
onTap: () {
    // param.value is 3, shared preferences value is 3

    pref.value += 1;
    pref.value += 1;

    // param.value changed to 5.
    // The widget will rebuild momentarily (i.e. on the next frame)
    //
    // Shared preferences still contain value 3. But asynchronous writing
    // already started. It will rewrite value in a few milliseconds
}
```

### Wait for SharedPref value

For a newly created `SharedPref` the `value` returns `null` until the object reads the actual data from the storage.
But what if we want to get actual data before doing anything else?

``` dart

final pref = SharedPref<int>("TheParameter");
await pref.initialized;

// we waited while the object was reading the data.
// Now pref.value returns the value from the storage, not default NULL.
// Even if it is NULL, it is a NULL from the storage :)

```

