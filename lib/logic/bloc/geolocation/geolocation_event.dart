part of 'geolocation_bloc.dart';

abstract class GeolocationEvent extends Equatable {
  const GeolocationEvent();
}

class FetchHomeLocation
 extends GeolocationEvent {
  const FetchHomeLocation();

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}
