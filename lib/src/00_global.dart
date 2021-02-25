// Copyright (c) 2021 Artёm Galkin.
// Use of this source code is governed by a MIT license.
// See LICENSE file for details

var prefnotifiersLog = (String txt) => print("prefnotifiers: $txt");

/// Set ```prefnotifiersLogVerbose=null``` to mute verbose logging.
var prefnotifiersLogVerbose = (String txt) => prefnotifiersLog?.call(txt);