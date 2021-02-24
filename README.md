# prefnotifiers

This library makes it easy to use [shared_preferences](https://pub.dev/packages/shared_preferences) with
state management libraries like [provider](https://pub.dev/packages/provider) or `ValueListenableBuilder` widgets.

`PrefItem` inherits from the `ValueNotifier` class. PrefItem serves as a **model** for an individual preference
parameter. It reads and writes data asynchronously. But `PrefItem.value` provides *"the best value we have for the moment"* in synchronous manner.

Suppose, we have parameter named *TheParameter* is the shared preferences.

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

We can automatically rebuild the widget when the value will be available:

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

The code above will also rebuild the widget when value is changed.

```
onTap: () {

    // myParameter.value is 3, shared prefs is 3

    myParameter.value += 1;
    myParameter.value += 1;

    // now myParameter.value changed to 5.
    // The widget will rebuild on the next frame.
    // Shared prefs is still 3, but asynchronous writing already started
}
```
