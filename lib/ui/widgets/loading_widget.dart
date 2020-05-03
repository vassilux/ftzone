import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:responsive_screen/responsive_screen.dart';
import 'package:ftzone/config/palette.dart';
import 'package:ftzone/ui/widgets/y_margin_widget.dart';


class LoadingWidget extends StatelessWidget {


 @override
  Widget build(BuildContext context) {
    final Function hp = Screen(context).hp;
    return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            YMarginWidget(hp(29)),
            Center(
                child: SpinKitSquareCircle(
              color: Palette.appColorBlue,
              size: 50.0,
            )),
          ],
        );
  }

}

