import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

AppBar appBar(BuildContext context, String title) {
  return AppBar(
    bottom: PreferredSize(
      child: Container(
        color: HexColor('EE6C4D'),
        height: 1,
      ),
      preferredSize: const Size.fromHeight(1),
    ),
    backgroundColor: Colors.transparent,
    elevation: 0,
    centerTitle: false,
    title: Text(
      title,
      style: Theme.of(context).textTheme.titleLarge,
    ),
  );
}
