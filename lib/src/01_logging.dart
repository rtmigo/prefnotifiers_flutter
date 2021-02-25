// Copyright (c) 2021 Artёm Galkin. All rights reserved.
// Use of this source code is governed by the BSD-3-Clause license found
// in the LICENSE file in the root directory of this source tree

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