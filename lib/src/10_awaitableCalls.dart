// Copyright (c) 2021 Artёm Galkin.
// Use of this source code is governed by a MIT license.
// See LICENSE file for details

import 'dart:async';

/// Controls the asynchronous read and write process so that reads occur only after all writes have completed.
///
/// To create object:
/// ```
///   final writingCalls = AwaitableCalls();
/// ```
///
/// To write:
/// ```
///   writingCalls.run(writeFunc)
/// ```
///
/// To read (but only when writing completed):
/// ```
///   await writingCalls.completed();
///   await readFunc();
/// ```
class AwaitableCalls
{
  List<Completer> _items = List<Completer>();

  Future run(func) async
  {
    Completer c = Completer();
    this._items.add(c);

    try
    {
      return await func();
    }
    catch (error, stack)
    {
      c.completeError(error, stack);
      c = null;
      rethrow;
    }
    finally
    {
      if (c!=null)
        c.complete();
      this._items.remove(c);
    }
  }

  Future<void> completed() async
  {
    while (this._items.length>0)
      await this._items[0].future;
  }
}