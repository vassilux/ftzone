

import 'package:meta/meta.dart';


class Setting<T> {
  /// The key use in [SharedPreferences]
  final String key;

  /// The value of saved value in [SharedPreferences]
  T value;

  /// The init value of if not saved value in [SharedPreferences]
  final T initValue;

  Setting({
    @required this.key,
    this.value,
    @required this.initValue,
  });

  @override
  String toString() {
    return 'Preference{key: $key, value: $value, initValue: $initValue}';
  }

  /// Returns [Preference] generic type used in bloc
  Type typeOfPreference() => T;
}