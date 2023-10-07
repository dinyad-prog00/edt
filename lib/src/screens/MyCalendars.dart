import 'package:edt/src/db/local_db.dart';
import 'package:edt/src/screens/add_calendar.dart';
import 'package:edt/src/services/notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../constants/urls.dart';
import '../widgets/CalendarCheckbox.dart';

class MyCalendars extends StatefulWidget {
  const MyCalendars({super.key});

  @override
  State<MyCalendars> createState() => _MyCalendarsState();
}

class _MyCalendarsState extends State<MyCalendars> {
  @override
  Widget build(BuildContext context) {
    final edtNotifier = Provider.of<EdtNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Mes EDT"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddCalendar()));
              },
              icon: Icon(Icons.add))
        ],
      ),
      body: FutureBuilder(
        future: edtNotifier.localBdManager.calendars(),
        builder: ((context, snap) {
          return snap.hasData
              ? Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            return CalendarCheckbox(
                                calendar: snap.data![index]);
                          },
                          itemCount: snap.data!.length,
                        ),
                      ),
                    ),
                  ],
                )
              : CircularProgressIndicator();
        }),
      ),
    );
  }
}
