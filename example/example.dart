import 'package:flutter/material.dart';
import 'package:prefnotifiers/prefnotifiers.dart';

void main() => runApp(new MyApp());

class Preferences {
  // this value will be stored permanently in shared preferences
  static PrefItem<int> rememberMe =
      PrefItem<int>(SharedPrefsStorage(), "rememberMeId");
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Example")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('You have pushed the button this many times:'),
            // the following widget will be automatically rebuilt when PrefItem finishes loading
            // and/or when its PrefItem.value changes
            ValueListenableBuilder(
                valueListenable: Preferences.rememberMe,
                builder: (context, value, child) {
                  // PrefItem returns NULL:
                  // - when a value with that name does not exist
                  // - when it is not yet asynchronously read
                  // Let's just be ready for NULL
                  final x = Preferences.rememberMe.value ?? 0;
                  return Text(x.toString());
                }),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () => Preferences.rememberMe.value =
            (Preferences.rememberMe.value ?? 0) + 1,
        tooltip: 'Increment and save',
        child: new Icon(Icons.add),
      ),
    );
  }
}
