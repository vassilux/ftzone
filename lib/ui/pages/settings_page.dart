import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ftzone/config/palette.dart';
import 'package:ftzone/logic/bloc/geolocation/geolocation_bloc.dart';
import 'package:ftzone/logic/bloc/settings/settings_bloc.dart';
import 'package:ftzone/model/home_position.dart';
import 'package:ftzone/model/setting.dart';
import 'package:ftzone/ui/widgets/common_scaffold.dart';
import 'package:ftzone/ui/widgets/language_selector.dart';
import 'package:ftzone/ui/widgets/loading_widget.dart';
import 'package:ftzone/ui/widgets/profile_tile.dart';
import 'package:ftzone/ui/widgets/value_tile.dart';
import 'package:ftzone/ui/widgets/x_margin_widget.dart';
import 'package:ftzone/utils/translations.dart';
import 'package:ftzone/utils/uidata.dart';

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

  Widget _buildLocationSettingsWidget(BuildContext context) {
    var homeLatitude = BlocProvider.of<SettingsBloc>(context)
        .getSetting<double>("home_latitude")
        .value;
    var homeLongitude = BlocProvider.of<SettingsBloc>(context)
        .getSetting<double>("home_longitude")
        .value;

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
                ValueTile(
                "Latitude",
                homeLatitude.toString()),           
            XMarginWidget(10),
            ValueTile(
                "Longitude",
                homeLongitude.toString() ),           

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

  Widget _buildLocationWidget(BuildContext context) {
    return BlocBuilder(
        bloc: BlocProvider.of<GeolocationBloc>(context),
        builder: (
          BuildContext context,
          GeolocationState state,
        ) {
          if (state is GeolocationHomeLoaded) {
            var homeLatitude = Setting<double>(
                key: 'home_latitude', initValue: 0, value: state.latitude);

            var homeLongitude = Setting<double>(
                key: 'home_longitude', initValue: 0, value: state.longitude);

            BlocProvider.of<SettingsBloc>(context)
                .add(UpdateSetting(homeLatitude));
            BlocProvider.of<SettingsBloc>(context)
                .add(UpdateSetting(homeLongitude));

            return Container();
          }

          if(state is GeolocationLoading) {
            return LoadingWidget();
          }

          return Container();
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
            _buildLocationWidget(context),
            //3
            /* Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  allTranslations.text("news"),
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
                        Icons.location_city,
                        color: Colors.orange,
                      ),
                      title: Text(allTranslations.text("country")),
                      trailing: CommonSwitch(
                        defValue: false,
                      ),
                    ),
                  ],
                ),
              ),*/
          ],
        ),
      ),
    );
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
