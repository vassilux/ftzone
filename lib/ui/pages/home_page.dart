import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:ftzone/config/config.dart';
import 'package:ftzone/config/palette.dart';
import 'package:ftzone/logic/bloc/settings/settings_bloc.dart';
import 'package:ftzone/model/menu.dart';
import 'package:ftzone/ui/widgets/map_widget.dart';

import 'package:ftzone/ui/widgets/profile_tile.dart';
import 'package:ftzone/utils/translations.dart';
import 'package:ftzone/utils/uidata.dart';
import 'package:ftzone/logic/bloc/menu/menu_bloc.dart';
import 'package:ftzone/version_check.dart';

class HomePage extends StatelessWidget {
  final MenuBloc menuBloc = MenuBloc();

  final _scaffoldState = GlobalKey<ScaffoldState>();
  Size deviceSize;
  BuildContext _context;
  //menuStack
  Widget menuStack(BuildContext context, Menu menu) => InkWell(
        onTap: () => _showModalBottomSheet(context, menu),
        splashColor: Colors.orange,
        child: Card(
          clipBehavior: Clip.antiAlias,
          elevation: 2.0,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              menuImage(menu),
              menuColor(),
              menuData(menu, context),
            ],
          ),
        ),
      );

  //stack 1/3
  Widget menuImage(Menu menu) => Image.asset(
        menu.image,
        fit: BoxFit.cover,
      );

  //stack 2/3
  Widget menuColor() => new Container(
        decoration: BoxDecoration(boxShadow: <BoxShadow>[
          BoxShadow(
            color: Palette.appColorBlue.withOpacity(0.8),
            blurRadius: 5.0,
          ),
        ]),
      );

  //stack 3/3
  Widget menuData(Menu menu, context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          menu.icon,
          color: Colors.white,
        ),
        SizedBox(
          height: 10.0,
        ),
        Text(
          allTranslations.text(menu.title),
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        )
      ],
    );
  }

  Widget buildMap(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      bloc: BlocProvider.of<SettingsBloc>(context),
      builder: (context, state) {
        var homeLatitude = BlocProvider.of<SettingsBloc>(context)
            .getSetting<double>("home_latitude")
            .value;
        var homeLongitude = BlocProvider.of<SettingsBloc>(context)
            .getSetting<double>("home_longitude")
            .value;

        var distance = BlocProvider.of<SettingsBloc>(context)
            .getSetting<int>("distance")
            .value;

        if (Config.enableFake) {
          homeLatitude = Config.fakeHomeLatitude;
          homeLongitude = Config.fakeHomeLongitude;
        }

        if (homeLatitude != 0 && homeLongitude != 0) {
          return MapWidget(latitude: homeLatitude, longitude: homeLongitude, zoneRadius : distance * 1000.0);
        }

        return Center(
            child: Text(
          allTranslations.text("define_home_position"),
          style: TextStyle(
              color: Palette.appColorRed, fontWeight: FontWeight.bold),
        ));
      },
    );
  }

  //appbar
  Widget appBar() => SliverAppBar(
        backgroundColor: Palette.background,
        pinned: true,
        elevation: 10.0,
        forceElevated: true,
        expandedHeight: 150.0,
        flexibleSpace: FlexibleSpaceBar(
          centerTitle: true,
          background: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: UIData.kitGradients2)),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              CircleAvatar(
                radius: 40.0,
                backgroundColor: Colors.white,
                backgroundImage: AssetImage(UIData.logoImage),
              ),
              SizedBox(
                width: 5.0,
              ),
              Text(allTranslations.text('app_title'),
                  style: UIData.h6Style.copyWith(
                    color: Palette.appColorBlue,
                  )),
                  
            ],
          ),
        ),
      );

  //bodygrid
  Widget bodyGrid(List<Menu> menu) => SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount:
              MediaQuery.of(_context).orientation == Orientation.portrait
                  ? 2
                  : 3,
          mainAxisSpacing: 0.0,
          crossAxisSpacing: 0.0,
          childAspectRatio: 1.0,
        ),
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          return menuStack(context, menu[index]);
        }, childCount: menu.length),
      );

  Widget homeScaffold(BuildContext context) => Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.transparent,
        ),
        child: Scaffold(key: _scaffoldState, body: bodySliverList(context)),
      );

  Widget bodySliverList(BuildContext context) {
    return StreamBuilder<List<Menu>>(
        stream: menuBloc.menuItems,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? CustomScrollView(
                  slivers: <Widget>[
                    appBar(),
                    
                    bodyGrid(snapshot.data),
                    SliverFillRemaining(
                        hasScrollBody: true, child: buildMap(context))
                  ],
                )
              : Center(child: CircularProgressIndicator());
        });
  }

  Widget header() => Ink(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: UIData.kitGradients2)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              CircleAvatar(
                radius: 25.0,
                backgroundImage: AssetImage(UIData.logoImage),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ProfileTile(
                  title: allTranslations.text("app_name"),
                  subtitle: "ftsgame@protonmail.com",
                  textColor: Colors.black87,
                ),
              )
            ],
          ),
        ),
      );

  void _showModalBottomSheet(BuildContext context, Menu menu) {
    if (menu.items.length == 1) {
      Navigator.pushNamed(context, "/${menu.items[0]}");
      return;
    }
    showModalBottomSheet(
        context: context,
        builder: (context) => Material(
            clipBehavior: Clip.antiAlias,
            color: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.only(
                    topLeft: new Radius.circular(15.0),
                    topRight: new Radius.circular(15.0))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                header(),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: false,
                    itemCount: menu.items.length,
                    itemBuilder: (context, i) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: ListTile(
                          title: Text(
                            menu.items[i],
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(context, "/${menu.items[i]}");
                          }),
                    ),
                  ),
                ),
              ],
            )));
  }

  Widget iosCardBottom(Menu menu, BuildContext context) => Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              width: 40.0,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(width: 3.0, color: Colors.white),
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(
                        menu.image,
                      ))),
            ),
            SizedBox(
              width: 20.0,
            ),
            Text(
              menu.title,
              textAlign: TextAlign.start,
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(
              width: 20.0,
            ),
            FittedBox(
              child: CupertinoButton(
                onPressed: () => _showModalBottomSheet(context, menu),
                borderRadius: BorderRadius.circular(50.0),
                child: Text(
                  "Go",
                  textAlign: TextAlign.left,
                  style: TextStyle(color: CupertinoColors.activeBlue),
                ),
                color: Colors.white,
              ),
            )
          ],
        ),
      );

  Widget menuIOS(Menu menu, BuildContext context) {
    return Container(
      height: deviceSize.height / 2,
      decoration: ShapeDecoration(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 3.0,
        margin: EdgeInsets.all(16.0),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            menuImage(menu),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                menu.title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              height: 60.0,
              child: Container(
                width: double.infinity,
                color: menu.menuColor,
                child: iosCardBottom(menu, context),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget bodyDataIOS(List<Menu> data, BuildContext context) => SliverList(
        delegate: SliverChildListDelegate(
            data.map((menu) => menuIOS(menu, context)).toList()),
      );

  Widget homeBodyIOS(BuildContext context) {
    return StreamBuilder<List<Menu>>(
        stream: menuBloc.menuItems,
        initialData: List(),
        builder: (context, snapshot) {
          return snapshot.hasData
              ? bodyDataIOS(snapshot.data, context)
              : Center(
                  child: CircularProgressIndicator(),
                );
        });
  }

  Widget homeIOS(BuildContext context) => Theme(
        data: ThemeData(
          fontFamily: '.SF Pro Text',
        ).copyWith(canvasColor: Colors.transparent),
        child: CupertinoPageScaffold(
          child: CustomScrollView(
            slivers: <Widget>[
              CupertinoSliverNavigationBar(
                border: Border(bottom: BorderSide.none),
                backgroundColor: CupertinoColors.white,
                largeTitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(UIData.appName,
                        style: TextStyle(
                          fontSize: 20,
                        )),
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: CircleAvatar(
                        radius: 15.0,
                        backgroundColor: CupertinoColors.black,
                        child: FlutterLogo(
                          size: 15.0,
                          colors: Colors.yellow,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              homeBodyIOS(context)
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => versionCheck(context));
    _context = context;
    deviceSize = MediaQuery.of(context).size;
    return defaultTargetPlatform == TargetPlatform.iOS
        ? homeIOS(context)
        : homeScaffold(context);
  }
}
