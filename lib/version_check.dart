import 'dart:io';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:ftzone/utils/translations.dart';

import 'package:ota_update/ota_update.dart';

const APP_STORE_URL =
    'https://freeapk-ca7ea.firebaseapp.com/archive/ftzone.apk';
const PLAY_STORE_URL =
    'https://freeapk-ca7ea.firebaseapp.com/archive/ftzone.apk';

versionCheck(context) async {
  //Get Current installed version of app
  final PackageInfo info = await PackageInfo.fromPlatform();
  double currentVersion = double.parse(info.version.trim().replaceAll(".", ""));

  //Get Latest version info from firebase config
  final RemoteConfig remoteConfig = await RemoteConfig.instance;

  try {
    // Using default duration to force fetching from remote server.
    await remoteConfig.fetch(expiration: const Duration(seconds: 0));
    await remoteConfig.activateFetched();
    remoteConfig.getString('force_update_current_version');
    double newVersion = double.parse(remoteConfig
        .getString('force_update_current_version')
        .trim()
        .replaceAll(".", ""));
    if (newVersion > currentVersion) {
      _showVersionDialog(context);
    }
  } on FetchThrottledException catch (exception) {
    // Fetch throttled.
    print(exception);
  } catch (exception) {
    print('Unable to fetch remote config. Cached or default values will be '
        'used');
  }
}
//Show Dialog to force user to update
_showVersionDialog(context) async {
  await showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      String title = allTranslations.text("udpate_dlg_title");
      String message =  allTranslations.text("udpate_dlg_text");
      String btnLabel = allTranslations.text("update_dlg_now");
      String btnLabelCancel = allTranslations.text("update_dlg_later");
      return Platform.isIOS
          ? new CupertinoAlertDialog(
              title: Text(title),
              content: Text(message),
              actions: <Widget>[
                FlatButton(
                  child: Text(btnLabel),
                  onPressed: () => _launchURL(APP_STORE_URL),
                ),
                FlatButton(
                  child: Text(btnLabelCancel),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            )
          : new AlertDialog(
              title: Text(title),
              content: Text(message),
              actions: <Widget>[
                FlatButton(
                  child: Text(btnLabel),
                  onPressed: () => _launchURL(PLAY_STORE_URL),
                ),
                FlatButton(
                  child: Text(btnLabelCancel),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            );
    },
  );
}

_launchURL(String url) async {
  try {    
    OtaUpdate().execute(url, destinationFilename: 'ftzone.apk').listen(
      (OtaEvent event) {
        print('EVENT: ${event.status} : ${event.value}');
      },
    );
  } catch (e) {
    print('Failed to make OTA update. Details: $e');
  }

}