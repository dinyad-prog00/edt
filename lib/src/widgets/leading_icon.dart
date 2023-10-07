import 'package:flutter/material.dart';

Widget leadingIcon(
    {required IconData icon,
    required Color bgColor,
    Color iconColor = Colors.white}) {
  return Container(
    child: Icon(icon, color: iconColor),
    height: 40,
    width: 40,
    decoration: BoxDecoration(
      color: bgColor,
      borderRadius: BorderRadius.circular(22.5),
    ),
  );
}
