// Copyright (c) 2021 Artёm Galkin.
// Use of this source code is governed by a MIT license.
// See LICENSE file for details

/// An abstract storage that reads and writes named values of certain types asynchronously.
abstract class PrefsStorage
{
  Future<String> getString(String key);
  Future<bool> getBool(String key);
  Future<int> getInt(String key);
  Future<double> getDouble(String key);
  Future<List<String>> getStringList(String key);

  Future<void> setString(String key, String value);
  Future<void> setDouble(String key, double value);
  Future<void> setInt(String key, int value);
  Future<void> setBool(String key, bool value);
  Future<void> setStringList(String key, List<String> value);

  Future<Set<String>> getKeys(String key);

  Future<void> setDateTime(String key, DateTime value) => this.setString(key, value!=null ? value.toIso8601String() : null);
  Future<DateTime> getDateTime(String key) async
  {
    String val = await this.getString(key);
    if (val==null)
      return null;
    return DateTime.parse(val);
  }
}