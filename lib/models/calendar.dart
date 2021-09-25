import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../utils.dart';
import '../utils/rx_value.dart';
import '../state.dart';
import '../models.dart';
import 'master.dart';
import 'package:built_collection/built_collection.dart';


class CalPageChanged with UIEventsDesc implements UIEvent {
  int page;
  
  CalPageChanged(this.page);
  
  perform() {
    Calendar.currentDate.value = Calendar.daysByPage(page).first;
    Calendar.currentPage = page;
  }

  String get desc => "${page}";
}

class CalEventEdit with UIEventsDesc implements UIEvent {
  Event event;
  
  CalEventEdit(this.event);
  
  perform() {
    Calendar.selectedEvent.value = event;
  }

  String get desc => "${event}";
}

class CalEventEditClose with UIEventsDesc implements UIEvent {
  
  CalEventEditClose();
  
  perform() {
    Calendar.selectedEvent.value = null;
  }
}

class CalPrevMonth implements UIEvent {
  
  perform() {
    Calendar.currentDate.value = Calendar.currentMonth.value =
    Calendar.currentDate.value.prevMonth;
  }
}

class CalNextMonth implements UIEvent {
  
  perform() {
    Calendar.currentDate.value = Calendar.currentMonth.value =
    Calendar.currentDate.value.nextMonth;
  }
}

class CalEventUpdate with UIEventsDesc implements UIEvent {
  BuiltSet<Service>? _services;
  String? _description;
  DateTime? _startAtDate;
  TimeOfDay? _startAtTime;
  Duration? _duration;
  Client? _client;
  Master? _master;
  
  CalEventUpdate({startAtDate, startAtTime, services, duration, master, client, description,}) {
    _startAtDate = startAtDate;
    _startAtTime = startAtTime;
    _services = services;
    _duration = duration;
    _master = master;
    _client = client;
    _description = description;
  }
  
  perform() {
    var e = Calendar.selectedEvent.value;
    
    if(e != null) {
      var t = _startAtTime ?? TimeOfDay.fromDateTime(e.startAt);
      var d = _startAtDate ?? e.startAt;
      var startAt = DateTime(d.year, d.month, d.day, t.hour, t.minute);
      
      Calendar.selectedEvent.value = e.copyWith(
        startAt: startAt,
        services: _services,
        duration: _duration,
        master: _master,
        client: _client,
        description: _description
      );
    }
  }
}

class CalEventDelete implements UIEvent {
  
  perform() {
  }
}

class CalEventCreate with UIEventsDesc implements UIEvent {
  final DateTime startAt;
  final Master master;
  
  CalEventCreate({required this.startAt, required this.master});
  
  perform() {
    Calendar.selectedEvent.value = Event(
      id: genId(),
      startAt: startAt,
      master: master,
      services: BuiltSet<Service>([])
    );
  }

  String get desc => "${startAt}";
}

class CalEventCreateClient with UIEventsDesc implements UIEvent {
  String firstName, phoneNumber;
  
  CalEventCreateClient({required this.firstName, required this.phoneNumber});

  perform() {
    var client = Client(
      id: genId(),
      firstName: firstName,
      phoneNumber: phoneNumber
    );
    
    emit(CalEventUpdate(client: client));
  }
}

class Calendar {
  static var onEventChanges = ValueNotifier(0);
  static var onEventUpdate = ValueNotifier(0);
  static int daysOnScreen = 3;
  static int currentPage = 100;
  static var currentDate = ValueNotifier(today());
  static var currentMonth = ValueNotifier(currentDate.value);
  static var selectedEvent = ValueNotifier<Event?>(null);

  static void init() {
    afterEvent([CalEventCreate, CalEventUpdate, CalEventDelete], onEventChanges);
    afterEvent([CalEventUpdate], onEventUpdate);
  }
  
  static Iterable<DateTime> daysByPage(int page) {
    var delta = page - currentPage;
    var date = currentDate.value.add(Duration(days: daysOnScreen * delta));

    return DateRange.from(date).take(daysOnScreen);
  }

  static BuiltSet<Event> eventsForDays(date) {
    return AppState.events;
  }

  static List<DateTime> selectedDays() {
    return DateRange.from(Calendar.currentDate.value).take(daysOnScreen).toList();
  }
}

class Event implements Doc {
  final String id;   
  final BuiltSet<Service> services;   
  final String description;
  final DateTime startAt;
  final Duration duration;
  final Client? client;
  final Master master;

  Event({
      required this.id,
      required this.startAt,
      required this.master,
      required this.services,
      this.duration = const Duration(minutes: 15),
      this.client,
      this.description = ""
  });

  DateTime get endAt {
    return startAt.add(this.duration);
  }

  Event copyWith({id, startAt, services, duration, master, client, description,}) {
   return Event(
     id: id ?? this.id,
     startAt: startAt ?? this.startAt,
     services: services ?? this.services,
     duration: duration ?? this.duration,
     master: master ?? this.master,
     client: client ?? this.client,
     description: description ?? this.description,
   );
  }

  String toString() {
    return "${Event} startAt ${startAt} endAt ${endAt}";
  }
}
