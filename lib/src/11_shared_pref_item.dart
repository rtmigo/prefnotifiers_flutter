import 'package:prefnotifiers/prefnotifiers.dart';

class PrefNotifier<T> extends PrefItem<T> {
  PrefNotifier(String key, {
    T Function()? initFunc,
    checkValue,
  }): super(_commonStorage, key, initFunc: initFunc, checkValue: checkValue);

  static SharedPrefsStorage? _commonStorageVal;
  static SharedPrefsStorage get _commonStorage {
    return _commonStorageVal ??= SharedPrefsStorage();
    //return _commonStorageVal;
  }
}
