// Copyright (c) 2021 Artёm Galkin <github.com/rtmigo>. All rights reserved.
// Use of this source code is governed by the BSD-3-Clause license found
// in the LICENSE file in the root directory of this source tree

import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:prefnotifiers/prefnotifiers.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();

  });

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });


  void tst<T>(T a, T b,
      Future<T?> Function(SharedPrefsStorage rps, String key) getFunc,
      Future<void> Function(SharedPrefsStorage rps, String key, T? val) setFunc) {
    test(T.toString(), () async {
      final storage = SharedPrefsStorage();
      expect(await getFunc(storage, 'key'), null);

      await setFunc(storage, 'key', null);
      expect(await getFunc(storage, 'key'), null);

      await setFunc(storage, 'key', a);
      expect(await getFunc(storage, 'key'), a);

      expect(await getFunc(storage, 'otherKey'), null);
      await setFunc(storage, 'otherKey', b);
      expect(await getFunc(storage, 'otherKey'), b);

      await setFunc(storage, 'key', b);
      expect(await getFunc(storage, 'key'), b);
      await setFunc(storage, 'key', null);
      //expect(false, isTrue);
      expect(await getFunc(storage, 'key'), null);
    });
  }

  tst<String>('value a', 'value b',
      (rps, key) => rps.getString(key),
      (rps, key, value) => rps.setString(key, value));

  tst<int>(5, 10,
          (rps, key) => rps.getInt(key),
          (rps, key, value) => rps.setInt(key, value));

  tst<double>(5.0, 3.141593,
          (rps, key) => rps.getDouble(key),
          (rps, key, value) => rps.setDouble(key, value));

  tst<bool>(false, true,
          (rps, key) => rps.getBool(key),
          (rps, key, value) => rps.setBool(key, value));


  tst<List<String>>(['a', 'bb', 'ccc'], ['bb', 'ccc', 'aaa'],
          (rps, key) => rps.getStringList(key),
          (rps, key, value) => rps.setStringList(key, value));

  tst<DateTime>(DateTime(2001,1,1, 00,00,00), DateTime(2021,03,23, 20,38,00),
          (rps, key) => rps.getDateTime(key),
          (rps, key, value) => rps.setDateTime(key, value));
}