import 'dart:convert';
import 'dart:io';
import 'package:calendar_view/calendar_view.dart';
import 'package:icalendar_parser/icalendar_parser.dart';

import '../models/calendar.dart';
import '../models/event.dart';

class CalendarSyncManager {
  static Future<String> load(Uri url) async {
    HttpClient httpClient = HttpClient();

    httpClient.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;

    try {
      var request = await httpClient.getUrl(url);
      var response = await request.close();

      if (response.statusCode == HttpStatus.ok) {
        var responseBody = await response.transform(utf8.decoder).join();

        return responseBody;
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during HTTP request: $e');
    } finally {
      httpClient.close();
    }
    return "";
  }

  static ICalendar parse(String icsString) {
    try {
      final iCalendar = ICalendar.fromString(icsString);
      return iCalendar;
    } catch (e) {
      return ICalendar(data: [], headData: {});
    }
  }

  static Future<List<EdtEvent>> getEvents(Uri uri) async {
    List<EdtEvent> list = [];
    final ics = await CalendarSyncManager.load(uri);
    final ic = CalendarSyncManager.parse(ics);
    for (var event in ic.data) {
      if (event["type"] == "VEVENT") {
        list.add(EdtEvent.fromMap(event));
      }
    }
    return list;
  }

  static Future<List<CalendarEventData>> getEventsData2(Uri uri) async {
    final events = await getEvents(uri);

    final eventsData = List.generate(
        events.length,
        (i) => CalendarEventData(
            description: events[i].description,
            event: events[i].location,
            title: events[i].title,
            startTime: events[i].start,
            endTime: events[i].end,
            date: events[i].start,
            endDate: events[i].end));
    return eventsData;
  }

  static Future<List<CalendarEventData<Map>>> getEventsData(
      Calendar cal) async {
    final events = await getEvents(cal.uri);

    final eventsData = List.generate(
        events.length,
        (i) => CalendarEventData(
            description: events[i].description,
            event: {
              "location": events[i].location,
              "id": cal.id,
              "color": cal.color
            },
            title: events[i].title,
            startTime: events[i].start,
            endTime: events[i].end,
            date: events[i].start,
            endDate: events[i].end));
    return eventsData;
  }

  static Future<List<CalendarEventData<Map>>> getFull(
      List<Calendar> cals) async {
    List<CalendarEventData<Map>> list = [];
    for (var cal in cals) {
      final events = await getEventsData(cal);
      list.addAll(events);
    }
    return list;
  }
}
