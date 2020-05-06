import 'dart:async';

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
import 'package:map_controller/map_controller.dart';
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
  //List<Marker> _markers = <Marker>[];

  MapController _mapController;

  StatefulMapController _statefulMapController;

  StreamSubscription<StatefulMapControllerStateChange> _sub;


  @override
  void initState() {
    _mapController = MapController();
    _statefulMapController = StatefulMapController(mapController: _mapController);

    // wait for the controller to be ready before using it
    _statefulMapController.onReady.then((_) => print("The map controller is ready"));

    /// [Important] listen to the changefeed to rebuild the map on changes:
    /// this will rebuild the map when for example addMarker or any method 
    /// that mutates the map assets is called
    _sub = _statefulMapController.changeFeed.listen((change) => setState(() {}));

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

    _statefulMapController.addMarker(marker: homeMarker, name: "Home");

    //_markers.add(homeMarker);

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
            
            _statefulMapController.removeMarker(name: "myposition");

            var postion = Marker(
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
            );

            _statefulMapController.addMarker(marker: postion, name: "Position");
            
            
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
              urlTemplate:
                  'https://server.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer/tile/{z}/{y}/{x}',           
              tileProvider:
                  CachedNetworkTileProvider(),
            ),
            MarkerLayerOptions(markers: _statefulMapController.markers),
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

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
