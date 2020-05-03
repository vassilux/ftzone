part of 'tracking_bloc.dart';

abstract class TrackingEvent extends Equatable {
  const TrackingEvent();
}

class TrackingStarted extends TrackingEvent {
  @override
  List<Object> get props => [];
  
}

class TrackingLocationChanged extends TrackingEvent {
  final Position position;

  TrackingLocationChanged(this.position);
  
  @override
  List<Object> get props => throw UnimplementedError();
  
}

class TrackingCalculateDistance extends TrackingEvent {
  final double startLatitude;
  final double startLongitude;
  final double endLatitude;
  final double endLongitude;

  TrackingCalculateDistance(this.startLatitude, this.startLongitude, this.endLatitude, this.endLongitude);

  @override
  List<Object> get props => throw UnimplementedError();


}
