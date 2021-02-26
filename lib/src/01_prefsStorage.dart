// Copyright (c) 2021 Artёm Galkin. All rights reserved.
// Use of this source code is governed by the BSD-3-Clause license found
// in the LICENSE file in the root directory of this source tree

/// An abstract storage that reads and writes named values of certain types asynchronously.
abstract class PrefsStorage {
  /// Reads named value from the storage. Returns the read value or [null] if value does not exist.
  Future<String> getString(String key);

  /// Reads named value from the storage. Returns the read value or [null] if value does not exist.
  Future<bool> getBool(String key);

  /// Reads named value from the storage. Returns the read value or [null] if value does not exist.
  Future<int> getInt(String key);

  /// Reads named value from the storage. Returns the read value or [null] if value does not exist.
  Future<double> getDouble(String key);

  /// Reads named value from the storage. Returns the read value or [null] if value does not exist.
  Future<List<String>> getStringList(String key);

  /// Writes named value to the storage.
  Future<void> setString(String key, String value);

  /// Writes named value to the storage.
  Future<void> setDouble(String key, double value);

  /// Writes named value to the storage.
  Future<void> setInt(String key, int value);

  /// Writes named value to the storage.
  Future<void> setBool(String key, bool value);

  /// Writes named value to the storage.
  Future<void> setStringList(String key, List<String> value);

  Future<Set<String>> getKeys(String key);

  /// Writes named [DateTime] value to the storage.
  Future<void> setDateTime(String key, DateTime value) =>
      this.setString(key, value != null ? value.toIso8601String() : null);

  /// Reads named [DateTime] from to the storage. Returns the read value or [null] if value does not exist.
  Future<DateTime> getDateTime(String key) async {
    String val = await this.getString(key);
    if (val == null) return null;
    return DateTime.parse(val);
  }
}
