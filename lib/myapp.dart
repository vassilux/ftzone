import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ftzone/config/palette.dart';
import 'package:ftzone/ui/pages/home_page.dart';
import 'package:ftzone/ui/pages/not_found_page.dart';
import 'package:ftzone/ui/pages/settings_page.dart';
import 'package:ftzone/utils/translations.dart';
import 'package:ftzone/utils/uidata.dart';
import 'package:ftzone/ui/pages/tracking_page.dart';


//Main application class 
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {

    

    return MaterialApp(
        title: UIData.appName,
        theme: ThemeData(
            primaryColor: Palette.appColorBlue, 
            fontFamily: UIData.quickFont,
            accentColor: Palette.appColorBlue,
            primarySwatch: Colors.amber),
        debugShowCheckedModeBanner: false,
        showPerformanceOverlay: false,
        home: HomePage(),
        localizationsDelegates: [
          const TranslationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: allTranslations.supportedLocales(),

        //routes
        routes: <String, WidgetBuilder>{
          UIData.homeRoute: (BuildContext context) => HomePage(),
          UIData.settingsRoute: (BuildContext context) => SettingsPage(),
          UIData.trackingRoute: (BuildContext context) => TrackingPage(),
          
        },
        onUnknownRoute: (RouteSettings rs) => new MaterialPageRoute(
            builder: (context) => new NotFoundPage(
                  appTitle: UIData.coming_soon,
                  icon: FontAwesomeIcons.solidSmile,
                  title: UIData.coming_soon,
                  message: "Under Development",
                  iconColor: Colors.green,
                )));
  }

  @override
  void initState() {
    allTranslations.onLocaleChangedCallback = _onLocaleChanged;
    super.initState();   
  }

  setLocale(Locale locale) {
    setState(() {
      //_locale = locale;
    });
  }

  _onLocaleChanged() async {
    // do anything you need to do if the language changes
    print('Language has been changed to: ${allTranslations.currentLanguage}');
    setLocale(allTranslations.locale);
  }
}
