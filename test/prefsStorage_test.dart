// Copyright (c) 2021 Artёm Galkin. All rights reserved.
// Use of this source code is governed by the BSD-3-Clause license found
// in the LICENSE file in the root directory of this source tree

import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:prefnotifiers/prefnotifiers.dart';

void main() {
  test('RamPrefsStorage read-write', () async {
    final storage = RamPrefsStorage();

    final pi = PrefItem<String>(storage, "pi");

    //expect(() async => await pi.read(), throwsA(isA<PrefItemNotFoundError>()));
    expect(await pi.read(), null);

    await pi.write("alpha");
    expect(await pi.read(), "alpha");
    expect(pi.value, "alpha");

    await pi.write("beta");
    expect(await pi.read(), "beta");
    expect(pi.value, "beta");

    var future = pi.write("gamma");
    expect(pi.value, "gamma"); // значение value обновляется сразу, хотя запись может быть асинхронной
    await future;

    pi.value = "delta";
    expect(pi.value, "delta");
    await Future.delayed(Duration(milliseconds: 10));
    expect(await pi.read(), "delta");

    await pi.write(null);
    //expect(() async => await pi.read(), throwsA(isA<PrefItemNotFoundError>()));
    expect(await pi.read(), null);
  });

  test('RamPrefsStorage datetime', () async {
    final storage = RamPrefsStorage();

    final a = DateTime.now();
    await storage.setDateTime("a", a);
    expect((await storage.getDateTime("a")).isAtSameMomentAs(a), isTrue);

    final b = DateTime.now().toUtc();
    await storage.setDateTime("b", b);
    expect((await storage.getDateTime("b")).isAtSameMomentAs(b), isTrue);
    expect((await storage.getDateTime("b")).isAtSameMomentAs(a), isFalse);

    //final b = DateTime.now().toUtc();
    await storage.setDateTime("b", null);
    expect(await storage.getDateTime("b"), isNull);
  });
}
