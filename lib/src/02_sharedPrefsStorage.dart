// Copyright (c) 2021 Artёm Galkin. All rights reserved.
// Use of this source code is governed by the BSD-3-Clause license found
// in the LICENSE file in the root directory of this source tree

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '01_prefsStorage.dart';
import '02_ramPrefsStorage.dart';

/// A [PrefsStorage] that stores the data in platform-dependent [SharedPreferences].
class SharedPrefsStorage extends PrefsStorage
{
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