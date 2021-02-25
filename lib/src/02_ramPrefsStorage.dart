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


import '01_prefsStorage.dart';

/// A [PrefsStorage] that keeps all the data in RAM only. Useful for testing.
class RamPrefsStorage extends PrefsStorage
{
  Map<String,dynamic> _data = Map<String,dynamic>();

  Future<String> getString(String key) async => _data[key];
  Future<bool> getBool(String key) async => _data[key];
  Future<int> getInt(String key) async => _data[key];
  Future<double> getDouble(String key) => _data[key];
  Future<List<String>> getStringList(String key) async => _data[key];

  Future<void> setString(String key, String value) async => _data[key] = value;
  Future<void> setDouble(String key, double value) async => _data[key] = value;
  Future<void> setInt(String key, int value) async => _data[key] = value;
  Future<void> setBool(String key, bool value) async => _data[key] = value;
  Future<void> setStringList(String key, List<String> value) async => _data[key] = value;

  Future<Set<String>> getKeys(String key) async => Set<String>.from(_data.values);
}