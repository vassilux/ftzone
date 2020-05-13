import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:ftzone/config/palette.dart';
import 'package:ftzone/logic/bloc/geolocation/geolocation_bloc.dart';
import 'package:ftzone/logic/bloc/settings/settings_bloc.dart';
import 'package:ftzone/model/setting.dart';
import 'package:ftzone/ui/widgets/common_scaffold.dart';
import 'package:ftzone/ui/widgets/language_selector.dart';
import 'package:ftzone/ui/widgets/loading_widget.dart';
import 'package:ftzone/ui/widgets/value_tile.dart';
import 'package:ftzone/ui/widgets/x_margin_widget.dart';
import 'package:ftzone/utils/translations.dart';
import 'package:ftzone/utils/uidata.dart';
import 'package:numberpicker/numberpicker.dart';

class SettingsPage extends StatefulWidget {
  static const String routeName = '/settings';

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
  }

  Widget _buildHomeLocation(double latitude, double longitude) {
    return Card(
      color: Colors.white,
      elevation: 2.0,
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Icon(
              Icons.refresh,
              color: Colors.grey,
            ),
            title: Row(
              children: [
                ValueTile("Latitude", latitude.toString()),
                XMarginWidget(10),
                ValueTile("Longitude", longitude.toString()),
              ],
            ),
            onTap: () {
              BlocProvider.of<GeolocationBloc>(context)
                  .add(FetchHomeLocation());
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSettingsWidget(BuildContext context) {
    //load default value before re-initialize home location
    var homeLatitude = BlocProvider.of<SettingsBloc>(context)
        .getSetting<double>("home_latitude")
        .value;
    var homeLongitude = BlocProvider.of<SettingsBloc>(context)
        .getSetting<double>("home_longitude")
        .value;

    return BlocBuilder(
        bloc: BlocProvider.of<GeolocationBloc>(context),
        builder: (
          BuildContext context,
          GeolocationState state,
        ) {
          if (state is GeolocationHomeLoaded) {
            return _buildHomeLocation(state.latitude, state.longitude);
          }

          if (state is GeolocationLoading) {
            return LoadingWidget();
          }
          //return widget with default value 0:0 if the first time run
          return _buildHomeLocation(homeLatitude, homeLongitude);
        });
  }

  Widget bodyData(BuildContext context) {
    return SingleChildScrollView(
      child: Theme(
        data: ThemeData(fontFamily: UIData.ralewayFont),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ClipPath(
              clipper: WaveClipperTwo(),
              child: Container(
                decoration: BoxDecoration(color: Palette.appColorBlue),
                height: 80,
              ),
            ),
            //1
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                allTranslations.text('general_settings'),
                style: UIData.h3Style.copyWith(
                  color: Palette.appColorBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Card(
              color: Colors.white,
              elevation: 2.0,
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Icon(
                      Icons.language,
                      color: Colors.red,
                    ),
                    title: new LanguageSelector(),
                  ),
                ],
              ),
            ),

            //2
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                allTranslations.text("setting_geo_home_title"),
                style: UIData.h3Style.copyWith(
                  color: Palette.appColorBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _buildLocationSettingsWidget(context),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                allTranslations.text("setting_geo_distance"),
                style: UIData.h3Style.copyWith(
                  color: Palette.appColorBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _buildDistanceWidget(context)
          ],
        ),
      ),
    );
  }

  Widget _buildDistanceWidget(BuildContext context) {

    return BlocBuilder(
        bloc: BlocProvider.of<SettingsBloc>(context),
        builder: (
          BuildContext context,
          SettingsState state,
        ) {
          var distance = BlocProvider.of<SettingsBloc>(context)
              .getSetting<int>("distance");
          var distanceValue = 100;

          if (distance != null) {
            distanceValue = distance.value;
          }

          if (state is SettingsInitial) {
            return Card(
                color: Colors.white,
                elevation: 2.0,
                child: Column(children: <Widget>[
                  ListTile(
                      leading: Icon(
                        Icons.refresh,
                        color: Colors.grey,
                      ),
                      title: Row(
                        children: [
                          ValueTile("Distance", "$distanceValue km"),
                          XMarginWidget(10),
                        ],
                      ),
                      onTap: () {
                        showDialog<int>(
                            context: context,
                            builder: (BuildContext context) {
                              return new NumberPickerDialog.integer(
                                minValue: 1,
                                maxValue: 10000,
                                title: new Text("Distance ?"),
                                initialIntegerValue: distanceValue,
                              );
                            }).then((value) {
                          var newDistanceSetting = Setting<int>(
                              key: 'distance', initValue: value, value: value);
                          BlocProvider.of<SettingsBloc>(context)
                              .add(UpdateSetting(newDistanceSetting));
                        });
                      })
                ]));
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      appTitle: allTranslations.text('settings'),
      showDrawer: false,
      showFAB: false,
      actionFirstIcon: null,
      backGroundColor: Colors.grey.shade300,
      bodyData: bodyData(context),
    );
  }
}
