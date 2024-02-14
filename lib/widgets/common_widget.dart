import 'package:flutter_spinkit/flutter_spinkit.dart';
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
      iconTheme: IconThemeData(
        color: appBarText, // Set your desired color here
      ),
      backgroundColor: appBarBgColor,
      elevation: elevation ?? 0,
      actions: actionsWidget ?? []);
}

class Spinner extends StatelessWidget {
  const Spinner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(child: SpinKitCircle(color: appSpinColor));
  }
}
