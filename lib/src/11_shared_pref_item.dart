import 'package:flutter/cupertino.dart';
import 'package:prefnotifiers/prefnotifiers.dart';

class PrefNotifierTypeError extends TypeError {
  String key;
  Type type;
  Type typeB;
  PrefNotifierTypeError(this.key, this.type, this.typeB);

  @override
  String toString() {
    return 'A $type has already been declared for key "$key". '
        'Cannot create PrefNotifier<$typeB> for the same key.';


  }
}

class PrefNotifier<T> extends PrefItem<T> {
  PrefNotifier(String key, {
    T Function()? initFunc,
    checkValue,
  }
  ): super(_commonStorage, key, initFunc: initFunc, checkValue: checkValue);

  static SharedPrefsStorage? _commonStorageVal;
  static SharedPrefsStorage get _commonStorage {
    return _commonStorageVal ??= SharedPrefsStorage();
  }

}
