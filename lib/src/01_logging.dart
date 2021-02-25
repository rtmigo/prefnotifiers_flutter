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
