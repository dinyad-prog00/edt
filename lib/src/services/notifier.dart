import 'package:edt/src/db/local_db.dart';
import 'package:edt/src/models/calendar.dart';
import 'package:flutter/widgets.dart';
import 'package:synchronized/synchronized.dart';

class EdtNotifier extends ChangeNotifier {
  List<Calendar> _calendars = [];

  LocalBdManager _localBdManager = LocalBdManager();

  List<Calendar> get calendars => _calendars;
  LocalBdManager get localBdManager => _localBdManager;
  final _lock = Lock();

  bool _initialized = false;
  bool get initialized => _initialized;

  Future<void> init() async {
    final cals = await _localBdManager.checkedCalendars();
    _calendars.addAll(cals);
    _initialized = true;
    notifyListeners();
  }

  bool contains(Calendar cal) {
    return _calendars.any((element) => element.id == cal.id);
  }

  Future<void> addCalendar(Calendar cal) async {
    if (!contains(cal)) {
      await _lock.synchronized(() {
        _calendars.add(cal);
      });
      notifyListeners();
    }
  }

  Future<void> removeCalendar(int id) async {
    await _lock.synchronized(() {
      _calendars.removeWhere((element) => element.id == id);
    });

    notifyListeners();
  }
}
