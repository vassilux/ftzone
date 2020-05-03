

class HomePosition {
  final double latitude;
  final double longitude;

  HomePosition(this.latitude, this.longitude);

  HomePosition.fromJson(Map<String, dynamic> json) :
    latitude = json['latitude'], longitude = json["longitude"];

  Map<String, dynamic> toJson() => { 'latitude': latitude, 'longitude' : longitude };

}