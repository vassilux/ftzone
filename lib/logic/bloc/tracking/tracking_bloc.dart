import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
//import 'package:rxdart/rxdart.dart';

part 'tracking_event.dart';
part 'tracking_state.dart';

class TrackingBloc extends Bloc<TrackingEvent, TrackingState> {
  final Geolocator _geolocator;
  StreamSubscription _locationSubscription;

  TrackingBloc({@required Geolocator geolocator})
      : assert(geolocator != null),
        _geolocator = geolocator;

  /*

var locationOptions = new LocationOptions(
      accuracy = LocationAccuracy.best,
    distanceFilter = 500,
      forceAndroidLocationManager = false,
      timeInterval = 0);
  */

  @override
  TrackingState get initialState => TrackingInitial();

  @override
  Stream<TrackingState> mapEventToState(
    TrackingEvent event,
  ) async* {
    if (event is TrackingStarted) {
      yield TrackingLoadInProgress();
      _locationSubscription?.cancel();
      var locationOptions =
          new LocationOptions(accuracy: LocationAccuracy.lowest, distanceFilter : 500, 
          forceAndroidLocationManager : false, timeInterval : 0);

      _locationSubscription = _geolocator
          .getPositionStream(locationOptions = locationOptions)
          .listen(
            (Position position) => add(
              TrackingLocationChanged(position),
            ),
          );
    } else if (event is TrackingLocationChanged) {
      yield TrackingLoadSuccess(event.position);
    } else if (event is TrackingCalculateDistance) {
      final double distance = await Geolocator().distanceBetween(
          event.startLatitude,
          event.startLongitude,
          event.endLatitude,
          event.endLongitude);
      yield TrackingDistanceSuccess(distance);
    }
  }
/*
@override
  Stream<Transition<TrackingEvent, TrackingState>> transformEvents(
    Stream<TrackingEvent> events,
    TransitionFunction<TrackingEvent, TrackingState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(seconds: 1)),
      transitionFn,
    );
  }*/

  @override
  Future<void> close() {
    _locationSubscription?.cancel();
    return super.close();
  }
}
