[![Pub Package](https://img.shields.io/pub/v/prefnotifiers.svg)](https://pub.dev/packages/prefnotifiers)
[![pub points](https://badges.bar/prefnotifiers/pub%20points)](https://pub.dev/packages/prefnotifiers/score)
[![Actions Status](https://github.com/rtmigo/prefnotifiers.flutter/workflows/ci%20test/badge.svg?branch=master)](https://github.com/rtmigo/prefnotifiers.flutter/actions)

# [prefnotifiers](https://github.com/rtmigo/prefnotifiers)

This library represents [shared_preferences](https://pub.dev/packages/shared_preferences) as `ValueNotifier` objects.

It fits in well with the paradigm of data models. Models make data readily available to widgets.

Reads and writes occur asynchronously in background.

# Why use PrefNotifier?

Suppose, we have parameter, that can be read with [shared_preferences](https://pub.dev/packages/shared_preferences) like that:

``` dart
final prefs = await SharedPreferences.getInstance();
int myParamValue = await prefs.getInt("MyParameter");
```

There are two lines of problem:

- This code is asynchronous. We cannot use such code directly when building a widget
- The `paramValue` does not reflect the parameter changes

Instead, we suggest using the new `PrefNotifier` class for accessing the parameter:

``` dart
final myParam = PrefNotifier<int>("MyParameter");
```

- `myParam` object can be used as the only representation of `"MyParameter"` in the whole program
- `myParam.value` allows indirectly read and write the shared preference value without getting out of sync
- `Widget build(_)` methods can access value without relying on `FutureBuilder`
- `myParam.addListener` makes it possible to track changes of the value

# What is PrefNotifier?



`PrefNotifier.value` provides **the best value we have for the moment**. The actual read/write operations happen asynchronously in background.

`PrefNotifier` serves as a **model** for an individual parameter stored in shared preferences.


Type                         | Аlternative to SharedPreferences methods
-----------------------------|---------------------------------------
`PrefNotifier<bool>`         | `.setBool` `.getBool` `.remove`
`PrefNotifier<int>`          | `.setInt` `.getInt` `.remove`
`PrefNotifier<double>`       | `.setDouble` `.getDouble` `.remove`
`PrefNotifier<String>`       | `.setString` `.getString` `.remove`
`PrefNotifier<List<String>>` | `.setStringList` `.getStringList` `.remove`

## PrefNotifier vs SharedPreferences

`myParam = PrefNotifier<int>('MyParameter')` | `prefs = await SharedPreferences.getInstance()`
--------------------------------|-----------------------------------------------
`myParam.value = 42`              | `await prefs.setInt('MyParameter', 42)`
`int? x = myParam.value`       | `int? x = await prefs.getInt('MyParameter')`
`myParam.value = null`         | `await prefs.remove('MyParameter')`

But the most great is

``` dart
myParam.addListener(() => print('Value changed! New value: ${myParam.value}');
```

# How to use PrefNotifier?

## Create 

``` dart
final myParam = PrefNotifier<int>("MyParameter");
```

<details>
    <summary>Before 1.0.0 and sound null safety it's PrefItem</summary>

``` dart
final myParam = PrefItem<int>(SharedPrefsStorage(), "MyParameter");
```

In newer version of the library `PrefItem` works as well. `PrefNotifier` is an easier to use alias.   

</details>


## Read 

Reading is is not finished yet. But we already can access `myParam.value`. By default, it returns `null`.
We can use it in synchronous code:

``` dart
Widget build(BuildContext context) {
    if (myParam.value==null)
        return Text("Not initialized yet");
    else
        return Text("Value is ${myParam.value}");
}
```

Since `PrefNotifier` inherits from the `ValueNotifier`, we can automatically 
rebuild the widget when the new value of `myParam` will be available:

``` dart
Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: myParam,
        builder: (BuildContext context, int? value, Widget child) {
            if (value==null)
                return Text("Not initialized yet");
            else
                return Text("Value is $value");
        });
}
```

## Write 

The code above will also rebuild the widget when value is changed. Let's change the value in a button callback:

``` dart
onTap: () {
    // param.value is 3, shared preferences value is 3

    myParam.value += 1;
    myParam.value += 1;

    // param.value is already changed to 5
    //
    // The widget will rebuild momentarily (i.e. on the next frame)
    //
    // Shared preferences still contain value 3. But asynchronous writing
    // already started. It will rewrite value in a few milliseconds
}
```

## Load

For a newly created `PrefNotifier` the `value` returns `null` until the object 
reads the actual data from the storage. Asynchronous **loading starts 
automatically when the object is created**.
 
But what if we want to get the loaded data before doing anything else?

``` dart

final myParam = PrefNotifier<int>("TheParameter");
await myParam.initialized;

// we waited while the object was reading the data.
// Now myParam.value returns the value from the storage, not default NULL.
// Even if it is NULL, it is a NULL from the storage :)

```

## Keep in sync

Create a **single instance** of PrefNotifier for a **particular 
parameter**. Only access this parameter with this PrefNotifier instance.

``` dart
final myParam = PrefNotifier<int>("MyParameter");
myParam.value = 5;

await (await SharedPreferences.getInstance())
    .setInt("MyParameter", 10); // DON'T DO THIS

var otherNotifier = PrefNotifier<int>("MyParameter"); // DON'T DO THIS
otherNotifier = 20;

// now the myParam.value is still 5.
// And the myParam has no idea it is changed
```
