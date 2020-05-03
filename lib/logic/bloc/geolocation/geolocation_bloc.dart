import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';

part 'geolocation_event.dart';
part 'geolocation_state.dart';

class GeolocationBloc extends Bloc<GeolocationEvent, GeolocationState> {
  @override
  GeolocationState get initialState => GeolocationUninitialized();

  @override
  Stream<GeolocationState> mapEventToState(
    GeolocationEvent event,
  ) async* {
    if(event is FetchHomeLocation) {
      yield* _mapFetchGeoLocation(event);
    }
    
  }

  Stream<GeolocationState> _mapFetchGeoLocation(FetchHomeLocation event) async* {
    yield GeolocationLoading();
    try {    

      Position position;
      position = await Geolocator().getCurrentPosition();  
      //
      yield GeolocationHomeLoaded(latitude: position.latitude, longitude: position.longitude);      

    } catch (e) {
      yield GeolocationError(error : e.toString());

    }
  }

}
