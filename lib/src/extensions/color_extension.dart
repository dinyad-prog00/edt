import 'package:flutter/material.dart';

extension ColorExtension on Color {
  String toHexString() {
    return '#${alpha.toRadixString(16).padLeft(2, '0')}'
        '${red.toRadixString(16).padLeft(2, '0')}'
        '${green.toRadixString(16).padLeft(2, '0')}'
        '${blue.toRadixString(16).padLeft(2, '0')}';
  }

  static Color fromHexString(String hexString) {
    hexString = hexString.replaceAll("#", "");
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 8) {
      buffer.write(hexString);
    } else {
      throw FormatException("Invalid hexadecimal color: $hexString");
    }
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
