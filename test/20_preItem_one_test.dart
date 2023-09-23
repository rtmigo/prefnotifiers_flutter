// Copyright (c) 2021 Artёm Galkin <github.com/rtmigo>. All rights reserved.
// Use of this source code is governed by the BSD-3-Clause license found
// in the LICENSE file in the root directory of this source tree

import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:prefnotifiers/prefnotifiers.dart';

void main() {
  test('RamPrefsStorage read-write', () async {
    final storage = RamPrefsStorage();

    final pi = PrefItem<String>(storage, 'pi');

    //expect(() async => await pi.read(), throwsA(isA<PrefItemNotFoundError>()));
    expect(await pi.read(), null);

    await pi.write('alpha');
    expect(await pi.read(), 'alpha');
    expect(pi.value, 'alpha');

    await pi.write('beta');
    expect(await pi.read(), 'beta');
    expect(pi.value, 'beta');

    var future = pi.write('gamma');
    expect(pi.value, 'gamma'); // значение value обновляется сразу, хотя запись может быть асинхронной
    await future;

    pi.value = 'delta';
    expect(pi.value, 'delta');
    await Future<dynamic>.delayed(const Duration(milliseconds: 10));
    expect(await pi.read(), 'delta');

    await pi.write(null);
    //expect(() async => await pi.read(), throwsA(isA<PrefItemNotFoundError>()));
    expect(await pi.read(), null);
  });
}
