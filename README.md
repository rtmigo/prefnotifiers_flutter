# prefnotifiers

Wraps particular app settings into `ValueNotifier` instances, so they can be used with `ValueListenableBuilder`
or [Provider](https://pub.dev/packages/provider).

Without **prefnotifiers** we can read and write preferences asynchronously:

```
import 'package:shared_preferences/shared_preferences.dart';

Future<int> readInt() async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.getInt("intName");
}
```

But where do we keep this `int`? How do we update GUI when it's read or changed?

The **prefnotifiers** approach is to wrap each preferences parameter as


`PrefItem` instances

But how do we use those asynchronous values when building widgets synchonously?

with prefinotifiers:

```
import 'package:prefnotifiers/prefnotifiers.dart';

final ValueNotifier<int> myValue = PrefItem<int>(storage, "intName");

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

