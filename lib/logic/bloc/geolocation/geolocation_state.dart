part of 'geolocation_bloc.dart';

abstract class GeolocationState extends Equatable {
  const GeolocationState();
}

class GeolocationUninitialized extends GeolocationState {
  @override
  List<Object> get props => [];
}

class GeolocationHomeLoaded extends GeolocationState {
  final double latitude;
  final double longitude;

  GeolocationHomeLoaded({
    this.latitude,
    this.longitude,
  });

  @override
  List<Object> get props => [latitude, longitude];
}

class GeolocationLoading extends GeolocationState {

  GeolocationLoading();
    
  
  @override
  List<Object> get props => [];
}



class GeolocationError extends GeolocationState {
  final String error;
  GeolocationError({
    this.error,
  });
  
  @override
  List<Object> get props => [];
}
