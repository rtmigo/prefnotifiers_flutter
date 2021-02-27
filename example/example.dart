import 'package:flutter/material.dart';
import 'package:prefnotifiers/prefnotifiers.dart';

void main() => runApp(new MyApp());

// this int value will be stored permanently in shared preferences
final pushesCount = PrefItem<int>(SharedPrefsStorage(), "buttonPushesCount");

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
      appBar: AppBar(title: Text("prefnotifiers demo")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('You have pushed the button this many times:'),
            // the following widget will be automatically rebuilt when PrefItem
            // finishes loading and/or when its PrefItem.value changes
            ValueListenableBuilder(
                valueListenable: pushesCount,
                builder: (context, value, child) {
                  final x = pushesCount.value ?? 0; // will show null as 0
                  return Text(x.toString());
                }),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () async {
          // make sure that loading completed
          // (it is enough to do it once)
          await pushesCount.initialized;
          // update the value
          pushesCount.value = (pushesCount.value ?? 0) + 1;
        },
        tooltip: 'Increment and save',
        child: new Icon(Icons.add),
      ),
    );
  }
}
