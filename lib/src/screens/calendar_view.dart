import 'package:calendar_view/calendar_view.dart';
import 'package:edt/src/constants/urls.dart';
import 'package:edt/src/constants/utils.dart';
import 'package:edt/src/screens/details_event.dart';
import 'package:edt/src/screens/settings.dart';
import 'package:edt/src/services/calendar_sync.dart';
import 'package:edt/src/services/notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CalendarView extends StatefulWidget {
  CalendarView({super.key});

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  final controller = EventController<Map>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // CalendarSyncManager.getEventsData(ing3).then((events) {
    //   controller.removeWhere((element) => true);
    //   controller.addAll(events);
    // });
  }

  @override
  Widget build(BuildContext context) {
    EdtNotifier edtNotifier = Provider.of<EdtNotifier>(context);
    if (!edtNotifier.initialized) {
      edtNotifier.init();
    }
    CalendarSyncManager.getFull(edtNotifier.calendars).then((cals) {
      controller.removeWhere((element) => true);
      controller.addAll(cals);
    });
    return Scaffold(
        appBar: AppBar(
          //leading: Icon(Icons.calendar_month),
          title: Text("Mon EDT"),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: GestureDetector(
                child: Icon(Icons.settings),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: ((context) => Settings())));
                },
              ),
            )
          ],
        ),
        body: DayView(
          eventTileBuilder: ((date, List<CalendarEventData<Map>> events,
              boundary, startDuration, endDuration) {
            int w = endDuration.getTotalMinutes - startDuration.getTotalMinutes;
            //print(events);
            return Row(
              children: List.generate(events.length, (index) {
                return Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 2.5),
                    height: w < 0 ? -w * heightPerMinute : w * heightPerMinute,
                    decoration: BoxDecoration(
                        color: events[index].event!["color"],
                        borderRadius: BorderRadius.circular(5)),
                    child: ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                events[index].title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Icon(
                                      Icons.location_pin,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                    Expanded(
                                      child: Text(
                                        events[index].event!["location"],
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }),
            );
          }),
          onEventTap: (events, date) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetailsEvent(event: events.first)));
          },
          controller: controller,
          //showVerticalLine: false,
          heightPerMinute: heightPerMinute,
          startDuration: Duration(hours: 6, minutes: 30),
          dateStringBuilder: (date, {secondaryDate}) {
            return DateFormat('EEE d MMM y', 'fr_FR').format(date);
          },
          timeStringBuilder: (date, {secondaryDate}) {
            return DateFormat('HH:mm', 'fr_FR').format(date);
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (() async {
            final events =
                await CalendarSyncManager.getFull(edtNotifier.calendars);
            controller.removeWhere((element) => true);
            controller.addAll(events);
          }),
          child: const Icon(Icons.replay),
        ));
  }
}

DateTime get _now => DateTime.now();

List<CalendarEventData> _events = [
  CalendarEventData(
    date: _now,
    //event: Event(title: "Joe's Birthday"),
    title: "Project meeting",
    description: "Today is project meeting.",
    startTime: DateTime(_now.year, _now.month, _now.day, 18, 30),
    endTime: DateTime(_now.year, _now.month, _now.day, 22),
  ),
  CalendarEventData(
    date: _now.add(Duration(days: 1)),
    startTime: DateTime(_now.year, _now.month, _now.day, 18),
    endTime: DateTime(_now.year, _now.month, _now.day, 19),
    //event: Event(title: "Wedding anniversary"),
    title: "Wedding anniversary",
    description: "Attend uncle's wedding anniversary.",
  ),
  CalendarEventData(
    date: _now,
    startTime: DateTime(_now.year, _now.month, _now.day, 14),
    endTime: DateTime(_now.year, _now.month, _now.day, 17),
    //event: Event(title: "Football Tournament"),
    title: "Football Tournament",
    description: "Go to football tournament.",
  ),
  CalendarEventData(
    date: _now.add(Duration(days: 3)),
    startTime: DateTime(_now.add(Duration(days: 3)).year,
        _now.add(Duration(days: 3)).month, _now.add(Duration(days: 3)).day, 10),
    endTime: DateTime(_now.add(Duration(days: 3)).year,
        _now.add(Duration(days: 3)).month, _now.add(Duration(days: 3)).day, 14),
    //event: Event(title: "Sprint Meeting."),
    title: "Sprint Meeting.",
    description: "Last day of project submission for last year.",
  ),
];
