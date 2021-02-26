// Copyright (c) 2021 Artёm Galkin. All rights reserved.
// Use of this source code is governed by the BSD-3-Clause license found
// in the LICENSE file in the root directory of this source tree

import 'dart:async';

import 'package:flutter/foundation.dart';

import '01_logging.dart';
import '01_prefsStorage.dart';
import '10_awaitableCalls.dart';

//class PrefItemNotFoundError implements Exception {} // outdated?
//class PrefItemNotInitializedError implements Exception {}  // outdated?

typedef CheckValueFunc<T>(T val);
typedef T AdjustFunc<T>(T old);

/// Represents a particular named value in a [PrefsStorage].
///
/// The [value] property acts like a synchronous "cache", while real reading and writing
/// is done asynchronously in background.
///
/// For a newly created object the [value] always returns [null], since the data is not read yet.
class PrefItem<T> extends ChangeNotifier implements ValueNotifier<T> {
  PrefItem(
    this.storage,
    this.key, {
    T initFunc(),
    @deprecated this.checkValue,
  }) {
    this._initCompleter = Completer<PrefItem<T>>();
    this._initCompleteFuture = this._initCompleter.future;

    if (initFunc != null)
      this._init(initFunc);
    else
      this.read();
  }

  @override
  void dispose() {
    this._isDisposed = true;
    super.dispose();
  }

  /// Returns [true] after [dispose] was called.
  bool get isDisposed => _isDisposed;
  bool _isDisposed = false;

  T _value;
  bool _valueInitialized = false;

  /// The current item key (or name, or id - depending on the storage).
  final String key;

  /// The parent storage containing the current item.
  final PrefsStorage storage;

  /// An optional callback that will be called before changing the [value] or saving a new value to the storage.
  ///
  /// If the value is invalid, the callback can throw an exception.
  final CheckValueFunc<T> checkValue;

  ////////
  // firstReadOrWrite позволяет дождаться загрузки интересующего значения

  Completer<PrefItem<T>> _initCompleter;
  Future<PrefItem<T>> _initCompleteFuture;

  /// Future completes when the object initialization completes. That means we have read value or NULL from the storage.
  Future<PrefItem<T>> get initialized => _initCompleteFuture;
  bool get isInitialized => _initCompleter.isCompleted;

  /// Reads and returns the data from storage. [value] property will also be updated.
  Future<T> read() async {
    if (this.isDisposed) return null;

    await this._writeCalls.completed();

    // we cannot change the value of disposed ValueNotifer
    if (this.isDisposed) return null;

    T t;

    if (T == int)
      t = await storage.getInt(key) as T;
    else if (T == String)
      t = (await storage.getString(key)) as T;
    else if (T == double)
      t = await storage.getDouble(key) as T;
    else if (T == bool)
      t = await storage.getBool(key) as T;
    else if (T == List)
      t = await storage.getStringList(key) as T;
    else if (T == DateTime)
      t = await storage.getDateTime(key) as T;
    else
      throw FallThroughError();

    logInfo("PrefItem: read $key, result=$t");

    this.value = t;

    return t;
  }

  Future<T> _init(T initFunc()) async {
    if (this.isDisposed) return null;
    //if (this.isInitialized)
    //throw StateError("");

    T t = await this.read();

    if (this.isDisposed) return null;

    if (t != null) return t;

    t = initFunc();
    if (t == null) throw ArgumentError("Init returns NULL.");
    await this.write(t);

    if (this.isDisposed) return null;

    return this.read();
  }

  /// Returns TRUE if we have the value in storage, otherwise FALSE.
  Future<bool> defined() async {
    if (this.isDisposed) return null;

    return (await this.read()) != null;
  }

  /// Reads an existing value, computes a new one with [AdjustFunc] and writes the new value to the storage.
  Future<T> adjust(AdjustFunc f) async {
    if (this.isDisposed) return null;

    var oldVal = await this.read();

    if (this.isDisposed) return null;

    var newVal = f(oldVal);
    await this.write(newVal);

    if (this.isDisposed) return null;

    return newVal;
  }

  Future<void> write(T value) {
    // значение value обновляем синхронно, а пишем после этого асинхронно.
    // Т.е. сразу после вызова у нас появится обновленное value, но сохранится оно с задержкой.

    if (this.checkValue != null) this.checkValue(value);
    this.value = value;

    return this._writeAsync(value);
  }

  // этот объект позволит дождаться окончания всех процедур записи, прежде чем значение будет прочитано
  final _writeCalls = AwaitableCalls();

  Future<void> _writeAsync(T value) async {
    if (this.isDisposed) return;

    logInfo("Writing $key=$value");

    this._writeCalls.run(() async {
      if (this.isDisposed) return;

      if (T == int)
        await storage.setInt(key, value as int);
      else if (T == String)
        await storage.setString(key, value as String);
      else if (T == double)
        await storage.setDouble(key, value as double);
      else if (T == bool)
        await storage.setBool(key, value as bool);
      else if (T == DateTime)
        await storage.setDateTime(key, value as DateTime);
      else if (T == List)
        await storage.setStringList(key, value as List<String>);
      else
        throw FallThroughError();
    });
  }

  set value(T newValue) {
    if (this._valueInitialized && newValue == this._value) return;

    if (this.checkValue != null) this.checkValue(newValue);

    this._value = newValue;
    this._valueInitialized = true;

    this.notifyListeners();

    if (!this._initCompleter.isCompleted) this._initCompleter.complete(this);

    this._writeAsync(newValue);
  }

  T get value {
    if (!this._valueInitialized) return null;
    return this._value;
  }

  /// Allows to wait when for the first value being asynchronously read after object creation.
  ///
  /// ```final pi=PrefItem<int>(storage, key);
  /// final x = await pi.initializedValue;```
  Future<T> get initializedValue =>
      this.initialized.then((prefitem) => prefitem.value);

  void toWaitList(List<Future> list) {
    list.add(this.initialized);
  }
}
