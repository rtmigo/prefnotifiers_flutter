// Copyright (c) 2021 Artёm Galkin <github.com/rtmigo>. All rights reserved.
// Use of this source code is governed by the BSD-3-Clause license found
// in the LICENSE file in the root directory of this source tree

import 'package:flutter_test/flutter_test.dart';
import 'package:prefnotifiers/src/11_shared_pref_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    //PrefNotifier.resetInstances();
  });

  test('get set', () async {
    final a = PrefNotifier<int>('keyIntA');

    expect(a.value, null);
    a.value = 5;
    expect(a.value, 5);
    expect(await a.read(), 5);
  });

  //Future<SharedPreferences> spi() => SharedPreferences.getInstance();

  void tst<T>(T newValue, T? Function(SharedPreferences sp, String key) getStoredValue) {

    assert(T!=Null);

    test('read write $T', () async {
      //SharedPreferences.setMockInitialValues({});
      final spi = await PrefNotifier.commonStorage.sp;
      final key = 'keyA$T';

      expect(getStoredValue(spi, key), isNull);

      // reading null
      final a = PrefNotifier<T>(key);
      await a.initialized;
      expect(a.value, null);

      // writing
      await a.write(newValue);

      // check it's written
      expect(a.value, newValue);
      expect(await a.read(), newValue);
      expect(getStoredValue(spi, key), newValue);
    });
  }

  tst<String>('new value', (spi, key)=>spi.getString(key));
  tst<int>(10, (spi, key)=>spi.getInt(key));
  tst<double>(10.10, (spi, key)=>spi.getDouble(key));
  tst<bool>(true, (spi, key)=>spi.getBool(key));
  tst<List<String>>(['abc','def'], (spi, key)=>spi.getStringList(key));

}
