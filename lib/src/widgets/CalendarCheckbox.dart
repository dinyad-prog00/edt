import 'package:edt/src/models/calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../services/notifier.dart';

class CalendarCheckbox extends StatefulWidget {
  const CalendarCheckbox({super.key, required this.calendar});
  final Calendar calendar;

  @override
  State<CalendarCheckbox> createState() => _CalendarCheckboxState();
}

class _CalendarCheckboxState extends State<CalendarCheckbox> {
  bool _value = false;
  late EdtNotifier edtNotifier;

  @override
  Widget build(BuildContext context) {
    edtNotifier = Provider.of<EdtNotifier>(context);
    setState(() {
      _value = edtNotifier.contains(widget.calendar);
    });
    return Container(
      child: Row(
        children: [
          Checkbox(
            value: _value,
            activeColor: widget.calendar.color,
            onChanged: ((value) {
              setState(() {
                _value = value!;
              });

              if (value == true) {
                edtNotifier.addCalendar(widget.calendar);
              } else {
                edtNotifier.removeCalendar(widget.calendar.id);
              }
              if (_value != null) {
                edtNotifier.localBdManager
                    .setCalendarChecked(widget.calendar.id, value!);
              }
            }),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.calendar.name),
            ),
          ),
          GestureDetector(
              child: Icon(Icons.delete),
              onTap: (() async {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Confirmation"),
                        content: Text("Voulez-vous vraiment supprimer ?"),
                        actions: <Widget>[
                          TextButton(
                            child: Text("Annuler"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: Text("Oui"),
                            onPressed: () async {
                              await edtNotifier.localBdManager
                                  .deleteCalendar(widget.calendar.id);
                              edtNotifier.removeCalendar(widget.calendar.id);
                              Navigator.of(context).pop(); // Close the dialog
                            },
                          ),
                        ],
                      );
                    });
              }))
        ],
      ),
    );
  }
}
