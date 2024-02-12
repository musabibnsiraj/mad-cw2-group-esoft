import '../constant.dart';
import 'package:flutter/material.dart';

AppBar appBar(String title, {List<Widget>? actionsWidget, double? elevation}) {
  return AppBar(
      title: Text(
        title,
        style: TextStyle(
          color: appBarText,
          fontSize: 28,
          fontFamily: "Montserrat",
          fontWeight: FontWeight.w700,
        ),
      ),
      backgroundColor: appBarBgColor,
      elevation: elevation ?? 0,
      actions: actionsWidget ?? []);
}
