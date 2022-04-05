import 'package:flutter/material.dart';

AppBar appBar(BuildContext context, String title) {
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    centerTitle: false,
    title: Text(
      title,
      style: Theme.of(context).textTheme.titleLarge,
    ),
  );
}
