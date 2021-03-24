import 'package:prefnotifiers/prefnotifiers.dart';

class SharedPref<T> extends PrefItem<T> {
  SharedPref(String key, {
    T Function()? initFunc,
    checkValue,
  }): super(SharedPrefsStorage(), key, initFunc: initFunc, checkValue: checkValue);
}
