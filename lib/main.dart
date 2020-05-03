import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ftzone/utils/translations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
//bloc
import 'logic/bloc/geolocation/geolocation_bloc.dart';
import 'logic/bloc/settings/settings_bloc.dart';
import 'package:ftzone/logic/bloc/tracking/tracking_bloc.dart';
//
import 'myapp.dart';
import 'simple_bloc_delegate.dart';
import 'package:ftzone/model/setting.dart';


void main() async  {
  WidgetsFlutterBinding.ensureInitialized();
  //
  BlocSupervisor.delegate = SimpleBlocDelegate();
  //
  var sharedPreferences = await SharedPreferences.getInstance();
  //
   await allTranslations.init();
  //
  //runApp(MyApp());

  runApp(
    MultiBlocProvider(
      providers: [        
        BlocProvider<SettingsBloc>(
          create: (context) => SettingsBloc(sharedPreferences : sharedPreferences,
          usageSettings: [
        Setting<double>(
          key: 'home_latitude',
          initValue: 0,
        ),
        Setting<double>(
          key: 'home_longitude',
          initValue: 0,
        ),

      ],
      ),
        ),
        BlocProvider<GeolocationBloc>(
          create: (context) => GeolocationBloc(),
        ),
        BlocProvider<TrackingBloc>(
          create: (context) => TrackingBloc( geolocator : Geolocator()),
        ),
      
      ],
      child: MyApp(),
    ),
  );

}
