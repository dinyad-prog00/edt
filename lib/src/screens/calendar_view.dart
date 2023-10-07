import 'package:calendar_view/calendar_view.dart';
import 'package:edt/src/constants/utils.dart';
import 'package:edt/src/extensions/string_extension.dart';
import 'package:edt/src/screens/details_event.dart';
import 'package:edt/src/screens/settings.dart';
import 'package:edt/src/services/calendar_sync.dart';
import 'package:edt/src/services/notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:week_of_year/week_of_year.dart';

class CalendarView extends StatefulWidget {
  CalendarView({super.key});

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  final controller = EventController<Map>();
  bool _isDay = true;
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
          backgroundColor: Colors.blue,
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
        
        body: _isDay? EdtDayView(controller: controller) : EdtWeekView(controller: controller),
        floatingActionButton: Wrap(
          direction: Axis.vertical,
          children: [
            Padding(
              
              padding: const EdgeInsets.only(bottom: 8),
              child: FloatingActionButton(
                heroTag: "changeViewType",
                onPressed: (()  {
                  setState(() {
                    _isDay=!_isDay;
                  });
                }),
                child: Icon(_isDay? Icons.view_week:Icons.view_day),
              ),
            ),
            FloatingActionButton(
              heroTag: "reload",
              onPressed: (() async {
                final events =
                    await CalendarSyncManager.getFull(edtNotifier.calendars);
                controller.removeWhere((element) => true);
                controller.addAll(events);
              }),
              child: const Icon(Icons.replay),
            ),
          ],
        ));
  }
}


class EdtDayView extends StatefulWidget {
  final EventController<Map> controller;
  const EdtDayView({super.key, required this.controller});

  @override
  State<EdtDayView> createState() => _EdtDayViewState();
}

class _EdtDayViewState extends State<EdtDayView> {
  @override
  Widget build(BuildContext context) {
    return DayView(
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
          controller: widget.controller,
          //showVerticalLine: false,
          heightPerMinute: heightPerMinute,
          startDuration: Duration(hours: 6, minutes: 30),
          
          dateStringBuilder: (date, {secondaryDate}) {
            if(date.compareWithoutTime(DateTime.now())){

            }
            return DateFormat('EEE d MMM y', 'fr_FR').format(date).capitalize();
          },
          timeStringBuilder: (date, {secondaryDate}) {
            return DateFormat('HH:mm', 'fr_FR').format(date);
          },
        );
  }
}

class EdtWeekView extends StatefulWidget {
  final EventController<Map> controller;
  const EdtWeekView({super.key, required this.controller});

  @override
  State<EdtWeekView> createState() => _EdtWeekViewState();
}

class _EdtWeekViewState extends State<EdtWeekView> {
  @override
  Widget build(BuildContext context) {
     EdtNotifier edtNotifier = Provider.of<EdtNotifier>(context);
    return WeekView(
      
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
                          padding: const EdgeInsets.all(3.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                events[index].title,
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 10,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
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
         
          weekDayBuilder: ((date) {
            if(date.compareWithoutTime(DateTime.now())){
              return Container(
                margin: EdgeInsets.all(2),
                decoration: BoxDecoration(color: Color.fromARGB(255, 32, 127, 182),borderRadius: BorderRadius.circular(15)),
                
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Text(DateFormat('EEE', 'fr_FR').format(date).capitalize(),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                Text(date.day.toString(),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold))
                          ],),
              );
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Text(DateFormat('EEE', 'fr_FR').format(date).capitalize()),
              Text(date.day.toString())
            ],);
          }),

          timeLineStringBuilder: (date, {secondaryDate}) {
            return DateFormat('HH:mm', 'fr_FR').format(date);
            
          },

          headerStringBuilder: (date, {secondaryDate}) {
            return "S${date.weekOfYear} : Du ${DateFormat('EEE d MMM', 'fr_FR').format(date)} au ${DateFormat('EEE d MMM', 'fr_FR').format(secondaryDate!)}";
          },
         
         showWeekends: edtNotifier.settings.showWeekends,
          onEventTap: (events, date) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetailsEvent(event: events.first)));
          },
          controller: widget.controller,
          //showVerticalLine: false,
          heightPerMinute: heightPerMinute,
        );
  }
}


