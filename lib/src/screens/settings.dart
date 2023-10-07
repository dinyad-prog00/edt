import 'package:edt/src/constants/urls.dart';
import 'package:edt/src/screens/MyCalendars.dart';
import 'package:edt/src/screens/add_calendar.dart';
import 'package:edt/src/widgets/CalendarCheckbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';

import '../widgets/leading_icon.dart';
import '../widgets/settings_group.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Paramètres")),
      body: ListView(
        children: [
          MySettingsGroup(title: "", children: [
            ListTile(
              leading: leadingIcon(
                icon: Icons.calendar_month,
                bgColor: Colors.blue,
              ),
              title: Text("Mes emplois du temps"),
              trailing: Icon(Icons.arrow_right),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MyCalendars()));
              },
            ),
          ]),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: const Divider(),
          ),

          // ...List.generate(calendars.length, ((index) {
          //   return CalendarCheckbox(calendar: calendars[index]);
          // }))
          // Expanded(
          //   child: Padding(
          //     padding: const EdgeInsets.all(15.0),
          //     child: ListView.builder(
          //       itemBuilder: (context, i) {

          //       },
          //       itemCount: calendars.length,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
