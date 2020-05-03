part of 'tracking_bloc.dart';

abstract class TrackingState extends Equatable {
  const TrackingState();
}

class TrackingInitial extends TrackingState {
  @override
  List<Object> get props => [];
}

class TrackingLoadSuccess extends TrackingState  {
  final Position position;

  TrackingLoadSuccess(this.position);
  
  @override
  List<Object> get props => [];

}

class TrackingLoadInProgress extends TrackingState  {
  @override
  List<Object> get props => [];

}

class TrackingDistanceSuccess extends TrackingState {
  //distance in mettres 
  final double distance;

  TrackingDistanceSuccess(this.distance);

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

