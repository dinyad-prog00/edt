import 'package:edt/src/extensions/color_extension.dart';
import 'package:flutter/services.dart';

class Calendar {
  int id;
  final String name;
  final Uri uri;
  final Color color;
  final bool checked;
  final DateTime addedAt;

  Calendar(
      {required this.id,
      required this.name,
      required this.uri,
      required this.color,
      required this.checked,
      required this.addedAt});
  factory Calendar.fromMap(Map cal) {
    return Calendar(
        id: cal["id"],
        name: cal["name"],
        uri: Uri.parse(cal["uri"]),
        color: cal["color"],
        checked: cal["checked"] == 1,
        addedAt: DateTime.parse(cal["added_at"]));
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "uri": uri,
      "color": color,
      "checked": checked,
      "added_at": addedAt
    };
  }

  factory Calendar.fromMapForDb(Map cal) {
    return Calendar(
        id: cal["id"],
        name: cal["name"],
        uri: Uri.parse(cal["uri"]),
        color: ColorExtension.fromHexString(cal["color"]),
        checked: cal["checked"] == 1,
        addedAt: DateTime.parse(cal["added_at"]));
  }
  Map<String, dynamic> toMapForDb() {
    return {
      "name": name,
      "uri": uri.toString(),
      "color": color.toHexString(),
      "checked": checked ? 1 : 0,
      "added_at": addedAt.toLocal().toString()
    };
  }
}
