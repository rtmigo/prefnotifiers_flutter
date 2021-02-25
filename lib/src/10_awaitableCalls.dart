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