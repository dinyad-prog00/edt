import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';

class DetailsEvent extends StatelessWidget {
  const DetailsEvent({super.key, required this.event});

  final CalendarEventData<Map> event;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ING3"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Icon(Icons.settings),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            event.title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Icon(
                  Icons.location_pin,
                  size: 18,
                ),
                Expanded(
                  child: Text(
                    event.event!["location"],
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              DateFormat("EEEE d MMM y", "fr-FR").format(event.date),
              style: const TextStyle(fontSize: 18),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(),
            child: Text(
              "${DateFormat("HH:mm", "fr-FR").format(event.startTime!)} à ${DateFormat("HH:mm", "fr-FR").format(event.endTime!)}",
              style: const TextStyle(fontSize: 18),
            ),
          ),
          Divider(),
          Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  event.description.split("\\n").where((e) => e != "").length,
                  (index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      event.description
                          .split("\\n")
                          .where((e) => e != "")
                          .toList()[index],
                      style: const TextStyle(),
                    ),
                  ),
                ),
              ))
        ]),
      ),
    );
  }
}
