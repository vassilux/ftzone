import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:ftzone/logic/bloc/geolocation/geolocation_bloc.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:ftzone/model/setting.dart';
import 'package:ftzone/model/settings.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SharedPreferences sharedPreferences;
  final List<Setting> _usageSettings;  

  SettingsBloc({@required this.sharedPreferences, @required List<Setting> usageSettings, @required GeolocationBloc geolocBloc}) : 
      _usageSettings = usageSettings,     
        assert(sharedPreferences != null),
        assert(usageSettings != null) {
          geolocBloc.listen((state) {

            if (state is GeolocationHomeLoaded) {
            var homeLatitude = Setting<double>(
                key: 'home_latitude', initValue: 0, value: state.latitude);
            
            _setSetting(homeLatitude);

            var homeLongitude = Setting<double>(
                key: 'home_longitude', initValue: 0, value: state.longitude);
            _setSetting(homeLongitude);
            add(RefreshedSettings());
          }

          });
        }

  @override
  SettingsState get initialState => _loadSettings();

  SettingsState _loadSettings() {
    var preferencesMap = Map<String, Setting>();
    _usageSettings
        .map((preference) => _getPreference(preference))
        .forEach((preference) => preferencesMap[preference.key] = preference);
    
    return SettingsInitial(
      settings: Settings(preferencesMap),
    );
  }

   Setting _getPreference(Setting setting) {
    var settingType = setting.typeOfPreference();
    if (settingType == int) {
      setting.value = sharedPreferences.getInt(setting.key);
    } else if (settingType == double) {
      setting.value = sharedPreferences.getDouble(setting.key);
    } else if (settingType == String) {
      setting.value = sharedPreferences.getString(setting.key);
    } else if (settingType == bool) {
      setting.value = sharedPreferences.getBool(setting.key);
    } else if (settingType == List) {
      setting.value = sharedPreferences.getStringList(setting.key);
    } else {
      throw Exception();
    }
    if (setting.value == null) {
      setting.value = setting.initValue;
    }
    return setting;
  }

  Future _setSetting(Setting setting) async {
    var settingType = setting.typeOfPreference();
    if (settingType == int) {
      await sharedPreferences.setInt(setting.key, setting.value);
    } else if (settingType == double) {
      await sharedPreferences.setDouble(setting.key, setting.value);
    } else if (settingType == String) {
      await sharedPreferences.setString(setting.key, setting.value);
    } else if (settingType == bool) {
      await sharedPreferences.setBool(setting.key, setting.value);
    } else if (settingType == List) {
      await sharedPreferences.setStringList(setting.key, setting.value);
    } else {
      throw Exception();
    }
  }

  /// Returns [Setting] by key from [Settings]
  Setting<T> getSetting<T>(String key) {
    return state.settings.get<T>(key);
  }



  @override
  Stream<SettingsState> mapEventToState(
    SettingsEvent event,
  ) async* {
    if(event is FetchSettings) {
      yield* _mapFetchSettings(event);

    }

    if(event is UpdateSetting) {
      yield* _mapUpdateSetting(event);
    }

    if(event is RefreshedSettings) {
      yield* _mapRefreshSettings(event); 

    }

    
  }

  Stream<SettingsState> _mapRefreshSettings(RefreshedSettings event) async* {
    yield SettingsLoading();
    try {    
      //
      yield _loadSettings(); 

    } catch (_) {
      yield SettingsError();

    }
  }


  Stream<SettingsState> _mapFetchSettings(FetchSettings event) async* {
    yield SettingsLoading();
    try {    
      //
      yield _loadSettings(); 

    } catch (_) {
      yield SettingsError();

    }
  }

  Stream<SettingsState> _mapUpdateSetting(UpdateSetting event) async* {
    try {    
      //
      var updatedPreference = event.updateSetting;
      await _setSetting(updatedPreference);
      yield _loadSettings();

    } catch (_) {
      yield SettingsError();

    }
  }

}
