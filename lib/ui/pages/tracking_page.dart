import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:ftzone/config/config.dart';
import 'package:ftzone/ui/widgets/common_scaffold.dart';
import 'package:ftzone/ui/widgets/horizontal_tile.dart';
import 'package:ftzone/ui/widgets/loading_widget.dart';
import 'package:ftzone/ui/widgets/profile_tile.dart';
import 'package:ftzone/utils/translations.dart';
import 'package:ftzone/utils/uidata.dart';
import 'package:latlong/latlong.dart';
import 'package:ftzone/config/palette.dart';
import 'package:ftzone/logic/bloc/settings/settings_bloc.dart';
import 'package:ftzone/logic/bloc/tracking/tracking_bloc.dart';
import 'package:ftzone/ui/tools/length.dart';
import 'package:responsive_screen/responsive_screen.dart';

class TrackingPage extends StatefulWidget {
  TrackingPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _TrackingPageState createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage>
    with AutomaticKeepAliveClientMixin {
  double _homeLatitude = 0;
  double _homeLongitude = 0;
  List<CircleMarker> _circleMarkers = <CircleMarker>[];
  List<Marker> _markers = <Marker>[];

  @override
  void initState() {
    _homeLatitude = BlocProvider.of<SettingsBloc>(context)
        .getSetting<double>("home_latitude")
        .value;
    _homeLongitude = BlocProvider.of<SettingsBloc>(context)
        .getSetting<double>("home_longitude")
        .value;

    if(Config.enableFake ){
      _homeLatitude = Config.fakeHomeLatitude;
      _homeLongitude = Config.fakeHomeLongitude;
    }  

    var homeMarker = Marker(
      width: 64.0,
      height: 64.0,
      point: LatLng(_homeLatitude, _homeLongitude),
      builder: (ctx) => Container(
        child: CircleAvatar(
          radius: 40.0,
          backgroundColor: Colors.transparent,
          backgroundImage: AssetImage(UIData.homeImage),
        ),
      ),
    );

    _markers.add(homeMarker);

    _circleMarkers.add(
      CircleMarker(
          point: LatLng(_homeLatitude, _homeLongitude),
          color: Colors.blue.withOpacity(0.2),
          borderColor: Colors.red,
          borderStrokeWidth: 2,
          useRadiusInMeter: true,
          radius: 1000.0 * 100 // 100 km
          ),
    );

    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void didChangeDependencies() {
    //
    BlocProvider.of<TrackingBloc>(context).add(TrackingStarted());
    super.didChangeDependencies();
  }

  Widget _scaffold() {
    return CommonScaffold(
      appTitle: allTranslations.text("tracking_title"),
      bodyData: bodyData(),
      showFAB: false,
      showDrawer: false,
      floatingIcon: Icons.refresh,
      floatingCallback: () {},
      actionFirstIconCallback: () {},
      actionFirstIcon: null,
    );
  }

  Widget _buildDistanceWidget(BuildContext context) {
    final Function hp = Screen(context).hp;
    final Function wp = Screen(context).wp;

    return Container(
          width: wp(100),
          height: hp(6),
          decoration: new BoxDecoration(
                  gradient: new LinearGradient(
                colors: UIData.kitGradients3,
              )),
          child : Center(child: Column(children: <Widget>[
      BlocBuilder<TrackingBloc, TrackingState>(
        builder: (context, state) {
          if (state is TrackingInitial) {
            return LoadingWidget();
          }

          if (state is TrackingLoadSuccess) {
            _markers.removeWhere((m) =>
                m.point.latitude != _homeLatitude &&
                m.point.longitude != _homeLongitude);

            _markers.add(Marker(
              width: 64.0,
              height: 64.0,
              point: LatLng(state.position.latitude, state.position.longitude),
              builder: (ctx) => Container(
                child: CircleAvatar(
                  radius: 40.0,
                  backgroundColor: Colors.transparent,
                  backgroundImage: AssetImage(UIData.trackingPositionImage),
                ),
              ),
            ));

            BlocProvider.of<TrackingBloc>(context).add(
              TrackingCalculateDistance(_homeLatitude, _homeLongitude, state.position.latitude, state.position.longitude)
            );  

            return Container(child: ProfileTile(title : "Starting", subtitle : "", textColor : Colors.white) );
            
          }

          
            if(state is TrackingDistanceSuccess)   {
              var length = Length.fromMeters(value: state.distance);
              var color = Colors.white;

              if(length.inMeters > 80 *1000){
                color = Palette.appColorRed;
              }
              return Container(child: 
              HorizonalTile(title : "Distance : ", subtitle : "${length.inKilometers.toStringAsFixed(2)} km", textColor : color) );
              
            }

          return Container();
        },
      )])));
  }

  Widget bodyData() { 
    return Column(children: <Widget>[
      _buildDistanceWidget(context),
      Flexible(
        child: new FlutterMap(
          options: new MapOptions(
            center: new LatLng(_homeLatitude, _homeLongitude),
            zoom: 8.0,
            maxZoom: 17.0,
            minZoom: 4.0,
          ),
          layers: [
            TileLayerOptions(
              /* urlTemplate: "https://api.tiles.mapbox.com/v4/"
            "{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
        additionalOptions: {
          'accessToken': 'sk.eyJ1IjoidmFzc2lsdXgiLCJhIjoiY2s5bWg0ZzV4MDRmdDNmcDlscms1bDVnbCJ9.khszoCakE1gaybO07T0k6w',
          'id': 'mapbox.streets',
        },*/

              urlTemplate:
                  'https://server.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer/tile/{z}/{y}/{x}',
              //'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              //subdomains: ['a', 'b', 'c'],

              // For example purposes. It is recommended to use
              // TileProvider with a caching and retry strategy, like
              // NetworkTileProvider or CachedNetworkTileProvider
              tileProvider:
                  CachedNetworkTileProvider(), //NonCachingNetworkTileProvider(),
            ),
            MarkerLayerOptions(markers: _markers),
            CircleLayerOptions(circles: _circleMarkers)
          ],
        ),
      )
    ]);
  }

  Widget build(BuildContext context) {
    super.build(context);
    return _scaffold();
  }
}
