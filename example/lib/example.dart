import 'package:flutter/material.dart';
import 'package:prefnotifiers/prefnotifiers.dart';

void main() => runApp(new MyApp());

// this int value will be stored permanently in shared preferences
final pushesCountPref = PrefNotifier<int>('buttonPushesCount');

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
          body: Center(
              child: Column(mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

            Text('You have pushed the button this many times:'),

            // SHOWING THE VALUE
            // the following widget will be automatically rebuilt when
            // PrefNotifier finishes loading and/or when its value changes
            ValueListenableBuilder(
                valueListenable: pushesCountPref,
                builder: (context, value, child) =>
                    Text(pushesCountPref.value.toString())),

            // CHANGING THE VALUE
            MaterialButton(
                child: Text("Increment and save"),
                color: Colors.amberAccent,
                onPressed: () async {

                  // make sure the value is already loaded
                  await pushesCountPref.initialized;

                  // update the value
                  pushesCountPref.value = (pushesCountPref.value ?? 0) + 1;

                  // ok, the value is already increased (widgets will see
                  // it on the next frame). Asynchronous writing of it in
                  // the SharedPreferences has also begun.
                  //
                  // By the way, awaiting for pushesCountPref.initialized
                  // was optional. PrefNotifier didn't need it.
                  //
                  // But our program could calculate the wrong new value,
                  // taking null for 0, when it just meant "not loaded yet".

                })

        ])));
  }
}
