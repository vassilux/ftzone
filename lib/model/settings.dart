
import 'package:ftzone/model/setting.dart';

class Settings {
  final Map<String, Setting> _settings;

  const Settings(this._settings);

  /// Get preference from lists
  Setting<T> get<T>(String key) {
    assert(key != null);
    return _settings.containsKey(key) ? _settings[key] : null;
  }
  
}