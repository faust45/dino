import 'package:flutter/foundation.dart';
import '../utils.dart';
import '../utils/rx_value.dart';
import '../state.dart';
import '../models.dart';
import 'package:built_collection/built_collection.dart';


class CalPageChanged implements UIEvent {
  int page;
  
  CalPageChanged(this.page);
  
  perform() {
    Calendar.currentDate.value = Calendar.daysByPage(page).first;
    Calendar.currentPage = page;
    // print(Calendar.onEventChanges);
  }

  String toString() {
    return "${this.runtimeType} ${page}";
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

class CalEventCreate implements UIEvent {
  
  perform() {
  }
}

class CalEventUpdate implements UIEvent {
  
  perform() {
  }
}

class CalEventDelete implements UIEvent {
  
  perform() {
  }
}


class Calendar {
  static var onEventChanges = ValueNotifier(0);
  static int daysOnScreen = 3;
  static int currentPage = 100;
  static var currentDate = ValueNotifier(today());
  static var currentMonth = ValueNotifier(currentDate.value);

  static void init() {
    afterEvent([CalEventCreate, CalEventUpdate, CalEventDelete], onEventChanges);
  }
  
  static Iterable<DateTime> daysByPage(int page) {
    var delta = page - currentPage;
    var date = currentDate.value.add(Duration(days: daysOnScreen * delta));

    return DateRange.from(date).take(daysOnScreen);
  }

  static BuiltSet<Event> eventsForDays(date) {
    return AppState.events;
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
      this.client,
      required this.id,
      required this.startAt,
      required this.services,
      required this.duration,
      required this.master,
      this.description = ""});

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
