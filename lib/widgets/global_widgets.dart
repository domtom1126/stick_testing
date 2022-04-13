import 'package:flutter/material.dart';

SliverAppBar appBar(BuildContext context, String title) {
  return SliverAppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    centerTitle: false,
    title: Text(
      title,
      style: Theme.of(context).textTheme.titleLarge,
    ),
  );
}

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}
