# prefnotifiers

This library makes it easy to use [shared_preferences](https://pub.dev/packages/shared_preferences) with
state management libraries like [Provider](https://pub.dev/packages/provider).

`PrefItem` inherits from the `ValueNotifier` class. PrefItem serves as a "model" of an individual application
preference parameter.

Wraps individual application preference settings into a `ValueNotifier` instances.


 so they can be used with `ValueListenableBuilder`
or [Provider](https://pub.dev/packages/provider).

Without **prefnotifiers** we can read and write preferences asynchronously:

```
import 'package:shared_preferences/shared_preferences.dart';

Future<int> readInt() async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.getInt("intName");
}

Future<void> writeInt(int newValue) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setInt("intName", newValue);
}

```

But where do we keep this `int`? How do we update GUI when it's read or changed?

The **prefnotifiers** approach is to wrap each preference parameter into a `ValueNotifier` instance.

So we declare the parameter only once:

```
final ValueNotifier<int> myValue = PrefItem<int>(storage, "intName");
```

Now we can sync


`PrefItem` instances

But how do we use those asynchronous values when building widgets synchonously?

with prefinotifiers:

```
import 'package:prefnotifiers/prefnotifiers.dart';



class MyPrefs
{
    final ValueNotifier<int> intParam;
    final ValueNotifier<String> stringParam;

    MyPreferences(storage) :
        intParam = PrefItem<int>(storage, "intName"),
        stringParam = PrefItem<String>(storage, "stringName");
}

```

After creating `MyPrefs` instance we can access `myPrefs.intParam.value` in synchronous manner.

