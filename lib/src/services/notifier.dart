import 'package:edt/src/db/local_db.dart';
import 'package:edt/src/models/calendar.dart';
import 'package:edt/src/models/settings.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synchronized/synchronized.dart';

class EdtNotifier extends ChangeNotifier {
  List<Calendar> _calendars = [];
  late  Setting _settings ;

  LocalBdManager _localBdManager = LocalBdManager();

  List<Calendar> get calendars => _calendars;
  LocalBdManager get localBdManager => _localBdManager;
  final _lock = Lock();

  //final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  bool _initialized = false;
  bool get initialized => _initialized;
  Setting get settings => _settings;

  Future<void> init() async {
    final cals = await _localBdManager.checkedCalendars();
    _calendars.addAll(cals);
    _initialized = true;
    //final prefs = await _prefs;
    _settings = Setting(showWeekends: false);
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

  void setShowWeeks(bool value){
      _settings.showWeekends=value;
      //_prefs.then((prefs)=>prefs.setBool("showWeekends", value));
      notifyListeners();
  }
}
