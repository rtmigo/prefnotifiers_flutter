// Copyright (c) 2021 Artyom Galkin
// 
// Use of this source code is governed by a MIT license:
// 
// Permission is hereby granted, free of charge, to any person obtaining a
// copy of this software and associated documentation files (the "Software"),
// to deal in the Software without restriction, including without limitation
// the rights to use, copy, modify, merge, publish, distribute, sublicense,
// and/or sell copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
// THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
// DEALINGS IN THE SOFTWARE.


import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:prefnotifiers/prefnotifiers.dart';

void main()
{
  test('RamPrefsStorage read-write', () async
  {
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

  test('RamPrefsStorage datetime', () async
  {
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