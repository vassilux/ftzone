
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:ftzone/utils/uidata.dart';
import 'package:latlong/latlong.dart';

class MapWidget extends StatelessWidget {
  final double latitude;
  final double longitude;
  final String image;
  final double zoneRadius;


  const MapWidget({this.latitude, this.longitude, this.image = UIData.homeImage, this.zoneRadius = (100 * 1000.0), Key key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    var homeMarker = Marker(
      width: 64.0,
      height: 64.0,
      point: LatLng(latitude, longitude),
      builder: (ctx) => Container(
        child: CircleAvatar(
          radius: 40.0,
          backgroundColor: Colors.transparent,
          backgroundImage: AssetImage(UIData.homeImage),
        ),
      ),
    );

    var circleMarker = 
      CircleMarker(
          point: LatLng(latitude, longitude),
          color: Colors.blue.withOpacity(0.2),
          borderColor: Colors.red,
          borderStrokeWidth: 2,
          useRadiusInMeter: true,
          radius: this.zoneRadius 
          );
    

    return Column(
 
      children: <Widget>[     

      Flexible(
        child: new FlutterMap(
          options: new MapOptions(
            center: new LatLng(latitude, longitude),
            zoom: 7.0,
            maxZoom: 17.0,
            minZoom: 4.0,
          ),
          layers: [
            TileLayerOptions( 
              urlTemplate:
                  'https://server.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer/tile/{z}/{y}/{x}',             
              tileProvider:
                  CachedNetworkTileProvider(), 
            ),
            MarkerLayerOptions(markers: [homeMarker]),
            CircleLayerOptions(circles: [circleMarker])
          ],
        ),
      )
    ]);
  }
}