import 'package:built_collection/built_collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../state.dart';
import '../models.dart';
import '../utils.dart';


class Master implements Doc {
  final String id;
  final String firstName; 
  final String? lastName; 
  final BuiltSet<Service> services;

  Master({
      required this.id,
      required this.firstName,
      this.lastName,
      // required this.workingHours7days,
      required this.services,
  }); 

  Master copyWith({id, firstName, lastName, services,}) {
    return Master(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      services: services ?? this.services,
   );
  }

  String toString() {
    return "$firstName ${lastName ?? ''}";
  }
  
  // BuiltSet<Event> eventsIn(Iterable<DateTime> dates) => eventsList;
}


class MasterWorkingHoursUpdate with UIEventsDesc implements UIEvent {
  WorkingHours wh;
  bool isOn;
  
  MasterWorkingHoursUpdate(this.wh, this.isOn);

  perform() {
    var hours = Masters.workingHours7days.value;
    
    Masters.workingHours7days.value = hours.rebuild(
      (h) => h..remove(wh)..add(wh)
    );
  }
  
}
  
class MasterEditClose with UIEventsDesc implements UIEvent {
  
  MasterEditClose();
  
  perform() {
    Masters.selected.value = null;
  }

}

class MasterCreate with UIEventsDesc implements UIEvent {
  
  MasterCreate();
  
  perform() {
  }

}

class MasterUpdate with UIEventsDesc implements UIEvent {
  
  BuiltSet<Service>? services;
  
  MasterUpdate({this.services});
  
  perform() {
    Masters.selected.value = Masters.selected.value?.copyWith(services: services);
  }

}

class MasterEdit with UIEventsDesc implements UIEvent {

  Master master;
  
  MasterEdit(this.master);
  
  perform() {
    Masters.selected.value = master;
  }
  
  String get desc => "${master.id}";

}


class Masters {
  static var selected = ValueNotifier<Master?>(null);
  static var workingHours7days = ValueNotifier<BuiltSet<WorkingHours>>(BuiltSet());
  static var onWorkingHoursUpdate = ValueNotifier<int>(0);
  
  static BuiltSet<WorkingHours> masterWorkingHours7days(DateTime from) {
    var defaultHours = DateRange.from(from)
    .take(7)
    .map((date) =>
      WorkingHours(
        date: date,
        work:  [[9, 00], [18, 00]],
        lunch: [[14, 00], [15, 00]]
      )
    ).toList();

    return BuiltSet();
  }
}
