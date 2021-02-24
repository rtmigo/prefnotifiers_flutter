# prefnotifiers

This library makes it easy to use [shared_preferences](https://pub.dev/packages/shared_preferences) with
state management libraries like [provider](https://pub.dev/packages/provider) or `ValueListenableBuilder` widgets.

`PrefItem` inherits from the `ValueNotifier` class. PrefItem serves as a **model** for an individual preference
parameter. It reads and writes data asynchronously. But `PrefItem.value` provides *"the best value we have for the moment"* in synchronous manner.

Suppose, we have parameter named *TheParameter* is the shared preferences. It's value is 3.

Let's declare the model for this parameter:

```
final theParameter = PrefItem<int>(storage, "TheParameter");
```

Reading is is not finished yet. But we already can access `theParameter.value`. By default, it returns `null`.
We can use it in synchronous code:

```
Widget build(BuildContext context) {
    if (theParameter.value==null)
        return Text("Not initialized yet");
    else
        return Text("Value is ${theParameter.value}");
}
```

We also can rebuild the widget when the value will be available:

```
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

Changes to the `value` will be immediately available, although actual writing may take some time. The following code
increases value by two:

```

onTap: () {
    // myParameter.value is 3, shared prefs is 3
    myParameter.value += 1;
    myParameter.value += 1;
    // myParameter.value is 5, shared prefs is still 3,
    // but will be written asynchronously soon
}

```

A few miiliceonds later

Let's wait for :

```
await myValueModel.initialized;
```



Now `myValueModel.value` returns the actual value that was stored in preferences. Let's change it:

```
myValueModel.value = 5;
```

Now `myValueModel.value` returns 5. And asynchronous writing started.



// now the value is readt  myValueModel.value returns returns null

```



Now we



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

