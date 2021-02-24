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


import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '01_prefsStorage.dart';
import '02_ramPrefsStorage.dart';

/// A [PrefsStorage] that stores the data in platform-dependent [SharedPreferences].
class SharedPrefsStorage extends PrefsStorage
{
  // опирается на SharedPreferences из сторонней библиотеки

  Future<SharedPreferences> _sp = SharedPreferences.getInstance();

  Future<String> getString(String key) async => (await this._sp).getString(key);
  Future<bool> getBool(String key) async => (await this._sp).getBool(key);
  Future<int> getInt(String key) async => (await this._sp).getInt(key);
  Future<double> getDouble(String key) async => (await this._sp).getDouble(key);
  Future<List<String>> getStringList(String key) async => (await this._sp).getStringList(key);

  Future<void> setString(String key, String value) async => await (await this._sp).setString(key, value);
  Future<void> setDouble(String key, double value) async => await (await this._sp).setDouble(key, value);
  Future<void> setInt(String key, int value) async => await (await this._sp).setInt(key, value);
  Future<void> setBool(String key, bool value) async => await (await this._sp).setBool(key, value);
  Future<void> setStringList(String key, List<String> value) async => await (await this._sp).setStringList(key, value);

  Future<Set<String>> getKeys(String key) async => (await this._sp).getKeys();

  static Future<PrefsStorage> withTestingFallback() async
  {
    try
    {
      final result = SharedPrefsStorage();
      await result._sp;
      return result;
    }
    on MissingPluginException catch (_,__)
    {
      print("Using RamPrefsStorage instead of SharedPrefsStorage.");
      return RamPrefsStorage();
    }
  }

}