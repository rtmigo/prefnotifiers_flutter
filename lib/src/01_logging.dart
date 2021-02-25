// Copyright (c) 2021 Artёm Galkin.
// Use of this source code is governed by a MIT license.
// See LICENSE file for details

import '00_global.dart';

void logPrint(String txt) {
  print("prefnotifiers: $txt");
}

void logInfo(String txt) {
  if (prefnotifiersLog)
    logPrint(txt);
}

void logVerbose(String txt) {
  if (prefnotifiersLog && prefnotifiersLogVerbose)
    logPrint(txt);
}