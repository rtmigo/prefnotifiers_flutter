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
  PrefNotifier._(String key//, {
    //T Function()? initFunc,
    //checkValue,
  //}
  ): super(_commonStorage, key);

  static SharedPrefsStorage? _commonStorageVal;
  static SharedPrefsStorage get _commonStorage {
    return _commonStorageVal ??= SharedPrefsStorage();
    //return _commonStorageVal;
  }

  factory PrefNotifier(String key) {

    PrefNotifier<dynamic>? dynamicNotifier = _instances[key];
    if (dynamicNotifier!=null) {
      try {
        return dynamicNotifier as PrefNotifier<T>;
      }
      catch (_) {
        throw PrefNotifierTypeError(key, dynamicNotifier.runtimeType, T);
      }
    }

    PrefNotifier<T> newNotifier = PrefNotifier<T>._(key);
    assert(_instances[key]==null);
    _instances[key]=newNotifier;

    assert(_instances[key]==newNotifier);
    return newNotifier;
  }

  static final Map<String,PrefNotifier> _instances = <String,PrefNotifier>{};

  @visibleForTesting
  static void resetInstances() {
    _instances.clear();
  }

  //SingletonOne._privateConstructor();

  //static final SingletonOne _instance = SingletonOne._privateConstructor();
}
