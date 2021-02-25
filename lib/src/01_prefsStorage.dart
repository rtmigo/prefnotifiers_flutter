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