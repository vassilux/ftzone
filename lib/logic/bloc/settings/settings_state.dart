
part of 'settings_bloc.dart';

abstract class SettingsState extends Equatable {
  final Settings settings;
  
  const SettingsState(
    this.settings,
  );

  @override
  List<Object> get props => [settings];
}

class SettingsInitial extends SettingsState {
  SettingsInitial({Settings settings}) : super(settings);    
}

class SettingsLoading extends SettingsState {  
  SettingsLoading() : super(null);
}


class SettingsLoaded extends SettingsState {
  SettingsLoaded({Settings settings}) : super(settings); 
}


class SettingsError extends SettingsState {  
  SettingsError() : super(null);
}
