import 'package:intl/intl.dart';

class EdtEvent {
  final String title;
  final String description;
  final String location;
  final DateTime start;
  final DateTime end;

  static final inputFormat = DateFormat("yyyyMMdd'T'HHmmss'Z'");

  EdtEvent(
      {required this.title,
      required this.description,
      required this.start,
      required this.end,
      required this.location});

  static EdtEvent fromMap(Map event) {
    return EdtEvent(
        title: event["summary"],
        description: event["description"],
        start: DateTime.parse(event["dtstart"].dt).toLocal(),
        end: DateTime.parse(event["dtend"].dt).toLocal(),
        location: event["location"]);
  }

  @override
  String toString() {
    return "$title:$description:$location:${start.toString()}:${end.toString()}";
  }
}
