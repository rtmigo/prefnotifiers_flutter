// Copyright (c) 2021 Artёm Galkin <github.com/rtmigo>. All rights reserved.
// Use of this source code is governed by the BSD-3-Clause license found
// in the LICENSE file in the root directory of this source tree

import 'package:prefnotifiers/prefnotifiers.dart';

class PrefNotifier<T> extends PrefItem<T> {
  PrefNotifier(
    String key, {
    T Function()? initFunc,
    checkValue,
  }) : super(commonStorage, key, initFunc: initFunc, checkValue: checkValue);

  static SharedPrefsStorage? _commonStorageVal;

  static SharedPrefsStorage get commonStorage {
    return _commonStorageVal ??= SharedPrefsStorage();
  }

  //static
}
