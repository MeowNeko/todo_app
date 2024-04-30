//extension
import 'package:flutter/material.dart';

extension General on Widget {
  Widget space({double top = 10, double bottom = 5}) => Padding(
        padding: EdgeInsets.only(
          top: top,
          bottom: bottom,
        ),
        child: this,
      );
}
