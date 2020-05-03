import 'package:flutter/material.dart';
import 'package:ftzone/model/menu.dart';
import 'package:ftzone/utils/uidata.dart';


class MenuViewModel {
  List<Menu> menuItems;

  MenuViewModel({this.menuItems});

  getMenuItems() {
    
    return menuItems = <Menu>[
     
      Menu(
          title: "startgeoloc",
          menuColor: Color(0xff261d33),
          icon: Icons.gps_fixed,
          image: UIData.geolocalisationImage,
          items: ["Tracking"]),    

      Menu(
          title: "settings",
          menuColor: Color(0xff2a8ccf),
          icon: Icons.settings,
          image: UIData.settingsImage,
          items: ["Settings"]),
     
    ];
  }
}
