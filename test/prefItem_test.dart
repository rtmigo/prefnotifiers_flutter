// Copyright (c) 2021 Artёm Galkin. All rights reserved.
// Use of this source code is governed by the BSD-3-Clause license found
// in the LICENSE file in the root directory of this source tree

import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:prefnotifiers/prefnotifiers.dart';

void main() {

  throw Error(); // fail in dev branch

  test('adjust simple', () async {
    final storage = RamPrefsStorage();

    final pi = PrefItem<int>(storage, "pi");
    expect(await pi.read(), null);

    pi.write(0);
    expect(await pi.read(), 0);

    expect(await pi.adjust((old) => old + 1), 1);
    expect(await pi.read(), 1);

    expect(await pi.adjust((old) => old + 1), 2);
    expect(await pi.read(), 2);
  });

  test('PrefItem write completers', () async {
    final storage = RamPrefsStorage();

    final pi = PrefItem<int>(storage, "pi");

    // запускаю кучу спонтанных операций записи. Но read прочитает значение только когда
    // все процедуры записи завершатся

    pi.write(1);
    await pi.write(2);
    pi.write(3);
    pi.write(4);
    await pi.write(5);
    pi.write(6);
    pi.write(7);
    pi.write(8);
    pi.write(9);

    expect(await pi.read(), 9);
  });

  test('PrefItem checking', () async {
    final storage = RamPrefsStorage();

    final pi = PrefItem<int>(storage, "pi", checkValue: (val) {
      //print("checkValue $val");
      if (val < 0) throw ArgumentError.value(val);
    });

    await pi.write(0);
    await pi.write(1);
    await pi.write(2);

    expect(() async => await pi.write(-1), throwsArgumentError);
    expect(() => pi.value = -2, throwsArgumentError);
  });

  test('PrefItem async reading by the constructor', () async {
    final storage = RamPrefsStorage();
    await storage.setInt("x", 23);

    final pi = PrefItem<int>(storage, "x");
    expect(pi.value, null);
    var a = await pi.initialized; // дожидаемся, пока значение подгрузится
    var b = await pi.initialized; // повторное ожидание погоды не делает

    expect(a, pi); // это тот же экземпляр
    expect(b, pi);

    expect(pi.value, 23);
    expect(a.value, 23);
  });

  test('PrefItem.initialized when no value in storage', () async {
    int notifications = 0;
    final storage = RamPrefsStorage();

    final pi = PrefItem<int>(storage, "unset");
    pi.addListener(() {
      notifications++;
    });

    expect(pi.isInitialized, false);
    expect(pi.value, null);
    expect(notifications, 0);

    await pi.initialized; // дожидаемся, пока значение подгрузится
    await pi.initialized; // повторное ожидание погоды не делает

    expect(pi.value, null);
    expect(pi.isInitialized, true);
    expect(notifications, 1); // значение value не изменилось (осталось NULL), но значение isInitialized изменилось

    pi.value = null;
    expect(notifications, 1); // ничто не изменилось

    pi.value = 23;
    expect(notifications, 2); // изменилось

    pi.value = 105;
    expect(notifications, 3); // изменилось

    expect(pi.isInitialized, true);
  });

  test('PrefItem writing value before reading', () async {
    testVal(initialVal) async {
      int notifications = 0;
      final storage = RamPrefsStorage();
      if (initialVal != null) storage.setInt("x", initialVal);

      final pi = PrefItem<int>(storage, "x");
      pi.addListener(() {
        notifications++;
      });
      expect(pi.isInitialized, false);
      pi.value = 23;
      expect(pi.isInitialized, true);
      expect(pi.value, 23);

      // хотя асинхронное чтение идет ПОСЛЕ этого - значением остается 23, а не исходное

      await Future.delayed(Duration(milliseconds: 100));
      expect(pi.value, 23);
      expect(notifications, 1);
    }

    await testVal(null);
    await testVal(13);
  });

  test('PrefItem firstReadOrWrite', () async {
    final storage = RamPrefsStorage();
    final pi = PrefItem<int>(storage, "x");
    expect(pi.value, null);
    expect(pi.isInitialized, false);
    pi.write(23); // это синхронная функция
    expect(pi.isInitialized, true);
    expect(pi.value, 23); // значение изменилось сразу
  });

  test('PrefItem constructor reading', () async {
    final storage = RamPrefsStorage();
    storage.setInt("x", 23);
    final pi = PrefItem<int>(storage, "x");
    expect(pi.value, null);
    await pi.initialized;
    expect(pi.value, 23);
  });

  test('PrefItem constructor initializing NULL', () async {
    final storage = RamPrefsStorage();
    final pi = PrefItem<int>(storage, "x", initFunc: () => 42);
    expect(pi.value, null);
    await pi.initialized;
    expect(pi.value, 42);
  });

  test('PrefItem constructor NOT initializing', () async {
    // функция инициализации задана, но значение уже есть - и потому не должно измениться

    final storage = RamPrefsStorage();
    storage.setInt("x", 23);
    final pi = PrefItem<int>(storage, "x", initFunc: () => 42);
    expect(pi.value, null);
    await pi.initialized;
    expect(pi.value, 23);
  });
}
