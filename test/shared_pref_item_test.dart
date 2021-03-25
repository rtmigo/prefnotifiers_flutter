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
    PrefNotifier.resetInstances();
  });

  test('get set', () async {
    final a = PrefNotifier<int>('keyIntA');

    expect(a.value, null);
    a.value = 5;
    expect(a.value, 5);
    expect(await a.read(), 5);
  });

  test('read write', () async {
    final a = PrefNotifier<String>('keyA');

    await a.initialized;

    expect(a.value, null);

    await a.write('new value');

    expect(a.value, 'new value');
    expect(await a.read(), 'new value');
  });

  test('is singleton', () async {
    final a = PrefNotifier<String>('theKey');
    final b = PrefNotifier<String>('theKey');

    await a.initialized;
    await b.initialized;

    expect(a.value, null);
    expect(b.value, null);

    a.value = 'haha';
    expect(b.value, 'haha');
  });

  test('singleton cannot redefine type', () async {
    PrefNotifier<int>('notifierInt');
    expect(()=>PrefNotifier<String>('notifierInt'), throwsA(isA<PrefNotifierTypeError>()));
  });

  // test('is singleton 2', () async {
  //   final a = PrefNotifier<String>('theKey');
  //   final b = PrefNotifier<String>('theKey');
  //
  //   await a.initialized;
  //   await b.initialized;
  //
  //   expect(a.value, null);
  //   expect(b.value, null);
  //
  //   a.value = 'haha';
  //   expect(b.value, 'haha');
  // });
}
