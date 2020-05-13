part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();
}


class FetchSettings extends SettingsEvent {
  const FetchSettings();

  @override 
  List<Object> get props => [];
}

class UpdateSetting extends SettingsEvent {
  final Setting updateSetting;
  const UpdateSetting(this.updateSetting);

  @override 
  List<Object> get props => [updateSetting];
}

class RefreshedSettings extends SettingsEvent {
  @override  
  List<Object> get props => [];
  
}
