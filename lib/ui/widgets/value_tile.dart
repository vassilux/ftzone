import 'package:flutter/material.dart';
import 'package:ftzone/utils/uidata.dart';


class ValueTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData iconData;

  ValueTile(this.label, this.value, {this.iconData});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          this.label,
          style: UIData.h5Style.copyWith(
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.bold,
                    ),
        ),
        SizedBox(
          height: 2,
        ),
        this.iconData != null
            ? Icon(
                iconData,
                color: Theme.of(context).accentColor,
                size: 20,
              )
            : Container(),
        SizedBox(
          height: 5,
        ),
        Text(
          this.value,       
          style: UIData.h5Style.copyWith(
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.bold,
                    )
        ),
      ],
    );
  }
}